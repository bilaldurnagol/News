//
//  ShowArticleVC.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit
import SafariServices
import SDWebImage
import FirebaseFirestore

class ShowArticleVC: UIViewController {
    
    private let db = Firestore.firestore()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 100
        return stackView
    }()
    
    private let readShareStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let readStoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("READ FULL STORY", for: .normal)
        button.setTitleColor(UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1).cgColor
        button.layer.cornerRadius = 8.0
        button.sizeToFit()
        return button
    }()
    
    private let shareStoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("SHARE", for: .normal)
        button.setTitleColor(UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1).cgColor
        button.sizeToFit()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    private let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFCompactDisplay-Medium", size: 30)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let articlePublishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFCompactDisplay-Light", size: 16)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let outerView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 20
        return view
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 1
        imageView.layer.cornerRadius = 50.0
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let articleContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.font = UIFont(name: "SFCompactDisplay-Regular", size: 16)
        
        return label
    }()
    private var navBarTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        return label
    }()
    
    var articleURL: String?
    var urlToImage: String?
    
    init(title: String, publishedAt: String, urlToImage: String, description: String, navBarTitle: String, articleURL: String ) {
        super.init(nibName: nil, bundle: nil)
        self.articleTitleLabel.text = title
        self.articlePublishedAtLabel.text = publishedAt.stringToPublishedAt()
        if urlToImage == nil {
            self.articleImageView.image = UIImage(named: "newsLogo")
        }else {
            self.articleImageView.sd_setImage(with: URL(string: urlToImage), completed: nil)
        }
        self.articleContentLabel.attributedText = NSMutableAttributedString(string: description)
        self.navBarTitle.text = navBarTitle
        self.articleURL = articleURL
        self.urlToImage = urlToImage
        readCounter(articleURL: articleURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        
        view.addSubview(scrollView)
        outerView.addSubview(articleImageView)
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(articleTitleLabel)
        stackView.addArrangedSubview(articlePublishedAtLabel)
        stackView.addArrangedSubview(outerView)
        stackView.addArrangedSubview(articleContentLabel)
        stackView.addArrangedSubview(readShareStackView)
        
        readShareStackView.addArrangedSubview(shareStoryButton)
        readShareStackView.addArrangedSubview(readStoryButton)
        
        readStoryButton.addTarget(self, action: #selector(didTapReadButton), for: .touchUpInside)
        shareStoryButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        //Constrain scroll view
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        //constrain stack view to scroll view
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -10).isActive = true
        
        //constrain width of stack view to width of self.view, NOT scroll view
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        //Constraint articleTitleLabel
        self.articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.articleTitleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 39).isActive = true
        self.articleTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.articleTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
        
        // Constraint articlePublishedAtLabel
        self.articlePublishedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        self.articlePublishedAtLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 10).isActive = true
        self.articlePublishedAtLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.articlePublishedAtLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
        self.articlePublishedAtLabel.bottomAnchor.constraint(equalTo: articlePublishedAtLabel.topAnchor, constant: 20).isActive = true
        
        // Constraint outerView
        self.outerView.translatesAutoresizingMaskIntoConstraints = false
        self.outerView.topAnchor.constraint(equalTo: articlePublishedAtLabel.bottomAnchor, constant: 30).isActive = true
        self.outerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.outerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
        self.outerView.bottomAnchor.constraint(equalTo: outerView.topAnchor, constant: 273).isActive = true
        
        // Constraint articleImageView
        self.articleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.articleImageView.topAnchor.constraint(equalTo: outerView.topAnchor).isActive = true
        self.articleImageView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor).isActive = true
        self.articleImageView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor).isActive = true
        self.articleImageView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor).isActive = true
        
        
        
        // Constrain articleContentLabel
        self.articleContentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.articleContentLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 30).isActive = true
        self.articleContentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.articleContentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
        
        
        //constrain stack view to scroll view
        self.readShareStackView.translatesAutoresizingMaskIntoConstraints = false
        self.readShareStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 25).isActive = true
        self.readShareStackView.topAnchor.constraint(equalTo: self.articleContentLabel.bottomAnchor, constant: 40).isActive = true
        self.readShareStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -25).isActive = true
        self.readShareStackView.bottomAnchor.constraint(equalTo: self.readShareStackView.topAnchor, constant: 50).isActive = true
        
        //shadow imageview
        outerView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                               y: articleImageView.bottom,
                                                               width: outerView.width,
                                                               height: 10)).cgPath
        
    }
    
    //Setup navigation bar
    private func setupNavBar() {
        
        title = navBarTitle.text
        //Transparent navigationbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapXmarkButton))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //navigationbar title colors
        self.navigationController?.navigationBar.tintColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)]
    }
    
    @objc private func didTapXmarkButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //Read more func
    @objc private func didTapReadButton() {
        guard let url = URL(string:self.articleURL ?? "https://www.google.com") else {return}
        let config = SFSafariViewController.Configuration()
        //open safari reader mode, if it is available
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
    
    //Share button func
    @objc private func didTapShareButton() {
        let imageView = UIImageView()
        guard let imageURL = URL(string: self.urlToImage ?? ""),
              let shareURL = URL(string: self.articleURL ?? "https://www.google.com") else {return}
        
        imageView.sd_setImage(with: imageURL, completed: nil)
        guard let shareImage = imageView.image else {return}
        let shareSheetVC = UIActivityViewController(activityItems: [shareImage, shareURL], applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
}
//MARK: - Database funcs
extension ShowArticleVC {
    
    private func readCounter(articleURL: String) {
        db.collection("articlesURL").document(articleURL.safeURL()).getDocument(completion: {document, error in
            if let document = document, document.exists {
                guard let count = document["readCounter"] as? Int else {
                    return
                }
                let newCount = count + 1
                self.db.collection("articlesURL").document(articleURL.safeURL()).updateData(["readCounter": newCount])
                
            }
        })
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
