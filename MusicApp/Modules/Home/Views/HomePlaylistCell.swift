//
//  HomePlaylistCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class HomePlaylistCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as? HomePlaylistCollectionViewLayout
        layout?.delegate = self
    }
    
    var playlists: [Playlist] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var onPlaylistDidSelect: Action<Playlist, Void>!

}

extension HomePlaylistCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let max = kHomePlaylistCollectionViewLayoutMaximumElements
        return playlists.count > max ? max : playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = String(describing: HomePlaylistItemCell.self)
        
        if indexPath.item == 0 {
            identifier = "Large\(identifier)"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? PlaylistItemCell {
            let playlist = playlists[indexPath.item]
            cell.configure(name: playlist.name, singer: playlist.singer, image: playlist.avatar)
        }
        
        return cell
    }
    
}

extension HomePlaylistCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.item]
        onPlaylistDidSelect.execute(playlist)
    }
    
}

extension HomePlaylistCell: HomePlaylistCollectionViewLayoutDelegate, HomePlaylistCellOptions {
    
    func itemSizeForCollectionView(_ collectionView: UICollectionView) -> CGFloat {
        return width(of: collectionView)
    }
    
    func itemPaddingForCollectionView(_ collectionView: UICollectionView) -> CGFloat {
        return itemPadding
    }
    
}
