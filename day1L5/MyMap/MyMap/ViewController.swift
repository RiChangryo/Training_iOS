//
//  ViewController.swift
//  MyMap
//
//  Created by 短期学部 on 2018/11/27.
//  Copyright © 2018年 RiChangryo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController ,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる(1)
        textField.resignFirstResponder()
        
        //入力された文字を取り出す（2）
        if let serchKey = textField.text {
            
            //入力された文字をデバッグエリアに表示（３）
            print(serchKey)
            
            //CLGeocoderインスタンスを取得(5)
            let geocoder = CLGeocoder()
            
            //入力された文字から位置情報を取得(6)
            geocoder.geocodeAddressString(serchKey, completionHandler: { (placemarks,
                error) in
                
                //位置情報存在する場合は、unwrapPlacemarksに取り出す（７）
                if let unwrapPlacemarks = placemarks {
                    
                    //1件目の情報を取り出す（８）
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        //位置情報を取り出す（９）
                        if let location = firstPlacemark.location {
                            
                            //位置情報から緯度経度をtargetCoordinateに取り出す（１０）
                            let targetCoordinate = location.coordinate
                            
                            //緯度経度をデバッグエリアに表示（１１）
                            print(targetCoordinate)
                            
                            //MKPointAnnotationインスタンスを取得し、ピンを生成（１２）
                            let pin = MKPointAnnotation()
                            
                            //ピンの置く場所に緯度経度を設定（１３）
                            pin.coordinate = targetCoordinate
                            
                            //ピンのタイトルを設定(14)
                            pin.title = serchKey
                            
                            //ピンを地図に置く（１５）
                            self.dispMap.addAnnotation(pin)
                            
                            //緯度経度を中心にして半径５００mwの範囲を表示（１６）
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            })
        }
        
        //デフォルト動作を行うのでtrueを返す（4）
        return true
        
    }
}
