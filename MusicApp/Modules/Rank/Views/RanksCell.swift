//
//  RanksCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Kingfisher

class RanksCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankImageView: UIImageView!
    
    @IBOutlet weak var firstItemLabel: UILabel!
    @IBOutlet weak var secondItemLabel: UILabel!
    @IBOutlet weak var thirdItemLabel: UILabel!
    @IBOutlet weak var fourthItemLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstIcon: UIView!
    @IBOutlet weak var secondIcon: UIView!
    @IBOutlet weak var thirdIcon: UIView!
    @IBOutlet weak var fourthIcon: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 7
        
        firstIcon.layer.cornerRadius = 5
        secondIcon.layer.cornerRadius = 5
        thirdIcon.layer.cornerRadius = 5
        fourthIcon.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        rankLabel.text = ""
        rankImageView.image = nil
        
        firstItemLabel.text = ""
        secondItemLabel.text = ""
        thirdItemLabel.text = ""
        fourthItemLabel.text = ""
    }
    
    var rank: String = "" {
        didSet {
            rankLabel.text = rank
        }
    }
    
    var rankImage: String = "" {
        didSet {
            if let image = UIImage(named: rankImage) {
                rankImageView.image = image
                return
            }
            
            let imageURL = URL(string: rankImage)
            rankImageView.kf.setImage(with: imageURL)
        }
    }
    
    var firstItem: String = "" {
        didSet {
            firstItemLabel.text = firstItem
        }
    }
    
    var secondItem: String = "" {
        didSet {
            secondItemLabel.text = secondItem
        }
    }
    
    var thirdItem: String = "" {
        didSet {
            thirdItemLabel.text = thirdItem
        }
    }
    
    var fourthItem: String = "" {
        didSet {
            fourthItemLabel.text = fourthItem
        }
    }

}
