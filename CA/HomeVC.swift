//
//  ViewController.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func nextPageClick(_ sender: Any) {
        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") {
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}

