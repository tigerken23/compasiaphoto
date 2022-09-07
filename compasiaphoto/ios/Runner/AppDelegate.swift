import UIKit
import Flutter
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    lazy var options: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
        return options
    }()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let photoChannel = FlutterMethodChannel(name: "compasia.interview.com/photo", binaryMessenger: controller.binaryMessenger)
        
        photoChannel.setMethodCallHandler {[weak self] call, result in
            guard let self = self else {return}
            switch (call.method) {
            case "getItem":
              let index = call.arguments as? Int ?? 0
              self.dataForGalleryItem(index: index, completion: { (data, id, created, location) in
                result([
                     "data": data,
                     "id": id,
                     "created": created,
                     "location": location
                ])
              })
            case "getTotalImages":
                result(self.getTotalImages())
            default: result(FlutterMethodNotImplemented)
             }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getTotalImages() -> Int {
          let fetchOptions = PHFetchOptions()
          fetchOptions.includeHiddenAssets = true

          let collection: PHFetchResult = PHAsset.fetchAssets(with: fetchOptions)
          return collection.count
    }

    func dataForGalleryItem(index: Int, completion: @escaping (Data?, String, Int, String) -> Void) {
      let fetchOptions = PHFetchOptions()
      fetchOptions.includeHiddenAssets = true
      let collection: PHFetchResult = PHAsset.fetchAssets(with: fetchOptions)
      if (index >= collection.count) {
        return
      }
      let asset = collection.object(at: index)
      let imageSize = CGSize(width: 250,
                             height: 250)

      let imageManager = PHCachingImageManager()
      imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options) { (image, info) in
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.9)
          completion(data,
                     asset.localIdentifier,
                     Int(asset.creationDate?.timeIntervalSince1970 ?? 0),
                     "\(asset.location ?? CLLocation())")
        } else {
          completion(nil, "", 0, "")
        }
      }
    }

}
