//
//  EditProfilVC.swift
//  News
//
//  Created by Bilal Durnagöl on 1.12.2020.
//

import UIKit

struct Account {
    let title: String
    let info: String
    let isSecureTextEntry: Bool
}

class EditProfileVC: UIViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .systemRed
        spinner.style = .large
        return spinner
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let validationErrorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen
        label.text = "There was a problem signing in. Check your email and password or create an account."
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    var data = [Account]()
    private var user: User?
    private var isValidEmail: Bool?
    private var isValidPassword: Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 253/255, alpha: 1)
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.addSubview(validationErrorLabel)
        view.addSubview(validationErrorLabel)
        
        setupNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = createTableHeaderView()
        //full screen tableview
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        
        //hide keyboard
        let gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureHideKeyboard)
        
    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        guard let name = user.user_name, let email = user.user_email, let password = user.user_password else {return}
        data.append(Account(title: "ADINIZ SOYADINIZ", info: name, isSecureTextEntry: false))
        data.append(Account(title: "EMAİL ADRESİNİZ", info: email, isSecureTextEntry: false))
        data.append(Account(title: "ŞİFRENİZ", info: password, isSecureTextEntry: true))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinner.center = view.center
        validationErrorLabel.frame = CGRect(x: 0, y: view.bottom - 70, width: view.width, height: 70)
    }
    //Setup navigation bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapExit))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: .plain, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    //MARK:- Objc funcs
    @objc private func didTapExit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton() {
        hideKeyboard()
        if isValidPassword ?? true, isValidEmail ?? true {
        spinner.startAnimating()
        let newUserInfo = user
        guard let id = newUserInfo?.user_id,
              let name = newUserInfo?.user_name,
              let email = newUserInfo?.user_email,
              let password = newUserInfo?.user_password else {return}
        DatabaseManager.shared.editProfile(userID: id, userName: name, userEmail: email, userPassword: password, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            if result {
                print("Success to edit profile")
                UserDefaults.standard.set(email, forKey: "currentUser")
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                    let vc = SettingsVC()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
            }else {
                print("Failed to edit profile")
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                }
            }
        })
        }else {
            if !(isValidPassword ?? true) {
                ValidationError(text: "Geçersiz parola girdiniz.")
            }else if !(isValidEmail ?? true) {
                ValidationError(text: "Geçersiz email girdiniz.")
            }
            
        }
    }
    //hide keyboard
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Error Funcs
    /// show login user error
    private func ValidationError(text: String) {
        validationErrorLabel.isHidden = false
        validationErrorLabel.text = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[weak self] in
            self?.validationErrorLabel.isHidden = true
        })
    }
    
    //MARK:- Validations Funcs
    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    private func validatePassword(candidate: String) -> Bool {
        let passwordRegex = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    private func createTableHeaderView() -> UIView {
        
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/6).integral)
        let backgroundImage = UIImageView(frame: header.bounds)
        backgroundImage.image = UIImage(named: "settings_background")
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 69, width: view.width, height: 30))
        titleLabel.text = "HESAP"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        header.addSubview(backgroundImage)
        header.addSubview(titleLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier, for: indexPath) as! EditProfileTableViewCell
        let model = data[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(title: model.title,
                       info: model.info,
                       isSecureTextEntry: model.isSecureTextEntry,
                       row: indexPath.row)
        
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension EditProfileVC: EditProfileTableViewCellDelegate {
    func getNewInfo(text: String, row: Int) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        if row == 0 {
            user?.user_name = text
        }else if row == 1 {
            user?.user_email = text
            if !validateEmail(candidate: text) {
                isValidEmail = false
            }else {
                isValidEmail = true
            }
        }else {
            user?.user_password = text
            if !validatePassword(candidate: text) {
                isValidPassword = false
            }else {
                isValidPassword = true
            }
        }
    }
}
