//
//  ViewController.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/02/27.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
let collectionItemSize: CGFloat = 88

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    var setVideoURLView = MaskVideoURLView()
    var pic = UIImagePickerController()
    var sliderView: SliderView?
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        sliderView = SliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView!)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.pic.mediaTypes = [kUTTypeMovie as String]
            self.pic.allowsEditing = true
            self.pic.delegate = self
            self.present(self.pic, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if url != nil {
            setVideoURLView.setURL(url: url!, views: sliderView!)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String,
            mediaType == (kUTTypeMovie as String),

        let urls = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL else { return }
        url = urls
        sliderView!.aVPlayerModel.video(url: urls)
        
        dismiss(animated: true)
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

public extension UIImage {
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage! {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height),true,0.0)
        
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

