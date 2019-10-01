//
//  VoiceDetailController.swift
//  EnglistWords
//
//  Created by Alexluan on 2019/9/29.
//  Copyright © 2019 Alexluan. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
import CoreAudio
import AVFoundation

class VoiceDetailController: UIViewController {

    private let url: String
    private let navTitle: String
    private var avPlayer = AVPlayer()
    private let audioBar = PlayerTooBar()

    init(url: String, title: String) {
        self.url = url
        navTitle = title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = navTitle
        view.backgroundColor = .lightGray
        createUI()
        createAction()
        createAVPlayer()
    }

    private func createUI() {
        view.addSubview(textFiled)
        view.addSubview(btn)
        view.addSubview(audioContainer)
        audioContainer.addSubview(audioBar)

        textFiled.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-view.safeAreaInsets.bottom)
        }
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(view.safeAreaInsets.top).offset(300)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        audioContainer.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        audioBar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        // 后台播放
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true, options: AVAudioSession.SetActiveOptions.init())
        try? session.setCategory(AVAudioSession.Category.playback)
    }

    private func createAction() {
        btn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
            self?.navigationController?.pushViewController(MoreController(), animated: true)
        }

        audioBar.control.producer.startWithValues { [weak self] (value) in
            guard let `self` = self else { return }
            switch value {
            case .play:
                self.avPlayer.play()
            case .pause:
                self.avPlayer.pause()
            case .after:
                print("after")
            case .before:
                print("before")
            }
        }
    }

    private func createAVPlayer() {
        guard let playerUrl = URL(string: self.url) else {
            return
        }
        let playerItem = AVPlayerItem(url: playerUrl)
        if self.avPlayer.status == .readyToPlay {
            self.avPlayer.replaceCurrentItem(with: playerItem)
        } else {
            self.avPlayer = AVPlayer.init(playerItem: playerItem)
        }
        avPlayer.play()
        audioContainer.setNeedsLayout()
        audioContainer.layoutIfNeeded()
    }

    // MARK: UI
    private let audioContainer: UIView = {
        let webView = UIView()
        webView.backgroundColor = .gray
        return webView
    }()

    private let textFiled: UITextView = {
        let textFiled = UITextView()
        textFiled.textColor = .black
        textFiled.backgroundColor = .white
        textFiled.textAlignment = .left
        return textFiled
    }()

    private let btn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()
}

// MARK: AUDIO BAR VIEW
class PlayerTooBar: UIView {

    enum PlayControl: String {
        case play
        case pause
        case after
        case before
    }

    open var control = MutableProperty<PlayControl>(.play)

    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
        createAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        addSubview(playButton)
        addSubview(before)
        addSubview(after)

        playButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        before.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        after.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func createAction() {
        playButton.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            btn.isSelected = !btn.isSelected
            self.control.value = btn.isSelected ? .pause : .play
        }

        before.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.control.value = .before
        }

        after.reactive.controlEvents(.touchUpInside).observeValues { (btn) in
            self.control.value = .after
        }
    }

    // MARK: UI
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("play", for: UIControl.State.selected)
        button.setTitle("pause", for: UIControl.State.normal)
        return button
    }()

    private let before: UIButton = {
        let button = UIButton()
        button.setTitle("before", for: UIControl.State.normal)
        return button
    }()

    private let after: UIButton = {
        let button = UIButton()
        button.setTitle("after", for: UIControl.State.normal)
        return button
    }()
}
