//
//  DetailSubVC.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit
import Firebase


class DetailSubVC: UIViewController {
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var messageContView: UIView!
    @IBOutlet var waitCountContView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    /// 診所名稱
    @IBOutlet var companyNameLabel: UILabel!
    /// 診所地址
    @IBOutlet var addressLabel: UILabel!
    /// 診所電話
    @IBOutlet var phoneLabel: UILabel!
    /// 稱呼及提醒句
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var largeTitleLabel: UILabel!
    
    /// 預約時間
    @IBOutlet var reservationTimeLabel: UILabel!
    
    /// 目前看診號
    @IBOutlet var originNumberLabel: UILabel!
    
    /// 我的看診號
    @IBOutlet var myNumberLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var reciprocalLabel: UILabel!
    
    @IBOutlet var originalDigitalLabel: UILabel!
    @IBOutlet var myDigitalLabel: UILabel!
    @IBOutlet var reciprocalDigatalLabel: UILabel!
    
    @IBOutlet var timeUnitsLabel: UILabel!
    
    @IBOutlet var waitCountLabel: UILabel!
    @IBOutlet var waitNumberLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()
    var containerVC: MainVC?
    var dailyVisits: DatabaseReference? = nil
    var patient: DatabaseReference? = nil
    
    let containerSegueName = "ContainerSegue"
    
    var companyNameStr = ""
    var addressStr = ""
    var phoneStr = ""
    var nameStr = ""
    var largeTitleStr = ""
    var visitTime = "2020.03.20 22:30:00"
    var originalDigitalNumber = 0   // 目前看診號
    var myDigitalNumber = 0     // 我的看診號
    var waitingNumber = 0       // 等待人數
    var reciprocalDigatalNumber = 0     // 倒數時間
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        setGradientView(fromColor: UIColor.set(red: 101, green: 172, blue: 172).withAlphaComponent(0.94),
                        toColor: UIColor.set(red: 29, green: 119, blue: 182).withAlphaComponent(0.94))
        
        companyNameStr = "美好診所"
        addressStr = "高雄市左營區博愛五路  235 號"
        phoneStr = "07 123 4567"
        nameStr = "蕭先生   您好   建議提前五分鐘於現場等候"
        largeTitleStr = "以下為您專屬預約資訊"
        originalDigitalNumber = 0
        myDigitalNumber = 0
        reciprocalDigatalNumber = 0
        
        setUI()
        
        // 現在看診號（originalDigitalNumber）
        dailyVisits = Database.database().reference().child("DailyVisits")
        dailyVisits?.child("current_number").observe(.value,
                                                     with: { (snapshot) in
                                                        // get current_number value
                                                        if let value = snapshot.value  {
                                                            print(value)
                                                            self.originalDigitalNumber = value as! Int
                                                        }
                                                        // 進度條停止轉動
                                                        self.activityIndicatorView.stopAnimating()
                                                        self.setUI()
        })
        
