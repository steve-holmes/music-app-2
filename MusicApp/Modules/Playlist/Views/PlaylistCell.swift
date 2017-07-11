//
//  PlaylistCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

class PlaylistCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
    }
    
    private var playlistSubscription: Disposable?
    private var didSelectActionSubscription: Disposable?
    
    var playlists: PlaylistCollection! {
        didSet {
            playlistSubscription = Observable.just(playlists)
                .map { collection in collection.playlists }
                .map { playlists in [PlaylistItemSection(model: "Playlist Collection", items: playlists)] }
                .bind(to: collectionView.rx.items(dataSource: dataSource))
        }
    }
    
    var didSelectAction: Action<Playlist, Void>! {
        didSet {
            didSelectActionSubscription = collectionView.rx.modelSelected(Playlist.self)
                .bind(to: didSelectAction.inputs)
        }
    }
    
    var registerPreviewAction: Action<UIView, Void>!
    
    var playAction: Action<Playlist, Void>!
    
    override func prepareForReuse() {
        playlistSubscription?.dispose()
        didSelectActionSubscription?.dispose()
    }
    
    deinit {
        playlistSubscription?.dispose()
        didSelectActionSubscription?.dispose()
    }

    fileprivate lazy var dataSource: RxCollectionViewSectionedReloadDataSource<PlaylistItemSection> = {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PlaylistItemSection>()
        
        dataSource.configureCell = { dataSource, collectionView, indexPath, playlist in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlaylistItemCell.self), for: indexPath)
            if let cell = cell as? PlaylistItemCell {
                let buttonAction = CocoaAction {
                    return self.playAction.execute(playlist).map { _ in }
                }
                cell.configure(name: playlist.name, singer: playlist.singer, image: playlist.avatar, action: buttonAction)
                self.registerPreviewAction.execute(cell)
            }
            return cell
        }
        
        return dataSource
    }()
    
}

extension PlaylistCell: UICollectionViewDelegateFlowLayout, PlaylistCellOptions {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size(of: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
}
