//
//  CreateViewController.swift
//  DinnerApp
//
//  Created by 板垣千尋 on 2022/11/13.
//

import UIKit
import Alamofire
import KeychainAccess

class CreateViewController: UIViewController {
    
    private var token = ""
    let consts = Constants.shared
    let okAlert = OkAlert()
    var selectedCountry = ""
//    private var token = "" //アクセストークンを格納しておく変数
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var searchcountry: UIPickerView!
//    @IBOutlet weak var date: UIPickerView!
//    @IBOutlet weak var date: UIPickerView!
//
    @IBOutlet weak var calendarDatePicker: UIDatePicker!
    //    @IBOutlet weak var languageTextView: UITextView!
    @IBOutlet weak var otherTextView: UITextField!
    @IBOutlet weak var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchcountry.delegate = self
        searchcountry.dataSource = self
        selectedCountry = consts.country[0]
        //token読み込み
        token = LoadToken().loadAccessToken()
        //キーチェーンからアクセストークンを取得して変数に格納
        let keychain = Keychain(service: consts.service)
        guard let token = keychain["access_token"] else { return print("NO TOKEN")}
        self.token = token
        
    }
    @IBAction func postArticle(_ sender: Any) {
               postRequest()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            titleTextField.resignFirstResponder()
//            bodyTextView.resignFirstResponder()
    }
    func postRequest() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateformatter.string(from: self.calendarDatePicker.date)
             //URL生成
        
            let url = URL(string: consts.baseUrl + "/api/dinners")!
             // Qiita API V2に合わせたパラメータを設定
//        "Laravel": Xcode
            let parameters: Parameters = [
                "title": titleTextField.text!,
                "country": selectedCountry,
                "calendar": date,
                "category_id": 1,
                "other": otherTextView.text!,
                "description": detailTextView.text!,
                "user_id": 1
                
//                "tags": [
//                    [
//                        "name": article.tag,
//                        "versions": []
//                    ]
//                ],
//                "title": article.title
            ]
        
        
        print("PARAMETERS:", parameters)

            //ヘッダにアクセストークンを含める
//            let headers :HTTPHeaders = [.authorization(bearerToken: token)]
        let headers :HTTPHeaders = [.contentType("application/json"), .accept("description")]

            //Alamofireで投稿をリクエスト
            AF.request(
                url,
                method: .post,  //POSTなので注意!
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
//            ).responseJSON{JSON in
//                print(JSON)
//            }
            ).response { response in
                switch response.result {
                //Success
                case .success:
                    self.okAlert.showOkAlert(title: "Posted !", message: "投稿しました", viewController: self)
                    self.titleTextField.text = ""
//                  r  self.searchcountry. PickerView= ""
                    self.detailTextView.text = ""
               //failure
                case .failure(let err):
                    self.okAlert.showOkAlert(title: "エラー", message: err.localizedDescription, viewController: self)
                    print(err.localizedDescription)
                }
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

}

extension CreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     
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
        selectedCountry = consts.country[row]
    }
}

