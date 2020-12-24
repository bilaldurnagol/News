//
//  EditTopicsVC.swift
//  News
//
//  Created by Bilal Durnagöl on 2.12.2020.
//

import UIKit

class EditTopicsVC: UIViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .systemRed
        spinner.style = .large
        return spinner
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TopicsTableViewCell.self, forCellReuseIdentifier: TopicsTableViewCell.identifier)
        return tableView
    }()
    
    private var user: User?
    private var userTopicsArray: [Topics]?
    private let topicsArray: [String] = ["İş","Eğlence","Sağlık","Bilim","Spor","Teknoloji"]
    private var chooseTopicArray = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 253/255, alpha: 1)
        setupNavBar()
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        guard let topics = user.topics else {return}
        userTopicsArray = topics
        
        guard let topicCount = userTopicsArray?.count else {return}
        for i in 0..<topicCount {
            guard let topic = userTopicsArray?[i].topic_name else {return}
            chooseTopicArray.append(topic)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        spinner.startAnimating()
        guard let userID = user?.user_id else {return}
        DatabaseManager.shared.updateTopics(topics: chooseTopicArray, userID: userID, completion: { [weak self] result in
            guard let strongSelf = self else {return}
            if result {
                print("Success to update topic")
                UserDefaults.standard.setValue(strongSelf.chooseTopicArray, forKey: "userTopics")
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                    let vc = SettingsVC()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
            } else {
                print("Failed to update topic")
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                }
            }
        })
    }
}

extension EditTopicsVC: UITableViewDelegate, UITableViewDataSource {
    
    private func createTableHeaderView() -> UIView {
        
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/6).integral)
        let backgroundImage = UIImageView(frame: header.bounds)
        backgroundImage.image = UIImage(named: "settings_background")
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 69, width: view.width, height: 30))
        titleLabel.text = "KATEGORİ"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        header.addSubview(backgroundImage)
        header.addSubview(titleLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicsTableViewCell.identifier,
                                                 for: indexPath) as! TopicsTableViewCell
        cell.configure(topic: topicsArray[indexPath.row], chooseTopics: userTopicsArray!, row: indexPath.row)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension EditTopicsVC: TopicsTableViewCellDelegate {
    func changeTopic(topic: String, row: Int, selected: Bool) {
        if selected == true {
            chooseTopicArray.append(topic)
            print("\(chooseTopicArray)")
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
           
            if let index = chooseTopicArray.firstIndex(of: topic) {
                chooseTopicArray.remove(at: index)
                print("\(chooseTopicArray)")
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}
