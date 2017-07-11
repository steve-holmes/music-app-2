//
//  AnimatedCircleImageView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Kingfisher

class AnimatedCircleImageView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String = "default" {
        didSet {
            imageView.fadeImage(image, placeholder: nil, duration: 0.5)
        }
    }
    
    func configure() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    // MARK: Animation
    
    private let duration: TimeInterval = 20
    private let clocks: Int = 20
    
    private lazy var durationPerClock: TimeInterval = { self.duration / TimeInterval(self.clocks) }()
    private lazy var radiansPerClock: CGFloat = { 2 * .pi / CGFloat(self.clocks) }()
    
    private var isRotating: Bool = false
    
    func startAnimating() {
        isRotating = true
        animate()
    }
    
    func stopAnimating() {
        isRotating = false
    }
    
    func animate() {
        UIView.animate(
            withDuration: durationPerClock,
            delay: 0,
            options: [.curveLinear],
            animations: {
                var transform = self.imageView.layer.transform
                transform = CATransform3DRotate(transform, self.radiansPerClock, 0, 0, 1)
                self.imageView.layer.transform = transform
            },
            completion: { _ in
                if self.isRotating {
                    self.animate()
                }
            }
        )
    }

}
