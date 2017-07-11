//
//  CategoryHeaderView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class CategoryHeaderView: UIView {
    
    // MARK: Default Header Height
    
    static let defaultHeight: CGFloat = 35
    
    // MARK: Dimension Properties
    
    let height: CGFloat
    let buttonSize: CGSize
    
    // MARK: UI Elements
    
    private let label = UILabel()
    private var button = UIButton(type: .custom)
    
    // MARK: Constructors
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, buttonSize: CGSize = CGSize(width: 80, height: 24)) {
        self.height = size.height
        self.buttonSize = buttonSize
        
        super.init(frame: CGRect(origin: .zero, size: size))
        self.backgroundColor = .background
        self.alpha = 0.9
        
        configureLabel()
        configureButton()
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
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = buttonSize.height / 2
        
        self.buttonText = "Thể Loại"
        self.buttonColor = .main
        self.action = nil
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: buttonSize.width),
            button.heightAnchor.constraint(equalToConstant: buttonSize.height)
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
    
    var buttonText: String = "Thể Loại" {
        didSet {
            button.setTitle(buttonText, for: .normal)
        }
    }
    
    var buttonColor: UIColor = .main {
        didSet {
            self.button.setTitleColor(buttonColor, for: .normal)
            self.button.layer.borderColor = buttonColor.cgColor
        }
    }
    
    var action: CocoaAction? {
        didSet {
            self.button.rx.action = action
        }
    }
    
    // MARK: Configure label's text and button's action (helper method)
    
    func configure(text: String, action: CocoaAction) {
        self.text = text
        self.action = action
    }

}
