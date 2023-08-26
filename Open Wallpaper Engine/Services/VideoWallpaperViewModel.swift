//
//  VideoWallpaperViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/14.
//

import AVKit
import SwiftUI

class VideoWallpaperViewModel: ObservableObject {
    var currentWallpaper: WEWallpaper {
        willSet {
            self.player = AVPlayer(url: newValue.wallpaperDirectory.appending(path: newValue.project.file))
        }
    }
    
    var playRate: Float = 0 {
        willSet {
            self.player.rate = newValue
        }
    }
    
    var playVolume: Float = 0 {
        willSet {
            self.player.volume = newValue
        }
    }
    
    var player = AVPlayer()
    
    init(wallpaper currentWallpaper: WEWallpaper) {
        self.currentWallpaper = currentWallpaper
        self.player = AVPlayer(url: currentWallpaper.wallpaperDirectory.appending(path: currentWallpaper.project.file))
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemWillSleep), name: NSWorkspace.screensDidSleepNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemDidWake), name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        print("replaying...")
        // 重新播放视频
        self.player.seek(to: CMTime.zero)
        self.player.rate = self.playRate
    }
    
    @objc private func playerDidStopPlaying(_ notification: Notification) {
        print("stopped, trying to resume...")
        // 重新播放视频
        self.player.rate = self.playRate
    }
    
    @objc func systemWillSleep(notification: Notification) {
        // Handle going to sleep
        print("System is going to sleep")
        // Update your SwiftUI state here if needed
        self.player.rate = self.playRate
    }
        
    @objc func systemDidWake(notification: Notification) {
        // Handle waking up
        print("System woke up from sleep")
        // Update your SwiftUI state here if needed
        self.player.rate = self.playRate
    }
}
