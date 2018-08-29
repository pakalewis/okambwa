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
        do {
            let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return url
        }
    }


    /**
     Constructs URL for a file in the documents directory with the given name
     */
    class func fileURL(identifier: String) -> URL {
        return PhotoManagement.documentsURL().appendingPathComponent("\(identifier)")
    }
    
    
    /**
     Save image data in documents directory with the given file name
     Overwrites any existing file
     */
    class func savePhoto(identifier: String, image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }

        let filePath = PhotoManagement.fileURL(identifier: identifier)
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: PhotoManagement.documentsURL().path)
            for existingName in fileNames {
                if existingName == identifier {
                    try FileManager.default.removeItem(atPath: filePath.path)
                }
            }
            try UIImagePNGRepresentation(image)?.write(to: filePath, options: .atomic)
            return image
        } catch {
            return nil
        }
    }
    
    
    /**
     Attempt to read data from a file in the documents directory with the given file name
     */
    class func retrievePhotoWith(identifier: String) -> UIImage? {
        let fileURL = PhotoManagement.fileURL(identifier: identifier)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    

    
    class func deletePhotoWith(identifier: String) -> Bool {
        let fileURL = PhotoManagement.fileURL(identifier: identifier)
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            return false
        }
    }
}
