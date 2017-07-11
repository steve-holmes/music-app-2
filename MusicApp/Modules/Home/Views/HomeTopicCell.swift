//
//  HomeTopicCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class HomeTopicCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    var topics: [Topic] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var onTopicDidSelect: Action<Topic, Void>!
    
}

extension HomeTopicCell: UICollectionViewDataSource {
    
    private var maxTopics: Int { return 4 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count > maxTopics ? maxTopics : topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeTopicItemCell.self), for: indexPath)
        
        if let cell = cell as? HomeTopicItemCell {
            let topic = topics[indexPath.item]
            cell.configure(name: topic.name, image: topic.avatar)
        }
        
        return cell
    }
    
}

extension HomeTopicCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.item]
        onTopicDidSelect.execute(topic)
    }
    
}

extension HomeTopicCell: UICollectionViewDelegateFlowLayout, HomeTopicCellOptions {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size(of: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
}
