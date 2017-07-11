//
//  SingerSection.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxDataSources

typealias SingerItemSection = SectionModel<String, Singer>

struct SingerCollection {
    let singers: [Singer]
}

typealias SingerCollectionSection = SectionModel<String, SingerCollection>
