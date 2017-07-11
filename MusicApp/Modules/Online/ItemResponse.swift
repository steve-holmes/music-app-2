//
//  ItemResponse.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/20/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

enum ItemResponse<Item> {
    
    case loading
    case item(Item)
    
}
