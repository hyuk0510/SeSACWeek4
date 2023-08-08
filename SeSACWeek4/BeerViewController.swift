//
//  BeerViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {
    static let identifier = "BeerViewController"
    
    @IBOutlet var titleLabel: UILabel!
        
    @IBOutlet var backView: UIView!
    @IBOutlet var beerImageView: UIImageView!
    
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var beerInfoLabel: UILabel!
    
    @IBOutlet var recommendBeerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
        designTitleLabel()
        designNameLabel()
        designInfoLabel()
        designRecommendButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func recommendButtonPressed(_ sender: UIButton) {
        callRequest()
    }
}

extension BeerViewController {
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let beerName = json[0]["name"].stringValue
                let beerInfo = json[0]["description"].stringValue
                let imageURL = URL(string: json[0]["image_url"].stringValue)
                
                self.beerImageView.kf.setImage(with: imageURL)
                self.beerNameLabel.text = beerName
                self.beerInfoLabel.text = beerInfo

                self.view.setNeedsDisplay()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func designTitleLabel() {
        titleLabel.text = "오늘은 이 맥주를 추천합니다!"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func designNameLabel() {
        beerNameLabel.text = ""
        beerNameLabel.textAlignment = .center
        beerNameLabel.font = .boldSystemFont(ofSize: 15)
    }

    func designInfoLabel() {
        beerInfoLabel.text = ""
        beerInfoLabel.textAlignment = .center
        beerInfoLabel.font = .boldSystemFont(ofSize: 13)
        beerInfoLabel.numberOfLines = 0
    }
    
    func designRecommendButton() {
        var config = UIButton.Configuration.filled()
        config.title = "다른 맥주 추천받기"
        config.image = UIImage(systemName: "star.fill")
        
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .orange
        config.imagePlacement = .leading
        config.titleAlignment = .trailing
        
        recommendBeerButton.configuration = config
    }
}
