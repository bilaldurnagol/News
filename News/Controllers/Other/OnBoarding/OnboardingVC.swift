//
//  OnboardingVC.swift
//  News
//
//  Created by Bilal Durnagöl on 26.11.2020.
//

import UIKit

class OnboardingVC: UIViewController {
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubbles")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hoşgeldiniz,"
        label.textColor = .white
        label.font = UIFont(name: "PlayfairDisplay-Black", size: 50.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sizin için özel hazırlanmış haberleri sunuyoruz. \nDünya'dan haberleri almaya hazır mısınız?"
        label.textColor = .white
        label.font = UIFont(name: "SFCompactDisplay-Regular", size: 18.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0.55
        return label
    }()
    
    private let registerButton: UIButton = {
       let button = UIButton()
        button.setTitle("Kayıt ol", for: .normal)
        button.setTitleColor(UIColor(red: 34/255, green: 56/255, blue: 156/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Medium", size: 17)
        button.backgroundColor = .white
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    private let guestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Üye olmadan devam et", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFCompactDisplay-Medium", size: 17)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 34/255, green: 56/255, blue: 156/255, alpha: 1)
        
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(registerButton)
        view.addSubview(guestButton)
        setupNavBar()
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(didTapGuestButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.frame = view.bounds
        titleLabel.frame = CGRect(x: 15, y: view.top + 155, width: view.width - 30, height: 80)
        subtitleLabel.frame = CGRect(x: 15, y: titleLabel.bottom, width: view.width - 30, height: 80)
        
        guestButton.frame = CGRect(x: 45, y: view.bottom - 92, width: view.width - 90, height: 55)
        registerButton.frame = CGRect(x: 45, y: guestButton.top - 70, width: view.width - 90, height: 55)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Giriş Yap", style: .plain, target: self, action: #selector(didTabSignButton))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "SFCompactDisplay-Medium", size: 20)!], for: UIControl.State.normal)
        
    }
    
    //objc funcs
    
    @objc private func didTabSignButton() {
        let vc = LoginVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapRegisterButton() {
        let vc = RegisterVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapGuestButton() {
        let vc = ChooseTopicVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
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
 
 
 family: Playfair Display
 name: PlayfairDisplay-Black
 */
