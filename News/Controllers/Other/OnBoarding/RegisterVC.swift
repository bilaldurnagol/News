//
//  LoginVC.swift
//  News
//
//  Created by Bilal Durnagöl on 23.11.2020.
//

import UIKit

class RegisterVC: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "register")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SFCompactDisplay-Semibold", size: 32)
        label.text = "Üye Ol"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SFCompactDisplay-Medium", size: 16)
        label.text = "Dünya'dan haber almaya çok yaklaştınız."
        return label
    }()
    
    private let nameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .next
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "İsim giriniz!",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
    }()
    
    private let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .next
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "Email adresi giriniz!",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
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
        textfield.attributedPlaceholder = NSAttributedString(string: "Username giriniz!",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
    }()
    
    private let passwordTextfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .next
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "Parola giriniz!",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
    }()
    
    private let confirmPassTexfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .next
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "Girdiğiniz parolayı tekrar giriniz!",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 133/255, blue: 253/255, alpha: 1.0)])
        return textfield
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Üye Ol", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Medium", size: 24)
        button.setTitleColor(UIColor(red: 83/255, green: 100/255, blue: 232/255, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30.0
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        let attributedString = NSMutableAttributedString(string: "veya\nGiriş Yap")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(.font,
                                      value: UIFont(name: "SFCompactDisplay-Medium", size: 24)!,
                                      range: NSRange(location: 4, length: 10))
        
        
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
        scrollView.addSubview(nameTextfield)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(usernameTextfield)
        scrollView.addSubview(passwordTextfield)
        scrollView.addSubview(confirmPassTexfield)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        
        loginButton.addTarget(self, action: #selector(didTabLoginButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: 48, y: scrollView.top + 130, width: scrollView.width - 96, height: 194)
        titleLabel.frame = CGRect(x: 96, y:imageView.bottom + 70, width: scrollView.width - 192, height: 32)
        subtitleLabel.frame = CGRect(x: 22, y:titleLabel.bottom + 14, width: scrollView.width - 44, height: 32)
        nameTextfield.frame = CGRect(x: 22, y:subtitleLabel.bottom + 14, width: scrollView.width - 44, height: 30)
        emailTextField.frame = CGRect(x: 22, y:nameTextfield.bottom + 14, width: scrollView.width - 44, height: 30)
        usernameTextfield.frame = CGRect(x: 22, y:emailTextField.bottom + 14, width: scrollView.width - 44, height: 30)
        passwordTextfield.frame = CGRect(x: 22, y:usernameTextfield.bottom + 14, width: scrollView.width - 44, height: 30)
        confirmPassTexfield.frame = CGRect(x: 22, y:passwordTextfield.bottom + 14, width: scrollView.width - 44, height: 30)
        registerButton.frame = CGRect(x: 22, y:confirmPassTexfield.bottom + 27, width: scrollView.width - 44, height: 60)
        loginButton.frame = CGRect(x: 22, y:registerButton.bottom + 13, width: scrollView.width - 44, height: 60)
        
        nameTextfield.addBottomBorder()
        emailTextField.addBottomBorder()
        usernameTextfield.addBottomBorder()
        passwordTextfield.addBottomBorder()
        confirmPassTexfield.addBottomBorder()
        
        
    }
    
    @objc private func didTabLoginButton() {
        let vc = LoginVC()
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
