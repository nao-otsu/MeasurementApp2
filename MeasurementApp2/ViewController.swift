//
//  ViewController.swift
//  MeasurementApp2
//
//  Created by 夏山聡史 on 2017/11/29.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var underButton: UIButton!
    
    let cmManager = CMMotionManager()
    
    //buttonのフラグ
    var flag: Bool = true
    
    //加速度データ用変数
    
    
    //加速度のデータ
    var acceleData:String = ""
    
    //加速度平均値
    var aveAcceleX: Double = 0.0
    var aveAcceleY: Double = 0.0
    
    //書き出し用ファイル名
    let AcceletoString:String = "AcceletoString.csv"
//    let rightAccele:String = "rightAccele.csv"
//    let leftAccele:String = "leftAccele.csv"
//    let underAccele:String = "underAccele.csv"
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calibration()
        
        //ファイル作成
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let file_topurl = url.appendingPathComponent(AcceletoString)
            do {
                try "Top,Right,Under,Left,TimeStamp\n".write(to: file_topurl, atomically: false, encoding: String.Encoding.utf8)
                
            }catch let error as NSError {
                print(error)
            }
//            let file_righturl = url.appendingPathComponent(rightAccele)
//            do {
//                try "X,Y,TimeStamp\n".write(to: file_righturl, atomically: false, encoding: String.Encoding.utf8)
//                
//            }catch let error as NSError {
//                print(error)
//            }
//
//            let file_lefturl = url.appendingPathComponent(leftAccele)
//            do {
//                try "X,Y,TimeStamp\n".write(to: file_lefturl, atomically: false, encoding: String.Encoding.utf8)
//                
//            }catch let error as NSError {
//                print(error)
//            }
//
//            let file_underurl = url.appendingPathComponent(underAccele)
//            do {
//                try "X,Y,TimeStamp\n".write(to: file_underurl, atomically: false, encoding: String.Encoding.utf8)
//                
//            }catch let error as NSError {
//                print(error)
//            }

        }
    }
    
    func calibration() {
        //ボタン操作off
        topButton.isEnabled = false
        rightButton.isEnabled = false
        leftButton.isEnabled = false
        underButton.isEnabled = false

        var sumX: Double = 0.0
        var sumY: Double = 0.0
        var count: Int = 0
    
        cmManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            let motionData = data!
            if count < 1000 {
                sumX = sumX + motionData.acceleration.x
                sumY = sumY + motionData.acceleration.y
                count = count + 1
//                print(9.80665 * motionData.acceleration.x)
//                print(9.80665 * motionData.acceleration.y)
            }else{
                self.cmManager.stopAccelerometerUpdates()
                self.aveAcceleX = -9.80665 * sumX / Double(count + 1)
                self.aveAcceleY = -9.80665 * sumY / Double(count + 1)
                
                //ボタン操作on
                self.topButton.isEnabled = true
                self.rightButton.isEnabled = true
                self.leftButton.isEnabled = true
                self.underButton.isEnabled = true
            }
        }
    }
    
    //↑ボタン
    @IBAction func TouchTopButton(_ sender: Any) {
        if flag == true{
            flag = false
            rightButton.isEnabled = false
            leftButton.isEnabled = false
            underButton.isEnabled = false
            cmManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                let motionData = data!
                self.acceleData += String(-9.80665 * motionData.acceleration.y - self.aveAcceleY) + ",0,0,0," + String(motionData.timestamp) + "\n"
            }
        } else {
            flag = true
            rightButton.isEnabled = true
            leftButton.isEnabled = true
            underButton.isEnabled = true
            cmManager.stopAccelerometerUpdates()
            if let url = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first{
                let file_url = url.appendingPathComponent(AcceletoString)
                //ファイルの存在確認
                //if FileManager.default.fileExists(atPath: file_url.path){
                    do {
                        let fileHnadle = try FileHandle(forWritingTo: file_url)
                        fileHnadle.seekToEndOfFile()
                        fileHnadle.write(self.acceleData.data(using: String.Encoding.utf8)!)
                        self.acceleData = ""
                        print("追記")
                    }catch let error as NSError{
                        print(error)
                    }
//                } else {
//                    do{
//                        try self.acceleData.write(to: file_url, atomically: true, encoding: String.Encoding.utf8)
//                        print("初書き込み")
//                    }catch let error as NSError{
//                        print("書き込み失敗?")
//                        print(error)
//                    }
//                }
            }
            print("stop")
        }
    }
   
    //→ボタン
    @IBAction func TouchRightButton(_ sender: Any) {
        if flag == true{
            flag = false
            topButton.isEnabled = false
            leftButton.isEnabled = false
            underButton.isEnabled = false
            cmManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                let motionData = data!
                self.acceleData += "0," + String(-9.80665 * motionData.acceleration.x  - self.aveAcceleX) + ",0,0," + String(motionData.timestamp) + "\n"
            }
        } else {
            flag = true
            topButton.isEnabled = true
            leftButton.isEnabled = true
            underButton.isEnabled = true
            cmManager.stopAccelerometerUpdates()
            if let url = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first{
                let file_url = url.appendingPathComponent(AcceletoString)
                do {
                    let fileHnadle = try FileHandle(forWritingTo: file_url)
                    fileHnadle.seekToEndOfFile()
                    fileHnadle.write(self.acceleData.data(using: String.Encoding.utf8)!)
                    self.acceleData = ""
                    print("追記")
                }catch let error as NSError{
                    print(error)
                }
            }
            print("stop")
        }

    }
    
    
    //←ボタン
    @IBAction func TouchLeftButton(_ sender: Any) {
        if flag == true{
            flag = false
            rightButton.isEnabled = false
            topButton.isEnabled = false
            underButton.isEnabled = false
            cmManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                let motionData = data!
                self.acceleData += "0,0,0," + String(-9.80665 * motionData.acceleration.x - self.aveAcceleX) + "," + String(motionData.timestamp) + "\n"
            }
        } else {
            flag = true
            rightButton.isEnabled = true
            topButton.isEnabled = true
            underButton.isEnabled = true
            cmManager.stopAccelerometerUpdates()
            if let url = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first{
                let file_url = url.appendingPathComponent(AcceletoString)
                do {
                    let fileHnadle = try FileHandle(forWritingTo: file_url)
                    fileHnadle.seekToEndOfFile()
                    fileHnadle.write(self.acceleData.data(using: String.Encoding.utf8)!)
                    self.acceleData = ""
                    print("追記")
                }catch let error as NSError{
                    print(error)
                }
            }
            print("stop")
        }

    }

    
    //↓ボタン
    @IBAction func TouchUnderButton(_ sender: Any) {
        if flag == true{
            flag = false
            rightButton.isEnabled = false
            leftButton.isEnabled = false
            topButton.isEnabled = false
            cmManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                let motionData = data!
                self.acceleData += "0,0," + String(-9.80665 * motionData.acceleration.y - self.aveAcceleY) + ",0," + String(motionData.timestamp) + "\n"
            }
        } else {
            flag = true
            rightButton.isEnabled = true
            leftButton.isEnabled = true
            topButton.isEnabled = true
            cmManager.stopAccelerometerUpdates()
            if let url = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first{
                let file_url = url.appendingPathComponent(AcceletoString)
                do {
                    let fileHnadle = try FileHandle(forWritingTo: file_url)
                    fileHnadle.seekToEndOfFile()
                    fileHnadle.write(self.acceleData.data(using: String.Encoding.utf8)!)
                    self.acceleData = ""
                    print("追記")
                }catch let error as NSError{
                    print(error)
                }
            }
            print("stop")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

