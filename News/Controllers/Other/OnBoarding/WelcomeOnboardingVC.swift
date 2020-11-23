//
//  WelcomeOnboardingVC.swift
//  News
//
//  Created by Bilal Durnagöl on 17.11.2020.
//

import UIKit

class WelcomeOnboardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var topics: Topics?
    
    private let scrollView = UIScrollView()
    private var collectionView: UICollectionView?
    
    var topicArray = ["Business","Entertainment","Health","Science","Sports","Technology"]
    var deselectedTopicArray = ["Business","Entertainment","Health","Science","Sports","Technology"]
    var chooseTopicsArray = [String]()
    var safeChooseTopicsArray = ["General"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }

    
    func configure() {
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        let titleArray = ["Welcome",
                          "Location",
                          "Please select the news topics you are interested in.",
                          "Get Started"]
        let contentArray = ["Press Continue to be informed about the latest news.",
                            "Please allow locations to access personalized news.",
                            "Your personalized news is ready.\nGood reading."]
        
        for i in 0..<4 {
            
            let pageView = UIView(frame: CGRect(x: CGFloat(i) * view.width,
                                                y: 0,
                                                width: view.width,
                                                height: view.height))
            
            scrollView.addSubview(pageView)
            
            if i == 2 {
                //title
                let titleLabel = UILabel(frame: CGRect(x: 10, y: 88, width: pageView.width - 20, height: 100))
                titleLabel.textAlignment = .center
                titleLabel.font = UIFont(name: "SFCompactDisplay-Medium", size: 27)
                titleLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
                titleLabel.backgroundColor = .clear
                titleLabel.numberOfLines = 0
                titleLabel.text = titleArray[i]
                pageView.addSubview(titleLabel)
                
                
                //collectionview for topic
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.minimumInteritemSpacing = 1
                layout.minimumLineSpacing = 50
                layout.itemSize = CGSize(width: 137, height: 113)
                layout.sectionInset = UIEdgeInsets(top: 0, left: 50, bottom: 50, right: 50)
                collectionView = UICollectionView(frame: CGRect(x: 0, y: titleLabel.bottom + 50, width: pageView.width, height: pageView.height - 113 - 50 - 88 - 100), collectionViewLayout: layout)
                collectionView?.register(OnboardingTopicCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingTopicCollectionViewCell.identifier)
                collectionView?.delegate = self
                collectionView?.dataSource = self
                guard let collectionView = collectionView else {
                    return
                }
                collectionView.backgroundColor = .clear
                pageView.addSubview(collectionView)
                
                //button
                let button = UIButton(frame: CGRect(x: 50, y: self.collectionView!.bottom, width: pageView.width - 100, height: 50))
                
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(red: 79/255, green: 68/255, blue: 255/255, alpha: 1)
                button.layer.cornerRadius = 25.0
                button.setTitle("Continue", for: .normal)
                pageView.addSubview(button)
                button.tag = i+1
                button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
                
            }
            else {
                //title,content, image, button
                let imageView = UIImageView(frame: CGRect(x: 60, y: 88, width: pageView.width - 120, height: 215))
                let titleLabel = UILabel(frame: CGRect(x: 10, y: imageView.bottom + 35, width: pageView.width - 20, height: 100))
                let contentLabel = UILabel(frame: CGRect(x: 50, y: titleLabel.bottom + 43, width: view.width - 100, height: 50))
                let button = UIButton(frame: CGRect(x: 50, y: contentLabel.bottom + 30, width: pageView.width - 100, height: 50))
                
                //title
                titleLabel.textAlignment = .center
                titleLabel.font = UIFont(name: "SFCompactDisplay-Medium", size: 27)
                titleLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
                titleLabel.backgroundColor = .clear
                titleLabel.numberOfLines = 0
                pageView.addSubview(titleLabel)
                
                if i == 3 {
                    titleLabel.text = titleArray[i-1]
                }else {
                    titleLabel.text = titleArray[i]
                }
               
                
                //content
                contentLabel.textAlignment = .center
                contentLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 18)
                contentLabel.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
                contentLabel.backgroundColor = .clear
                contentLabel.numberOfLines = 0
                pageView.addSubview(contentLabel)
                if i == 3 {
                    contentLabel.text = contentArray[i-1]
                } else {
                    contentLabel.text = contentArray[i]
                }
              
                
                //image
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "onBoarding_\(i)")
                if i == 3 {
                    imageView.image = UIImage(named: "onBoarding_\(i-1)")
                }
                imageView.backgroundColor = .clear
                pageView.addSubview(imageView)
                
                //button
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(red: 79/255, green: 68/255, blue: 255/255, alpha: 1)
                button.layer.cornerRadius = 25.0
                button.setTitle("Continue", for: .normal)
                if i == 3 {
                    button.setTitle("Get Started", for: .normal)
                }
                button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
                button.tag = i+1
                pageView.addSubview(button)
            }
        }
        scrollView.contentSize = CGSize(width: view.width * 4, height: 0)
        scrollView.isPagingEnabled = true
    }
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 4 else {
            //dismiss
            WelcomeOnBoarding.shared.isNotNewUser()
            regionCode()
            chooseTopics()
            let vc = ArticleVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            return
        }
        
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: view.width * CGFloat(button.tag), y: 0), animated: true)
        
    }
    
    
    //get location regionCode
    private func regionCode() {
        let location = Locale.current
        guard let regionCode = location.regionCode else {
            fatalError("failed to regionCode")
        }
        UserDefaults.standard.setValue(regionCode, forKey: "regionCode")
    }
    
    //choose topics
    private func chooseTopics() {
        //added general topic
        self.safeChooseTopicsArray.append(contentsOf: chooseTopicsArray)
        UserDefaults.standard.setValue(safeChooseTopicsArray, forKey: "chooseTopics")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topic = topicArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingTopicCollectionViewCell.identifier,
                                                      for: indexPath) as! OnboardingTopicCollectionViewCell
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
            print("chose topics: \(chooseTopicsArray)")
             DispatchQueue.main.async {
                 collectionView.reloadData()
             }
        } else {
            topicArray[indexPath.row] = deselectedTopicArray[indexPath.row]
            for i in chooseTopicsArray {
                if i == deselectedTopicArray[indexPath.row] {
                    if let index = chooseTopicsArray.firstIndex(of: i) {
                        chooseTopicsArray.remove(at: index)
                        print("chose topics: \(chooseTopicsArray)")
                    }
                   
                }
            }
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
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

