//
//  ImagePicker.swift
//  ImagePicker
//
//  Created by 陳薇涵 on 2022/9/4.
//

import Foundation
import UIKit

open class VideoPicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?

    public init(presentationController: UIViewController) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController

        self.pickerController.delegate = self
        self.pickerController.mediaTypes = ["public.movie"]
        self.pickerController.videoQuality = .typeHigh
    }
    
    public func selectVideo(from sourceView: UIView) {
        self.pickerController.sourceType = .photoLibrary
        self.presentationController?.present(self.pickerController, animated: true)
    }

    private func didSelectVideo(_ controller: UIImagePickerController, didSelect url: URL?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func uploadMedia(videoPath: URL?) {
        if videoPath == nil {
            return
        }
        // server url
        guard let url = URL(string: "http://192.168.43.238:8000") else {
            return
        }
        var request = URLRequest(url: url)
        let boundary = "------------------------baseballclip"
        
        request.httpMethod = "POST"
        request.setValue("multipart/from-data; boundary=\(boundary)", forHTTPHeaderField: "Contetnt-Type")
        
        var movieData: Data?
        do {
            movieData = try Data(contentsOf: videoPath!,options:  Data.ReadingOptions.alwaysMapped)
        } catch _ {
            movieData = nil
            return
        }
        print("movie data: \(movieData)")
        
        let filename = "upload.mp4"
        let mimetype = "video/mp4"
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:from-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(movieData!)
        request.httpBody = body
        
//        let task = URLSession.shared.dataTask(with: request) {
//            (data: Data?, reponse: URLResponse?, error: Error?) in
//            if let error = error {
//                print(error)
//                return
//            }
//            if let data = data {
//                print(String(data: data, encoding: String.Encoding.utf8))
//            }
//        }
//        task.resume()
    }
}
extension VideoPicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.didSelectVideo(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let url = info[.mediaURL] as? URL else {
            return self.didSelectVideo(picker, didSelect: nil)
        }
        self.didSelectVideo(picker, didSelect: url)
        print("video path: \(url)")
        uploadMedia(videoPath: url)
    }
}

extension VideoPicker: UINavigationControllerDelegate {

}
