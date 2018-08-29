import XCTest
@testable import MyDogs

class PhotoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        var files: [String]?
        files = try? FileManager.default.contentsOfDirectory(atPath: PhotoManagement.documentsURL().path)

        for file in files ?? [] {
            let _ = PhotoManagement.deletePhotoWith(identifier: file)
        }
    }
    
    
    func testSavePhoto() {
        let image = UIImage(named: DataManagement.auggie_image_id)!
        PhotoManagement.savePhoto(newNameOfFile: DataManagement.auggie_image_id, image: image) { (savedImage) in
            XCTAssertNotNil(savedImage)
        }
    }
    

    func testDeletePhoto() {
        let identifier = DataManagement.auggie_image_id
        let image = UIImage(named: identifier)!

        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: identifier))

        PhotoManagement.savePhoto(newNameOfFile: identifier, image: image) { (savedImage) in
            XCTAssertNotNil(savedImage)
            XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: identifier))
        }

        XCTAssertTrue(PhotoManagement.deletePhotoWith(identifier: identifier))
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: identifier))
    }

    
    func testSaveAndOverwritePhoto() {
        let identifier = DataManagement.auggie_image_id
        
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: identifier))
        
        let image = UIImage(named: DataManagement.auggie_image_id)!
        PhotoManagement.savePhoto(newNameOfFile: DataManagement.auggie_image_id, image: image) { (savedImage) in
            XCTAssertNotNil(savedImage)
            XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: identifier))
        }
        
        let newImage = UIImage(named: DataManagement.murphy_image_id)!
        PhotoManagement.savePhoto(newNameOfFile: DataManagement.auggie_image_id, image: newImage) { (savedImage) in
            XCTAssertNotNil(savedImage)
            XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: identifier))
        }
    }
    
    
    func testRetrievePhoto() {
        let identifier = DataManagement.auggie_image_id
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: identifier))
    }
}
