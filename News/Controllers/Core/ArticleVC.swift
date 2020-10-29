//
//  ArticleVC.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit

class ArticleVC: UIViewController {
    
    private var articleList: [Article]?
    private var topicArray:[String] = ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
    private var articleListVM: ArticleListViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        tableView.register(FeaturedArticleTableViewCell.self, forCellReuseIdentifier: FeaturedArticleTableViewCell.identifier)
        tableView.register(ArticlesTableViewCell.self, forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=tr&apiKey=a9ca5d6857f34469b1ab44452a983acc")else {return}
        
        getArticles(with: url, completion: {success in
            if success {print("OK!")}
            else {print("Fail!")}
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 25, y: view.safeAreaInsets.top, width: view.width - 27, height: view.height - 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetworkMonitor.shared.isConnection == true {
            
        } else {
            let vc = ConnectionControlVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        //Transparent navigationbar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func getArticles(with url: URL, completion: @escaping (Bool) -> ()) {
        
        WebService.shared.getArticles(url: url, completion: {result in
            switch result {
            case .failure(let error):
                print(error)
                completion(false)
            case .success(let articles):
                if let articles = articles {
                    self.articleListVM = ArticleListViewModel(articles: articles)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                completion(true)
            }
            
        })
    }
}
extension ArticleVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.numberOfSection
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        } else {
            return self.articleListVM.numberOfRowsInSection(section)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier,
                                                     for: indexPath) as! CollectionTableViewCell
            cell.configure(topics: topicArray)
            cell.delegate = self
            return cell
        }else if indexPath.section == 1 {
            let articleVM = articleListVM.articleAtIndex(0)
            let cell = tableView.dequeueReusableCell(withIdentifier: FeaturedArticleTableViewCell.identifier,
                                                     for: indexPath) as! FeaturedArticleTableViewCell
            cell.configure(article: articleVM)
            return cell
            
        } else {
            let articleVM = articleListVM.articleAtIndex(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier,
                                                     for: indexPath) as! ArticlesTableViewCell
            cell.configure(article: articleVM)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articleVM = articleListVM.articleAtIndex(indexPath.row)
        let vc = ShowArticleVC(model: articleVM)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
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
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 42, width: 250, height: 91))
            titleLabel.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
            titleLabel.text = "Choose your \ntopics"
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
            titleLabel.text = "Featured Article"
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
            titleLabel.text = "For you"
            titleLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 20)
            titleLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
            view.addSubview(titleLabel)
            return view
        }
    }
    
}

extension ArticleVC: CollectionTableViewCellDelegate {
    func chooseTopic(topic: ArticleListViewModel) {
        self.articleListVM = topic
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