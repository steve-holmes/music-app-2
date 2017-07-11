//
//  TopicDetailViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import Action
import RxDataSources
import NSObject_Rx

class TopicDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topicNameLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
    
    var store: TopicDetailStore!
    var action: TopicDetailAction!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    
    fileprivate var refreshControl = OnlineRefreshControl()
    
    // MARK: Properties
    
    var topic: Topic {
        get { return store.topic.value }
        set { store.topic.value = newValue }
    }
    
    private func configure() {
        topicNameLabel.text = topic.name
        topicImageView.kf.setImage(with: URL(string: topic.avatar))
    }
    
    var topicDetailInfoInput: TopicDetailInfo?
    
    // MARK: Output Properties
    
    lazy var topicDetailInfoOutput: Observable<TopicDetailInfo> = {
        return self.topicDetailInfoSubject.asObservable()
    }()
    
    fileprivate var topicDetailInfoSubject = PublishSubject<TopicDetailInfo>()
    
    // MARK: Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        
        bindStore()
        bindAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        topicDetailInfoSubject.onCompleted()
    }
    
    // MARK: Target Actions
    
    @IBAction func backButtonTapped(_ backButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Data Source
    
    fileprivate let PlaylistsSection = 1
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<PlaylistCollectionSection> = { [weak self] in
        let dataSource = RxTableViewSectionedReloadDataSource<PlaylistCollectionSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, playlists in
            guard let controller = self else { fatalError("Unexpected View Controller") }
            
            return dataSource.configureCell(for: tableView, at: indexPath, in: controller, animated: true) {
                if indexPath.section == controller.PlaylistsSection {
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaylistCell.self), for: indexPath)
                    if let cell = cell as? PlaylistCell {
                        cell.registerPreviewAction = Action { sourceView in
                            controller.action.onRegisterPlaylistPreview.execute((sourceView, controller))
                        }
                        
                        cell.didSelectAction = Action { playlist in
                            controller.action.onPlaylistDidSelect.execute((playlist, controller))
                        }
                        
                        cell.playAction = controller.action.onPlaylistPlayButtonTapped()
                        
                        cell.playlists = playlists
                    }
                    return cell
                }
                fatalError("Unexpected Playlist Section")
            }
        }
        
        return dataSource
    }()

}

extension TopicDetailViewController: UITableViewDelegate, PlaylistCellOptions {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AdvertisementSection = 0
        let PlaylistSection = 1
        let LoadMoreSection = 2
        
        switch indexPath.section {
        case AdvertisementSection: return 50
        case LoadMoreSection: return 44
        case PlaylistSection:
            let itemHeight = height(of: tableView)
            let items = self.store.playlists.value.count
            let lines = (items % itemsPerLine == 0) ? (items / itemsPerLine) : (items / itemsPerLine + 1)
            return CGFloat(lines) * itemHeight + CGFloat(lines + 1) * itemPadding
        default:
            fatalError("Unexpected Row Height")
        }
    }
    
}

extension TopicDetailViewController {
    
    func bindStore() {
        store.playlists.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            })
            .map { playlists in PlaylistCollection(playlists: playlists) }
            .map { collection -> [PlaylistCollectionSection] in [
                PlaylistCollectionSection(model: "Advertisement", items: [PlaylistCollection(playlists: [
                    Playlist(id: "ad1", name: "Advertisement", singer: "Google", avatar: "not_found")
                ])]),
                PlaylistCollectionSection(model: "Playlists", items: [collection])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.playlists.asObservable()
            .filter { $0.count == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.view)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    func bindAction() {
        if let info = topicDetailInfoInput {
            store.playlists.value = info.playlists
        } else {
            action.onLoad.execute(())
        }
    }
    
}
