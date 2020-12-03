//
//  EditProfileTableViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 1.12.2020.
//

import UIKit

protocol EditProfileTableViewCellDelegate {
    func getNewInfo(text: String, row: Int)
}

class EditProfileTableViewCell: UITableViewCell {
    
    static let identifier = "EditProfileTableViewCell"
    var delegate: EditProfileTableViewCellDelegate?
    var row: Int?
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let textfield: UITextField = {
       let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.font = .systemFont(ofSize: 24, weight: .bold)
        textfield.layer.borderWidth = 1.0
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textfield.layer.borderColor = UIColor.systemGray.cgColor
        return textfield
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textfield)
        textfield.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 20,
                                  y: 0,
                                  width: contentView.width,
                                  height: 3*contentView.height/4)
        
        textfield.frame = CGRect(x: 0,
                                 y: titleLabel.bottom,
                                 width: contentView.width,
                                 height: contentView.height/4)
    }
    
    public func configure(title: String, info: String, isSecureTextEntry: Bool, row: Int){
        titleLabel.text = title
        textfield.text = info
        textfield.isSecureTextEntry = isSecureTextEntry
        self.row = row
    }
}
extension EditProfileTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let infoText = textfield.text!
        let safe_row = row!
        if let delegate = self.delegate {
            delegate.getNewInfo(text: infoText, row: safe_row)
        }
    }
}
