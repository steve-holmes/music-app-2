//
//  RanksSection.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxDataSources

struct RanksItem {
    let rank: String
    let image: String
    let items: [String]
}

typealias RankSection = SectionModel<String, RanksItem>
