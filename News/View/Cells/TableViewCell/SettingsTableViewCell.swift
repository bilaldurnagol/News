//
//  SettingsTableViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 30.11.2020.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    private let settingImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .regular)
        return label
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = UIColor(red: 144/255, green: 104/255, blue: 252/255, alpha: 1)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(settingImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nextButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(image: String, title: String) {
        settingImage.image = UIImage(named: image)
        titleLabel.text = title
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        settingImage.frame = CGRect(x: 24, y: 20, width: 60, height: 60)
        titleLabel.frame = CGRect(x: settingImage.right + 25, y: 40, width: 200, height: 30)
        nextButton.frame = CGRect(x: contentView.width - 100, y: 0, width: 100, height: 100)
        
        
    }
    
}
