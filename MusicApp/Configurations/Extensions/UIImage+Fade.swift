//
//  UIImage+Fade.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let kUIImageViewDuration: TimeInterval = 0.25

extension UIImageView {
    
    func fadeImage(_ image: String, placeholder placeholderImage: UIImage? = nil, duration: TimeInterval? = nil) {
        let imageURL = URL(string: image)
        
        let placeholderImage = placeholderImage != nil ? placeholderImage : self.image
        let duration = duration != nil ? duration! : kUIImageViewDuration
        
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                self.kf.setImage(
                    with: imageURL,
                    placeholder: placeholderImage,
                    options: [.transition(.fade(duration))]
                )
            },
            completion: nil
        )
    }
    
}
