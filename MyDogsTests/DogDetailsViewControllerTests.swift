import XCTest
@testable import MyDogs

class DogDetailsViewControllerTests: XCTestCase {
    
    var dogDetailsViewController: DogDetailsViewController!
    var leftNavButton: UIBarButtonItem?
    var rightNavButton: UIBarButtonItem?
    var nameDatumView: DogDatumView!
    var ownerDatumView: DogDatumView!
    var textView: UITextView!
    
    let dogModel = Mocks.Snowy
    
    override func setUp() {
        super.setUp()
        
    }

    func set() {
        let _ = dogDetailsViewController.view
        leftNavButton = dogDetailsViewController.navigationItem.leftBarButtonItem
        rightNavButton = dogDetailsViewController.navigationItem.rightBarButtonItem
        nameDatumView = dogDetailsViewController.nameDatumView
        ownerDatumView = dogDetailsViewController.ownerDatumView
        textView = dogDetailsViewController.textView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateMode() {
        dogDetailsViewController = DogDetailsViewController.instance(mode: .create)
        set()

        XCTAssertNotNil(leftNavButton)
        XCTAssertNotNil(rightNavButton)
        XCTAssertEqual(nameDatumView.textField.text, "")
        XCTAssertEqual(ownerDatumView.textField.text, "")
        XCTAssertTrue(textView.isEditable)
    }

    func testEditMode() {
        dogDetailsViewController = DogDetailsViewController.instance(mode: .edit, dogModel: dogModel)
        set()

        XCTAssertNotNil(leftNavButton)
        XCTAssertNotNil(rightNavButton)
        XCTAssertEqual(nameDatumView.textField.text, dogModel.name)
        XCTAssertEqual(ownerDatumView.textField.text, dogModel.owner)
        XCTAssertEqual(textView.text, dogModel.blurb)
        XCTAssertTrue(textView.isEditable)

    }

    func testReadOnlyMode() {
        dogDetailsViewController = DogDetailsViewController.instance(mode: .readOnly, dogModel: dogModel)
        set()
        
        XCTAssertNotNil(leftNavButton)
        XCTAssertNil(rightNavButton)
        XCTAssertEqual(nameDatumView.textField.text, dogModel.name)
        XCTAssertEqual(ownerDatumView.textField.text, dogModel.owner)
        XCTAssertEqual(textView.text, dogModel.blurb)
        XCTAssertFalse(textView.isEditable)
    }
}
