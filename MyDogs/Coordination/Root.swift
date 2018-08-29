import Foundation
import UIKit

class Root: NSObject {
    var navigationController = UINavigationController()
    let myDogsViewController = MyDogsViewController.instance()

    override init() {
        super.init()
        
        let barButtonItem = UIBarButtonItem(title: "Add Dog", style: .plain, target: self, action: #selector(addNewDog))
        barButtonItem.tintColor = .white
        barButtonItem.setTitleTextAttributes(FontsAndStyles.navigationBarTextAttributes(component: .barButton), for: .normal)
        myDogsViewController.navigationItem.setRightBarButton(barButtonItem, animated: false)
        myDogsViewController.delegate = self
        
        navigationController = UINavigationController(rootViewController: myDogsViewController)
        navigationController.applyRoverStyle()
        
        // seed CoreData with a few sample dogs
        DataManagement.shared.addSampleDogs()
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


//|----------------------------------------------------------------------|\\
//|                         Dog List ViewController                      |\\
//|----------------------------------------------------------------------|\\

extension Root: MyDogsViewControllerDelegate {
    func dogSelected(dog: Dog) {
        displayDetails(dog: dog, mode: .edit)
    }
}


//|----------------------------------------------------------------------|\\
//|                         Dog Details ViewController                   |\\
//|----------------------------------------------------------------------|\\

extension Root: DogDetailsViewControllerDelegate {
    func close() {
        navigationController.popViewController(animated: true)
    }
    
    func saveSuccessful() {
        navigationController.popViewController(animated: true)
        navigationController.showBanner(text: "Saved!", backgroundColor: .gray)
    }
}
