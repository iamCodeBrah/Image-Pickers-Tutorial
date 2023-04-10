//
//  iOS13ImagePickerController.swift
//  Image-Pickers-Tutorial
//
//  Created by YouTube on 2023-04-10.
//

import UIKit
import Photos

class iOS13ImagePickerController: MainController {
    
    let imagePicker = UIImagePickerController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "iOS 13"

        PHPhotoLibrary.authorizationStatus()
        
        PHPhotoLibrary.requestAuthorization { _ in }
    }
    
    // MARK: - Selectors
    override func didTapPhotoButton() {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

extension iOS13ImagePickerController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.mediaType] as? String == "public.image" {
            self.handlePhoto(info)
        }
        else  if info[.mediaType] as? String == "public.movie" {
            self.handleVideos(info)
            
        } else {
            print("DEBUG PRINT:", "Media was neither Image or Video.")
        }
        
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Images
    private func handlePhoto(_ info: [UIImagePickerController.InfoKey : Any]) {
//        if let imageURL = info[.imageURL] as? URL {
//            print("DEBUG PRINT:", "Image URL: \(imageURL.description)")
//            let dict: CFDictionary? = self.bestMetadataCollectionMethod(with: imageURL)
//            print("DEBUG PRINT:", dict ?? "Failed to get metadata")
//        }
        
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            print("DEBUG PRINT:", asset.location)
            print("DEBUG PRINT:", asset.creationDate?.description)
            print("DEBUG PRINT:", asset.pixelHeight)
            print("DEBUG PRINT:", asset.pixelWidth)
        }
        
        
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
        }
    }
    
    private func bestMetadataCollectionMethod(with url: URL) -> CFDictionary? {
        let options = [kCGImageSourceShouldCache as String:  kCFBooleanFalse]
        guard let data = NSData(contentsOf: url) else { return nil }
        guard let imgSrc = CGImageSourceCreateWithData(data, options as CFDictionary) else { return nil }
        let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary)
        return metadata
    }
    
    
    // MARK: - Videos
    private func handleVideos(_ info: [UIImagePickerController.InfoKey : Any]) {
//        guard let asset = info[.phAsset] as? PHAsset else { return }
//        print("DEBUG PRINT:", asset.location)
        
        guard let videoURL = info[.mediaURL] as? URL else { return }
        print("DEBUG PRINT:", videoURL)
         
        guard let videoData = try? Data(contentsOf: videoURL, options: NSData.ReadingOptions.mappedIfSafe) else { return }
    
        AVAsset(url: videoURL).generateThumbnail { thumbnail in
            DispatchQueue.main.async {
                self.imageView.image = thumbnail
            }
        }
    }
    
}



extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let times = [NSValue(time: CMTime(seconds: 0.0, preferredTimescale: 600))]
            imageGenerator.appliesPreferredTrackTransform = true
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, aaa, bbb, ccc in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(UIImage(systemName: "video")!)
                }
            })
        }
    }
}
