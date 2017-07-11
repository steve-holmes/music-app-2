//
//  HomePageCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class HomePageCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        startTimer()
    }
    
    override func prepareForReuse() {
        stopTimer()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextPage(_:)), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func moveToNextPage(_ timer: Timer) {
        let nextItem = (pageControl.currentPage + 1) % pageControl.numberOfPages
        collectionView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: [], animated: true)
        pageControl.currentPage = nextItem
    }
    
    var pages: [Playlist] = [] {
        didSet {
            pageControl.numberOfPages = pages.count
            pageControl.currentPage = 0
            collectionView.reloadData()
        }
    }
    
    var onPageDidSelect: Action<Playlist, Void>!

}

extension HomePageCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomePageItemCell.self), for: indexPath)
        (cell as? HomePageItemCell)?.image = pages[indexPath.item].avatar
        return cell
    }
    
}

extension HomePageCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let page = pages[indexPath.item]
        onPageDidSelect.execute(page)
    }
    
}

extension HomePageCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

extension HomePageCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
}
