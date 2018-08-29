import Foundation
import CoreData

enum DogFetchType {
    case
    all, // used to fetch all dog entities
    sample, // used to fetch only sample dog entities
    real // used to fetch only real (non-sample) dog entities
}

class DataManagement: NSObject {
    open class var shared: DataManagement {
        struct Static {
            static let instance: DataManagement = DataManagement()
        }
        return Static.instance
    }
    
    let coreData = CoreDataStack()
    
    
    static let auggie_image_id = "auggie_image"
    static let murphy_image_id = "murphy_image"
    static let kermit_image_id = "kermit_image"
    static let rufus_image_id = "rufus_image"
    static let bailey_image_id = "bailey_image"
    
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

        do {
            try coreData.saveContext()
            return dog
        } catch {
            return nil
        }
    }
    
    
    /**
     Fetch all Dogs according to the given DogFetchType.
     */
    func allDogs(type: DogFetchType) -> [Dog]? {
        let fetchRequest = NSFetchRequest(entityName: "Dog") as NSFetchRequest<Dog>
        
        // add a predicate based on the DogFetchType
        switch type {
        case .all:
            break
        case .real:
            fetchRequest.predicate = NSPredicate(format: "sample == %@", NSNumber(value: false))
        case .sample:
            fetchRequest.predicate = NSPredicate(format: "sample == %@", NSNumber(value: true))
        }

        let result = try? coreData.context.fetch(fetchRequest)
        return result
    }
    

    /**
     Convenience method to fetch the count of Dogs saved in CoreData
     Excludes sample Dogs
     */
    func allDogsCount(type: DogFetchType) -> Int {
        return allDogs(type: type)?.count ?? 0
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
            blurb: "At first glance, it's hard to tell if Auggie is a dog or a pogo stick! Auggie has some serious hops which he uses to great effect while enjoying his favorite hobbies - dog-agility and frisbee! But beware, if you bring out his frisbee - Auggie will be relentless until you toss it for him at least 20 times! When he's calmed down from his game of fetch, Auggie is a very affectionate fellow and loves to perch on the back of the couch next to you while you read or watch TV. And don't worry, Auggie will make his needs clear by letting out an expressive howl!",
            uuid: DataManagement.auggie_image_id,
            sample: true
        )
        let _ = saveDog(model: auggie)
        
        let murphy = DogModel(
            name: "Murphy",
            owner: "Kate",
            blurb: "Murphy may be 15.5, but he still loves to cause trouble! This stubborn boy will find any chocolate or food - so please be sure that nothing is left out! This genius loves games like finding hidden toys and learning new tricks. While he enjoys walks, these need to be at a slower “Murphy pace” to accommodate his arthritic knees and with enough time to smell all the flowers. Murphy loves a snuggle and an ear rub and, after some time to earn his trust, Murphy will become your best friend.",
            uuid: DataManagement.murphy_image_id,
            sample: true
        )
        let _ = saveDog(model: murphy)
        
        let kermit = DogModel(
            name: "Kermit",
            owner: "Kate and Dylan",
            blurb: "If Kermit could be granted one wish, it would be endless cuddles. He’ll answer any questions you have with his charming head tilt and wag of his tail. This mostly-blind, senior poodle doesn’t know his own limitations. Unfortunately, that means he often overlooks stairs and fences! But this rescue-senior know no bounds! He lives a jet-set life traveling around in planes and convertibles. But don’t let the flash and good looks deceive, Kermit is a loyal boy who will snuggle you as long as you please (just until it's time for his next walk!)",
            uuid: DataManagement.kermit_image_id,
            sample: true
        )
        let _ = saveDog(model: kermit)
        
        let rufus = DogModel(
            name: "Rufus",
            owner: "Charlie",
            blurb: "Rufus is one cool cat.... I mean dog. With his “doggles” on, Rufus rides the streets of San Fran on his dad’s motorbike. This mellow dude will get along with most anyone, dog or human alike. But watch out for his archnemesis (skateboards) at which point this chill dude will lose his mind.",
            uuid: DataManagement.rufus_image_id,
            sample: true
        )
        let _ = saveDog(model: rufus)
        
        let bailey = DogModel(
            name: "Bailey",
            owner: "Randy",
            blurb: "Bailey loves running on the beach, insisting on constant pets, and chasing tennis balls in the backyard. This affectionate gal will answer any concern with an emphatic handshake that’ll never let you down. Her sweet nature makes her the most loyal and loving companion. She’s great with kids, cats, dogs and adults! She’d be a happy companion on any outing. Just beware, she has a predilection for stealing your socks!",
            uuid: DataManagement.bailey_image_id,
            sample: true
        )
        let _ = saveDog(model: bailey)

    }
}
