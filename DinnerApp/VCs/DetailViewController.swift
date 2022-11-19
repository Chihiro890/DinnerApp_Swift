//
//  DetailViewController.swift
//  DinnerApp
//
//  Created by 板垣千尋 on 2022/11/13.
//

import UIKit
import Alamofire
import KeychainAccess

class DetailViewController: UIViewController {
    var articleId: Int!
    var myUser: User!
    
    let consts = Constants.shared
    let commentSectionName = ["コメント覧"] //セクションのタイトル
    private var token = ""
    var comments: [Comment] = []
    let okAlert = OkAlert()
    
    @IBOutlet weak var titleLabel: UILabel! //①
    @IBOutlet weak var country: UILabel! //③
    @IBOutlet weak var dateLabel: UILabel! //③
    @IBOutlet weak var languageAtLabel: UILabel! //③
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel! //③
    @IBOutlet weak var authorlabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView! //⑥
    // @IBOutlet weak var editAndDeleteButtonState: UIBarButtonItem! //⑦
    @IBOutlet weak var editButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタンを使えなくして、色を透明にする(見えなくする)
        //        editAndDeleteButtonState.isEnabled = false
        //        editAndDeleteButtonState.tintColor = UIColor.clear
                token = LoadToken().loadAccessToken() //トークン読み込み
        commentTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //IDが渡ってきているかをチェックしてから実行
        if let id = articleId {
            getArticleWithComments(id: id)
        }
    }
    
    //idから記事と一緒にコメントを取得
    func getArticleWithComments(id: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/dinners/\(id)") else { return }
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: Article.self) { response in
            switch response.result {
            case .success(let article):
                print("🌟success from Detail🌟")
                
                //それぞれのラベルやイメージビューに受け取ったものを入れる
                self.titleLabel.text = article.title
                self.authorlabel.text = article.user_name
                
                self.dateLabel.text = article.calendar
                self.createdAtLabel.text = article.created_at
                
                self.descriptionLabel.text = article.description
//                self.languageAtLabel.text = article.language
                self.country.text = article.country
                
                //コメントがあったら定義しておいた変数に入れる
                guard let comments = article.comments else { return }
                print("🌟Comments data Get!!🌟")
                
                self.comments = comments
                self.commentTableView.reloadData()
                
                //投稿者と自分のnameが一致したとき…
                if let user = self.myUser {
                    if user.name == article.user_name {
                        //編集削除のボタンを見えるようにして押せる状態にする
//                        self.editButton.isEnabled = true
//                        self.editButton.tintColor = UIColor.systemBlue
                        //                        self.deleteButtonState.isEnabled = true
                        //                        self.deleteButtonState.tintColor = UIColor.systemBlue
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func editButton(_ sender: Any) {
        guard let articleId = articleId else { return }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "Edit") as! EditViewController
        editVC.articleId = articleId
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBAction func commentButton(_ sender: Any) {
        let comment = commentTextField.text!
        
        postRequest(comment: comment)
    }

    func postRequest(comment: String) {
             //URL生成
        let url = URL(string: consts.baseUrl + "/api/dinners/\(String(describing: articleId!))/comments")!
             // Qiita API V2に合わせたパラメータを設定
            let parameters: Parameters = [
                "body": comment,
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
                    self.okAlert.showOkAlert(title: "commented", message: "コメントしました !", viewController: self)
                    self.getArticleWithComments(id: self.articleId)
////     ビューに行かなくていい。
//                    self.titleTextField.text = ""
////                  r  self.searchcountry. PickerView= ""
//                    self.detailTextView.text = ""
               //failure
                case .failure(let err):
//                    self.okAlert.showOkAlert(title: "エラー", message: err.localizedDescription, viewController: self)
                    print(err.localizedDescription)
                }
            }
        }

}

extension DetailViewController: UITableViewDataSource {
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentSectionName.count
    }
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return commentSectionName[section]
    }
    
    //セクション内の行(セル)の数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    //行(セル)の内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
        cell.commentLabel.text = comments[indexPath.row].body
        cell.commentAuthorLabel.text = comments[indexPath.row].user_name
        return cell
    }
}

