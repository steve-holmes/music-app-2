//
//  CategoryCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/16/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var highlightedView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureBackgroundViews()
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        nameLabel.textColor = .text
        
        selectedView.setProperties(withAlpha: startAlpha, andTransform: startTransform)
        highlightedView.setProperties(withAlpha: startAlpha, andTransform: startTransform)
    }
    
    private func configureBackgroundViews() {
        let height: CGFloat = 20
        selectedView.layer.cornerRadius = height
        highlightedView.layer.cornerRadius = height
        containerView.layer.cornerRadius = height
    }
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == oldValue { return }
            
            if isSelected { didSelected() }
            else { didDeselected() }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted == oldValue { return }
            
            if isHighlighted { didHighlighted() }
            else { didUnhighlighted() }
        }
    }
    
}

extension CategoryCell {
    
    fileprivate func didSelected() {
        nameLabel.textColor = .text
        selectedView.setProperties(withAlpha: startAlpha, andTransform: startTransform)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.nameLabel.textColor = .white
                self.selectedView.setProperties(withAlpha: self.endAlpha, andTransform: self.endTransform)
            },
            completion: nil
        )
    }
    
    fileprivate func didDeselected() {
        nameLabel.textColor = .white
        selectedView.setProperties(withAlpha: endAlpha, andTransform: endTransform)
        
        UIView.animate(withDuration: duration) {
            self.nameLabel.textColor = .text
            self.selectedView.setProperties(withAlpha: self.startAlpha, andTransform: self.startTransform)
        }
    }

    fileprivate func didHighlighted() {
        highlightedView.setProperties(withAlpha: startAlpha, andTransform: startTransform)
        UIView.animate(withDuration: duration) { 
            self.highlightedView.setProperties(withAlpha: self.endAlpha, andTransform: self.endTransform)
        }
    }
    
    fileprivate func didUnhighlighted() {
        highlightedView.setProperties(withAlpha: endAlpha, andTransform: endTransform)
        UIView.animate(withDuration: duration) { 
            self.highlightedView.setProperties(withAlpha: self.startAlpha, andTransform: self.startTransform)
        }
    }
    
}

extension CategoryCell {
    
    fileprivate var startTransform: CGAffineTransform { return CGAffineTransform(scaleX: 0.1, y: 0.1) }
    fileprivate var endTransform: CGAffineTransform { return .identity }
    
    fileprivate var startAlpha: CGFloat { return 0 }
    fileprivate var endAlpha: CGFloat { return 1 }
    
    fileprivate var duration: TimeInterval { return 0.2 }
    
}

fileprivate extension UIView {
    
    func setProperties(withAlpha alpha: CGFloat, andTransform transform: CGAffineTransform) {
        self.alpha = alpha
        self.transform = transform
    }
    
}
