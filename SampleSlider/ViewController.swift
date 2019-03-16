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

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var setVideoModel = MaskVideoModel()
    var sliderView: SliderView?
    var url: URL?


    override func viewDidLoad() {
        super.viewDidLoad()

        sliderView = SliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView!)

        let imagePickerModel = ImagePickerModel()
        imagePickerModel.mediaSegue(vc: self, bool: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if url != nil {
            sliderView!.aVPlayerModel.video(url: url!)
            setVideoModel.setURL(url: url!,sliderView: sliderView!, heightY: 100, height: 44)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String,
            mediaType == (kUTTypeMovie as String),

            let urls = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL else { return }
        url = urls
        dismiss(animated: true)
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
