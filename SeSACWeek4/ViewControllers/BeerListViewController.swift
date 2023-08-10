//
//  BeerListViewController.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/08.
//

import UIKit

class BeerListViewController: UIViewController {
    
    @IBOutlet var beerListCollectionView: UICollectionView!

    static let identifier = "BeerListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerListCollectionView.delegate = self
        beerListCollectionView.dataSource = self
        
        connectCell()
        
        beerListCollectionCellLayout()
    }
}

extension BeerListViewController {
    func connectCell() {
        let nib = UINib(nibName: BeerListCollectionViewCell.identifier, bundle: nil)
        
        beerListCollectionView.register(nib, forCellWithReuseIdentifier: BeerListCollectionViewCell.identifier)
    }
}

extension BeerListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerListCollectionViewCell.identifier, for: indexPath)
        as! BeerListCollectionViewCell
        
        let row = indexPath.row
        
        cell.configureCell(index: row)
                
        return cell
    }
    
    func beerListCollectionCellLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing = CGFloat(10)
        let width = UIScreen.main.bounds.width - (spacing * 10)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: UIScreen.main.bounds.height / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        beerListCollectionView.collectionViewLayout = layout
    }
}
