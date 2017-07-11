//
//  LyricCopyingView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LyricCopyingView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func copyButtonTapped(_ copyButton: UIButton) {
        copyPasteboard()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
    }
    
    private var store: LyricStore?
    
    func configure(store: LyricStore?) {
        self.store = store
    }
    
    private func copyPasteboard() {
        if let lyrics = store?.lyrics.value, !lyrics.isEmpty {
            UIPasteboard.general.string = lyrics
                .map { $0.content }
                .joined(separator: "\n")
            
            let banner = StatusBarNotificationBanner(title: "Đã sao chép lời bài hát", style: .info)
            banner.show()
        } else {
            let banner = StatusBarNotificationBanner(title: "Không có lời bài hát nào được sao chép", style: .info)
            banner.show()
        }
    }

}
