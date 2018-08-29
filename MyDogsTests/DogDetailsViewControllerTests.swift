import XCTest
@testable import MyDogs

class DogDetailsViewControllerTests: XCTestCase {
    
    var dogDetailsViewController: DogDetailsViewController!

    let dogModel = Mocks.Snowy
    

    func testCreateMode() {
        dogDetailsViewController = DogDetailsViewController.instance(mode: .create)
        let _ = dogDetailsViewController.view
        
        XCTAssertNotNil(dogDetailsViewController.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(dogDetailsViewController.navigationItem.rightBarButtonItem)
        XCTAssertEqual(dogDetailsViewController.nameDatumView.textField.text, "")
        XCTAssertEqual(dogDetailsViewController.ownerDatumView.textField.text, "")
        XCTAssertTrue(dogDetailsViewController.textView.isEditable)
    }

    
    func testEditMode() {
        dogDetailsViewController = DogDetailsViewController.instance(mode: .edit, dogModel: dogModel)
        let _ = dogDetailsViewController.view

        XCTAssertNotNil(dogDetailsViewController.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(dogDetailsViewController.navigationItem.rightBarButtonItem)
        XCTAssertEqual(dogDetailsViewController.nameDatumView.textField.text, dogModel.name)
        XCTAssertEqual(dogDetailsViewController.ownerDatumView.textField.text, dogModel.owner)
        XCTAssertEqual(dogDetailsViewController.textView.text, dogModel.blurb)
        XCTAssertTrue(dogDetailsViewController.textView.isEditable)
    }

    
    func testReadOnlyMode() {
        dogDetailsViewController = DogDetailsViewController.instance(mode: .readOnly, dogModel: dogModel)
        let _ = dogDetailsViewController.view

        XCTAssertNotNil(dogDetailsViewController.navigationItem.leftBarButtonItem)
        XCTAssertNil(dogDetailsViewController.navigationItem.rightBarButtonItem)
        XCTAssertEqual(dogDetailsViewController.nameDatumView.textField.text, dogModel.name)
        XCTAssertEqual(dogDetailsViewController.ownerDatumView.textField.text, dogModel.owner)
        XCTAssertEqual(dogDetailsViewController.textView.text, dogModel.blurb)
        XCTAssertFalse(dogDetailsViewController.textView.isEditable)
    }
}
