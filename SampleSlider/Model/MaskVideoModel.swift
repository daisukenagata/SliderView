//
//  MaskVideoURLView.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/03/11.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

public class MaskVideoModel {

    private var videoURL  = URL(fileURLWithPath: "")
    private var thumbnailViews = [UIImageView]()
    private var duration: Float64   = 0.0
    private var heightY = CGFloat()
    private var height = CGFloat()


    func setURL(url: URL,sliderView: UIView ,heightY: CGFloat ,height: CGFloat ) {
        self.heightY = heightY
        self.height = height
        self.duration = videoDuration(videoURL: url)
        self.videoURL = url
        self.updateThumbnails(sliderView: sliderView)
    }

    private func videoDuration(videoURL: URL) -> Float64 {
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }

    private func updateThumbnails(sliderView: UIView) {

        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        backgroundQueue.async { _ = self.updateThumbnails(sliderView: sliderView, videoURL: self.videoURL, duration: self.duration) }
    }

    private func updateThumbnails(sliderView: UIView, videoURL: URL, duration: Float64) -> [UIImageView] {
        var thumbnails = [UIImage]()

        for view in self.thumbnailViews {
            DispatchQueue.main.sync { view.removeFromSuperview() }
        }

        for i in 0...Int(ceil(duration)) {
            DispatchQueue.main.sync {
                let thumbnail = thumbnailFromVideo(videoUrl: videoURL,
                                                   time: CMTimeMake(value: Int64(i), timescale: 1))
                thumbnails.append(thumbnail)
            }
        }
        self.addImagesToView(images: thumbnails, sliderView: sliderView)
        return self.thumbnailViews
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

    private func addImagesToView(images: [UIImage], sliderView: UIView) {

        DispatchQueue.main.sync {
            thumbnailViews.removeAll()
            var xPos: CGFloat = 0.0
            var count: Int = 0

            let width = Double(sliderView.frame.size.width) / (ceil(duration) + 1)
            for image in images {
                let imageViews = UIImageView()
                imageViews.image = image

                imageViews.clipsToBounds = true
                imageViews.frame = CGRect(x: xPos,
                                          y: heightY,
                                          width: CGFloat(width),
                                          height: height)
                thumbnailViews.append(imageViews)
                sliderView.addSubview(thumbnailViews[count])
                count += 1
                xPos += CGFloat(width)
            }
        }
    }
}
