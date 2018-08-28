import UIKit

protocol MyDogsViewControllerDelegate: class {
    func dogSelected(dog: Dog)
}

class MyDogsViewController: UIViewController {
    class func instance() -> MyDogsViewController {
        return UIStoryboard(name: "MyDogs", bundle: nil).instantiateInitialViewController() as! MyDogsViewController
    }
    deinit {
        print("-- Deinit MyDogsViewController")
    }

    @IBOutlet weak var tableOfDogs: UITableView!
    
    @IBOutlet weak var seeSampleBiosButton: UIButton!
    
    weak var delegate: MyDogsViewControllerDelegate?
    
    var dogs = [Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Dogs"
        
        
        seeSampleBiosButton.layer.cornerRadius = min(seeSampleBiosButton.bounds.width, seeSampleBiosButton.bounds.height) / 2
        seeSampleBiosButton.backgroundColor = .blue
        
        tableOfDogs.delegate = self
        tableOfDogs.dataSource = self
        tableOfDogs.register(MyDogCell.nib(), forCellReuseIdentifier: MyDogCell.identifier)

        tableOfDogs.separatorColor = Colors._DFDFDF
        tableOfDogs.separatorStyle = .singleLine
        tableOfDogs.separatorInset = UIEdgeInsets.zero
        tableOfDogs.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refetch()
    }
    
    func refetch() {
        if let dogs = DataManagement.shared.allDogs() {
            self.dogs = dogs
            tableOfDogs.reloadData()
        }
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seeSampleProfilesButtonTapped(_ sender: Any) {
        if let pages = SampleProfilesViewController.samplePages() {
            let sampler = SampleProfilesViewController()
            sampler.pages = pages
            let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
            closeButton.setTitleTextAttributes(FontsAndStyles.navigationBarTextAttributes(component: .barButton), for: .normal)
            sampler.navigationItem.setLeftBarButton(closeButton, animated: true)
            let nav = UINavigationController(rootViewController: sampler)
            nav.applyRoverStyle()
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension MyDogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDogCell.identifier, for: indexPath) as! MyDogCell
        let dog = dogs[indexPath.row]
        cell.display(dog: dog)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dog = dogs[indexPath.row]
        delegate?.dogSelected(dog: dog)
    }
}
