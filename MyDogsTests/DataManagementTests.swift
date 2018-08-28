import XCTest
@testable import MyDogs

class DataManagementTests: XCTestCase {
    let dataStore = DataManagement.shared
    
    let snowy = Mocks.Snowy

    override func setUp() {
        super.setUp()
        dataStore.deleteAll()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAllDogs() {
        XCTAssertEqual(dataStore.allDogsCount(), 0)
        XCTAssertEqual(dataStore.allDogs()?.count, 0)

        let count = 100
        for _ in 1...count {
            let _ = dataStore.saveDog(model: DogModel())
        }
        XCTAssertEqual(dataStore.allDogsCount(), count)
        XCTAssertNotNil(dataStore.allDogs())

        let sample_count = 10
        for _ in 1...sample_count {
            let _ = dataStore.saveDog(model: DogModel(sample: true))
        }
        XCTAssertEqual(dataStore.allDogsCount(), count)
        XCTAssertEqual(dataStore.allDogsCount(excludeSample: false), count + sample_count)
    }
    
    
    func testSave() {
        XCTAssertEqual(dataStore.allDogsCount(), 0)
        
        let dog = dataStore.saveDog(model: snowy)!
        XCTAssertNotNil(dog)
        XCTAssertEqual(dog.name, Mocks.Snowy.name)
        XCTAssertEqual(dog.owner, Mocks.Snowy.owner)
        XCTAssertEqual(dog.blurb, Mocks.Snowy.blurb)
        XCTAssertNotEqual(dog.uuid, "")
        XCTAssertTrue(dog.sample)
        XCTAssertEqual(dataStore.allDogsCount(), 1)
        
        snowy.blurb = "New blurb"
        let updatedDog = dataStore.saveDog(model: snowy)!
        XCTAssertNotNil(updatedDog)
        XCTAssertEqual(dog.uuid, updatedDog.uuid)
        XCTAssertEqual(updatedDog.name, Mocks.Snowy.name)
        XCTAssertEqual(updatedDog.owner, Mocks.Snowy.owner)
        XCTAssertEqual(updatedDog.blurb, "New blurb")
        XCTAssertTrue(updatedDog.sample)
        XCTAssertEqual(dataStore.allDogsCount(), 1)
        
        let newDog = dataStore.saveDog(model: Mocks.Toto)!
        XCTAssertNotNil(newDog)
        XCTAssertNotEqual(dog.uuid, newDog.uuid)
        XCTAssertNotEqual(updatedDog.uuid, newDog.uuid)
        XCTAssertEqual(newDog.name, Mocks.Toto.name)
        XCTAssertEqual(newDog.owner, Mocks.Toto.owner)
        XCTAssertEqual(newDog.blurb, Mocks.Toto.blurb)
        XCTAssertTrue(newDog.sample)
        XCTAssertEqual(dataStore.allDogsCount(), 2)
    }
    
    func testDelete() {
        XCTAssertEqual(dataStore.allDogsCount(), 0)
        let dog = dataStore.saveDog(model: snowy)!
        XCTAssertEqual(dataStore.allDogsCount(), 1)
        dataStore.deleteDog(uuid: dog.uuid)
        XCTAssertEqual(dataStore.allDogsCount(), 0)
    }
    
    func testAddSampleDogs() {
        XCTAssertEqual(dataStore.allDogsCount(), 0)
        dataStore.addSampleDogs()
        XCTAssertEqual(dataStore.allDogsCount(excludeSample: false), 3)
        XCTAssertEqual(dataStore.allDogsCount(excludeSample: true), 0)
        
        let auggie = dataStore.findDog(uuid: DataManagement.AUGGIE_UUID)!
        XCTAssertNotNil(auggie)
        XCTAssertEqual(auggie.name, "Auggie")
        XCTAssertEqual(auggie.owner, "Lewis family")
        XCTAssertEqual(auggie.blurb, "Auggie is an 11-year-old cockapoo")
        XCTAssertEqual(auggie.uuid, DataManagement.AUGGIE_UUID)
        XCTAssertTrue(auggie.sample)
    }

}
