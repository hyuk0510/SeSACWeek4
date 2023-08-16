//
//  TranslationViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/07.
//

import UIKit

class TranslationViewController: UIViewController {

    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalTextView.text = UserDefaultsHelper.standard.nickname
        UserDefaults.standard.string(forKey: "nickname")
        
        UserDefaults.standard.set("선상혁", forKey: "nickname")
        UserDefaultsHelper.standard.nickname = "졸려"
        
        originalTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
    }
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        TranslateAPIManager.shared.callRequest(text: originalTextView.text ?? "") { result in
            self.translateTextView.text = result
        }
    }
}
