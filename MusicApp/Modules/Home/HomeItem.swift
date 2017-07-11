//
//  HomeItem.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

enum HomeItem {
    case advertisement
    
    case pages([Playlist])
    case playlists([Playlist])
    
    case videos([Video])
    case films([Video])
    
    case topics([Topic])
    
    case songs([Song])
}
