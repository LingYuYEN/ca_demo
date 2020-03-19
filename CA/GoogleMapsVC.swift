//
//  GoogleMapsVC.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/19.
//  Copyright © 2020 顏淩育. All rights reserved.
//
//  地址暫為：高雄市左營區博愛五路  235 號 （22.6885991,120.3172083）
import UIKit
import GoogleMaps

class GoogleMapsVC: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: 22.6885991, longitude: 120.3172083, zoom: 15)
        mapView.camera = camera
        setMark()
    }


    func setMark() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 22.6885991, longitude: 120.3172083)
        marker.map = mapView
        marker.title = "美好診所"
        marker.snippet = "高雄市"
    }

}
