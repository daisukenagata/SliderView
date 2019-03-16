//
//  SliderView.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/02/28.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

struct CommonStructure {
    static var panGesture = UIPanGestureRecognizer()
}

final class SliderView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet weak var thumnaiIImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    var aVPlayerModel = AVPlayerModel()
    private var currentValue = Float()
    private var nowTime = CGFloat()
    private var currentTime = Float64()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
        slider.addTarget(self, action: #selector(onChange(change:)), for: .valueChanged)
        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        self.addGestureRecognizer(CommonStructure.panGesture)
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

    @objc func panTapped(sender: UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: self)
        let nowTime = aVPlayerModel.currentTime()

        switch sender.state {
        case .ended:
            break
        case .possible:
            break
        case .began:
            currentTime = aVPlayerModel.videoDurationTime()
            slider.minimumValue = 0
            slider.maximumValue = Float(currentTime)
            break
        case .changed:
            let value = Float64(position.x) * (aVPlayerModel.videoDurationTime() / Float64(self.frame.width))

            slider.value = Float(value)
            timeLabel.text = nowTime.description
            aVPlayerModel.videoSeek(change: Float(value))

            let currentValue = Float(UIScreen.main.bounds.width - thumnaiIImageView.frame.width) / Float(currentTime)
            let changeOrigin = currentValue * Float(value)

            thumnaiIImageView.frame.origin.x = CGFloat(changeOrigin)
            thumnaiIImageView.image = aVPlayerModel.videoImageViews(nowTime: nowTime)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

    // Duration and origin
    @objc func onChange(change: UISlider) {

        let nowTime = aVPlayerModel.currentTime()
        timeLabel.text = nowTime.description

        let currentTime = aVPlayerModel.videoDurationTime()
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
