//
//  EditLocationVC.swift
//  News
//
//  Created by Bilal Durnagöl on 2.12.2020.
//

import UIKit

class EditLocationVC: UIViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .systemRed
        spinner.style = .large
        return spinner
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let locationArray: [String] = ["TR", "US"]
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavBar()
        tableView.tableHeaderView = createTableHeaderView()
        //full screen tableview
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinner.center = view.center
    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    //exit button
    @objc private func didTapExit() {
        dismiss(animated: true, completion: nil)
    }
    //save new location
    @objc private func didTapSaveButton() {
        spinner.startAnimating()
        DatabaseManager.shared.updateLocation(user: user, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result {
                print("success to update user location")
                guard let location = strongSelf.user?.user_location else {return}
                UserDefaults.standard.setValue(location, forKey: "regionCode")
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                    let vc = ArticleVC()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
            }else {
                print("failed to update location")
                strongSelf.spinner.stopAnimating()
            }
        })
    }
}

extension EditLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    private func createTableHeaderView() -> UIView {
        
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/6).integral)
        let backgroundImage = UIImageView(frame: header.bounds)
        backgroundImage.image = UIImage(named: "settings_background")
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 69, width: view.width, height: 30))
        titleLabel.text = "KONUM"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        header.addSubview(backgroundImage)
        header.addSubview(titleLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if locationArray[indexPath.row] == user?.user_location {
            cell.accessoryType = .checkmark
            
        }
        cell.textLabel?.text = locationArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let selectedLocation = locationArray[indexPath.row]
        user?.user_location = selectedLocation
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
