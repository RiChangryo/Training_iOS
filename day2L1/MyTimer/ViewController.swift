//
//  ViewController.swift
//  MyTimer
//
//  Created by 短期学部 on 2018/11/28.
//  Copyright © 2018年 RiChangryo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //タイマーの変数を作成
    var timer : Timer?
    
    //カウント（経過時間）の変数を作成
    var count = 0
    
    //変数を扱うキーを設定
    let settingKey = "timer_value"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Userfaultsのインスタンスを作成
        let settings = UserDefaults.standard
        
        //UserDaefaultsに初期値を登録
        settings.register(defaults: [settingKey:10])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                //タイマー停止
                nowTimer.invalidate()
            }
        }
        
        //画面遷移を行う
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        
        //タイマーをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが実行中だったらスタートしない
            if nowTimer.isValid == true {
                //何も処理しない
                return
            }
        }
        
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerInterrupt(_timer:)), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func stopButtonAction(_ sender: Any) {
        //タイマーをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                //タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    //画面の更新をする(戻り値：remainCount:残り時間)
    func displayUpdate() -> Int {
        
        //UserDefaultのインスタンスを作成
        let settings = UserDefaults.standard
        
        //取得した秒数をtimerValueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        
        //残り時間（remainCount)を生成
        let remainCount = timerValue - count
        
        //remainCount(残りの時間)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        
        //残り時間を戻り値に設定
        return remainCount
        
    }
    
    //経過時間の処理
    @objc func timerInterrupt(_timer:Timer) {
        //count（経過時間）に＋１していく
        count += 1
        //remainCount(残り時間）が０以下の時タイマーを止める
        if displayUpdate() <= 0 {
            //初期化処理
            count = 0
            //タイマー停止
            timer?.invalidate()
            
            //カスタマイズ編：ダイアログを作成
            let alertController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
            //ダイアログに表示させるOKボタンを作成
            let defaultaction = UIAlertAction(title: "OK", style: .default, handler: nil)
            //アクションを追加
            alertController.addAction(defaultaction)
            //ダイアログの表示
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //画面切り替えのタイミングで処理を行う
    override func viewDidAppear(_ animated: Bool) {
        //カウント（経過時間）をゼロにする
        count = 0
        //タイマーの表示を更新する
        _ = displayUpdate()
    }
}

