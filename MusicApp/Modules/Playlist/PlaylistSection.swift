//
//  PlaylistSection.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxDataSources

typealias PlaylistItemSection = SectionModel<String, Playlist>

struct PlaylistCollection {
    let playlists: [Playlist]
}

typealias PlaylistCollectionSection = SectionModel<String, PlaylistCollection>
