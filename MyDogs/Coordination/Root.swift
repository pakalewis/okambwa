import Foundation
import UIKit

class Root: NSObject {
    var navigationController = UINavigationController()
    let myDogsViewController = MyDogsViewController.instance()

    override init() {
        super.init()
        
        myDogsViewController.delegate = self
        let barButtonItem = UIBarButtonItem(title: "Add Dog", style: .plain, target: self, action: #selector(addNewDog))
        barButtonItem.setTitleTextAttributes(FontsAndStyles.navigationBarTextAttributes(component: .barButton), for: .normal)
        myDogsViewController.navigationItem.setRightBarButton(barButtonItem, animated: false)
        navigationController = UINavigationController(rootViewController: myDogsViewController)
        navigationController.applyRoverStyle()
        
        if DataManagement.shared.allDogsCount() == 0 {
            DataManagement.shared.addSampleDogs()
        }
    }
    
    
    @objc func addNewDog() {
        displayDetails(dog: nil, mode: .create)
    }
    
    
    func displayDetails(dog: Dog?, mode: DetailsMode) {
        let dogDetailsViewController = DogDetailsViewController.instance(mode: mode)
        dogDetailsViewController.delegate = self
        if let dog = dog {
            dogDetailsViewController.dogModel = dog.model()
        }        
        
        navigationController.pushViewController(dogDetailsViewController, animated: true)
    }
}

extension Root: MyDogsViewControllerDelegate {
    func dogSelected(dog: Dog) {
        displayDetails(dog: dog, mode: .edit)
    }
}

extension Root: DogDetailsViewControllerDelegate {
    func cancel() {
        navigationController.popViewController(animated: true)

    }
    
    func done() {
        navigationController.popViewController(animated: true)

    }
    
    func save() {
        navigationController.popViewController(animated: true)

    }
    
    func addPhoto() {
    }
}
