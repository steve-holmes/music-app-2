//
//  HomeVideoCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class HomeVideoCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    var videos: [Video] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var onVideoDidSelect: Action<Video, Void>!

}

extension HomeVideoCell: UICollectionViewDataSource {
    
    private var maxVideos: Int { return 4 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count > maxVideos ? maxVideos : videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeVideoItemCell.self), for: indexPath)
        
        if let cell = cell as? HomeVideoItemCell {
            let video = videos[indexPath.item]
            cell.configure(name: video.name, singer: video.singer, image: video.avatar, time: video.time)
        }
        
        return cell
    }
    
}

extension HomeVideoCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.item]
        onVideoDidSelect.execute(video)
    }
    
}

extension HomeVideoCell: UICollectionViewDelegateFlowLayout, HomeVideoCellOptions {
    
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
