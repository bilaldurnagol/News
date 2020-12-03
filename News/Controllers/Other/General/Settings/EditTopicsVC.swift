//
//  EditTopicsVC.swift
//  News
//
//  Created by Bilal Durnagöl on 2.12.2020.
//

import UIKit

class EditTopicsVC: UIViewController {
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TopicsTableViewCell.self, forCellReuseIdentifier: TopicsTableViewCell.identifier)
        return tableView
    }()
    
    private var user: UserInfo?
    private var userTopicsArray: [Topics]?
    private let topicsArray: [String] = ["İş","Eğlence","Sağlık","Bilim","Spor","Teknoloji"]
    private var chooseTopicArray = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 253/255, alpha: 1)
        setupNavBar()
        view.addSubview(tableView)
        
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

    }
    init(user: UserInfo) {
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
        guard let user_id = user?.user_id else {return}
        
        WebService.shared.updateTopics(topics: chooseTopicArray, user_id: user_id, completion: {result in
            if result {
                print("success to update topic")
                UserDefaults.standard.setValue(self.chooseTopicArray, forKey: "chooseTopics")
                DispatchQueue.main.async {
                    let vc = ArticleVC()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
            } else {
                print("failed to update topic")
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
        
        let titleLabel = UILabel(frame: CGRect(x: 150, y: 69, width: view.width - 300, height: 30))
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
