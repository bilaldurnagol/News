//
//  ArticleVC.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit

class ArticleVC: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        tableView.register(FeaturedArticleTableViewCell.self, forCellReuseIdentifier: FeaturedArticleTableViewCell.identifier)
        tableView.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        return tableView
    }()
    let customBackgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
    
    private var topicArray = UserDefaults.standard.value(forKey: "userTopics")
    private var regionCode = UserDefaults.standard.value(forKey: "regionCode")
    private var currentUser = UserDefaults.standard.value(forKey: "currentUser")
    
    private var articles: [Article]?
    private var featuredArticle: [Article]?
    
    private let localhost = "http://34.76.59.104"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = customBackgroundColor
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        guard let regionCode = regionCode else {return}
        getArticles(url: "\(localhost)/articles/\(regionCode)/general")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 25,
                                 y: view.safeAreaInsets.top,
                                 width: view.width - 27,
                                 height: view.height - 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Check internet
        if NetworkMonitor.shared.isConnection == true {
            
        } else {
            let vc = ConnectionControlVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
        //Check isnewuser for onboarding
        let currentUser = UserDefaults.standard.value(forKey: "currentUser")
        if currentUser == nil {
            let vc = OnboardingVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let regionCode = regionCode else {return}
        getFeaturedArticle(url: "\(localhost)/featured_article/\(regionCode)")
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettingsButton))
    }
    
    //MARK:- Article Funcs
    
    //get all articles
    private func getArticles(url: String) {
        DatabaseManager.shared.getArticles(url: url, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let articles):
                guard let articles = articles else {return}
                strongSelf.articles = articles
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        })
    }
    
    //get featured article
    private func getFeaturedArticle(url: String) {
        DatabaseManager.shared.getFeaturedArticle(url: url, completion: {[weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let article):
                guard let featuredArticle = article else {return}
                strongSelf.featuredArticle = featuredArticle
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        })
    }
    
    //MARK: -objc Funcs
    @objc private func didTapSettingsButton() {
        let vc = SettingsVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}


//MARK: - Tableview configure
extension ArticleVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else {
            return articles?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier,
                                                     for: indexPath) as! CollectionTableViewCell
            cell.configure(topics: topicArray as? [String])
            cell.delegate = self
            return cell
        }else if indexPath.section == 1 {
            let featuredArticle = self.featuredArticle?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: FeaturedArticleTableViewCell.identifier,
                                                     for: indexPath) as! FeaturedArticleTableViewCell
            cell.configure(article: featuredArticle)
            return cell
        }else {
            let article = articles?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier,
                                                     for: indexPath) as! ArticlesTableViewCell
            cell.configure(article: article)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let featuredArticle = self.featuredArticle?[indexPath.row]
            let vc = ShowArticleVC(article: featuredArticle)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }else {
            let article = articles?[indexPath.row]
            let vc = ShowArticleVC(article: article)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 67
        } else if indexPath.section == 1 {
            return 293
        } else {
            return 130
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        }else if section == 1 {
            return 20
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.sizeToFit()
            view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 22, width: 300, height: 91))
            titleLabel.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            titleLabel.text = "Konu başlığı \nseç"
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont(name: "SFCompactDisplay-Medium", size: 38)
            titleLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
            view.addSubview(titleLabel)
            return view
            
        } else if section == 1 {
            let view = UIView()
            view.sizeToFit()
            view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
            titleLabel.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            titleLabel.text = "En çok okunan"
            titleLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 20)
            titleLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
            view.addSubview(titleLabel)
            return view
        } else {
            let view = UIView()
            view.sizeToFit()
            view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
            titleLabel.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            titleLabel.text = "Senin için"
            titleLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 20)
            titleLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
            view.addSubview(titleLabel)
            return view
        }
    }
}

extension ArticleVC: CollectionTableViewCellDelegate {
    func chooseTopic(topic: [Article]) {
        self.articles = topic
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
