//
//  RankHeaderView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

class RankHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var bannerImageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var songBannerImageViewBottomConstraint: NSLayoutConstraint! {
        didSet {
            bannerImageViewBottomConstraint = songBannerImageViewBottomConstraint
        }
    }
    
    @IBOutlet weak var playlistBannerImageViewBottomConstraint: NSLayoutConstraint! {
        didSet {
            bannerImageViewBottomConstraint = playlistBannerImageViewBottomConstraint
        }
    }
    
    @IBOutlet weak var videoBannerImageViewBottomConstraint: NSLayoutConstraint! {
        didSet {
            bannerImageViewBottomConstraint = videoBannerImageViewBottomConstraint
        }
    }
    
    func configure(country: String, type: String) {
        switch type {
        case kRankTypeSong:
            titleLabel.text = "BXH Bài hát"
        case kRankTypePlaylist:
            titleLabel.text = "BXH Playlist"
        case kRankTypeVideo:
            titleLabel.text = "BXH Video"
        default:
            break
        }
        
        switch country {
        case kRankCountryVietnam:
            bannerImageView.image = #imageLiteral(resourceName: "BXH-App-Banner_VN_V")
        case kRankCountryEurope:
            bannerImageView.image = #imageLiteral(resourceName: "BXH-App-Banner_US_V")
        case kRankCountryKorea:
            bannerImageView.image = #imageLiteral(resourceName: "BXH-App-Banner_KR_V")
        default:
            break
        }
    }
    
    var action: CocoaAction? {
        didSet {
            if let buttonAction = action {
                playButton?.rx.action = buttonAction
            }
        }
    }
    
    func configureAnimation(with tableView: UITableView) {
        let startOffset: CGFloat = tableView.contentOffset.y
        let startHeight: CGFloat = frame.height
        
        let minHeight: CGFloat = 64 // status (20) + navigation bar (44)
        let maxOffset: CGFloat = startHeight - minHeight
        
        let startImageConstant = bannerImageViewBottomConstraint.constant
        
        tableView.rx.didScroll
            .map { _ in tableView.contentOffset.y }
            .subscribe(onNext: { [weak self] contentOffset in
                let offset = contentOffset - startOffset
                if offset < maxOffset {
                    self?.frame.size.height = startHeight - offset
                    self?.bannerImageViewBottomConstraint.constant = startImageConstant + offset
                    
                    let alpha = (maxOffset - minHeight - offset) / (maxOffset - minHeight)
                    self?.titleLabel.alpha = alpha
                }
            })
            .addDisposableTo(rx_disposeBag)
    }

}
