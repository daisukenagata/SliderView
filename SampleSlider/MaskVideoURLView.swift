//
//  MaskVideoURLView.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/03/11.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

public class MaskVideoURLView: UIView {
    
    var duration: Float64   = 0.0
    var videoURL  = URL(fileURLWithPath: "")
    public let imageView = UIImageView()
    public var thumbnailViews = [UIImageView]()
    public var views = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 44)
        views.frame = self.frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setURL(url: URL,sliderView: SliderView) {
        self.duration = MaskVideoURLView().videoDuration(videoURL: url)
        self.videoURL = url
        self.updateThumbnails(sliderView: sliderView)
    }
    
    private func updateThumbnails(sliderView: SliderView){
        
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        backgroundQueue.async { _ = self.updateThumbnails(sliderView: sliderView, videoURL: self.videoURL, duration: self.duration) }
    }
    
    private func thumbnailCount(inView: SliderView) -> Int {
        var num :Double = 0
        
        DispatchQueue.main.sync { num = Double(inView.frame.size.width) / Double(44) }
        return Int(ceil(num))
    }
    
    private func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage {
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do{
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch { print("error") }
        
        return UIImage()
    }
    
    private func updateThumbnails(sliderView: SliderView, videoURL: URL, duration: Float64) -> [UIImageView] {
        var thumbnails = [UIImage]()
        var offset: Float64 = 0
        
        for view in self.thumbnailViews{
            DispatchQueue.main.sync { view.removeFromSuperview() }
        }
        
        let imagesCount = self.thumbnailCount(inView: sliderView)
        for i in 0..<imagesCount{
            DispatchQueue.main.sync {
                let thumbnail = thumbnailFromVideo(videoUrl: videoURL,
                                                   time: CMTimeMake(value: Int64(offset), timescale: 1))
                offset = Float64(i) * (duration / Float64(imagesCount))
                thumbnails.append(thumbnail)
            }
        }
        self.addImagesToView(images: thumbnails, sliderView: sliderView)
        return self.thumbnailViews
    }
    
    private func videoDuration(videoURL: URL) -> Float64 {
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }
    
    private func addImagesToView(images: [UIImage], sliderView: SliderView) {

        thumbnailViews.removeAll()
        var xPos: CGFloat = 0.0
        var count: Int = 0
        for image in images{
            DispatchQueue.main.sync {
                let imageViews = UIImageView()
                imageViews.image = image

                imageViews.clipsToBounds = true
                imageViews.frame = CGRect(x: xPos,
                                         y: 100,
                                         width: 44,
                                         height: 44)
                thumbnailViews.append(imageViews)
                sliderView.addSubview(thumbnailViews[count])
                count += 1
                xPos += 44
            }
        }
    }
}
