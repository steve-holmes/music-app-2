//
//  SingerDetailHeaderView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SingerDetailHeaderView: UIView {

    // MARK: Outlet
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var singerLabel: UILabel!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    func configure() {
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    // MARK: Size
    
    func configureAnimation(with tableView: UITableView) {
        let startOffset: CGFloat = tableView.contentOffset.y
        let startHeight: CGFloat = frame.height
        
        let minHeight: CGFloat = 64 // status (20) + navigation bar (44)
        let maxOffset: CGFloat = startHeight - minHeight
        
        let startImageConstant = imageViewBottomConstraint.constant
        
        tableView.rx.didScroll
            .map { _ in tableView.contentOffset.y }
            .subscribe(onNext: { [weak self] contentOffset in
                let offset = contentOffset - startOffset
                if offset < maxOffset {
                    self?.frame.size.height = startHeight - offset
                    self?.imageViewBottomConstraint.constant = startImageConstant + offset
                    
                    let alpha = (maxOffset - minHeight - offset) / (maxOffset - minHeight)
                    self?.imageView.alpha = alpha
                    self?.singerLabel.alpha = alpha
                }
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    // MARK: Properties
    
    func setImage(_ image: String) {
        imageView.fadeImage(image)
        backgroundImageView.fadeImage(image)
    }
    
    func setSinger(_ singer: String) {
        singerLabel.text = singer
    }

}
