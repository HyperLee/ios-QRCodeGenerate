//
//  ViewController.swift
//  QRCodeGen
//
//  Created by noveltek on 2016/8/15.
//  Copyright © 2016年 noveltek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var qrcodeImage: CIImage!

    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func performButtonAction(_ sender: AnyObject) {
        if qrcodeImage == nil {
            if TextField.text == "" {
                return
            }
            
            let data = TextField.text!.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            //let data = TextField.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            /**
             *  @param "inputMessage" 
             *  inputMessage：這是要轉換成 QR Code 圖片的初始資料。事實上，此參數必須是 NSData 物件，所以請確定你所使用的字串或其他物件都已轉換成這種資料類型。
             */
            
            filter!.setValue(data, forKey: "inputMessage")
            
            /**
             *  @param "inputCorrectionLevel" 
             *  inputCorrectionLevel：這裡表示有多少額外的錯誤更正資料要被附加到輸出的 QR Code 圖片中。其數值是 4 種字串之一： L 、 M 、 Q 、 H ，分別對應到不同的錯誤復原能力，依序為 7% 、 15% 、 25% 、 30%
             *  數值越大，輸出的 QR Code 圖片也就越大。
             */
            
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            /**
             *  Hidden keyboard
             *
             *  @param TextField.text 透過呼叫文字欄位的 resignFirstResponder() 來隱藏鍵盤。
             */
            TextField.resignFirstResponder()
            
            
            // input Text
            print("\(TextField.text)")
//            NSLog("Text = %@", TextField)

            
            Button.setTitle("Clear", for: UIControlState())
            NSLog("Button Generate", Button)
            
            displayQRCodeImage()
        }
        else {
            ImageView.image = nil
            qrcodeImage = nil
            Button.setTitle("Generate", for: UIControlState())
            NSLog("Button Clear", Button)
        }
        
        TextField.isEnabled = !TextField.isEnabled
        Slider.isHidden = !Slider.isHidden
    }
    
    @IBAction func changeImageViewScale(_ sender: AnyObject) {
        ImageView.transform = CGAffineTransform(scaleX: CGFloat(Slider.value), y: CGFloat(Slider.value))
    }
    
    
    // MARK: Custom method implementation
    
    func displayQRCodeImage() {
        let scaleX = ImageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = ImageView.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        ImageView.image = UIImage(ciImage: transformedImage)
    }

}

