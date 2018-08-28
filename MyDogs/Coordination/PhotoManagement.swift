import Foundation
import Photos

class PhotoManagement: NSObject {
    class func checkStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }

    class func requestPhotoAccess(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            completion()
        }
    }
    
    
    class func documentsURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    
    class func savePhoto(newNameOfFile: String, mediaInfo: [String : Any], completion: @escaping ((_ image: UIImage?) -> Void)) {
        guard
            let image = mediaInfo[UIImagePickerControllerOriginalImage] as? UIImage
        else {
            completion(nil)
            return
        }
        let documentsURL = PhotoManagement.documentsURL()
        let documentPath = documentsURL.path
//        print("documentDirectory = \(documentsURL)")
//        print("documentPath = \(documentPath)")
        
        // Create filePath URL by appending final path component (name of image)
        let filePath: URL = documentsURL.appendingPathComponent(newNameOfFile)
        // Check for existing image data
//        print("filePath = \(filePath)")
        
        do {
            // Look through array of files in documentDirectory
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: documentPath)
            for existingName in fileNames {
                print(existingName)
                if existingName == newNameOfFile {
                    try FileManager.default.removeItem(atPath: filePath.path)
                }
            }
            try UIImagePNGRepresentation(image)?.write(to: filePath, options: .atomic)
//            print("saved image at \(filePath)")
            
//            let image = UIImage(contentsOfFile: filePath.absoluteURL)
//            print(image)
//            let i = UIImage(

            
            
            completion(image)
            return
        } catch {
            completion(nil)
            return
        }

    }
}
