//
//  VideoTableViewCell.swift
//  SeSACWeek4
//
//  Created by 선상혁 on 2023/08/09.
//

import UIKit
import Kingfisher

class VideoTableViewCell: UITableViewCell {

    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.contentMode = .scaleToFill
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 2
    }
    
    func configureCell(data: Document) {
        let url = URL(string: data.thumbnail)
        let contents = "\(data.author) | \(data.playTime)회\n\(data.datetime)"
        titleLabel.text = data.title
        contentLabel.text = contents
        
        thumbnailImageView.kf.setImage(with: url)
    }
}
