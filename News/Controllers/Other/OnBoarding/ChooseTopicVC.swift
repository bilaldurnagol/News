//
//  ChooseTopicVC.swift
//  News
//
//  Created by Bilal Durnagöl on 29.11.2020.
//

import UIKit

class ChooseTopicVC: UIViewController {
    
    var collectionView: UICollectionView?
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Haber kategorilerinizi seçin"
        label.textAlignment = .center
        label.font = UIFont(name: "SFCompactDisplay-Medium", size: 27)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private let topicAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("Haberlere Geç", for: .normal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 80/255, green: 68/255, blue: 255/255, alpha: 1).cgColor
        button.backgroundColor = UIColor(red: 79/255, green: 68/255, blue: 255/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var topicArray = ["Business","Entertainment","Health","Science","Sports","Technology"]
    var deselectedTopicArray = ["Business","Entertainment","Health","Science","Sports","Technology"]
    var chooseTopicsArray = [String]()
    var safeChooseTopicsArray = ["General"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: 137, height: 113)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 50, bottom: 50, right: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(RegisterTopicCollectionViewCell.self, forCellWithReuseIdentifier: RegisterTopicCollectionViewCell.identifier )
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {return}
        collectionView.backgroundColor = .white
        scrollView.addSubview(collectionView)
        scrollView.addSubview(topicAddButton)
        
        topicAddButton.addTarget(self, action: #selector(didTapTopicAddButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        titleLabel.frame = CGRect(x: 10, y: 0, width: scrollView.width - 20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: titleLabel.bottom + 20, width: scrollView.width, height: scrollView.height - 100 - 60 - 20 - 20 - 60)
        topicAddButton.frame = CGRect(x: 45, y: collectionView!.bottom , width: scrollView.width - 90, height: 60)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - @objc funcs
    
    @objc private func didTapTopicAddButton() {
        let email = UserDefaults.standard.value(forKey: "currentUser")
        self.safeChooseTopicsArray.append(contentsOf: chooseTopicsArray)
        if email != nil {
            WebService.shared.addTopic(userEmail: email! as! String, topics: safeChooseTopicsArray, completion: {result in
                if result {
                    UserDefaults.standard.setValue(self.safeChooseTopicsArray, forKey: "chooseTopics")
                    DispatchQueue.main.async {
                        let vc = ArticleVC()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                
                } else {
                    print("Failed to added topics")
                }
            })
        } else {
            UserDefaults.standard.setValue(self.safeChooseTopicsArray, forKey: "chooseTopics")
            UserDefaults.standard.setValue("guest", forKey: "currentUser")
            DispatchQueue.main.async {
                let vc = ArticleVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
       
      
    }
    
}
extension ChooseTopicVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topic = topicArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterTopicCollectionViewCell.identifier,
                                                      for: indexPath) as! RegisterTopicCollectionViewCell
        cell.configure(imageName: topic)
        return cell
    }
    
    //choose topics func
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedTopic = topicArray[indexPath.row]
        if selectedTopic == deselectedTopicArray[indexPath.row] {
            let newTopic = "\(selectedTopic)_clicked"
            topicArray[indexPath.row] = newTopic
            self.chooseTopicsArray.append(deselectedTopicArray[indexPath.row])
            print("choose topics: \(chooseTopicsArray)")
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        } else {
            topicArray[indexPath.row] = deselectedTopicArray[indexPath.row]
            for i in chooseTopicsArray {
                if i == deselectedTopicArray[indexPath.row] {
                    if let index = chooseTopicsArray.firstIndex(of: i) {
                        chooseTopicsArray.remove(at: index)
                        print("choose topics: \(chooseTopicsArray)")
                    }
                }
            }
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
    }
    
}

