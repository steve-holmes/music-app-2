//
//  HomePlaylistCollectionViewLayout.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

let kHomePlaylistCollectionViewLayoutMaximumElements = 6

protocol HomePlaylistCollectionViewLayoutDelegate: class {
    
    func itemSizeForCollectionView(_ collectionView: UICollectionView) -> CGFloat
    func itemPaddingForCollectionView(_ collectionView: UICollectionView) -> CGFloat
    
}

class HomePlaylistCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: HomePlaylistCollectionViewLayoutDelegate?
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        guard cache.isEmpty else { return }
        guard let collectionView = collectionView else { return }
        guard collectionView.numberOfItems(inSection: 0) == 6 else { return }
        
        guard let itemSize = self.delegate?.itemSizeForCollectionView(collectionView) else { return }
        guard let itemPadding = self.delegate?.itemPaddingForCollectionView(collectionView) else { return }
        
        let bigLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        bigLayoutAttributes.frame = CGRect(
            x: itemPadding,
            y: itemPadding,
            width: 2 * itemSize + itemPadding,
            height: 2 * itemSize + itemPadding
        )
        cache.append(bigLayoutAttributes)
        
        for item in 1 ... 2 {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            layoutAttributes.frame = CGRect(
                x: 2 * itemSize + 3 * itemPadding,
                y: CGFloat(item - 1) * (itemSize + itemPadding) + itemPadding,
                width: itemSize,
                height: itemSize
            )
            cache.append(layoutAttributes)
        }
        
        for item in 3 ... 5 {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            layoutAttributes.frame = CGRect(
                x: itemPadding + CGFloat(item - 3) * (itemSize + itemPadding),
                y: 2 * itemSize + 3 * itemPadding,
                width: itemSize,
                height: itemSize
            )
            cache.append(layoutAttributes)
        }
    }
    
    override var collectionViewContentSize : CGSize {
        guard let collectionView = collectionView else { return CGSize.zero }
        guard let itemSize = self.delegate?.itemSizeForCollectionView(collectionView) else { return CGSize.zero }
        guard let itemPadding = self.delegate?.itemPaddingForCollectionView(collectionView) else { return CGSize.zero }
        
        return CGSize(
            width: 3 * itemSize + 4 * itemPadding,
            height: 3 * itemSize + 2 * itemPadding
        )
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = cache.filter { $0.frame.intersects(rect) }
        return layoutAttributes.isEmpty ? nil : layoutAttributes
    }
    
}
