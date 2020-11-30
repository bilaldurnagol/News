//
//  OnboardingTopicCollectionViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 30.10.2020.
//

import UIKit

class RegisterTopicCollectionViewCell: UICollectionViewCell {
    static let identifier = "OnboardingTopicCollectionViewCell"
    private let topicImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(topicImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topicImage.frame = contentView.bounds
    }
    
    func configure(imageName: String) {
        self.topicImage.image = UIImage(named: imageName)
    }
}
