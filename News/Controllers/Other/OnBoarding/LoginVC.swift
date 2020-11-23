//
//  LoginVC.swift
//  News
//
//  Created by Bilal Durnagöl on 23.11.2020.
//

import UIKit

class LoginVC: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "login")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SFCompactDisplay-Semibold", size: 32)
        label.text = "Giriş"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SFCompactDisplay-Medium", size: 16)
        label.text = "Dünya'dan haber almak için giriş yapınız."
        return label
    }()
    private let usernameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .next
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter username or email...",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
    }()
    
    private let passwordTextfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .continue
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter password...",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Medium", size: 24)
        button.setTitleColor(UIColor(red: 83/255, green: 100/255, blue: 232/255, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30.0
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        let attributedString = NSMutableAttributedString(string: "veya\nÜye Ol")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(.font,
                                      value: UIFont(name: "SFCompactDisplay-Medium", size: 24)!,
                                      range: NSRange(location: 4, length: 7))
        
        
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 83/255, green: 100/255, blue: 232/255, alpha: 1)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subtitleLabel)
        scrollView.addSubview(usernameTextfield)
        scrollView.addSubview(passwordTextfield)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(didTabRegisterButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: 48, y: scrollView.top + 130, width: scrollView.width - 96, height: 194)
        titleLabel.frame = CGRect(x: 96, y:imageView.bottom + 50, width: scrollView.width - 192, height: 32)
        subtitleLabel.frame = CGRect(x: 22, y:titleLabel.bottom + 14, width: scrollView.width - 44, height: 32)
        usernameTextfield.frame = CGRect(x: 22, y:subtitleLabel.bottom + 14, width: scrollView.width - 44, height: 30)
        passwordTextfield.frame = CGRect(x: 22, y:usernameTextfield.bottom + 27, width: scrollView.width - 44, height: 30)
        loginButton.frame = CGRect(x: 22, y:passwordTextfield.bottom + 27, width: scrollView.width - 44, height: 60)
        registerButton.frame = CGRect(x: 22, y:loginButton.bottom + 13, width: scrollView.width - 44, height: 60)
        
        
        usernameTextfield.addBottomBorder()
        passwordTextfield.addBottomBorder()
        
        
    }
    
    @objc private func didTabRegisterButton() {
        let vc = RegisterVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
