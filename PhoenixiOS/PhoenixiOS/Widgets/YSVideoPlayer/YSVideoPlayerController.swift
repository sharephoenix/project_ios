//
//  YSVideoPlayerController.swift
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/22.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import MediaPlayer

class YSVideoPlayerController: YSBaseController {
    private let palyerUrls = ["http://192.168.21.252:8000/a.mkv",
                              "http://192.168.21.252:8000/b.mov",
                              "http://192.168.21.252:8000/d.mov",
                              "http://192.168.21.252:8000/c.mp4",
                              "http://192.168.21.252:8000/favicon.ico"]
    private let playerUrlIndex = 3

    private var currentUrl: String {
        get {
            return self.palyerUrls[self.playerUrlIndex]
        }
    }
    /// actionCase0
    private var avplayer: AVPlayer!
    private var avplayerLayer: AVPlayerLayer!

    /// actionCase1 弃用
    private var mpPlayer: MPMoviePlayerController!

    /// testButton
    private var imageView: UIImageView = UIImageView()
    private var buttoncase2: UIButton!
    private var buttoncase1: UIButton!
    private var buttoncase0: UIButton!
    private var buttonGetImage: UIButton!
    private var buttonRemoveImage: UIButton!

    private var contentScroll = UIScrollView()
    private var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "视频播放器"

        var preView: UIView?

        view.addSubview(contentScroll)
        contentScroll.addSubview(contentView)

        contentScroll.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }


        contentView.addSubview(imageView)
        imageView.backgroundColor = .groupTableViewBackground
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true

        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(344)
        }
        preView = imageView
    /***********************************/
        buttonGetImage = UIButton()
        buttonGetImage.backgroundColor = UIColor.lightGray
        buttonGetImage.setTitle("GetImage", for: UIControl.State.normal)
        buttonGetImage.addTarget(self, action: #selector(getImage), for: UIControl.Event.touchUpInside)
        contentView.addSubview(buttonGetImage)

        buttonGetImage.snp.makeConstraints { (make) in
            make.top.equalTo(preView!.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        preView = buttonGetImage
    /***********************************/
        buttonRemoveImage = UIButton()
        buttonRemoveImage.backgroundColor = UIColor.lightGray
        buttonRemoveImage.setTitle("buttonRemoveImage", for: UIControl.State.normal)
        buttonRemoveImage.addTarget(self, action: #selector(clearCache), for: UIControl.Event.touchUpInside)
        contentView.addSubview(buttonRemoveImage)

        buttonRemoveImage.snp.makeConstraints { (make) in
            make.top.equalTo(preView!.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        preView = buttonRemoveImage

     /***********************************/
        buttoncase2 = UIButton()
        buttoncase2.backgroundColor = UIColor.lightGray
        buttoncase2.setTitle("actioncase2", for: UIControl.State.normal)
        buttoncase2.addTarget(self, action: #selector(actioncase2), for: UIControl.Event.touchUpInside)
        contentView.addSubview(buttoncase2)

        buttoncase2.snp.makeConstraints { (make) in
            make.top.equalTo(preView!.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        preView = buttoncase2

    /***********************************/
        buttoncase1 = UIButton()
        buttoncase1.backgroundColor = UIColor.lightGray
        buttoncase1.setTitle("actioncase1_弃用", for: UIControl.State.normal)
        buttoncase1.addTarget(self, action: #selector(actionCase1), for: UIControl.Event.touchUpInside)
        contentView.addSubview(buttoncase1)

        buttoncase1.snp.makeConstraints { (make) in
            make.top.equalTo(preView!.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        preView = buttoncase1
    /***********************************/
        buttoncase0 = UIButton()
        buttoncase0.backgroundColor = UIColor.lightGray
        buttoncase0.setTitle("actioncase0", for: UIControl.State.normal)
        buttoncase0.addTarget(self, action: #selector(actionCase0), for: UIControl.Event.touchUpInside)
        contentView.addSubview(buttoncase0)

        buttoncase0.snp.makeConstraints { (make) in
            make.top.equalTo(preView!.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        preView = buttoncase0

    /***************/
        preView?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
        })
    }

    @objc private func actioncase2() {
        let autoPlay = true
        let avplayController = AVPlayerViewController()
        let playUrl = currentUrl
        avplayer = AVPlayer(url: URL(string: playUrl)!)
        autoPlay ? avplayer.play() : {}()
        let avplayerLayer = AVPlayerLayer(player: avplayer)
        avplayerLayer.backgroundColor = UIColor.gray.cgColor
        avplayController.player = avplayer
        present(avplayController, animated: true, completion: nil)
    }

    @objc private func actionCase1() {
        let playUrl = currentUrl
        mpPlayer = MPMoviePlayerController(contentURL: URL(string: playUrl)!)
        mpPlayer.view.frame = imageView.bounds
        mpPlayer.view.backgroundColor = UIColor.lightGray
        imageView.addSubview(mpPlayer.view)
    }

    @objc private func actionCase0() {
        let playUrl = currentUrl
        avplayer = AVPlayer(url: URL(string: playUrl)!)
        avplayerLayer = AVPlayerLayer(player: avplayer)
        imageView.layer.insertSublayer(avplayerLayer, at: 0)
        avplayerLayer.frame = imageView.bounds
        avplayerLayer.backgroundColor = UIColor.gray.cgColor
        avplayer.play()
    }

    @objc private func getImage() {
        clearCache()
        let image = YSVideoPlayerTools .getVideoImageWithTime(time: 8000, path: URL(string: currentUrl)!)
        imageView.image = image
        if avplayer != nil {
            avplayer.pause()
        }
    }

    @objc private func clearCache() {
        imageView.image = nil
        imageView.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        avplayer = nil
        avplayerLayer = nil
    }
    
}
