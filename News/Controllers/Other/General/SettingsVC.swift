//
//  SettingsVC.swift
//  News
//
//  Created by Bilal Durnagöl on 30.11.2020.
//

import UIKit

struct SettingsCell {
    let iconImage: String
    let title: String
    let handler: (() -> Void)
}

class SettingsVC: UIViewController {
    private let tableView: UITableView = {
       let table = UITableView()
        table.backgroundColor = .clear
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()
    private let guestLabel: UILabel = {
       let label = UILabel()
        label.text = "Ayarlar için üye olmanız gerekmektedir."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private var data = [SettingsCell]()
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 253/255, alpha: 1)
        configure()
        setupNavBar()
        guard let email = UserDefaults.standard.value(forKey: "currentUser") as? String else {return}
        DatabaseManager.shared.getUserInfo(email: email, completion: {result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self.user = user
            }
        })
        if email == "guest" {
            view.addSubview(guestLabel)
            customAlert(title: "Uyarı", message: "Ayarlar için üye olmanız gerekmektedir.")
        } else {
            view.addSubview(tableView)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeaderView()
        //full screen tableview
        tableView.contentInsetAdjustmentBehavior = .never
        //remove cell lines
        tableView.separatorStyle = .none

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        guestLabel.frame = CGRect(x: 0, y: 0, width: view.width, height: 100)
        guestLabel.center = view.center
    }
    
    private func configure() {
        data.append(SettingsCell(iconImage: "s_account", title: "Hesap", handler: {[weak self] in
            self?.didTapAcoount()
        }))
        data.append(SettingsCell(iconImage: "s_topic", title: "Kategori", handler: {[weak self] in
            self?.didTapTopic()
        }))
        data.append(SettingsCell(iconImage: "s_location", title: "Lokasyon", handler: {[weak self] in
            self?.didTapLocation()
        }))
        data.append(SettingsCell(iconImage: "s_notification", title: "Bildirimler", handler: {[weak self] in
            self?.didTapNotification()
        }))
        data.append(SettingsCell(iconImage: "s_logout", title: "Çıkış", handler: {[weak self] in
            self?.didTapLogOut()
        }))
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapExit))
    }
    
    private func didTapAcoount(){
        let vc = EditProfileVC(user: user!)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func didTapTopic(){
        let vc = EditTopicsVC(user: user!)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func didTapLocation(){
        let vc = EditLocationVC(user: user!)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    private func didTapNotification() {
        let action = UIAlertController(title: "Uyarı", message: "Bu özellik daha açılmadı. En kısa sürede aktif olacaktır.", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        present(action, animated: true)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Çıkış", message: "Çıkış yapmak istediğinize emin misiniz?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Çıkış Yap", style: .destructive, handler: {_ in
            UserDefaults.standard.setValue(nil, forKey: "userTopics")
            UserDefaults.standard.setValue(nil, forKey: "currentUser")
            UserDefaults.standard.setValue(nil, forKey: "regionCode")
            DispatchQueue.main.async {
                let vc = OnboardingVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        
        //for ipad
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
    

    @objc private func didTapExit(){
        let vc = ArticleVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //Custom alert
    private func customAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Üye Ol", style: .default, handler: {_ in
            
            UserDefaults.standard.setValue(nil, forKey: "chooseTopics")
            UserDefaults.standard.setValue(nil, forKey: "currentUser")
            UserDefaults.standard.setValue(nil, forKey: "regionCode")
            DispatchQueue.main.async {
                let vc = OnboardingVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .destructive, handler: {_ in
                let vc = ArticleVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
        }))
        present(alert, animated: true)
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    private func createTableHeaderView() -> UIView {
        
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/6).integral)
        let backgroundImage = UIImageView(frame: header.bounds)
        backgroundImage.image = UIImage(named: "settings_background")
        
        let titleLabel = UILabel(frame: CGRect(x: 150, y: 69, width: view.width - 300, height: 30))
        titleLabel.text = "AYARLAR"
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
        let model = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.backgroundColor = .clear
        cell.configure(image: model.iconImage, title: model.title)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
