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
import RxSwift
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
        view.addSubview(audioContainer)
        view.addSubview(clearButton)

        audioContainer.addSubview(audioBar)

        textFiled.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        clearButton.snp.makeConstraints { (make) in
            make.top.equalTo(textFiled.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        audioContainer.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        audioBar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.audioContainer.setNeedsLayout()
        self.audioContainer.layoutIfNeeded()
        self.audioContainer.removeFromSuperview()
        self.textFiled.inputAccessoryView = self.audioContainer

        // 后台播放
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true, options: AVAudioSession.SetActiveOptions.init())
        try? session.setCategory(AVAudioSession.Category.playback)
    }

    private func createAction() {
        audioBar.control.producer.startWithValues { [weak self] (value) in
            guard let `self` = self else { return }
            switch value {
            case .play:
                self.avPlayer.play()
            case .pause:
                self.avPlayer.pause()
            case .after:
                let current = self.avPlayer.currentTime() + CMTime(seconds: 2, preferredTimescale: CMTimeScale(bitPattern: 1000000000))
                self.avPlayer.seek(to: current)
            case .before:
                let current = self.avPlayer.currentTime() - CMTime(seconds: 2, preferredTimescale: CMTimeScale(bitPattern: 1000000000))
                self.avPlayer.seek(to: current)            }
        }

        clearButton.reactive.controlEvents(UIControl.Event.touchUpInside)
            .observeValues { [weak self]_ in
                self?.textFiled.text = ""
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
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }

    // MARK: UI
    private let audioContainer: UIView = {
        let webView = UIView()
        webView.backgroundColor = .gray
        return webView
    }()

    private let textFiled: UITextView = {
        let textFiled = UITextView()
        textFiled.textColor = .label
        textFiled.backgroundColor = .systemBackground
        textFiled.font = UIFont.systemFont(ofSize: 22)
        textFiled.textAlignment = .left
        textFiled.keyboardType = .phonePad
        return textFiled
    }()

    private let clearButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "iconfont", size: 22)
        button.setTitle("\u{e72a}", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.setTitleColor(.blue, for: .focused)
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

        before.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        playButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        after.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
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
        button.titleLabel?.font = UIFont(name: "iconfont", size: 22)
        button.setTitle("\u{e618}", for: UIControl.State.selected)
        button.setTitle("\u{e693}", for: UIControl.State.normal)
        return button
    }()

    private let before: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "iconfont", size: 22)
        button.setTitle("\u{e74e}", for: UIControl.State.normal)
        return button
    }()

    private let after: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "iconfont", size: 22)
        button.setTitle("\u{e750}", for: UIControl.State.normal)
        return button
    }()
}
