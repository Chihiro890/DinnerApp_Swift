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

        //TextViewとImageViewに枠線をつける
//        let viewCustomize = ViewCustomize()
//        bodyTextView = viewCustomize.addBoundsTextView(textView: bodyTextView)
//        imageView = viewCustomize.addBoundsImageView(imageView: imageView)
        
    }
    @IBAction func postArticle(_ sender: Any) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            titleTextField.resignFirstResponder()
//            bodyTextView.resignFirstResponder()
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
