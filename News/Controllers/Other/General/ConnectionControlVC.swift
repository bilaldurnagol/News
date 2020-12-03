//
//  ConnectionControlVC.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit

class ConnectionControlVC: UIViewController {
    
    private let connectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wifi.exclamationmark")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tryButton: UIButton = {
       let button = UIButton()
        button.setTitle("Try Again", for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(connectionImageView)
        view.addSubview(tryButton)
        
        tryButton.addTarget(self, action: #selector(didTapTryButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        self.connectionImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.connectionImageView.center = view.center
        self.tryButton.frame = CGRect(x: 50, y: connectionImageView.bottom + 50, width: view.width - 100, height: 50)
    }
    
    @objc private func didTapTryButton() {
      let vc = ArticleVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}
