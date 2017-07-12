//
//  OnlineCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol OnlineCoordinator {
    
    func presentSearch() -> Observable<Void>
    
}

class MAOnlineCoordinator: OnlineCoordinator {
    
    weak var sourceController: OnlineViewController?
    var getSearchController: (() -> SearchViewController?)?
    
    func presentSearch() -> Observable<Void> {
        guard let sourceController = sourceController else { return .empty() }
        guard let destinationController = getSearchController?() else { return .empty() }
        
        sourceController.show(destinationController, sender: self)
        
        return .empty()
    }
    
}
