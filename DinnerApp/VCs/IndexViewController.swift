//
//  IndexViewController.swift
//  DinnerApp
//
//  Created by 板垣千尋 on 2022/11/13.
//

import UIKit
import Alamofire
import Kingfisher
import KeychainAccess

class IndexViewController: UIViewController {
    @IBOutlet weak var indexTableView: UITableView!
    
    @IBOutlet weak var search_country: UIPickerView!
    
    @IBOutlet weak var from_date: UIDatePicker!
    
    @IBOutlet weak var to_date: UIDatePicker!
    
    
    
    let consts = Constants.shared
    let sectionTitle = ["TOPIC"]
    private var token = ""
    
       var articles: [Article] = []
//       var country: country!
//       var language: User!
       var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTableView.dataSource = self
        indexTableView.delegate = self
        
       
//        getUser()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        requestIndex()
    }
    
    func requestIndex(){
//            //URL、トークン、ヘッダーを用意
            let url = URL(string: consts.baseUrl + "/api/dinners")!//たたきたいapiのURL
            let token = LoadToken().loadAccessToken()
            let headers: HTTPHeaders = [
                .contentType("application/json"),
                .accept("application/json"),
                .authorization(bearerToken: token)
            ]

            /* ヘッダーはこの書き方でもOK
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(token)",
            ]
            */
            
            //Alamofireでリクエスト
            AF.request(
                url,
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers
            ).responseDecodable(of: Index.self) { response in
                switch response.result {
                case .success(let articles):
                    print("🔥success from Index🔥")
                    if let atcls = articles.data {
                        self.articles = atcls
                        self.indexTableView.reloadData()
//                        print(self.articles)
                    }
                case .failure(let err):
                    print(err)
                }
            }
//            ).responseJSON{JSON in
//                print(JSON)
//            }
        }
    
    //自分(user)の情報取得(idとname)
    func getUser() {
        let url = URL(string: consts.baseUrl + "/api/user")!
        let token = LoadToken().loadAccessToken()
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request(
            url,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: User.self){ response in
            switch response.result {
            case .success(let user):
                self.user = user
            case .failure(let err):
                
//                self.dateLabel.text = article.calendar
//                titleLabel.text = "kaka"
//                titleView.text = "jj"
                print(err)
            }
        }
    }
    @IBAction func pressedCreateButtton(_ sender: Any) {
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateViewController
        navigationController?.pushViewController(createVC, animated: true)
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
extension IndexViewController: UITableViewDataSource {
    
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    //セクションの数 (= セクションのタイトルの数)
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    //行の数(= 記事の数)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    //セル1つの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndexCell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = articles[indexPath.row].title
        cell.countryAtLabel.text = articles[indexPath.row].country
        cell.dateLabel.text = articles[indexPath.row].calendar
        cell.authorLabel.text = articles[indexPath.row].user_name
        
//            cell.articleImageView.kf.setImage(with: URL(string: articles[indexPath.row].imageUrl)!)
        cell.detailLabel.text = articles[indexPath.row].description
        
        return cell
    }
    
    //セルの高さをがめんの高さの1/3に設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 1 / 3
    }
}

extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        print(article)
//        guard let user = user else { return }
        detailVC.articleId = article.id //詳細画面の変数に記事のIDを渡す
        detailVC.myUser = user //ユーザー情報も渡す
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
