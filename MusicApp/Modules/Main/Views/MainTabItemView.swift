//
//  MainTabItemView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class MainTabItemView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func configure(store: MainStore, action: MainAction) {
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }

}

// MARK: State

extension MainTabItemView {
    
    enum State {
        case normal
        case selected
    }
    
    func setState(_ state: State) {
        updateUI(at: state)
    }
    
}

// MARK: Update UI

extension MainTabItemView {
    
    func updateUI(at state: State) {
        switch state {
        case .normal: updateNormalUI()
        case .selected: updateSelectedUI()
        }
    }
    
    private func updateNormalUI() {
        imageView.tintColor = normalTintColor
        label.textColor = normalLabelColor
        backgroundColor = normalBackgroundColor
    }
    
    private func updateSelectedUI() {
        imageView.tintColor = selectedTintColor
        label.textColor = selectedLabelColor
        backgroundColor = selectedBackgroundColor
    }
    
}

// MARK: Color Constants

extension MainTabItemView {
    var normalLabelColor: UIColor           { return .text }
    var selectedLabelColor: UIColor         { return .white }
    
    var normalTintColor: UIColor            { return .toolbarImage}
    var selectedTintColor: UIColor          { return .white }
    
    var normalBackgroundColor: UIColor      { return .normalBackground }
    var selectedBackgroundColor: UIColor    { return .main }
}
