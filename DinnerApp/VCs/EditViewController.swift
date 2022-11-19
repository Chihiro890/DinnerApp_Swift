//
//  EditViewController.swift
//  DinnerApp
//
//  Created by 板垣千尋 on 2022/11/13.
//

import UIKit
import Alamofire
import KeychainAccess
import Kingfisher

class EditViewController: UIViewController {
    var articleId: Int!
    private var token = ""
    let consts = Constants.shared
    let okAlert = OkAlert()
    
    @IBOutlet weak var titleTextField: UITextField! //①
    @IBOutlet weak var descriptionTextView: UITextView! //②
    
    @IBOutlet weak var calendarDatePicker: UIDatePicker!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var search_country: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //記事のIDがnilじゃなければ記事を読み込む
        guard let id = articleId else { return }
        loadArticle(articleId: id)
        
        search_country.delegate = self
        search_country.dataSource = self
        //token読み込み
        //        token = LoadToken().loadAccessToken()
    }
    
    //編集したい記事の情報をapiでリクエストして読み込む
    func loadArticle(articleId: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/dinners/\(articleId)") else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(
            url
//            headers: headers
        ).responseDecodable(of: Article.self) { response in
            switch response.result {
            case .success(let article):
                print("🌟success from Edit🌟")
                self.titleTextField.text = article.title
                self.descriptionTextView.text = article.description

                self.calendarDatePicker.date = article.calendarDate()
                let index = self.consts.country.index(of: article.country)!
                print("country : \(article.country)")
                print("index : \(index)")
                self.search_country.selectRow(index, inComponent: 0, animated: false)

            case .failure(let error):
                print("🌟failure from Edit🌟")
                print(error)
            }
        }
//        ).response{ res in
//            print(res.data!)
//        }
    }
// 追加ここまで
    
//    //更新のリクエスト
//      func updateRequest(token: String, articleId: Int) {
//
//          //URLに記事のIDを含めることを忘れずに!
//          guard let url = URL(string: consts.baseUrl + "/api/dinners/\(articleId)") else { return }
//
//          let headers: HTTPHeaders = [
//              .authorization(bearerToken: token),
//              .accept("application/json"),
//              .contentType("multipart/form-data")
//          ]
//
//          //文字情報と画像やファイルを送信するときは 「AF.upload(multipartFormData: …」 を使う
//          AF.upload(
//              multipartFormData: { multipartFormData in
//
//                  guard let titleTextData = self.titleTextField.text?.data(using: .utf8) else {return}
//                  multipartFormData.append(titleTextData, withName: "title")
//
////                  guard let bodyTextData = self.bodyTextView.text?.data(using: .utf8) else {return}
////                  multipartFormData.append(bodyTextData, withName: "body")
//
//                  //「PATCH」のHTTPメソッドをmultipartFormDataに追加
//                  guard let method = "patch".data(using: .utf8) else { return }
//                  multipartFormData.append(method, withName: "_method")
//
//
//              },
//              to: url,
//              method: .post,
//              headers: headers
////          ).response { response in
////              switch response.result {
////              case .success:
////                  print(response)
////                  /*  ここに更新成功のときの処理 */
////                  self.completionAlart(title: "更新完了!", message: "記事を更新しました")
////              case .failure(let err):
////                  print(err)
////                  self.okAlert.showOkAlert(title: "エラー!", message: "\(err)", viewController: self)
////              }
////          }
//          ).responseJSON { JSON in
//              print(JSON)
//          }
//      }
    //更新または削除処理完了の際に表示するアラート。OKを押すと、前の画面に戻る
    func completionAlart(title: String, message: String) {
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
       //↓ココから削除処理↓
        //削除リクエスト(DELETE)
        func deleteRequest(token: String, articleId: Int){
            guard let url = URL(string: consts.baseUrl + "/api/posts/\(articleId)") else { return }
            let headers :HTTPHeaders = [.authorization(bearerToken: token)]
            
            AF.request(
                url,
                method: .delete,
                headers: headers
            ).response { response in
                switch response.result {
                case .success:
                    self.completionAlart(title: "削除完了", message: "記事を削除しました")
                case .failure(let err):
                    print(err)
                }
            }
        }
       //↑ココまで削除処理↑
    //更新する時に確認をするアラート
    func updateAlert(token: String, articleId: Int) {
        let alert = UIAlertController(title: "更新しますか?", message: "この記事を更新してもよろしいですか?", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "更新", style: .destructive) { action in
//            self.updateRequest(article: articleId)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    //削除する時に確認をするアラート
    func deleteAlert(token: String, articleId: Int) {
        let alert = UIAlertController(title: "削除しますか?", message: "この記事を削除します", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { action in
            self.deleteRequest(token: token, articleId: articleId)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    @IBAction func title(_ sender: Any) {
    }
    
//    @IBOutlet weak var countryLabel: UILabel!
//    let apiURL = "http://api.opencube.tw/countrys"
    


    
    
//    var PickerView = UIPickerView()
//    var country:[String] = ["Japan","Spain","Costa Rica","China","Germany"]
    
    @IBAction func date(_ sender: Any) {
    }
    
//    @IBOutlet weak var language: UIPickerView!
    
    @IBOutlet weak var languageTextLabel: UILabel!
    
    @IBAction func otherTextView(_ sender: Any) {
    }
    //Update(更新)ボタン
    @IBAction func updateButton(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextView.text != "" {
            guard let id = articleId else { return }
            updateAlert(token: token, articleId: id)
        } else {
            okAlert.showOkAlert(title: "未入力欄があります", message: "全ての欄を入力してください", viewController: self)
        }
        
    }
    //Delete(削除)ボタン
    @IBAction func deleteButton(_ sender: Any) {
        guard let articleId = articleId else { return }
        deleteAlert(token: token, articleId: articleId)
        
    }
    
    //投稿時のpostRequestメソッドのbodyとtitleだけバージョン(更新なのでpatch)
    //ArticleIDをdinnereIDに変えて、articleを画面からもってくる。
    func updateRequest(article: Article) {
        let url = URL(string: consts.baseUrl + "/api/dinners/\(article.id)")!
        let parameters: Parameters = [
            "description": article.description,
            "title": article.title,
            "country": article.country,
            "other": article.other,
//            "user_id": article.user_id,
            "category_id": article.category_id,
            "description": article.description,
//            "created_at": article.created_at,
//            "updated_at": article.updated_at,
//            "user_name": article.user_name,
            "calendar": article.calendar,
//            "category_name": article.category_name,
        ]
        let headers :HTTPHeaders = [.authorization(bearerToken: token)]
        AF.request(url,
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                self.okAlert.showOkAlert(title: "更新しました", message: "記事の更新をしました", viewController: self)
            case .failure(let err):
                self.okAlert.showOkAlert(title: "エラー", message: err.localizedDescription, viewController: self)
                print(err.localizedDescription)
            }
        }
    }
}

//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        titleTextField.resignFirstResponder()


extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return consts.country.count
    }
     
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return consts.country[row]
    }
     
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        // 処理
    }
}



















/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


