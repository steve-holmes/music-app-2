//
//  HomeHeaderSectionView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

class HomeHeaderSectionView: UIView {

    // MARK: Default Header Height
    
    static let defaultHeight: CGFloat = 35
    
    // MARK: UI Elements
    
    private let label = UILabel()
    private var button = UIButton(type: .custom)
    
    // MARK: Constructors
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, moreButtonEnabled: Bool = true) {
        super.init(frame: CGRect(origin: .zero, size: size))
        self.backgroundColor = .background
        self.alpha = 0.9
        
        configureLabel()
        
        if moreButtonEnabled {
            configureButton()
        }
    }
    
    // MARK: Configurations
    
    private func configureLabel() {
        self.text = ""
        self.textColor = .text
        self.font = .avenirNextFont()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])
    }
    
    private func configureButton() {
        button.titleLabel?.font = .avenirNextFont(size: 13)
        
        self.buttonText = "Xem thêm"
        self.buttonColor = .text
        self.action = nil
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Label Properties
    
    var text: String = "" {
        didSet {
            self.label.text = text
        }
    }
    
    var textColor: UIColor = .text {
        didSet {
            self.label.textColor = textColor
        }
    }
    
    var font: UIFont = .avenirNextFont() {
        didSet {
            self.label.font = font
        }
    }
    
    // MARK: Button Properties
    
    var buttonText: String? {
        didSet {
            button.setTitle(buttonText, for: .normal)
        }
    }
    
    var buttonColor: UIColor = .text {
        didSet {
            self.button.setTitleColor(buttonColor, for: .normal)
        }
    }
    
    var action: CocoaAction? {
        didSet {
            self.button.rx.action = action
        }
    }

}
