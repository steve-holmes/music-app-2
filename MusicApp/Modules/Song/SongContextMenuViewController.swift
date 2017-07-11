//
//  SongContextMenuViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class SongContextMenuViewController: UIViewController {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dimmingView: UIView!
    
    var song: Song!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        songNameLabel.text = song.name
    }
    
    private func configureViews() {
        backgroundView.layer.cornerRadius = 10
        
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapGestureDidReceieve(_:))))
    }
    
    func dimmingViewTapGestureDidReceieve(_ tapGesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ shareButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonTapped(_ addButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func downLoadButtonTapped(_ downloadButton: UIButton) {
        self.dismiss(animated: true)
    }

}
