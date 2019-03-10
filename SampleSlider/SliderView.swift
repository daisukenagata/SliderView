//
//  SliderView.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/02/28.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

final class SliderView: UIView {

    @IBOutlet weak var thumnaiIImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private var currentValue = Float()

    var aVPlayerModel = AVPlayerModel()

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

        let nowTime = aVPlayerModel.videoTime()
        timeLabel.text = nowTime.description

        let currentTime = aVPlayerModel.videoCurrentTime()
        aVPlayerModel.videoSeek(change: change.value)
        durationLabel.text = currentTime.description

        slider.minimumValue = 0
        slider.maximumValue = Float(currentTime)

        let currentValue = Float(UIScreen.main.bounds.width - thumnaiIImageView.frame.width) / Float(currentTime)
        let changeOrigin = currentValue * change.value

        thumnaiIImageView.frame.origin.x = CGFloat(changeOrigin)
        thumnaiIImageView.image = aVPlayerModel.videoImageViews(nowTime: nowTime)
    }
}
