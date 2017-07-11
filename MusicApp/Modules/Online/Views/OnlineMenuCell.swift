//
//  OnlineBarCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class OnlineMenuCell: UICollectionViewCell {
    
    var label: UILabel!
    var imageView: UIImageView?
    
    func configure(title: String, image: UIImage?, configureCallback: ((_ label: UILabel) -> Void)? = nil) {
        label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        configureCallback?(label)
        
        if let image = image {
            imageView = UIImageView()
            imageView?.image = image.withRenderingMode(.alwaysTemplate)
            imageView?.contentMode = .scaleAspectFit
        }
        
        if let imageView = imageView {
            addImageView(imageView)
        } else {
            addLabel(label)
        }
    }
    
    private func addLabel(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.removeAllSubviews()
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func addImageView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.removeAllSubviews()
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            view.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7, constant: 0),
            view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7, constant: 0)
        ])
    }
    
}
