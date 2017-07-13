//
//  SingerDetailViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Action
import NSObject_Rx

class SingerDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: SingerDetailHeaderView!
    
    fileprivate let headerCell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
    
    fileprivate var initialIndicatorView = DetailInitialActivityIndicatorView()
    
    var store: SingerDetailStore!
    var action: SingerDetailAction!
    
    // MARK: Properties
    
    var singer: Singer {
        get { return store.info.value }
        set { store.info.value = newValue }
    }
    
    var singerDetailInfoInput: SingerDetailInfo?
    
    // MARK: Output Properties
    
    lazy var singerDetailInfoOutput: Observable<SingerDetailInfo> = {
        return self.singerDetailInfoSubject.asObservable()
    }()
    
    fileprivate var singerDetailInfoSubject = PublishSubject<SingerDetailInfo>()
    
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
        
        headerView.configure()
    }
    
    // MARK: Data Source
    
    fileprivate let HeaderRow = 0
    fileprivate let MenuRow = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SingerDetailItemSection> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SingerDetailItemSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, detailItem in
            if indexPath.row == self.HeaderRow {
                return self.headerCell
            }
            
            if indexPath.row == self.MenuRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SingerMenuCell.self), for: indexPath)
                (cell as? SingerMenuCell)?.action = self.action.onSingerDetailStateChange()
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
            case let .video(video):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoItemCell.self), for: indexPath)
                if let videoCell = cell as? VideoItemCell {
                    videoCell.configure(name: video.name, singer: video.singer, image: video.avatar)
                }
                return cell
            }
        }
        
        return dataSource
    }()

}

// MARK: Activity Indicator

extension SingerDetailViewController {
    
    func beginInitialLoading() {
        initialIndicatorView.startAnimating(in: self.view)
    }
    
    func endInitialLoading() {
        initialIndicatorView.stopAnimating()
    }
    
}


extension SingerDetailViewController: UITableViewDelegate {
    
    private var headerHeight: CGFloat { return tableView.bounds.height / 3 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.HeaderRow {
            return headerHeight
        }
        
        if indexPath.row == self.MenuRow {
            return 44
        }
        
        switch self.store.state.value {
        case .song: return 44
        case .playlist: return 60
        case .video: return 80
        }
    }
    
}

// MARK: Store

extension SingerDetailViewController {
    
    func bindStore() {
        store.info.asObservable()
            .subscribe(onNext: { [weak self] singer in
                self?.headerView.setImage(singer.avatar)
                self?.headerView.setSinger(singer.name)
            })
            .addDisposableTo(rx_disposeBag)
        
        let state = store.state.asObservable()
            .filter { [weak self] _ in self != nil }
            .shareReplay(1)
        
        state
            .subscribe(onNext: { [weak self] state in
                let indexPath = IndexPath(row: 1, section: 0)
                let cell = self?.tableView.cellForRow(at: indexPath) as? SingerMenuCell
                cell?.state = state
            })
            .addDisposableTo(rx_disposeBag)
        
        bindDataSource(state: state)
    }
    
    private func bindDataSource(state: Observable<SingerDetailState>) {
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
        
        let fakeVideo = Video(id: "", name: "'", singer: "", avatar: "", time: "")
        let fakeVideos = [fakeVideo, fakeVideo]
        let video = state
            .filter { $0 == .video }
            .map { [weak self] _ in fakeVideos + self!.store.videos.value }
            .shareReplay(1)
        
        let songDataSource = song
            .map { songs in songs.map { SingerDetailItem.song($0) } }
            .map { [SectionModel(model: "Song", items: $0)] }
        
        let playlistDataSource = playlist
            .map { playlists in playlists.map { SingerDetailItem.playlist($0) } }
            .map { [SectionModel(model: "Playlist", items: $0)] }
        
        let videoDataSource = video
            .map { videos in videos.map { SingerDetailItem.video($0) } }
            .map { [SectionModel(model: "Video", items: $0)] }
        
        Observable.from([songDataSource, playlistDataSource, videoDataSource])
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

extension SingerDetailViewController {
    
    func bindAction() {
        if let detailInfo = singerDetailInfoInput {
            store.songs.value = detailInfo.songs
            store.playlists.value = detailInfo.playlists
            store.videos.value = detailInfo.videos
            store.state.value = .song
        } else {
            action.onLoad.execute(())
                .subscribe(singerDetailInfoSubject)
                .addDisposableTo(rx_disposeBag)
        }
        
        let detailItem = tableView.rx.modelSelected(SingerDetailItem.self)
            .shareReplay(1)
        
        detailItem
            .map { item -> Song? in
                guard case let .song(song) = item else { return nil }
                return song
            }
            .filter { $0 != nil }
            .map { $0! }
            .filter { song in !song.id.isEmpty }
            .subscribe(action.onSongDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
        
        detailItem
            .map { item -> Playlist? in
                guard case let .playlist(playlist) = item else { return nil }
                return playlist
            }
            .filter { $0 != nil }
            .map { $0! }
            .filter { playlist in !playlist.id.isEmpty }
            .filter { [weak self] _ in self != nil }
            .map { [weak self] in ($0, self!) }
            .subscribe(action.onPlaylistDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
        
        detailItem
            .map { item -> Video? in
                guard case let .video(video) = item else { return nil }
                return video
            }
            .filter { $0 != nil }
            .map { $0! }
            .filter { video in !video.id.isEmpty }
            .filter { [weak self] _ in self != nil }
            .map { [weak self] in ($0, self!) }
            .subscribe(action.onVideoDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