        // 我的看診號（myDigitalNumber）
        patient = Database.database().reference().child("Patient")
        patient?.child("waiting_number").observe(.value,
                                                 with: { (snapshot) in
                                                    // get waiting_number value
                                                    if let value = snapshot.value {
                                                        print(value)
                                                        self.myDigitalNumber = value as! Int
                                                    }
                                                    // 進度條停止轉動
                                                    self.activityIndicatorView.stopAnimating()
                                                    self.setUI()
        })
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicatorView.layer.cornerRadius = 15
        
        
        updateReciprocalTime()
    }
    
    override func viewWillLayoutSubviews() {
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.size.height / 2
    }
    func setValue() {
        
    }
    
    func setUI() {
        
        updateReciprocalTime()
        
        waitingNumber = myDigitalNumber - originalDigitalNumber
        
        messageContView.layer.cornerRadius = 14 * screenScaleWidth
        waitCountContView.layer.cornerRadius = 14 * screenScaleWidth
        
        companyNameLabel.attributedText = .setAttributedString(string: companyNameStr, wordSpace: .twoPFiveSeven)
        addressLabel.attributedText = .setAttributedString(string: addressStr, wordSpace: .twoPThreeThree)
        phoneLabel.attributedText = .setAttributedString(string: phoneStr, wordSpace: .twoPThreeThree)
        
        nameLabel.attributedText = .setAttributedString(string: nameStr, wordSpace: .onePFive)
        largeTitleLabel.attributedText = .setAttributedString(string: largeTitleStr, wordSpace: .fivePZero)
        
        cancelBtn.setAttributedTitle(.setAttributedString(string: "取消", wordSpace: .twoPThreeThree), for: .normal)
        
        reservationTimeLabel.attributedText = .setAttributedString(string: "預約時間", wordSpace: .onePNine)
        originNumberLabel.attributedText = .setAttributedString(string: "目前看診號", wordSpace: .onePNine)
        myNumberLabel.attributedText = .setAttributedString(string: "我預約診號", wordSpace: .onePNine)
        dateLabel.attributedText = .setAttributedString(string: "今日下午", wordSpace: .onePNine)
        
        reciprocalLabel.attributedText = .setAttributedString(string: "等待時間倒數", wordSpace: .onePNine)
        waitCountLabel.attributedText = .setAttributedString(string: "等待人數預計", wordSpace: .onePNine)
        
        
        var formatStr = String(format: "%05ld", originalDigitalNumber)
        originalDigitalLabel.attributedText = .setDiffrentColorAttrStr(string: formatStr, wordSpace: .fourPZero, color: .lightGray, interval: originalDigitalNumber)
        
        formatStr = String(format: "%05ld", myDigitalNumber)
        myDigitalLabel.attributedText = .setDiffrentColorAttrStr(string: formatStr, wordSpace: .fourPZero, color: .lightGray, interval: myDigitalNumber)
        
        formatStr = String(format: "%03ld", waitingNumber)
        waitNumberLabel.attributedText = .setDiffrentColorAttrStr(string: formatStr, wordSpace: .twoPTwo, color: .lightGray, interval: waitingNumber)
        
        switch waitingNumber {
        case 0:
            largeTitleStr = "以下為您專屬預約資訊"
            setGradientView(fromColor: UIColor.set(red: 101, green: 172, blue: 172).withAlphaComponent(0.94),
                            toColor: UIColor.set(red: 29, green: 119, blue: 182).withAlphaComponent(0.94))
            break
        case 1 ... 5:
            largeTitleStr = "請留意時間 以免過號"
            setGradientView(fromColor: UIColor.set(red: 201, green: 60, blue: 60).withAlphaComponent(0.94),
                            toColor: UIColor.set(red: 163, green: 40, blue: 40).withAlphaComponent(0.94))
        default:
            largeTitleStr = "以下為您專屬預約資訊"
            setGradientView(fromColor: UIColor.set(red: 101, green: 172, blue: 172).withAlphaComponent(0.94),
                            toColor: UIColor.set(red: 29, green: 119, blue: 182).withAlphaComponent(0.94))
        }
    }
    
    /// 更新倒數時間
    func updateReciprocalTime() {
        let dateFormatter = DateFormatter()     // 建立日期格式化器
        let calendar = Calendar.current         // 取得本地日曆
        
        dateFormatter.dateFormat = "YYYY.MM.dd HH:mm:ss"    // 時間格式
        let vivitDate = dateFormatter.date(from: visitTime) // 自訂 String 時間格式需與上一行吻合
        let visitDateHourStr = calendar.component(.hour, from: vivitDate!)  // 提取 hour
        let visitDateMinuteStr = calendar.component(.minute, from: vivitDate!)  // 提取 minute
        
        // 與現在時間時間相差
        let dateBetween = Date().daysBetweenDate(toDate: vivitDate!)
        var reciprocalTime = dateBetween.day
        var reciprocalUnit = "天"
        
        // day
        if reciprocalTime <= 0 {
            reciprocalTime = 0
            reciprocalTime = dateBetween.hour
            reciprocalUnit  = "小時"
            
            // hour
            if reciprocalTime <= 0 {
                reciprocalTime = 0
                reciprocalTime = dateBetween.minute
                reciprocalUnit  = "分鐘"
                
                // minute
                if reciprocalTime <= 10 {
                    setGradientView(fromColor: UIColor.set(red: 201, green: 60, blue: 60).withAlphaComponent(0.94),
                                    toColor: UIColor.set(red: 163, green: 40, blue: 40).withAlphaComponent(0.94))
                    largeTitleStr = "請留意時間 以免過號"
                    
                    if reciprocalTime <= 0 {
                        reciprocalTime = 0
                        largeTitleStr = "以下為您專屬預約資訊"
                        
                        setGradientView(fromColor: UIColor.set(red: 101, green: 172, blue: 172).withAlphaComponent(0.94),
                                        toColor: UIColor.set(red: 29, green: 119, blue: 182).withAlphaComponent(0.94))
                    }
                } else {
                    largeTitleStr = "以下為您專屬預約資訊"
                }
            }
        }
        print("\(dateBetween.day)天", "\(dateBetween.hour)小時", "\(dateBetween.minute)分")
        
        timeLabel.attributedText = .setAttributedString(string: "\(visitDateHourStr):\(visitDateMinuteStr)", wordSpace: .onePNine)
        timeUnitsLabel.attributedText = .setAttributedString(string: reciprocalUnit, wordSpace: .onePNine)
        
        let formatStr = String(format: "%02ld", reciprocalTime)
        switch reciprocalTime {
        case 0:
            reciprocalDigatalLabel.attributedText = .setAttributedString(string: "\(formatStr)", wordSpace: .fivePZero)
            reciprocalDigatalLabel.textColor = .lightGray
        case 1 ... 9:
            reciprocalDigatalLabel.attributedText = .setDiffrentColorAttrStr(string: "\(formatStr)", wordSpace: .fivePZero, color: .lightGray, interval: reciprocalTime)
        default:
            reciprocalDigatalLabel.attributedText = .setAttributedString(string: "\(formatStr)", wordSpace: .fivePZero)
        }
        
    }
    
    // 漸層
    func setGradientView(fromColor: UIColor, toColor: UIColor) {
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        backgroundImageView.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func onCancelBtnClick(_ sender: Any) {
        if waitingNumber > 0 {
            originalDigitalNumber += 1
        }
        setUI()
    }
}
