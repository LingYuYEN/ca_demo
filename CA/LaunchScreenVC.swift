//
//  LaunchScreenVC.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class LaunchScreenVC: UIViewController {

    @IBOutlet var launchScreenTitleLabel: UILabel!
    @IBOutlet var poweredByLabel: UILabel!
    @IBOutlet var conquerLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var versionNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 0
            }) { (finish) in
                if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") {
                    homeVC.modalPresentationStyle = .overFullScreen
                    self.present(homeVC, animated: false, completion: nil)
                }
            }
            
        }
        
        setUI()
    }
    
    func setUI() {
        launchScreenTitleLabel.attributedText = .setAttributedString(string: "診所預約通知系統", wordSpace: .fourPSixEight)
        poweredByLabel.attributedText = .setAttributedString(string: "POWERED  BY", wordSpace: .onePFive)
        versionLabel.attributedText = .setAttributedString(string: "VERSION", wordSpace: .onePFive)
        
        conquerLabel.attributedText = .setAttributedString(string: "CONQUER", wordSpace: .onePEightThree)
        versionNumberLabel.attributedText = .setAttributedString(string: "7.3.0", wordSpace: .onePEightThree)
    }

}
