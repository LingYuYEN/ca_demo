//
//  HomeVC.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import EventKit


class MainVC: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var callBtn: UIButton!
    @IBOutlet var mapBtn: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
    var phoneNumber: String?
    var pageViewController: PageViewController!
    var addressCoordinator: String?
    var visitTime: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressCoordinator = "22.6885991,120.3172083"
        visitTime = "2020.03.20 22:30:00"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerSegue" {
            pageViewController = segue.destination as? PageViewController
            pageViewController.pageViewControllerDelegate = self
            pageViewController.mainViewController = self
        }
    }
    
    
    @IBAction func onCallBtnClick(_ sender: Any) {
        makePhoneCall(phoneNumber: "0926004286")
    }
    @IBAction func onMapBtnClick(_ sender: Any) {
        guard let addressCoordinator = addressCoordinator else { return }
        getMapAlert(address: addressCoordinator)
    }
    @IBAction func onCalendarBtnClick(_ sender: Any) {
        let alerController = UIAlertController(title: "加到行事曆", message: "是否將預約時間加入行事曆？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是", style: .default) { _ in
            self.creatCalendarAction()
        }
        alerController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        
        self.present(alerController, animated: true, completion: nil)
        
    }
    
    /// 打電話
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    /// 顯示提示框，並前往google maps
    func getMapAlert(address: String) {
        
        
        
        // 建立提示框
        let alertController = UIAlertController(title: "前往 Google Maps", message: "確定後將離開此 APP", preferredStyle: .alert)
        
        // 建立確定動作
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            // 使用 open(_:options:completionHandler:) 來開啟 google maps 的 URL Scheme
            let urlStr = "https://www.google.com/maps/search/?api=1&query=\(address)"
            guard let url = URL(string: urlStr) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(okAction)
        
        // 建立取消動作
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// 顯示提示框，並新增排程制行事曆
    func creatCalendarAction() {
        guard let visitTime = visitTime else { return }
        let dateFormatter = DateFormatter()     // 建立日期格式化器
        
        dateFormatter.dateFormat = "YYYY.MM.dd HH:mm:ss"    // 時間格式
        guard let visitDate = dateFormatter.date(from: visitTime) else { return }// 自訂 String
        
        // 建立行事曆
        let store = EKEventStore()
        store.requestAccess(to: .event) { (bool, error) in
            print(bool ? "⏰ 初始化成功" : "⏰ 初始化失敗")
        }
        let newEvent = EKEvent(eventStore: store)
        let alarm = EKAlarm(relativeOffset: -60 * 15) //(提醒時間) 以開始時間為0點,負前正後
        newEvent.title = "預約看診" //標題
        newEvent.notes = "您的預約時間是： \(visitTime)" //備註
        
        newEvent.addAlarm(alarm) // 新增提醒
        newEvent.startDate = visitDate // 事件開始時間
        newEvent.endDate = newEvent.startDate.addingTimeInterval(300) // 事件結束時間
        newEvent.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(newEvent, span: .thisEvent)
            print("⏰ 提醒新增成功")
            getCalendarAlert()
        } catch {
            print (error, "⏰ 提醒新增失敗")
        }
    }
    
    // 顯示提示框是否新增行事曆
    func getCalendarAlert() {
        // 建立提示框
        let alertController = UIAlertController(title: "新增成功", message: "請按確定檢視行事曆，或按取消回到 APP", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            // URL Scheme to 行事曆
            let urlStr = "calshow://"
            guard let url = URL(string: urlStr) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
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
