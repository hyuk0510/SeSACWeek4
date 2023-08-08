//
//  BeerListViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class BeerListViewController: UIViewController {

    var count = 0
    
    @IBOutlet var beerListCollectionView: UICollectionView!

    static let identifier = "BeerListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerListCollectionView.delegate = self
        beerListCollectionView.dataSource = self
        
        connectCell()
        callRequest()
    }
}

extension BeerListViewController {
    func connectCell() {
        let nib = UINib(nibName: BeerListCollectionViewCell.identifier, bundle: nil)
        
        beerListCollectionView.register(nib, forCellWithReuseIdentifier: BeerListCollectionViewCell.identifier)
    }
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                let beerImage = json[0]["image_url"].stringValue
                print(beerImage)
//                for item in json {
//                    let beerImage = item["image_url"].stringValue
//                }
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension BeerListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerListCollectionViewCell.identifier, for: indexPath)
        as! BeerListCollectionViewCell
        
        cell.configureCell()
        count = cell.count
        
        return cell
    }
}
