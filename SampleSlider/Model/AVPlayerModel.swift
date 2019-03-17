//
//  AVPlayerModel.swift
//  SampleSlider
//
//  Created by 永田大祐 on 2019/03/10.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

final class AVPlayerModel {

    var playerItem: AVPlayerItem?
    var videoPlayer: AVPlayer!
    var urls: URL?


    func video(url: URL) {
        urls = url
        let avAsset = AVURLAsset(url: url, options: nil)
        playerItem = AVPlayerItem(asset: avAsset)
        videoPlayer = AVPlayer(playerItem: playerItem)
    }

    func videoSeek(change: Float) { videoPlayer.seek(to:CMTimeMakeWithSeconds(Float64(change), preferredTimescale: Int32(NSEC_PER_SEC))) }
    func currentTime() ->Float64 { return CMTimeGetSeconds((videoPlayer.currentItem?.currentTime())!) }
    func videoDurationTime() ->Float64 { return CMTimeGetSeconds((videoPlayer.currentItem?.duration)!) }

    func videoImageViews(nowTime: Float64)-> UIImage {
        let interval = CMTime(seconds: nowTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        guard  let url = urls else { return UIImage() }
        return  thumbnailFromVideo(videoUrl: url, time: interval)
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
}
