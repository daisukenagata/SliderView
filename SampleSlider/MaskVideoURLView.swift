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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 44, y: 44, width: 44, height: 44)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setURL(url: URL, views: SliderView) {
        self.duration = MaskVideoURLView().videoDuration(videoURL: url)
        self.videoURL = url
        self.updateThumbnails(views: views)
    }
    
    private func updateThumbnails(views: SliderView) {
        
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        backgroundQueue.async { _ = self.updateThumbnails(view: views, videoURL: self.videoURL, duration: self.duration) }
    }
    
    private func thumbnailCount(inView: SliderView) -> Int {
        var num :Double = 0
        DispatchQueue.main.sync { num = Double(UIScreen.main.bounds.width) / Double(44) }
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
    
    private func updateThumbnails(view: SliderView, videoURL: URL, duration: Float64) -> [UIImageView] {
        var thumbnails = [UIImage]()
        var offset: Float64 = 0
        
        for view in self.thumbnailViews{
            DispatchQueue.main.sync { view.removeFromSuperview() }
        }
        
        let imagesCount = self.thumbnailCount(inView: view)
        for i in 0..<imagesCount{
            DispatchQueue.main.sync {
                let thumbnail = thumbnailFromVideo(videoUrl: videoURL,
                                                   time: CMTimeMake(value: Int64(offset), timescale: 1))
                offset = Float64(i) * (duration / Float64(imagesCount))
                thumbnails.append(thumbnail)
            }
        }
        self.addImagesToView(images: thumbnails, view: view)
        return self.thumbnailViews
    }
    
    private func videoDuration(videoURL: URL) -> Float64 {
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }
    
    private func addImagesToView(images: [UIImage], view: SliderView) {
        var xPos: CGFloat = 44
        var i = 0
        DispatchQueue.main.async {
            for image in images{
                self.imageView.image = image
                self.imageView.clipsToBounds = true
                self.imageView.frame = CGRect(x: xPos,
                                         y: 44,
                                         width: 44,
                                         height: 44)
                
                self.thumbnailViews.append(self.imageView)
                view.sendSubviewToBack(self.thumbnailViews[i])
                i += 1
                xPos += 24
            }
        }
    }
}


extension CGImage {
    func resize(_ image: CGImage) -> CGImage? {
        let maxWidth: CGFloat = CGFloat(UIScreen.main.bounds.width)
        let maxHeight: CGFloat = CGFloat(UIScreen.main.bounds.height)

        guard let colorSpace = image.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(maxWidth), height: Int(maxHeight), bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: colorSpace, bitmapInfo: image.alphaInfo.rawValue) else { return nil }

        context.interpolationQuality = .high
        context.draw(image, in: CGRect(x: 0, y: 0, width: Int(maxWidth), height: Int(maxHeight)))

        return context.makeImage()
    }
}
