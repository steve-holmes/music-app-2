//
//  MainStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol MainStore {
    
    var position: Variable<MainState> { get }
    
    var image: Variable<String> { get }
    var rotating: Variable<Bool> { get }
    var iconVisible: Variable<Bool> { get }
    
    var translation: Variable<CGFloat> { get }
    
}

class MAMainStore: MainStore {
    
    let position = Variable<MainState>(.online)
    
    let image = Variable<String>("")
    let rotating = Variable<Bool>(false)
    let iconVisible = Variable<Bool>(true)
    
    let translation = Variable<CGFloat>(0)
    
}
