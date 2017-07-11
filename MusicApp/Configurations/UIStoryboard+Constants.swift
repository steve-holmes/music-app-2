//
//  UIStoryboard+Constants.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var main: UIStoryboard       { return UIStoryboard(name: "Main", bundle: nil) }
    static var online: UIStoryboard     { return UIStoryboard(name: "Online", bundle: nil) }
    static var user: UIStoryboard       { return UIStoryboard(name: "User", bundle: nil) }
    static var player: UIStoryboard     { return UIStoryboard(name: "Player", bundle: nil) }
    
    static var home: UIStoryboard       { return UIStoryboard(name: "Home", bundle: nil) }
    static var category: UIStoryboard   { return UIStoryboard(name: "Category", bundle: nil) }
    static var search: UIStoryboard     { return UIStoryboard(name: "Search", bundle: nil) }
    static var playlist: UIStoryboard   { return UIStoryboard(name: "Playlist", bundle: nil) }
    static var song: UIStoryboard       { return UIStoryboard(name: "Song", bundle: nil) }
    static var video: UIStoryboard      { return UIStoryboard(name: "Video", bundle: nil) }
    static var rank: UIStoryboard       { return UIStoryboard(name: "Rank", bundle: nil) }
    static var topic: UIStoryboard      { return UIStoryboard(name: "Topic", bundle: nil) }
    static var singer: UIStoryboard     { return UIStoryboard(name: "Singer", bundle: nil) }
    
}

extension UIStoryboard {
    
    func controller<Controller: UIViewController>(of type: Controller.Type) -> Controller {
        return self.instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
    
}
