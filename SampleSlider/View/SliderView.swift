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

        switch sender.state {
        case .ended:
            break
        case .possible:
            break
        case .began:
            currentModel()
            break
        case .changed:
            let value = Float64(position.x) * (aVPlayerModel.videoDurationTime() / Float64(self.frame.width))
            slider.value = Float(value)
            ges(value: Float(value))
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

    // Duration and origin
    @objc func onChange(change: UISlider) { ges(value: change.value) }
    
    func currentModel() {
        let currentTime = aVPlayerModel.videoDurationTime()
        slider.minimumValue = 0
        slider.maximumValue = Float(currentTime)
    }

    func  ges(value: Float) {

        aVPlayerModel.videoSeek(change: value)

        let nowTime = aVPlayerModel.currentTime()
        timeLabel.text = nowTime.description
        
        let currentTime = aVPlayerModel.videoDurationTime()
        durationLabel.text = currentTime.description

        let currentValue = Float(UIScreen.main.bounds.width - thumnaiIImageView.frame.width) / Float(currentTime)
        let changeOrigin = currentValue * Float(value)
        aVPlayerModel.videoSeek(change: Float(value))

        thumnaiIImageView.frame.origin.x = CGFloat(changeOrigin)
        thumnaiIImageView.image = aVPlayerModel.videoImageViews(nowTime: nowTime)
    }
}
