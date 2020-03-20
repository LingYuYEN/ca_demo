//
//  PageViewController.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit


protocol PageVCDelegate: class {
    
    /// 設定頁數
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - numberOfPage: _
    func pageViewController(_ pageViewController: PageViewController, didUpdateNumberOfPage numberOfPage: Int)
    
    /// 當 pageViewController 切換頁數時，設定 pageControl 的頁數
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - pageIndex: _
    func pageViewController(_ pageViewController: PageViewController, didUpdatePageIndex pageIndex: Int)
}

protocol FetchPhoneNumberDelegate {
//    func fetchPhoneNumber(_ phoneNumber: String)
    func fetchPhoneNumber() -> String
}

class PageViewController: UIPageViewController {

    var viewControllerArr = [UIViewController]()
    weak var pageViewControllerDelegate: PageVCDelegate?
    var fetchPhoneNumberDelegate: FetchPhoneNumberDelegate?
    var mainViewController: MainVC!
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllerArr.append(DetailSubVC(nibName: "DetailSubVC", bundle: nil))
        self.viewControllerArr.append(DetailSubVC(nibName: "DetailSubVC", bundle: nil))
        self.viewControllerArr.append(DetailSubVC(nibName: "DetailSubVC", bundle: nil))
//        self.viewControllerArr.append(DetailSubSecVC(nibName: "DetailSubSecVC", bundle: nil))
        
        self.dataSource = self
        self.delegate = self
        
        // 指定第一個顯示的頁面
        setViewControllers([viewControllerArr.first!], direction: .forward, animated: true, completion: nil)
        
        
        self.pageViewControllerDelegate?.pageViewController(self, didUpdateNumberOfPage: self.viewControllerArr.count)
        
        phoneNumber = self.fetchPhoneNumberDelegate?.fetchPhoneNumber()
    }
    
    func showPage(byIndex index: Int) {
        let viewController = viewControllerArr[index]
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }


}

extension PageViewController: UIPageViewControllerDataSource {
    
    /// 上一頁
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - viewController: _
    /// - Returns: _
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // 取得當前頁數的 index(未翻頁前)
        let currentIndex: Int =  self.viewControllerArr.firstIndex(of: viewController)!
        
        // 設定上一頁的 index
        let priviousIndex: Int = currentIndex - 1

        // 判斷上一頁的 index 是否小於 0，若小於 0 則停留在當前的頁數
        return priviousIndex < 0 ? nil : self.viewControllerArr[priviousIndex]
    }
    
    /// 下一頁
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - viewController: _
    /// - Returns: _
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // 取得當前頁數的 index(未翻頁前)
        let currentIndex: Int =  self.viewControllerArr.firstIndex(of: viewController)!
        
        // 設定下一頁的 index
        let nextIndex: Int = currentIndex + 1
        
        // 判斷下一頁的 index 是否大於總頁數，若大於則停留在當前的頁數
        return nextIndex > self.viewControllerArr.count - 1 ? nil : self.viewControllerArr[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    /// 切換完頁數觸發的 func
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - finished: _
    ///   - previousViewControllers: _
    ///   - completed: _
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // 取得當前頁數的 viewController
        let currentViewController: UIViewController = (self.viewControllers?.first)!
        
        // 取得當前頁數的 index
        let currentIndex: Int =  self.viewControllerArr.firstIndex(of: currentViewController)!
        
        // 設定 RootViewController 上 PageControl 的頁數
        self.pageViewControllerDelegate?.pageViewController(self, didUpdatePageIndex: currentIndex)
        
    }
}
