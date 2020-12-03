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

    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var data = [Account]()
    private var user: UserInfo?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 253/255, alpha: 1)
        view.addSubview(tableView)
        setupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = createTableHeaderView()
        //full screen tableview
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.separatorStyle = .none
        
        
        
    }
    init(user: UserInfo) {
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
    
    @objc private func didTapExit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton() {
        print("save button")
        let newUserInfo = user
        guard let id = newUserInfo?.user_id,
              let name = newUserInfo?.user_name,
              let email = newUserInfo?.user_email,
              let password = newUserInfo?.user_password else {return}
        
        WebService.shared.updateUserInfo(user_id: id, user_name: name, user_email: email, user_password: password, completion: { result in
            if result {
                print("success update user")
                DispatchQueue.main.async {
                    let vc = SettingsVC()
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                print("failed to update user")
            }
            
        })
        
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
        
        let titleLabel = UILabel(frame: CGRect(x: 150, y: 69, width: view.width - 300, height: 30))
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
        }else {
            user?.user_password = text
        }
    }
}
