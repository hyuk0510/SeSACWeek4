//
//  TranslationViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController {

    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    static let identifier = "TranslationViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
    }
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        let detectURL = "https://openapi.naver.com/v1/papago/detectLangs"
        let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "\(APIKey.naverClientID)",
            "X-Naver-Client-Secret": "\(APIKey.naverClientSecret)"
        ]
        
        let detectParameters: Parameters = [
            "query": originalTextView.text ?? ""
        ]
        
        var translateParameters: Parameters = [
            "target": "en",
            "text": originalTextView.text ?? ""
        ]
        
        AF.request(detectURL, method: .post, parameters: detectParameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let source = json["langCode"].stringValue
                translateParameters.updateValue(source, forKey: "source")
                
                AF.request(translateURL, method: .post, parameters: translateParameters, headers: header).validate().responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        
                        let data = json["message"]["result"]["translatedText"].stringValue
                        
                        self.translateTextView.text = data
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
