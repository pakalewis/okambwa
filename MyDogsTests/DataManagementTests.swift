import XCTest
@testable import MyDogs

class DataManagementTests: XCTestCase {
    let dataStore = DataManagement.shared
    
    override func setUp() {
        super.setUp()
        dataStore.deleteAll()

    }
    
    override func tearDown() {
        super.tearDown()
        dataStore.deleteAll()
    }
    
    
    func testAllDogs() {
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 0)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), 0)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), 0)
        
        let real_count = 100
        for _ in 1...real_count {
            let _ = dataStore.saveDog(model: DogModel())
        }
        XCTAssertEqual(dataStore.allDogsCount(type: .all), real_count)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), real_count)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), 0)


        let sample_count = 10
        for _ in 1...sample_count {
            let _ = dataStore.saveDog(model: DogModel(sample: true))
        }
        XCTAssertEqual(dataStore.allDogsCount(type: .all), real_count + sample_count)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), real_count)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), sample_count)
    }
    
    
    func testSave() {
        let snowy = Mocks.Snowy
        
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 0)
        
        let dog = dataStore.saveDog(model: snowy)!
        XCTAssertNotNil(dog)
        XCTAssertEqual(dog.name, Mocks.Snowy.name)
        XCTAssertEqual(dog.owner, Mocks.Snowy.owner)
        XCTAssertEqual(dog.blurb, Mocks.Snowy.blurb)
        XCTAssertNotEqual(dog.uuid, "")
        XCTAssertTrue(dog.sample)
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 1)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), 0)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), 1)

        snowy.blurb = "New blurb"
        let updatedDog = dataStore.saveDog(model: snowy)!
        XCTAssertNotNil(updatedDog)
        XCTAssertEqual(dog.uuid, updatedDog.uuid)
        XCTAssertEqual(updatedDog.name, Mocks.Snowy.name)
        XCTAssertEqual(updatedDog.owner, Mocks.Snowy.owner)
        XCTAssertEqual(updatedDog.blurb, "New blurb")
        XCTAssertTrue(updatedDog.sample)
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 1)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), 0)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), 1)

        let newDog = dataStore.saveDog(model: Mocks.Toto)!
        XCTAssertNotNil(newDog)
        XCTAssertNotEqual(dog.uuid, newDog.uuid)
        XCTAssertNotEqual(updatedDog.uuid, newDog.uuid)
        XCTAssertEqual(newDog.name, Mocks.Toto.name)
        XCTAssertEqual(newDog.owner, Mocks.Toto.owner)
        XCTAssertEqual(newDog.blurb, Mocks.Toto.blurb)
        XCTAssertTrue(newDog.sample)
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 2)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), 0)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), 2)
    }
    
    
    func testDelete() {
        let snowy = Mocks.Snowy
        XCTAssertNil(PhotoManagement.retrievePhotoWith(identifier: snowy.uuid))
        
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 0)
        let dog = dataStore.saveDog(model: snowy)!
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 1)
        dataStore.deleteDog(uuid: dog.uuid)
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 0)
    }
    
    
    func testFindByUUID() {
        dataStore.addSampleDogs()
        
        let auggie = dataStore.findDog(uuid: DataManagement.auggie_image_id)!
        XCTAssertNotNil(auggie)
        XCTAssertEqual(auggie.name, "Auggie")
        XCTAssertEqual(auggie.owner, "Lewis family")
        XCTAssertEqual(auggie.blurb, "At first glance, it's hard to tell if Auggie is a dog or a pogo stick! Auggie has some serious hops which he uses to great effect while enjoying his favorite hobbies - dog-agility and frisbee! But beware, if you bring out his frisbee - Auggie will be relentless until you toss it for him at least 20 times! When he's calmed down from his game of fetch, Auggie is a very affectionate fellow and loves to perch on the back of the couch next to you while you read or watch TV. And don't worry, Auggie will make his needs clear by letting out an expressive howl!")
        XCTAssertEqual(auggie.uuid, DataManagement.auggie_image_id)
        XCTAssertTrue(auggie.sample)
    }

    
    func testAddSampleDogs() {
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 0)
        dataStore.addSampleDogs()
        XCTAssertEqual(dataStore.allDogsCount(type: .all), 5)
        XCTAssertEqual(dataStore.allDogsCount(type: .real), 0)
        XCTAssertEqual(dataStore.allDogsCount(type: .sample), 5)
    }
}
