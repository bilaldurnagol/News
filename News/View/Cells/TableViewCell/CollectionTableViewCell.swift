//
//  CollectionTableViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import UIKit


protocol CollectionTableViewCellDelegate {
    func chooseTopic(topic: ArticleListViewModel )
}

class CollectionTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionTableViewCell"
    
    var collectionView: UICollectionView?
    private var topics: [String]?
    var delegate: CollectionTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView!)
        collectionView?.register(TopicsCollectionViewCell.self, forCellWithReuseIdentifier: TopicsCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 249/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = contentView.bounds
    }
    func configure(topics: [String]) {
        self.topics = topics
        collectionView?.reloadData()
        
    }
    
}
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if topics?.count == 0 {
            return 0
        }else {
            return topics!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topic = topics?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicsCollectionViewCell.identifier, for: indexPath) as! TopicsCollectionViewCell
        cell.configure(topic: topic!, row: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 141, height: 61)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}

extension CollectionTableViewCell: TopicsCollectionViewCellDelegate {
    func chooseTopic(articles: ArticleListViewModel) {
        if let delegate = self.delegate {
            delegate.chooseTopic(topic: articles)
        }
    }
}
