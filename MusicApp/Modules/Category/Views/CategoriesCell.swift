//
//  CategoriesCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/16/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var topicNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepareForReuse() {
        topicNameLabel.text = ""
    }
    
    var name: String = "" {
        didSet {
            topicNameLabel.text = name
        }
    }
    
    var categories: [Category] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var item: Int!
    
    weak var delegate: CategoriesCellDelegate?
    
    func selectAtItem(_ item: Int, animated: Bool = true) {
        collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: animated, scrollPosition: [])
    }
    
    func deselectAtItem(_ item: Int, animated: Bool = true) {
        collectionView.deselectItem(at: IndexPath(item: item, section: 0), animated: animated)
    }
    
}

extension CategoriesCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCell.self), for: indexPath) as! CategoryCell
        
        let category = categories[indexPath.item]
        cell.name = category.name
        
        return cell
    }
    
}

extension CategoriesCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoriesCell(self, didSelectAtItem: indexPath.item)
    }
    
}

extension CategoriesCell: UICollectionViewDelegateFlowLayout {
    
    private var itemsPerRow: Int { return 3 }
    private var itemsPerColumn: Int { return 3 }
    
    private var rowPadding: CGFloat { return 10 }
    private var columnPadding: CGFloat { return 10 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        let width = (size.width - CGFloat(itemsPerRow + 1) * rowPadding) / CGFloat(itemsPerRow)
        let height = (size.height - CGFloat(itemsPerColumn + 1) * columnPadding) / CGFloat(itemsPerColumn)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return rowPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return columnPadding
    }
    
}

protocol CategoriesCellDelegate: class {
    
    func categoriesCell(_ cell: CategoriesCell, didSelectAtItem item: Int)
    
}
