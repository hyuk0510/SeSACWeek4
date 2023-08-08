//
//  BeerListCollectionViewCell.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerListCollectionViewCell: UICollectionViewCell {

    var count = 0
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var infoTextView: UITextView!
    
    static let identifier = "BeerListCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell() {
        let url = "https://api.punkapi.com/v2/beers"

        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.count = json.count
                
                for index in 0..<json.count {
                    let imageURL = URL(string: json[index]["image_url"].stringValue)
                    let beerName = json[index]["name"].stringValue
                    let beerInfo = json[index]["description"].stringValue
                    
                    self.imageView.kf.setImage(with: imageURL)
                    self.nameLabel.text = beerName
                    self.infoTextView.text = beerInfo
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
