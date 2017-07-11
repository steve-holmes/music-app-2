//
//  SongDataSource.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

extension TableViewSectionedDataSource {
    
    func configureCell(for tableView: UITableView, at indexPath: IndexPath, in controller: UIViewController, animated: Bool, configuration otherCallback: () -> UITableViewCell) -> UITableViewCell {
        let AdvertisementSection = 0
        let LoadMoreSection = 2
        
        switch indexPath.section {
        case AdvertisementSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AdvertisementCell.self), for: indexPath)
            if let cell = cell as? AdvertisementCell {
                cell.configure(rootViewController: controller)
            }
            return cell
        case LoadMoreSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadMoreCell.self), for: indexPath)
            (cell as? LoadMoreCell)?.loadMoreEnabled = animated
            return cell
        default:
            return otherCallback()
        }
    }
    
}
