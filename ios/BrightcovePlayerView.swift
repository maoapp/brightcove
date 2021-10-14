//
//  BrightcovePlayerView.swift
//  VideoCloudBasicPlayer
//
//  Created by Mauricio arroyave on 7/10/21.
//  Copyright © 2021 Brightcove. All rights reserved.
//

import AVKit
import UIKit
import BrightcovePlayerSDK

final class BrightcovePlayerView: RCTView {
    let sharedSDKManager = BCOVPlayerSDKManager.shared()
    var playbackService:BCOVPlaybackService?
    var playbackController :BCOVPlaybackController?
    var nowPlayingHandler: NowPlayingHandler?
    var playerView: BCOVPUIPlayerView?
    
    @objc var accountId: NSString!
    @objc var videoId: NSString!
    @objc var policyKey: NSString!
    @objc var userId: NSString!
    
    weak var currentPlayer: AVPlayer? 
    required init?(coder aDecoder: NSCoder) {
        BCOVGlobalConfiguration.sharedConfig().setValue([
            "privateUser":userId,
            "privateApplication":""
        ], forKey: "privateSessionAnalytics")
       fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.playbackController = (sharedSDKManager?.createPlaybackController())!
        self.playbackController?.delegate = self
        self.playbackController?.allowsBackgroundAudioPlayback = true
        self.playbackController?.allowsExternalPlayback = true
        self.playbackController?.isAutoPlay = true
    }
    
    override func didSetProps(_ changedProps: [String]!) {
        refreshVideo()
    }
    
    
    func refreshVideo() {
        if self.policyKey != "" && self.accountId != "" && self.videoId != "" {
            self.playbackService =  BCOVPlaybackService(accountId: self.accountId as String, policyKey: self.policyKey as String) 
            setupVideoPlayer()
        }
    }
    
    func requestContentFromPlaybackService() {
        playbackService?.findVideo(withVideoID: self.videoId as String, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                self.playbackController?.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    func setUpAudioSession() {
        var categoryError :NSError?
        var success: Bool
        do {
            // see https://developer.apple.com/documentation/avfoundation/avaudiosessioncategoryplayback
            if let currentPlayer = currentPlayer {
                
                // If the player is muted, then allow mixing.
                // Ensure other apps can have their background audio
                // active when this app is in foreground
                if currentPlayer.isMuted {
                    try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
                } else {
                    try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions(rawValue: 0))
                }
            } else {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions(rawValue: 0))
            }
            
            success = true
        } catch let error as NSError {
            categoryError = error
            success = false
        }

        if !success {
            print("AppDelegate Debug - Error setting AVAudioSession category.  Because of this, there may be no sound. \(categoryError!)")
        }
    }
    
    func setupVideoPlayer () {
        setUpAudioSession()
        
        // Set up our player view. Create with a standard VOD layout.
        let options = BCOVPUIPlayerViewOptions()
        options.showPictureInPictureButton = true
        
        guard let playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: options, controlsView: BCOVPUIBasicControlView.withVODLayout()) else {
            return
        }
        
        self.playerView = playerView
        
        playerView.delegate = self
        
        // Install in the container view and match its size.
        self.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.topAnchor),
            playerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            playerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // Associate the playerView with the playback controller.
        playerView.playbackController = playbackController
        
        nowPlayingHandler = NowPlayingHandler(withPlaybackController: playbackController!)
        
        requestContentFromPlaybackService()
    }
}



extension BrightcovePlayerView: BCOVPlaybackControllerDelegate {
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
        
        currentPlayer = session.player
        
        // Enable route detection for AirPlay
        // https://developer.apple.com/documentation/avfoundation/avroutedetector/2915762-routedetectionenabled
        // playerView?.controlsView.routeDetector?.isRouteDetectionEnabled = true
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval) {
        print("Progress: \(progress) seconds")
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        if lifecycleEvent.eventType == kBCOVPlaybackSessionLifecycleEventEnd {
            // Disable route detection for AirPlay
            // https://developer.apple.com/documentation/avfoundation/avroutedetector/2915762-routedetectionenabled
            // playerView?.controlsView.routeDetector?.isRouteDetectionEnabled = false
        }
    }
    
}

extension BrightcovePlayerView: BCOVPUIPlayerViewDelegate {
    
    func pictureInPictureControllerDidStartPicture(inPicture pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerDidStartPicture")
    }
    
    func pictureInPictureControllerDidStopPicture(inPicture pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerDidStopPicture")
    }
    
    func pictureInPictureControllerWillStartPicture(inPicture pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerWillStartPicture")
    }
    
    func pictureInPictureControllerWillStopPicture(inPicture pictureInPictureController: AVPictureInPictureController) {
        print("pictureInPictureControllerWillStopPicture")
    }
    
    func picture(_ pictureInPictureController: AVPictureInPictureController!, failedToStartPictureInPictureWithError error: Error!) {
        print("failedToStartPictureInPictureWithError \(error.localizedDescription)")
    }
    
}

