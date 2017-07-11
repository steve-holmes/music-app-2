//
//  SingerCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

class SingerCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
    }
    
    private var singerSubscription: Disposable?
    private var didSelectActionSubscription: Disposable?
    
    var singers: SingerCollection! {
        didSet {
            singerSubscription = Observable.just(singers)
                .map { collection in collection.singers }
                .map { singers in [SingerItemSection(model: "Singer Collection", items: singers)] }
                .bind(to: collectionView.rx.items(dataSource: dataSource))
        }
    }
    
    var didSelectAction: Action<Singer, Void>! {
        didSet {
            didSelectActionSubscription = collectionView.rx.modelSelected(Singer.self)
                .bind(to: didSelectAction.inputs)
        }
    }
    
    var registerPreviewAction: Action<UIView, Void>!
    
    override func prepareForReuse() {
        singerSubscription?.dispose()
        didSelectActionSubscription?.dispose()
    }
    
    deinit {
        singerSubscription?.dispose()
        didSelectActionSubscription?.dispose()
    }
    
    fileprivate lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SingerItemSection> = {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SingerItemSection>()
        
        dataSource.configureCell = { dataSource, collectionView, indexPath, singer in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SingerItemCell.self), for: indexPath)
            if let cell = cell as? SingerItemCell {
                cell.configure(name: singer.name, image: singer.avatar)
                self.registerPreviewAction.execute(cell)
            }
            return cell
        }
        
        return dataSource
    }()

}

extension SingerCell: UICollectionViewDelegateFlowLayout, SingerCellOptions {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size(of: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
}
