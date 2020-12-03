//
//  TopicsTableViewCell.swift
//  News
//
//  Created by Bilal Durnagöl on 2.12.2020.
//

import UIKit

protocol TopicsTableViewCellDelegate {
    func changeTopic(topic: String, row: Int, selected: Bool)
}

class TopicsTableViewCell: UITableViewCell {
    
    static let identifier = "TopicsTableViewCell"
    var delegate:TopicsTableViewCellDelegate?
    var selectedRow: Int?
    
    private let topicLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    private let topicSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(topicLabel)
        contentView.addSubview(topicSwitch)
        topicSwitch.addTarget(self, action: #selector(didTapTopicSwitch), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(topic: String, chooseTopics: [Topics], row: Int) {
        for i in chooseTopics {
            if topic == i.topic_name! {
                topicSwitch.isOn = true
            }
        }
        topicLabel.text = topic
        self.selectedRow = row
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topicLabel.frame = CGRect(x: 20,
                                  y: 20,
                                  width: contentView.width - 150 ,
                                  height: contentView.height - 40)
        topicSwitch.frame = CGRect(x: contentView.width - 70, y: 30, width: 50, height: contentView.height - 60)
    }
    
    @objc private func didTapTopicSwitch() {
        if topicSwitch.isOn == true {
            guard let topic = topicLabel.text else {return}
            if let delegate = self.delegate {
                delegate.changeTopic(topic: topic, row: selectedRow!, selected: true)
            }
            
        }else {
            guard let topic = topicLabel.text else {return}
            if let delegate = self.delegate {
                delegate.changeTopic(topic: topic, row: selectedRow!, selected: false)
            }
            }
        }
    }

