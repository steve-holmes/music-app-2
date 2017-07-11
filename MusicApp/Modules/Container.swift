//
//  Container.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class ModuleContainer {
    
    lazy var musicModule: MusicModule           = { return MusicModule(parent: self) }()
    lazy var trackModule: TrackModule           = { return TrackModule(parent: self) }()
    
    lazy var mainModule: MainModule             = { return MainModule(parent: self) }()
    lazy var onlineModule: OnlineModule         = { return OnlineModule(parent: self) }()
    lazy var userModule: UserModule             = { return UserModule(parent: self) }()
    lazy var playerModule: PlayerModule         = { return PlayerModule(parent: self) }()
    
    lazy var homeModule: HomeModule             = { return HomeModule(parent: self) }()
    lazy var categoryModule: CategoryModule     = { return CategoryModule(parent: self) }()
    lazy var searchModule: SearchModule         = { return SearchModule(parent: self) }()
    lazy var playlistModule: PlaylistModule     = { return PlaylistModule(parent: self) }()
    lazy var songModule: SongModule             = { return SongModule(parent: self) }()
    lazy var videoModule: VideoModule           = { return VideoModule(parent: self) }()
    lazy var rankModule: RankModule             = { return RankModule(parent: self) }()
    lazy var topicModule: TopicModule           = { return TopicModule(parent: self) }()
    lazy var singerModule: SingerModule         = { return SingerModule(parent: self) }()
    
}

class Module {
    
    weak var parent: ModuleContainer?
    let container = Container()
    
    init(parent: ModuleContainer?) {
        self.parent = parent
        register()
    }
    
    func register() {
        fatalError("Subclass Implementation")
    }
    
    func getController<C: UIViewController>(of controllerType: C.Type, in module: Module) -> C {
        guard let controller = module.container.resolve(controllerType) else {
            fatalError("\(String(describing: controllerType)) not found")
        }
        return controller
    }
    
}
