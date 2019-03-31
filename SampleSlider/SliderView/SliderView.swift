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

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trimButton: UIButton!
    @IBOutlet weak var thumnaiIImageView: UIImageView!

    private var nowTime = CGFloat()
    private var currentValue = Float()
    private var keyValueObservations = [NSKeyValueObservation]()
    private var mutableComposition = MutableComposition()

    private var startValue: Float?
    private var endValue: Float?

    var url: URL?
    var vc: ViewController?
    var cALayerView = CALayerLogic()
    var lineDashView = LineDashView()
    var gestureObject = GestureObject()
    var aVPlayerModel = AVPlayerModel()
    var touchFlag = TouchFlag.touchSideLeft

    // Example
    let vcs = UIView()


    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
        slider.addTarget(self, action: #selector(onChange(change:)), for: .valueChanged)
        trimButton.addTarget(self, action: #selector(trimBt), for: .touchUpInside)

        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self
        self.addGestureRecognizer(CommonStructure.swipePanGesture)

        // Example
        vcs.frame = CGRect(x: 0, y: 100, width: self.frame.width, height: 100)
        vcs.layer.addSublayer(cALayerView.hollowTargetLayer)
        vcs.addSubview(lineDashView)

        lineDashView.isHidden = true

        cALayerView.tori(views: lineDashView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    func loadNib() {
        self.frame = UIScreen.main.bounds
        let view = Bundle.main.loadNibNamed("SliderView", owner: self, options: nil)?.first as! UIView
        view.frame = UIScreen.main.bounds
        self.addSubview(view)
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: self)

        if lineDashView.isHidden == true { self.addSubview(vcs) }
        // Slider
        let value = Float64(position.x) * (self.aVPlayerModel.videoDurationTime() / Float64(self.frame.width))
        DispatchQueue.main.async {
            self.lineDashView.isHidden = false
            //Gesture
            self.gestureObject.endPoint = self.lineDashView.frame.origin
            self.gestureObject.endFrame = self.lineDashView.frame
            self.touchFlag = self.gestureObject.cropEdgeForPoint(point: position, views: self.vcs)
            self.gestureObject.updatePoint(point: position, views: self.lineDashView, touchFlag: self.touchFlag)
            // Layer
            self.cALayerView.tori(views: self.lineDashView)
            self.slider.value = Float(value)
            self.ges(value: Float(value))
        }
        switch sender.state {
        case .ended:
            switch self.touchFlag {
            case .touchSideRight:
                self.endValue = Float(value)
                break
            case .touchSideLeft:
                self.startValue = Float(value)
                break
            }
            break
        case .possible:
            break
        case .began:
            break
        case .changed:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }

    @objc func trimBt() {
        guard let urs = url, let startValue = startValue, let endValue = endValue else { return }
        let avAsset = AVAsset(url: urs)
        let timeSet = endValue - startValue
        let startTime = CMTime(seconds: Float64(startValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let endTime = CMTime(seconds: Float64(timeSet), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        mutableComposition.aVAssetMerge(startAVAsset: avAsset, startDuration: startTime, endDuration: endTime)
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
