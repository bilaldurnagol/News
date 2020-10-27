//
//  ShowArticleVC.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit
import SafariServices

class ShowArticleVC: UIViewController {
    
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
    
    private let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 30)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let articlePublishedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Light", size: 16)
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
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
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        
        return label
    }()
    private var navBarTitle: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(red: 38/255, green: 50/255, blue: 91/255, alpha: 1)
        return label
    }()
    
    init(model: Article) {
        super.init(nibName: nil, bundle: nil)
        
        self.articleTitleLabel.text = model.title
        self.articlePublishedAtLabel.text = model.publishedAt?.stringToPublishedAt()
        self.articleImageView.sd_setImage(with: URL(string: model.urlToImage ?? ""), completed: nil)
        self.articleContentLabel.attributedText = NSMutableAttributedString(string: model.description ?? "nill")
        self.navBarTitle.text = model.source?.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.addSubview(scrollView)
        view.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(articleTitleLabel)
        stackView.addArrangedSubview(articlePublishedAtLabel)
        stackView.addArrangedSubview(articleImageView)
        stackView.addArrangedSubview(articleContentLabel)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Constrain scroll view
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        
        //constrain stack view to scroll view
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true;
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true;
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true;
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true;
        
        //constrain width of stack view to width of self.view, NOT scroll view
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true;
        
        //Constraint articleTitleLabel
        self.articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.articleTitleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 49).isActive = true
        self.articleTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.articleTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        
        // Constraint articlePublishedAtLabel
        self.articlePublishedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        self.articlePublishedAtLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 10).isActive = true
        self.articlePublishedAtLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.articlePublishedAtLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        self.articlePublishedAtLabel.bottomAnchor.constraint(equalTo: articlePublishedAtLabel.topAnchor, constant: 20).isActive = true;
        
        // Constraint articleImageView
        self.articleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.articleImageView.topAnchor.constraint(equalTo: articlePublishedAtLabel.bottomAnchor, constant: 30).isActive = true
        self.articleImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
        self.articleImageView.bottomAnchor.constraint(equalTo: articleImageView.topAnchor, constant: 273).isActive = true;
        
        // Constrain articleContentLabel
        self.articleContentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.articleContentLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 40).isActive = true
        self.articleContentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25).isActive = true
        self.articleContentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25).isActive = true
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
    
}
