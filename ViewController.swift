//
//  ViewController.swift
//  二维码扫描和生成
//
//  Created by yuanshi on 2017/3/27.
//  Copyright © 2017年 moviewisdom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    
    private var imgView: UIImageView?
    
    private let scanner = QRCodeScannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))

        scanner.readQRCodeFinishClosure = { string in
            WQAlertManager.sharedInstance.showAlert(targetVC: self, title: nil, message: string, style: .alert, confirmTitle: "确认", cancelTitle: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 二维码扫描
    @IBAction func readQRCode(_ sender: Any) {
        
        self.present(scanner, animated: true, completion: nil)
    }
    
    // 生成二维码
    @IBAction func produceQRCode(_ sender: Any) {
        
        let qrManager = QRCodeManager()
        let qrImg = qrManager.generateQRCodeImage(info: textField.text ?? "https://www.moviewisdom.cn", size: CGSize.init(width: 300, height: 400))
        imgView?.removeFromSuperview()
        imgView = UIImageView.init(image: qrImg)
        view.addSubview(imgView!)
        imgView?.frame = CGRect.init(x: 10, y: 250, width: 300, height: 300)
    }
    
    // 生成条形码
    @IBAction func barCode() {
        let qrManager = QRCodeManager()
        let qrImg = qrManager.barCodeImage(barCodeStr: "199106071936", barCodeSize: CGSize.init(width: 200, height: 200))
        imgView?.removeFromSuperview()
        imgView = UIImageView.init(image: qrImg)
        view.addSubview(imgView!)
        imgView?.frame = CGRect.init(x: 10, y: 250, width: 300, height: 300)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            textField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    @IBAction func fromPictures(_ sender: UIButton) {
        
        scanner.selectPhotoFormPhotoLibrary(sender)
    }
}

