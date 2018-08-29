import XCTest
@testable import MyDogs

class PhotoTests: XCTestCase {
    
    let IDENTIFIER_A = "IDENTIFIER_A"
    let IDENTIFIER_B = "IDENTIFIER_B"

    let IMAGE_A = UIImage(named: DataManagement.auggie_image_id)!
    let IMAGE_B = UIImage(named: DataManagement.murphy_image_id)!

    override func setUp() {
        super.setUp()

        let _ = PhotoManagement.deletePhotoWith(identifier: IDENTIFIER_A)
        let _ = PhotoManagement.deletePhotoWith(identifier: IDENTIFIER_B)
    }
    
    
    func testSaveAndRetrievePhoto() {
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))
        XCTAssertNotNil(PhotoManagement.savePhoto(identifier: IDENTIFIER_A, image: IMAGE_A))
        XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))
    }


    func testDeletePhoto() {
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))
        XCTAssertNotNil(PhotoManagement.savePhoto(identifier: IDENTIFIER_A, image: IMAGE_A))
        XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))
        XCTAssertTrue(PhotoManagement.deletePhotoWith(identifier: IDENTIFIER_A))
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))
    }

    
    func testSaveAndOverwritePhoto() {
        XCTAssertNotNil(PhotoManagement.savePhoto(identifier: IDENTIFIER_A, image: IMAGE_A))
        XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))

        XCTAssertNotNil(PhotoManagement.savePhoto(identifier: IDENTIFIER_A, image: IMAGE_B))
        XCTAssertNotNil(PhotoManagement.retrievePhotoWith(identifier: IDENTIFIER_A))
    }
}
