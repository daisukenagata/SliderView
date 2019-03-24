//
//  SliderView.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/02/28.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

struct CommonStructure { static var swipePanGesture = UIPanGestureRecognizer() }

final class SliderView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet weak var thumnaiIImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private var keyValueObservations = [NSKeyValueObservation]()
    private var currentValue = Float()
    private var nowTime = CGFloat()

    var aVPlayerModel = AVPlayerModel()
    var cALayerView = CALayerLogic()
    var lineDashView = LineDashView()
    var gestureObject = GestureObject()
    var touchFlag = TouchFlag.touchSideLeft

    // Example
    let vcs = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
        slider.addTarget(self, action: #selector(onChange(change:)), for: .valueChanged)
        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self
        self.addGestureRecognizer(CommonStructure.swipePanGesture)

        self.frame = UIScreen.main.bounds
 
        // レイヤーのマスキング
        cALayerView.tori(views: lineDashView)
        
        vcs.layer.addSublayer(cALayerView.hollowTargetLayer)
        vcs.addSubview(lineDashView)
        lineDashView.isHidden = true
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

    func addView() {
        self.addSubview(vcs)
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: self)
        //指が離れた際の座標を取得
        DispatchQueue.main.async {
            self.lineDashView.isHidden = false
            //Gesture
            self.gestureObject.endPoint = self.lineDashView.frame.origin
            self.gestureObject.endFrame = self.lineDashView.frame
            self.touchFlag = self.gestureObject.cropEdgeForPoint(point: self.gestureObject.framePoint, views: self.vcs)
            self.gestureObject.updatePoint(point: position,views: self.lineDashView,touchFlag: self.touchFlag)
            // Layer
            self.cALayerView.tori(views: self.lineDashView)
            // Slider
            let value = Float64(position.x) * (self.aVPlayerModel.videoDurationTime() / Float64(self.frame.width))
            self.slider.value = Float(value)
            self.ges(value: Float(value))
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: self)
        gestureObject.framePoint = position
        return true
    }

    // Duration and origin
    @objc func onChange(change: UISlider) { ges(value: change.value) }

    func ges(value: Float) {

        let currentTime = aVPlayerModel.videoDurationTime()
        slider.minimumValue = 0
        slider.maximumValue = Float(currentTime)

        aVPlayerModel.videoSeek(change: value)

        let nowTime = aVPlayerModel.currentTime()
        timeLabel.text = nowTime.description
        
        durationLabel.text = currentTime.description

        let currentValue = Float(UIScreen.main.bounds.width - thumnaiIImageView.frame.width) / Float(currentTime)
        let changeOrigin = currentValue * Float(value)
        aVPlayerModel.videoSeek(change: Float(value))

        thumnaiIImageView.frame.origin.x = CGFloat(changeOrigin)
        thumnaiIImageView.image = aVPlayerModel.videoImageViews(nowTime: nowTime)
    }
}
