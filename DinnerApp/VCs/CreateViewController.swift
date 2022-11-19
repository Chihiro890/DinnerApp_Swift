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
//    private var token = "" //アクセストークンを格納しておく変数
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var searchcountry: UIPickerView!
//    @IBOutlet weak var date: UIPickerView!
    @IBOutlet weak var date: UIPickerView!
//    @IBOutlet weak var languageTextView: UITextView!
    @IBOutlet weak var otherTextView: UITextField!
    @IBOutlet weak var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //token読み込み
        token = LoadToken().loadAccessToken()
        //キーチェーンからアクセストークンを取得して変数に格納
        let keychain = Keychain(service: consts.service)
        guard let token = keychain["access_token"] else { return print("NO TOKEN")}
        self.token = token
        
    }
    @IBAction func postArticle(_ sender: Any) {
//               let article = Article()
//               postRequest(article: article)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            titleTextField.resignFirstResponder()
//            bodyTextView.resignFirstResponder()
    }
    func postRequest(article: Article) {
             //URL生成
            let url = URL(string: consts.baseUrl + "/items")!
             // Qiita API V2に合わせたパラメータを設定
            let parameters: Parameters = [
                "title": article.title,
                "country": article.country,
                "calendar": article.calendar,
                "category_id":article.category_id,
                "other": article.other,
                "description": article.description,
                
//                "tags": [
//                    [
//                        "name": article.tag,
//                        "versions": []
//                    ]
//                ],
//                "title": article.title
            ]

            //ヘッダにアクセストークンを含める
            let headers :HTTPHeaders = [.authorization(bearerToken: token)]

            //Alamofireで投稿をリクエスト
            AF.request(
                url,
                method: .post,  //POSTなので注意!
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
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
