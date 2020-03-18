//
//  HomeVC.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var callBtn: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
    var phoneNumber: String?
    var pageViewController: PageViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerSegue" {
            pageViewController = segue.destination as? PageViewController
            pageViewController.pageViewControllerDelegate = self
            pageViewController.mainViewController = self
        }
    }
    
    
    @IBAction func callBtnClick(_ sender: Any) {
        makePhoneCall(phoneNumber: "0926004286")
    }
    
    // 打電話
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
}

extension MainVC: PageVCDelegate {
    func pageViewController(_ pageViewController: PageViewController, didUpdateNumberOfPage numberOfPage: Int) {
        self.pageControl.numberOfPages = numberOfPage
    }
    
    func pageViewController(_ pageViewController: PageViewController, didUpdatePageIndex pageIndex: Int) {
        self.pageControl.currentPage = pageIndex
    }
}
