//
//  OnlineModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class OnlineModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(UINavigationController.self) { [weak self] resolver in
            let navigationController = UIStoryboard.online.instantiateViewController(withIdentifier: String(describing: OnlineViewController.self)) as! UINavigationController
            
            if let onlineController = navigationController.viewControllers.first as? OnlineViewController {
                onlineController.store = resolver.resolve(OnlineStore.self)!
                onlineController.action = resolver.resolve(OnlineAction.self)!
                
                if let searchModule = self?.parent?.searchModule {
                    onlineController.searchController = searchModule.container.resolve(UISearchController.self)!
                }
                
                self?.setupMenu(onlineController)
                
                onlineController.controllers = [
                    self!.getController(of: HomeViewController.self,     in: self!.parent!.homeModule),
                    self!.getController(of: PlaylistViewController.self, in: self!.parent!.playlistModule),
                    self!.getController(of: SongViewController.self,     in: self!.parent!.songModule),
                    self!.getController(of: VideoViewController.self,    in: self!.parent!.videoModule),
                    self!.getController(of: RankViewController.self,     in: self!.parent!.rankModule),
                    self!.getController(of: SingerViewController.self,   in: self!.parent!.singerModule),
                    self!.getController(of: TopicViewController.self,    in: self!.parent!.topicModule)
                ]
            }
            
            return navigationController
        }
        
        container.register(OnlineStore.self) { resolver in
            return MAOnlineStore()
        }
        
        container.register(OnlineAction.self) { resolver in
            return MAOnlineAction(
                store: resolver.resolve(OnlineStore.self)!,
                service: resolver.resolve(OnlineService.self)!
            )
        }
        
        // MARK: Domain Model
        
        container.register(OnlineService.self) { resolver in
            return MAOnlineService(
                coordinator: resolver.resolve(OnlineCoordinator.self)!
            )
        }
        
        container.register(OnlineCoordinator.self) { resolver in
            return MAOnlineCoordinator()
        }.initCompleted { [weak self] resolver, coordinator in
            let coordinator = coordinator as! MAOnlineCoordinator
            coordinator.sourceController = resolver.resolve(UINavigationController.self)?.viewControllers.first as? OnlineViewController
            
            let searchModule = self?.parent?.searchModule
            coordinator.getSearchController = { searchModule?.container.resolve(SearchViewController.self) }
        }
    }
    
    private func setupMenu(_ controller: OnlineViewController) {
        let menuColor = UIColor(withIntWhite: 250)
        
        controller.settings.style.buttonBarBackgroundColor = menuColor
        controller.settings.style.selectedBarBackgroundColor = .main
        controller.settings.style.selectedBarHeight = 3
        controller.settings.style.buttonBarBackgroundColor = menuColor
        controller.settings.style.buttonBarItemFont = UIFont(name: "AvenirNext-Medium", size: 15)!
        controller.settings.style.buttonBarItemTitleColor = .text
        
        controller.buttonBarItemSpec = .cellClass { _ in 80 }
        
        controller.changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
            guard changeCurrentIndex == true else { return }
            
            newCell?.label.textColor = .main
            oldCell?.label.textColor = .text
            
            newCell?.imageView?.tintColor = .main
            oldCell?.imageView?.tintColor = .text
            
            let startScale: CGFloat = 0.9
            let endScale: CGFloat = 1.1
            
            if animated {
                UIView.animate(withDuration: 0.1) {
                    newCell?.layer.transform = CATransform3DMakeScale(endScale, endScale, 1)
                    oldCell?.layer.transform = CATransform3DMakeScale(startScale, startScale, 1)
                }
            } else {
                newCell?.layer.transform = CATransform3DMakeScale(endScale, endScale, 1)
                oldCell?.layer.transform = CATransform3DMakeScale(startScale, startScale, 1)
            }
        }
        
        controller.edgesForExtendedLayout = []
    }
    
}
