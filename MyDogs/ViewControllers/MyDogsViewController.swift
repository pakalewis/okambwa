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
    @IBOutlet weak var noDogsLabel: UILabel!
    
    @IBOutlet weak var seeSampleBiosButton: UIButton!
    
    weak var delegate: MyDogsViewControllerDelegate?
    
    var dogs = [Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Dogs"
        self.view.backgroundColor = Colors._77C045
        
        seeSampleBiosButton.setTitle("View sample profiles!", for: .normal)
        seeSampleBiosButton.layer.cornerRadius = 5
        seeSampleBiosButton.layer.borderColor = UIColor.darkGray.cgColor
        seeSampleBiosButton.layer.borderWidth = 2
        seeSampleBiosButton.backgroundColor = .white
        seeSampleBiosButton.isHidden = DataManagement.shared.allDogsCount(type: .sample) == 0
        
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
        let dogs = DataManagement.shared.allDogs(type: .real) ?? []
        self.dogs = dogs
        tableOfDogs.reloadData()
        noDogsLabel.isHidden = dogs.count > 0
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seeSampleProfilesButtonTapped(_ sender: Any) {
        let sampler = SampleProfilesViewController()
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        closeButton.setTitleTextAttributes(FontsAndStyles.navigationBarTextAttributes(component: .barButton), for: .normal)
        closeButton.tintColor = .white
        sampler.navigationItem.setLeftBarButton(closeButton, animated: true)
        let nav = UINavigationController(rootViewController: sampler)
        nav.applyRoverStyle()
        self.present(nav, animated: true, completion: nil)
    }
}


//|----------------------------------------------------------------------|\\
//|                    Table View Delegate / Data Source                 |\\
//|----------------------------------------------------------------------|\\

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
