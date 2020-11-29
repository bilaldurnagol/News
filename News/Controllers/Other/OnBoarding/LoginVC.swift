//
//  LoginVC.swift
//  News
//
//  Created by Bilal Durnagöl on 26.11.2020.
//

import UIKit

class LoginVC: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubbles_blur")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Giriş yapınız"
        label.textColor = UIColor(red: 34/255, green: 56/255, blue: 156/255, alpha: 1)
        label.font = UIFont(name: "PlayfairDisplay-Black", size: 40.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 251/255, alpha: 1)
        stackView.layer.masksToBounds = true
        stackView.layer.borderWidth = 2.0
        stackView.layer.cornerRadius = 8.0
        stackView.layer.borderColor = UIColor(red: 215/255, green: 218/255, blue: 235/255, alpha: 1).cgColor
        return stackView
    }()
    
    private let emailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .continue
        textfield.leftViewMode = .always
        textfield.keyboardType = .emailAddress
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.textColor = UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1.0)
        textfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1.0)])
        return textfield
    }()
    
    private let passwordTextfield: UITextField = {
        let textfield = UITextField()
        textfield.returnKeyType = .done
        textfield.leftViewMode = .always
        textfield.keyboardType = .default
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.masksToBounds = true
        textfield.isSecureTextEntry = true
        textfield.textColor = UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1.0)
        textfield.attributedPlaceholder = NSAttributedString(string: "Şifre",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1.0)])
        return textfield
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Semibold", size: 20)
        button.backgroundColor = UIColor(red: 39/255, green: 62/255, blue: 168/255, alpha: 1)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Bu uygulamaya üyeliğim yok. Kayıt yap")
        attributedString.addAttribute(.link, value: "Giriş Yap", range: NSRange(location: 28, length: 9))
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        label.textColor = UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactDisplay-Regular", size: 15)
        return label
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = UIFont(name: "PlayfairDisplay-Black", size: 15.0)
        label.textColor = UIColor(red: 27/255, green: 36/255, blue: 92/255, alpha: 1)
        label.textAlignment = .center
        
        return label
    }()
    
    private let seperatorViewName: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 215/255, green: 218/255, blue: 235/255, alpha: 1)
        return separator
    }()
    
    private let seperatorViewEmail: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 215/255, green: 218/255, blue: 235/255, alpha: 1)
        return separator
    }()
    
    let facebookButton = IconTextButton(frame: CGRect(x: 0, y: 0, width: 300 , height: 55))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(seperatorViewEmail)
        stackView.addArrangedSubview(emailTextfield)
        stackView.addArrangedSubview(seperatorViewName)
        stackView.addArrangedSubview(passwordTextfield)
        scrollView.addSubview(orLabel)
        scrollView.addSubview(facebookButton)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(signUpLabel)
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        facebookButton.configure(with: IconTextButtonViewModel(text: "Facebook ile giriş", image: UIImage(named: "facebook_icon"), backgroundColor: UIColor.clear))
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSignUp))
        signUpLabel.addGestureRecognizer(gesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        imageView.frame = scrollView.bounds
        
        let width = scrollView.width - 90
        
        titleLabel.frame = CGRect(x: 45, y: scrollView.top + 142, width: width, height: 60)
        stackView.frame = CGRect(x: 45, y: titleLabel.bottom + 35, width: width, height: 140)
        loginButton.frame = CGRect(x: 45, y: stackView.bottom + 15, width: width, height: 55)
        orLabel.frame = CGRect(x: 45, y: loginButton.bottom + 20, width: width, height: 35)
        facebookButton.frame = CGRect(x: 45, y: orLabel.bottom + 20, width: width, height: 55)
        signUpLabel.frame = CGRect(x: 45, y: facebookButton.bottom + 23 , width: scrollView.width - 90, height: 20)
        
        
        
        
        //seperator's
        self.seperatorViewEmail.translatesAutoresizingMaskIntoConstraints = false
        self.seperatorViewEmail.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 25).isActive = true
        self.seperatorViewEmail.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -25).isActive = true
        self.seperatorViewEmail.bottomAnchor.constraint(equalTo: seperatorViewEmail.topAnchor, constant: 1).isActive = true
        
        
        self.seperatorViewName.translatesAutoresizingMaskIntoConstraints = false
        self.seperatorViewName.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 25).isActive = true
        self.seperatorViewName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -25).isActive = true
        self.seperatorViewName.bottomAnchor.constraint(equalTo: seperatorViewName.topAnchor, constant: 1).isActive = true
        
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    //objc
    @objc private func didTapSignUp() {
        let vc = RegisterVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogin() {
        print("Did tap login button")
    }
}
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            passwordTextfield.becomeFirstResponder()
        }else if textField == passwordTextfield {
            didTapLogin()
        }
        return true
    }
}
