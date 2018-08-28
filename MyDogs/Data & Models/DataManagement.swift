import Foundation
import CoreData

class DataManagement: NSObject {
    open class var shared: DataManagement {
        struct Static {
            static let instance: DataManagement = DataManagement()
        }
        return Static.instance
    }
    
    let coreData = CoreDataStack()
    
    static let AUGGIE_UUID = "AUGGIE_UUID"
    static let MURPHY_UUID = "MURPHY_UUID"
    static let KERMIT_UUID = "KERMIT_UUID"

    
    
    /**
     Save Dog to CoreData
     if the given DogModel corresponds to an existing entity, it will be updated
     else, a new entity will be created
     on success, the Dog entity is returned
     */
    func saveDog(model: DogModel) -> Dog? {
        let dog: Dog
        if let existingDog = findDog(uuid: model.uuid) {
            dog = existingDog
        } else {
            dog = NSEntityDescription.insertNewObject(forEntityName: "Dog", into: coreData.context) as! Dog
        }
        dog.updateWith(model: model)
//        dog.printDescription()
        do {
            try coreData.saveContext()
            print("SAved")
            return dog
        } catch {
            print("not")
            return nil
        }
    }
    
    /**
     Fetch Dog that corresponds to the given UUID
     */
    func findDog(uuid: String) -> Dog? {
        let fetchRequest = NSFetchRequest(entityName: "Dog") as NSFetchRequest<Dog>
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            let dog = try coreData.context.fetch(fetchRequest).first
            return dog
        } catch {
            return nil
        }
    }
    
    /**
     Fetch all Dogs saved in CoreData
     Excludes sample Dogs by default. 
     */
    func allDogs(excludeSample: Bool? = false) -> [Dog]? {
        let fetchRequest = NSFetchRequest(entityName: "Dog") as NSFetchRequest<Dog>
//        if let exclude = excludeSample {
//            fetchRequest.predicate = NSPredicate(format: "sample == %@", NSNumber(value: true))
//        }
        
        let result = try? coreData.context.fetch(fetchRequest)
        return result
    }
    

    /**
     Convenience method to fetch the count of Dogs saved in CoreData
     Excludes sample Dogs
     */
    func allDogsCount(excludeSample: Bool? = false) -> Int {
        return allDogs(excludeSample: excludeSample)?.count ?? 0
    }
    
    
    /**
     Delete Dog that corresponds to the given UUID
     Optional completion block indicates success
     */
    func deleteDog(uuid: String, completion: ((_ success: Bool) -> Void)? = nil) {
        let fetchRequest = NSFetchRequest(entityName: "Dog") as NSFetchRequest<Dog>
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            if let dog = try coreData.context.fetch(fetchRequest).first {
                coreData.context.delete(dog)
                do {
                    try coreData.context.save()
                    completion?(true)
                } catch {
                    completion?(false)
                }
            }
        } catch {
            completion?(false)
        }
    }
    

    /**
     Delete all Dogs from CoreData
     Optional completion block indicates success
     */
    func deleteAll(completion: ((_ success: Bool) -> Void)? = nil) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try coreData.context.execute(deleteRequest)
            completion?(true)
        } catch {
            completion?(false)
        }
    }

    
    func addSampleDogs() {
        let auggie = DogModel(
            name: "Auggie",
            owner: "Lewis family",
            blurb: "Auggie is an 11-year-old cockapoo",
            uuid: DataManagement.AUGGIE_UUID,
            sample: true
        )
        let _ = saveDog(model: auggie)
        let murphy = DogModel(
            name: "Murphy",
            owner: "Kate Lewis family",
            blurb: "Murphy is a spry 15 years old! He lives with my sister in California",
            uuid: DataManagement.MURPHY_UUID,
            sample: true
        )
        let _ = saveDog(model: murphy)
        let kermit = DogModel(
            name: "Kermit",
            owner: "Kate and Dylan",
            blurb: "Kermit was adopted last year. He's about 10 years old and it mostly blind. ",
            uuid: DataManagement.KERMIT_UUID,
            sample: true
        )
        let _ = saveDog(model: kermit)
    }

    func allSampleDogs() -> [Dog]? {
        let fetchRequest = NSFetchRequest(entityName: "Dog") as NSFetchRequest<Dog>
        fetchRequest.predicate = NSPredicate(format: "sample == %@", NSNumber(value: true))
        return try? coreData.context.fetch(fetchRequest)
    }
}
