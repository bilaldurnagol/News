//
//  IconTextButton.swift
//  News
//
//  Created by Bilal Durnagöl on 28.11.2020.
//

import UIKit

import UIKit

struct IconTextButtonViewModel {
    let text: String
    let image: UIImage?
    let backgroundColor: UIColor?
}

final class IconTextButton: UIButton {
    
    private let primaryLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(primaryLabel)
        addSubview(iconImageView)
        clipsToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: IconTextButtonViewModel) {
        primaryLabel.text = viewModel.text
        iconImageView.image = viewModel.image
        backgroundColor = viewModel.backgroundColor
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        primaryLabel.sizeToFit()
        let iconSize:CGFloat = 25
        let iconX: CGFloat = (frame.size.width - primaryLabel.frame.size.width - iconSize - 5) / 2
        iconImageView.frame = CGRect(x: iconX, y: (frame.size.height - iconSize)/2, width: iconSize, height: iconSize)
        primaryLabel.frame = CGRect(x: iconX + iconSize + 10, y: 0, width: primaryLabel.frame.size.width, height: frame.size.height)

    }

}
