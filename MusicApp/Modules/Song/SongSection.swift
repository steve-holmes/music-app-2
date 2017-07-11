//
//  SongSection.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxDataSources

typealias SongSection = SectionModel<String, Song>

extension Song: IdentifiableType {
    var identity: String { return id + Date().description }
}
