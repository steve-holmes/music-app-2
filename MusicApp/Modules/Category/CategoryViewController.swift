//
//  CategoryViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/16/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class CategoryViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var suffixSegmentControl: TwicketSegmentedControl!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dimmingView: UIView!
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setCurrentCategory()
    }
    
    // MARK: Configure UI
    
    private func configureViews() {
        nameLabel.text = category.name
        
        suffixSegmentControl.setSegmentItems(["Mới nhất", "Hot nhất"])
        suffixSegmentControl.font = .avenirNextFont(size: 12)
        suffixSegmentControl.defaultTextColor = .text
        suffixSegmentControl.highlightTextColor = .white
        suffixSegmentControl.segmentsBackgroundColor = .background
        suffixSegmentControl.sliderBackgroundColor = .main
        suffixSegmentControl.isSliderShadowHidden = false
        suffixSegmentControl.move(to: category.new ? 0 : 1)
        suffixSegmentControl.isHidden = suffixSegmentControlHiddenEnabled
        suffixSegmentControl.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageControl.numberOfPages = categoryInfos.count
        
        backgroundView.layer.cornerRadius = 10
        
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerDidReceiveInDimmingView(_:))))
    }
    
    func tapGestureRecognizerDidReceiveInDimmingView(_ tapGesture: UITapGestureRecognizer) {
        self.dismiss(animated: true) { 
            self.categoryCompletion?(nil)
        }
    }
    
    // MARK: Current Item
    
    fileprivate var selectedIndexPath = IndexPath()
    
    private func setCurrentCategory() {
        selectedIndexPath = findCategory(self.category)
        pageControl.currentPage = selectedIndexPath.section
        collectionView.scrollToItem(at: IndexPath(item: selectedIndexPath.section, section: 0), at: [], animated: false)
    }
    
    fileprivate func findCategory(_ category: CategoryInfo) -> IndexPath {
        let searchCategory = category
        
        for (infoIndex, info) in categoryInfos.enumerated() {
            for (categoryIndex, category) in info.categories.enumerated() {
                if category.name == searchCategory.name {
                    let selectedIndexPath = IndexPath(item: categoryIndex, section: infoIndex)
                    return selectedIndexPath
                }
            }
        }
        
        return IndexPath()
    }
    
    // MARK: Properties
    
    var category: CategoryInfo! {
        didSet {
            nameLabel?.text = category.name
        }
    }
    
    var categoryInfos: [CategoriesInfo] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var suffixSegmentControlHiddenEnabled = false {
        didSet {
            suffixSegmentControl?.isHidden = suffixSegmentControlHiddenEnabled
        }
    }
    
    var categoryCompletion: ((CategoryInfo?) -> Void)?
    
    // MARK: Actions

    @IBAction func cancelButtonTapped(_ cancelButton: UIButton) {
        self.dismiss(animated: true) { 
            self.categoryCompletion?(nil)
        }
    }
    
}

extension CategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoriesCell.self), for: indexPath) as! CategoriesCell
        
        let categoryInfo = categoryInfos[indexPath.item]
        cell.name = categoryInfo.name
        cell.categories = categoryInfo.categories
        
        cell.item = indexPath.item
        cell.delegate = self
        
        if isSelectedItem(indexPath.item) {
            cell.selectAtItem(selectedIndexPath.item, animated: false)
        }
        
        return cell
    }
    
    private func isSelectedItem(_ item: Int) -> Bool {
        return item == selectedIndexPath.section
    }
    
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

extension CategoryViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
}

extension CategoryViewController: CategoriesCellDelegate {
    
    func categoriesCell(_ cell: CategoriesCell, didSelectAtItem item: Int) {
        reloadCategoriesCollectionView(at: cell, and: item) {
            self.dimissController(withIndexPath: self.selectedIndexPath)
        }
    }
    
    private func reloadCategoriesCollectionView(at cell: CategoriesCell, and item: Int, completion: (() -> Void)?) {
        if cell.item == selectedIndexPath.section && item == selectedIndexPath.item {
            return
        } else if cell.item == selectedIndexPath.section {
            selectedIndexPath = IndexPath(item: item, section: cell.item)
            collectionView.reloadItems(at: [IndexPath(item: cell.item, section: 0)])
            
        } else {
            let section = selectedIndexPath.section
            selectedIndexPath = IndexPath(item: item, section: cell.item)
            
            collectionView.performBatchUpdates({ [unowned self] in
                self.collectionView.reloadItems(at: [IndexPath(item: cell.item, section: 0)])
                self.collectionView.reloadItems(at: [IndexPath(item: section, section: 0)])
            }, completion: nil)
        }
        
        completion?()
    }
    
    private func dimissController(withIndexPath indexPath: IndexPath) {
        let selectedCategory = findCategory(atIndexPath: indexPath)
        
        let name = selectedCategory.name
        let new = self.category.new
        let newlink = selectedCategory.newlink
        let hotlink = selectedCategory.hotlink
        
        self.dismiss(animated: true) { [weak self] in
            let category = CategoryInfo(name: name, new: new, newlink: newlink, hotlink: hotlink)
            self?.categoryCompletion?(category)
        }
    }
    
    private func findCategory(atIndexPath indexPath: IndexPath) -> Category {
        return self.categoryInfos[indexPath.section].categories[indexPath.item]
    }
    
}

extension CategoryViewController: TwicketSegmentedControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:  dimissController(withSubKind: true)
        case 1:  dimissController(withSubKind: false)
        default: break
        }
    }
    
    private func dimissController(withSubKind subKind: Bool) {
        guard shouldDimissController(withSubKind: subKind) else { return }
        
        self.dismiss(animated: true) { [weak self] in
            guard let this = self else { return }
            let category = CategoryInfo(
                name: this.category.name,
                new: subKind,
                newlink: this.category.newlink,
                hotlink: this.category.hotlink
            )
            this.categoryCompletion?(category)
        }
    }
    
    private func shouldDimissController(withSubKind subKind: Bool) -> Bool {
        return subKind != category.new
    }
    
}
