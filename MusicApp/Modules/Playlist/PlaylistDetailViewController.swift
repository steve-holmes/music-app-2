//
//  PlaylistDetailViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/18/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Action
import NSObject_Rx

class PlaylistDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: PlaylistDetailHeaderView!
    
    @IBOutlet weak var playButton: UIButton!
    
    fileprivate let headerCell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
    
    fileprivate var initialIndicatorView = DetailInitialActivityIndicatorView()
    fileprivate var loadingIndicatorView = LoadingActivityIndicatorView()
    
    var store: PlaylistDetailStore!
    var action: PlaylistDetailAction!
    
    // MARK: Properties
    
    var playlist: Playlist {
        get { return store.info.value }
        set { store.info.value = newValue }
    }
    
    var playlistDetailInfoInput: PlaylistDetailInfo?
    
    // MARK: Output Properties
    
    lazy var playlistDetailInfoOutput: Observable<PlaylistDetailInfo> = {
        return self.playlistDetailInfoSubject.asObservable()
    }()
    
    fileprivate var playlistDetailInfoSubject = PublishSubject<PlaylistDetailInfo>()
    
    // MARK: Target Actions
    
    @IBAction func backButonTapped(_ backButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        tableView.delegate = self
        headerView.configureAnimation(with: tableView)

        bindStore()
        bindAction()
    }
    
    private var headerViewNeedsToUpdate = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if headerViewNeedsToUpdate {
            headerView.frame.size.height = tableView.bounds.size.height / 3
            headerViewNeedsToUpdate = false
        }
    }
    
    // MARK: Data Source
    
    fileprivate let HeaderRow = 0
    fileprivate let MenuRow = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<PlaylistDetailItemSection> = {
        let dataSource = RxTableViewSectionedReloadDataSource<PlaylistDetailItemSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, detailItem in
            if indexPath.row == self.HeaderRow {
                return self.headerCell
            }
            
            if indexPath.row == self.MenuRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaylistMenuCell.self), for: indexPath)
                if let cell = cell as? PlaylistMenuCell {
                    cell.state = self.store.state.value
                    cell.action = self.action.onPlaylistDetailStateChange()
                }
                return cell
            }
            
            switch detailItem {
            case let .song(song):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongCell.self), for: indexPath)
                if let songCell = cell as? SongCell {
                    let contextAction = CocoaAction { [weak self] _ in
                        guard let this = self else { return .empty() }
                        return this.action.onContextMenuOpen.execute((song, this)).map { _ in }
                    }
                    songCell.configure(name: song.name, singer: song.singer, contextAction: contextAction)
                }
                return cell
            case let .playlist(playlist):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaylistDetailCell.self), for: indexPath)
                if let playlistCell = cell as? PlaylistDetailCell {
                    playlistCell.configure(name: playlist.name, singer: playlist.singer, image: playlist.avatar)
                }
                return cell
            }
        }
        
        return dataSource
    }()

}

// MARK: UITableViewDelegate

extension PlaylistDetailViewController: UITableViewDelegate {
    
    private var headerHeight: CGFloat { return tableView.bounds.height / 3 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.HeaderRow {
            return headerHeight
        }
        
        if indexPath.row == self.MenuRow {
            return 44
        }
        
        if self.store.state.value == .song {
            return 44
        } else {
            return 60
        }
    }
    
}

// MARK: Activity Indicator

extension PlaylistDetailViewController {
    
    func beginInitialLoading() {
        initialIndicatorView.startAnimating(in: self.view)
    }
    
    func endInitialLoading() {
        initialIndicatorView.stopAnimating()
    }
    
    func beginLoading() {
        loadingIndicatorView.startAnimation(in: self.view)
    }
    
    func endLoading() {
        loadingIndicatorView.stopAnimation()
    }
    
}

// MARK: Store

extension PlaylistDetailViewController {

    func bindStore() {
        store.info.asObservable()
            .subscribe(onNext: { [weak self] playlist in
                self?.headerView.setImage(playlist.avatar)
                self?.headerView.setPlaylist(playlist.name)
                self?.headerView.setSinger(playlist.singer)
            })
            .addDisposableTo(rx_disposeBag)
        
        let state = store.state.asObservable()
            .filter { [weak self] _ in self != nil }
            .shareReplay(1)
        
        state
            .subscribe(onNext: { [weak self] state in
                let indexPath = IndexPath(row: 1, section: 0)
                let cell = self?.tableView.cellForRow(at: indexPath) as? PlaylistMenuCell
                cell?.state = state
            })
            .addDisposableTo(rx_disposeBag)
        
        bindDataSource(state: state)
        
        store.loading.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] loading in
                if loading  { self?.beginLoading() }
                else        { self?.endLoading() }
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func bindDataSource(state: Observable<PlaylistDetailState>) {
        let fakeSong = Song(id: "", name: "", singer: "")
        let fakeSongs = [fakeSong, fakeSong]
        let song = state
            .filter { $0 == .song }
            .map { [weak self] _ in fakeSongs + self!.store.songs.value }
            .shareReplay(1)
        
        let fakePlaylist = Playlist(id: "", name: "'", singer: "", avatar: "")
        let fakePlaylists = [fakePlaylist, fakePlaylist]
        let playlist = state
            .filter { $0 == .playlist }
            .map { [weak self] _ in fakePlaylists + self!.store.playlists.value }
            .shareReplay(1)
        
        let songDataSource = song
            .map { songs in songs.map { PlaylistDetailItem.song($0) } }
            .map { [SectionModel(model: "Song", items: $0)] }
        
        let playlistDataSource = playlist
            .map { playlists in playlists.map { PlaylistDetailItem.playlist($0) } }
            .map { [SectionModel(model: "Playlist", items: $0)] }
        
        Observable.from([songDataSource, playlistDataSource])
            .merge()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        song
            .map { song in song.count }
            .filter { count in count == 2 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.beginInitialLoading()
            })
            .addDisposableTo(rx_disposeBag)
        
        song
            .map { song in song.count }
            .filter { count in count > 2 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.endInitialLoading()
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

// MARK: Action

extension PlaylistDetailViewController {
    
    func bindAction() {
        if let detailInfo = playlistDetailInfoInput {
            store.tracks.value = detailInfo.tracks
            store.songs.value = detailInfo.songs
            store.playlists.value = detailInfo.playlists
            store.state.value = .song
        } else {
            action.onLoad.execute(())
                .subscribe(playlistDetailInfoSubject)
                .addDisposableTo(rx_disposeBag)
        }
        
        let detailItem = tableView.rx.modelSelected(PlaylistDetailItem.self)
            .shareReplay(1)
        
        detailItem
            .map { item -> Playlist? in
                switch item {
                case .song(_): return nil
                case let .playlist(playlist): return playlist
                }
            }
            .filter { $0 != nil }
            .map { $0! }
            .filter { playlist in !playlist.id.isEmpty }
            .subscribe(action.onPlaylistDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
        
        detailItem
            .map { item -> Song? in
                switch item {
                case let .song(song): return song
                case .playlist(_): return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
            .filter { song in !song.id.isEmpty }
            .subscribe(action.onSongDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
        
        playButton.rx.action = action.onPlayButtonPress()
    }
    
}
