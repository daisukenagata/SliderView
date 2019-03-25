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

final class ViewController: PickerViewController {

    var setVideoModel = MaskVideoModel()
    var sliderView: SliderView?

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
            guard let views = sliderView else  { return }
            setVideoModel.setURL(url: url!,sliderView: views, heightY: 100, height: 100)
        }
    }
}
