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


    class func savePhoto(newNameOfFile: String, image: UIImage?, completion: @escaping ((_ image: UIImage?) -> Void)) {
        guard let image = image else {
            completion(nil)
            return
        }

        let documentsURL = PhotoManagement.documentsURL()
        let documentPath = documentsURL.path
        let filePath: URL = documentsURL.appendingPathComponent(newNameOfFile)
        
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: documentPath)
            for existingName in fileNames {
                if existingName == newNameOfFile {
                    try FileManager.default.removeItem(atPath: filePath.path)
                }
            }
            try UIImagePNGRepresentation(image)?.write(to: filePath, options: .atomic)
            completion(image)
            return
        } catch {
            completion(nil)
            return
        }
    }
    
    
    class func retrievePhotoWith(identifier: String) -> UIImage? {
        let fileURL = PhotoManagement.documentsURL().appendingPathComponent(identifier)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    
    class func deletePhotoWith(identifier: String) -> Bool {
        let documentsURL = PhotoManagement.documentsURL()
        let filePath: URL = documentsURL.appendingPathComponent(identifier)
        
        do {
            try FileManager.default.removeItem(at: filePath)
            print("deleted \(identifier)")

            return true
        } catch {
            return false
        }
    }
}
