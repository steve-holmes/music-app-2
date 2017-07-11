//
//  HomeFilmCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class HomeFilmCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    var films: [Video] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var onFilmDidSelect: Action<Video, Void>!

}

extension HomeFilmCell: UICollectionViewDataSource {
    
    private var maxFilms: Int { return 4 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count > maxFilms ? maxFilms : films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeVideoItemCell.self), for: indexPath)
        
        if let cell = cell as? HomeVideoItemCell {
            let film = films[indexPath.item]
            cell.configure(name: film.name, singer: film.singer, image: film.avatar, time: film.time)
        }
        
        return cell
    }
    
}

extension HomeFilmCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let film = films[indexPath.item]
        onFilmDidSelect.execute(film)
    }
    
}

extension HomeFilmCell: UICollectionViewDelegateFlowLayout, HomeVideoCellOptions {
    
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
