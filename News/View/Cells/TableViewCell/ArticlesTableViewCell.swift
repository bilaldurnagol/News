//
//  ArticlesTableViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit
import SDWebImage

class ArticlesTableViewCell: UITableViewCell {
    
    static let identifier = "ArticlesTableViewCell"
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "image2")
        imageView.layer.cornerRadius = 20.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Lunch Break angels swing above mmters passing"
        label.font = UIFont(name: "SFCompactDisplay-Medium", size: 18)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let articlePublishedAtLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Min read | 26 oct"
        label.font = UIFont(name: "SFCompactDisplay-Light", size: 16)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        
        contentView.addSubview(articleImageView)
        contentView.addSubview(articleTitleLabel)
        contentView.addSubview(articlePublishedAtLabel)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        articleImageView.frame = CGRect(x: 0,
                                        y: 25,
                                        width: 120,
                                        height: 80)
        
        articleTitleLabel.frame = CGRect(x: articleImageView.right + 24,
                                         y: 25,
                                         width: contentView.width - articleImageView.width - 49,
                                         height: 53)
        
        articlePublishedAtLabel.frame = CGRect(x: articleImageView.right + 24,
                                               y: articleTitleLabel.bottom + 7,
                                               width: contentView.width - articleImageView.width - 49,
                                               height: 20)
    }
    
    public func configure(article: Article?) {
        articleTitleLabel.text = article?.title
        articlePublishedAtLabel.text = article?.published_at
        
        if article?.url_to_image == nil {
            articleImageView.image = UIImage(named: "newsLogo")
        }else {
            articleImageView.sd_setImage(with: URL(string: article?.url_to_image ?? ""), completed: nil)
        }
        
    }
    
}


/*
 SF Compact Display
 == SFCompactDisplay-Regular
 == SFCompactDisplay-Ultralight
 == SFCompactDisplay-Thin
 == SFCompactDisplay-Light
 == SFCompactDisplay-Medium
 == SFCompactDisplay-Semibold
 == SFCompactDisplay-Bold
 == SFCompactDisplay-Heavy
 == SFCompactDisplay-Black
 */
