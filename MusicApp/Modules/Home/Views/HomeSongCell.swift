//
//  HomeSongCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class HomeSongCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    var songs: [Song] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var onSongDidSelect: Action<Song, Void>!

}

extension HomeSongCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongCell.self), for: indexPath)
        
        if let cell = cell as? SongCell {
            let song = songs[indexPath.row]
            let contextAction = CocoaAction {
                return .empty()
            }
            cell.configure(name: song.name, singer: song.singer, contextAction: contextAction)
        }
        
        return cell
    }
    
}

extension HomeSongCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        onSongDidSelect.execute(song)
    }
    
}
