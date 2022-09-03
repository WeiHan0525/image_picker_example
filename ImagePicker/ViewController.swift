//
//  ViewController.swift
//  ImagePicker
//
//  Created by 陳薇涵 on 2022/9/4.
//

import UIKit

class ViewController: UIViewController {
    var videoPicker: VideoPicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoPicker = VideoPicker(presentationController: self)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.videoPicker.selectVideo(from: sender)
    }
}

