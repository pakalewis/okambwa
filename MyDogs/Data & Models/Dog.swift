import Foundation
import CoreData
import UIKit


open class DogModel: NSObject {
    var name: String
    var owner: String
    var blurb: String
    let uuid: String
    var sample: Bool
    
    init(name: String? = nil, owner: String? = nil, blurb: String? = nil, uuid: String? = nil, sample: Bool? = nil) {
        self.name = name ?? ""
        self.owner = owner ?? ""
        self.blurb = blurb ?? ""
        self.uuid = uuid ?? UUID().uuidString
        self.sample = sample ?? false
    }

    func image() -> UIImage? {
        if let image = UIImage(named: self.uuid) {
            return image
        }
        return PhotoManagement.retrievePhotoWith(identifier: uuid)
    }
}


open class Dog: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var owner: String
    @NSManaged var blurb: String
    @NSManaged var uuid: String
    @NSManaged var sample: Bool

    func model() -> DogModel {
        return DogModel(name: self.name, owner: self.owner, blurb: self.blurb, uuid: self.uuid, sample: self.sample)
    }
    
    
    func updateWith(model: DogModel) {
        self.name = model.name
        self.owner = model.owner
        self.blurb = model.blurb
        self.uuid = model.uuid
        self.sample = model.sample
    }
    
    
    func printDescription() {
        let desc = """
        Dog:
        \t name = \(name)
        \t owner = \(owner)
        \t blurb = \(blurb)
        \t uuid = \(uuid)
        \t sample = \(sample)
        """
        print(desc)
    }
}
