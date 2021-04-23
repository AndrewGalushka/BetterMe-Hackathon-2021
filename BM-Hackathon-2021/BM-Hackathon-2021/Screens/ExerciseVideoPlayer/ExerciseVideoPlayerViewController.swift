//
//  ExerciseVideoPlayerViewController.swift
//  BM-Hackathon-2021
//
//  Created Andrii Halushka on 23.04.2021.
//  Copyright © 2021 Andrii Halushka. All rights reserved.
//

import UIKit
import AVKit

final class ExerciseVideoPlayerViewController: UIViewController {
    struct Props: Equatable {
        let url: URL?
        let onDestroy: Command
        
        static let initial = Props(
            url: nil,
            onDestroy: .nop
        )
    }
    
    private var props = Props.initial
    private var oldProps = Props.initial
    
    private var playerView = PlayerView()
    private var playerLooper: AVPlayerLooper?
    
    deinit {
        props.onDestroy.perform()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func render(props: Props) {
        guard self.props != props else { return }
        self.props = props
        view.setNeedsLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateUI()
        oldProps = props
    }
    
    private func updateUI() {
        guard props != oldProps else { return }
        
        if let url = props.url {
            startPlayer(url: url)
        } else {
            removeVideo()
        }
    }
    
    private func setup() {
        playerView.embed(to: self.view)
        playerView.playerLayer.videoGravity = .resizeAspectFill
    }
    
    private func startPlayer(url: URL) {
        playerLooper = nil
        
        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        let playerItem = AVPlayerItem(asset: asset)
        let queuePlayer = AVQueuePlayer()

        playerView.player = queuePlayer
        
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        queuePlayer.play()
    }
    
    private func removeVideo() {
        playerView.player?.pause()
        playerView.player = nil
    }
}
