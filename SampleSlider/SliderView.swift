//
//  XibView.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/02/28.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

final class SliderView: UIView {

    @IBOutlet weak var labelSet: UILabel!
    @IBOutlet weak var slider: UISlider!
    private var currentValue = Float()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        slider.addTarget(self, action: #selector(onChange(change:)), for: .valueChanged)
       
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("SliderView", owner: self, options: nil)?.first as! UIView
        view.frame = UIScreen.main.bounds
        self.addSubview(view)
    }

    // Duration and origin
    @objc func onChange(change: UISlider) {

        slider.minimumValue = 0
        slider.maximumValue = Float(UIScreen.main.bounds.width - labelSet.frame.width)

        currentValue = Float(UIScreen.main.bounds.width - labelSet.frame.width) / Float(slider.maximumValue)

        let changeOrigin = currentValue * change.value
        labelSet.frame.origin.x = CGFloat(changeOrigin)

        let deviceSise = floor(CGFloat(changeOrigin) + labelSet.frame.width)
        labelSet.text = deviceSise.description
    }
}
