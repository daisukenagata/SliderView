//
//  ViewController.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/02/27.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sliderView = SliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width
            , height: view.frame.height))
        view.addSubview(sliderView)
    }
}
