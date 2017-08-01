//
//  QRCodeManager.swift
//  二维码扫描和生成
//
//  Created by yuanshi on 2017/3/28.
//  Copyright © 2017年 moviewisdom. All rights reserved.
//

import UIKit

class QRCodeManager: NSObject {
    
    /// 创建二维码
    func generateQRCodeImage(info: String, size: CGSize) -> UIImage {
        
        // 1. 生成二维码
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setDefaults()
        qrFilter.setValue(info.data(using: String.Encoding.utf8), forKey: "inputMessage")
        let ciImage = qrFilter.outputImage
        
        // 2. 缩放处理
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.applying(transform)
        
        // 3. 颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(transformImage, forKey: "inputImage")
        // 前景色
        colorFilter.setValue(CIColor(color: UIColor.black), forKey: "inputColor0")
        // 背景色
        colorFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor1")
        
        let outputImage = colorFilter.outputImage
        
        return insertAvatarImage(qrimage: UIImage(ciImage: outputImage!), avatar: UIImage(named: "zhanwei")!)
    }
    
    /// 创建条形码
    func barCodeImage(barCodeStr:String,barCodeSize:CGSize) -> UIImage {
        //将传入的string转成nsstring，再编码
        let stringData = barCodeStr.data(using: String.Encoding.utf8)
        
        
        // 系统自带能生成的码
        // CIAztecCodeGenerator 二维码
        // CICode128BarcodeGenerator 条形码
        // CIPDF417BarcodeGenerator
        // CIQRCodeGenerator     二维码
        let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
        qrFilter?.setDefaults()
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        
        let outputImage:CIImage? = qrFilter?.outputImage
        
        /*
         生成的条形码需要对其进行消除模糊处理，本文提供两种方法消除模糊，其原理都是放大条码，但项目中需要在条码底部加上条码内容文字，使用其方法一会模糊并变小文字，所以使用方法二，需要各位去研究下原因哈。。。
        */
        
        // 消除模糊方法一
        //        let context = CIContext()
        //        let cgImage = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
        
        //        let image = UIImage(CGImage: cgImage, scale: 1.0, orientation: UIImageOrientation.Up)
        //
        //        // Resize without interpolating
        //        let scaleRate:CGFloat = 20.0
        //        let resized = resizeImage(addText(image), quality: CGInterpolationQuality.None, rate: scaleRate)
        
        // 消除模糊方法二
        let scaleX:CGFloat = barCodeSize.width/outputImage!.extent.size.width; // extent 返回图片的frame
        let scaleY:CGFloat = barCodeSize.height/outputImage!.extent.size.height;
        let resultImage = outputImage?.applying(CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY))
        let image = UIImage.init(ciImage: resultImage!)
        
        return addText(image: image,textName: barCodeStr);
    }
    
    //添加条形码下方文字
    func addText(image:UIImage,textName:String) ->UIImage{
        let size = CGSize.init(width: image.size.width, height: image.size.height+30)
        
        UIGraphicsBeginImageContextWithOptions (size, false , 0.0 );
        
        image.draw(at: CGPoint.zero)
        
        // 获得一个位图图形上下文
        
        let context = UIGraphicsGetCurrentContext ();
        
        context!.drawPath (using: .stroke );
        //绘制文字
        let barText:NSString = textName as NSString
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.alignment = .center
        
        barText.draw(in: CGRect.init(x: 0, y: image.size.height-4, width: size.width, height: 30), withAttributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18.0),NSBackgroundColorAttributeName:UIColor.clear,NSParagraphStyleAttributeName:textStyle])
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    func insertAvatarImage(qrimage: UIImage, avatar: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(qrimage.size)
        
        let rect = CGRect(origin: CGPoint.zero, size: qrimage.size)
        qrimage.draw(in: rect)
        
        let w = rect.width * 0.2
        let x = (rect.width - w) * 0.5
        let y = (rect.height - w) * 0.5
        avatar.draw(in: CGRect(x: x, y: y, width: w, height: w))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
