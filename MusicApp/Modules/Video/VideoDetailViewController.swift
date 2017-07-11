//
//  VideoDetailViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TwicketSegmentedControl
import RxSwift
import RxCocoa
import Action
import RxDataSources
import NSObject_Rx

class VideoDetailViewController: UIViewController {
    
    @IBOutlet weak var headerView: VideoDetailHeaderView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var segmentControl: VideoMenuView!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var othersTableView: UITableView!
    @IBOutlet weak var singersTableView: UITableView!
    
    fileprivate var initialIndicatorView = DetailInitialActivityIndicatorView()
    fileprivate var loadingIndicatorView = LoadingActivityIndicatorView()
    
    var store: VideoDetailStore!
    var action: VideoDetailAction!
    
    var video: Video {
        get { return store.video.value }
        set { store.video.value = newValue }
    }
    
    var player: VideoPlayer!

    @IBAction func backButtonTapped(_ backButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBannerView()
        playerView.configure(player: player)
        
        othersTableView.delegate = self
        singersTableView.delegate = self
        
        bindStore()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideStatusBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !store.track.value.url.isEmpty {
            player.play(url: store.track.value.url)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        showStatusBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.stop()
    }
    
    private func configureBannerView() {
        bannerView.adUnitID = "ca-app-pub-3982247659947570/9857463647"
        bannerView.rootViewController = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
    fileprivate lazy var othersDataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Video>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Video>>()
        dataSource.configureCell = { dataSource, tableView, indexPath, video in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoItemCell.self), for: indexPath)
            if let cell = cell as? VideoItemCell {
                cell.configure(name: video.name, singer: video.singer, image: video.avatar)
            }
            return cell
        }
        return dataSource
    }()
    
    fileprivate lazy var singersDataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Video>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Video>>()
        dataSource.configureCell = { dataSource, tableView, indexPath, video in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoItemCell.self), for: indexPath)
            if let cell = cell as? VideoItemCell {
                cell.configure(name: video.name, singer: video.singer, image: video.avatar)
            }
            return cell
        }
        return dataSource
    }()
    
}

extension VideoDetailViewController {
    
    fileprivate func hideStatusBar() {
        let mainController = rootController as? MainViewController
        mainController?.setStatusBarHidden(true)
    }
    
    fileprivate func showStatusBar() {
        let mainController = rootController as? MainViewController
        mainController?.setStatusBarHidden(false)
    }
    
    private var rootController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.window?.rootViewController
    }
    
}

extension VideoDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension VideoDetailViewController {
    
    func bindStore() {
        store.video.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] video in
                self?.headerView.name = video.name
                self?.headerView.singer = video.singer
            })
            .addDisposableTo(rx_disposeBag)
        
        store.others.asObservable()
            .filter { $0.count > 0 }
            .map { [SectionModel(model: "Other Videos", items: $0)] }
            .bind(to: othersTableView.rx.items(dataSource: othersDataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.singers.asObservable()
            .filter { $0.count > 0 }
            .map { [SectionModel(model: "Same Singer Videos", items: $0)] }
            .bind(to: singersTableView.rx.items(dataSource: singersDataSource))
            .addDisposableTo(rx_disposeBag)
        
        let videos = Observable
            .combineLatest(store.others.asObservable(), store.singers.asObservable()) { others, singers in
                (others: others, singers: singers)
            }
            .shareReplay(1)
        
        videos
            .filter { others, singers in others.count == 0 && singers.count == 0 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.videosView)
            })
            .addDisposableTo(rx_disposeBag)
        
        videos
            .filter { others, singers in others.count > 0 || singers.count > 0 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
            })
            .addDisposableTo(rx_disposeBag)
        
        store.loading.asObservable()
            .skip(3)
            .subscribe(onNext: { [weak self] loading in
                if loading  { self?.loadingIndicatorView.startAnimation(in: self?.view) }
                else        { self?.loadingIndicatorView.stopAnimation() }
            })
            .addDisposableTo(rx_disposeBag)
        
        store.state.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                self?.segmentControl.state = state
                
                if state == .other {
                    self?.scrollView.scrollRectToVisible(CGRect(
                        origin: .zero,
                        size: self?.videosView.bounds.size ?? .zero
                    ), animated: true)
                }
                
                if state == .singer {
                    self?.scrollView.scrollRectToVisible(CGRect(
                        origin: CGPoint(x: self?.videosView.bounds.width ?? 0, y: 0),
                        size: self?.videosView.bounds.size ?? .zero
                    ), animated: true)
                }
            })
            .addDisposableTo(rx_disposeBag)
        
        store.track.asObservable()
            .filter { track in !track.id.isEmpty }
            .subscribe(onNext: { [weak self] track in
                self?.player.reload(track.url)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension VideoDetailViewController {
    
    func bindAction() {
        action.onLoad.execute(video)
        
        othersTableView.rx.modelSelected(Video.self)
            .filter { [weak self] video in self?.store.video.value != video }
            .subscribe(onNext: { [weak self] video in
                self?.action.onLoad.execute(video)
            })
            .addDisposableTo(rx_disposeBag)
        
        singersTableView.rx.modelSelected(Video.self)
            .filter { [weak self] video in self?.store.video.value != video }
            .subscribe(onNext: { [weak self] video in
                self?.action.onLoad.execute(video)
            })
            .addDisposableTo(rx_disposeBag)
        
        let width = videosView.bounds.width
        scrollView.rx.didEndDecelerating
            .map { [weak self] _ in Int(self?.scrollView.contentOffset.x ?? 0 / width) }
            .map { index -> VideoDetailState in index == 0 ? .other : .singer }
            .subscribe(onNext: { [weak self] state in
                self?.action.onStateChange.execute(state)
            })
            .addDisposableTo(rx_disposeBag)
        
        segmentControl.action = Action { [weak self] state in
            self?.action.onStateChange.execute(state).map { _ in } ?? .empty()
        }
    }
    
}
