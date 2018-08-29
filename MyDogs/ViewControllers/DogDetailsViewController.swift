import UIKit

enum DetailsMode {
    case create, edit, readOnly
}

protocol DogDetailsViewControllerDelegate: class {
    func close()
    func saveSuccessful()
}

class DogDetailsViewController: UIViewController {
    class func instance(mode: DetailsMode, dogModel: DogModel? = nil) -> DogDetailsViewController {
        let instance = UIStoryboard(name: "DogDetails", bundle: nil).instantiateInitialViewController() as! DogDetailsViewController
        instance.mode = mode
        if let dogModel = dogModel {
            instance.dogModel = dogModel
        }
        return instance
    }
    deinit {
        print("-- Deinit DogDetailsViewController")
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tapRecevierView: UIView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var nameDatumView: DogDatumView!
    @IBOutlet weak var ownerDatumView: DogDatumView!
    @IBOutlet weak var textView: UITextView!
    
    let PLACEHOLDER_TEXT = "Add a brief dog bio"
    var dogModel = DogModel()
    var mode = DetailsMode.readOnly
    weak var delegate: DogDetailsViewControllerDelegate?

    var tempContainerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureViews(forMode: self.mode)
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(viewFullImage))
        tapRecevierView.addGestureRecognizer(photoTap)
    }
    
    @objc func viewFullImage() {
        guard let image = imageView.image else { return }
        
        let container = UIView(frame: view.bounds)
        container.alpha = 0.0
        let tempImageView = UIImageView(frame: view.bounds)
        tempImageView.backgroundColor = Colors._555555
        tempImageView.contentMode = .scaleAspectFit
        tempImageView.image = image
        container.addSubview(tempImageView)
        
        let dismissPhotoTap = UITapGestureRecognizer(target: self, action: #selector(dismissFullImage))
        container.addGestureRecognizer(dismissPhotoTap)

        view.addSubview(container)
        tempContainerView = container
        
        UIView.animate(withDuration: 0.2, animations: {
            container.alpha = 1.0
        })

    }
    
    @objc func dismissFullImage() {
        UIView.animate(withDuration: 0.2, animations: {
            self.tempContainerView?.alpha = 0.0
        }) { (done) in
            self.tempContainerView?.removeFromSuperview()
            self.tempContainerView = nil
        }
    }

    
    func configureTextView() {
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
    }
    
    
    func configureViews(forMode mode: DetailsMode) {
        let leftBarButtonItem: UIBarButtonItem
        var rightBarButtonItem: UIBarButtonItem?
        let name: String
        let owner: String
        let bodyText: String
        
        switch mode {
        case .create, .edit:
            leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelOrDoneButtonTapped))
            rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
            
            if mode == .create {
                self.title = "New Dog"
                name = ""
                owner = ""
                bodyText = PLACEHOLDER_TEXT
            } else {
                self.title = "Edit Dog"
                name = dogModel.name
                owner = dogModel.owner
                bodyText = dogModel.blurb
            }
            textView.isEditable = true

        case .readOnly:
            self.title = "Dog Details"
            leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelOrDoneButtonTapped))
            textView.isEditable = false
            
            name = dogModel.name
            owner = dogModel.owner
            bodyText = dogModel.blurb

            nameDatumView.textField.isEnabled = false
            ownerDatumView.textField.isEnabled = false
            textView.isEditable = false
            addPhotoButton.isHidden = true
            addPhotoButton.isEnabled = false            
        }
        
        leftBarButtonItem.setTitleTextAttributes(FontsAndStyles.navigationBarTextAttributes(component: .barButton), for: .normal)
        leftBarButtonItem.tintColor = .white
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)

        if let rightButton = rightBarButtonItem {
            rightButton.setTitleTextAttributes(FontsAndStyles.navigationBarTextAttributes(component: .barButton), for: .normal)
            rightButton.tintColor = .white
            navigationItem.setRightBarButton(rightButton, animated: true)
        }
        
        nameDatumView.configure(descriptor: "Dog Name", datum: name, delegate: self)
        ownerDatumView.configure(descriptor: "Owner", datum: owner, delegate: self)
        let nameAttributes = FontsAndStyles.attributes(
            color: Colors._777777,
            font: .regular,
            size: 15,
            lineHeight: 24,
            lineHeightmultiple: 1.6,
            lineBreakMode: .byWordWrapping
        )
        textView.attributedText = NSAttributedString(string: bodyText, attributes: nameAttributes)

        if let i = dogModel.image() {
            imageView.image = i
        } else {
            imageView.image = nil
            imageView.backgroundColor = Colors._555555
        }        
    }
    
    
    @objc func cancelOrDoneButtonTapped() {
        self.delegate?.close()
    }

    
    @objc func saveButtonTapped() {
        if let _ = DataManagement.shared.saveDog(model: self.dogModel) {
            self.delegate?.saveSuccessful()
        } else {
            showBanner(text: "Unable to save", backgroundColor: .red)
        }
    }
    
    
    @IBAction func addPhotoButtonTapped() {
        switch PhotoManagement.checkStatus() {
            case .authorized:
                showPicker()
            case .notDetermined:
                PhotoManagement.requestPhotoAccess {
                    if PhotoManagement.checkStatus() == .authorized {
                        self.showPicker()
                    }
                }
            case .denied, .restricted:
                let alert = UIAlertController.init(title: "Unable to access camera", message: "Please check settings", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
                    if let settingURL = URL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(settingURL)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
}


//|----------------------------------------------------------------------|\\
//|                         Dog Datum View Delegate                      |\\
//|----------------------------------------------------------------------|\\

extension DogDetailsViewController: DogDatumViewDelegate {
    func contentEdited(newValue: String, dogDatumView: DogDatumView) {
        if dogDatumView == nameDatumView {
            dogModel.name = newValue
        } else if dogDatumView == ownerDatumView {
            dogModel.owner = newValue
        }
    }
}


//|----------------------------------------------------------------------|\\
//|                            UITextView Delegate                       |\\
//|----------------------------------------------------------------------|\\

extension DogDetailsViewController: UITextViewDelegate {    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != PLACEHOLDER_TEXT && textView.text != "" {
            dogModel.blurb = textView.text
        } else {
            textView.text = PLACEHOLDER_TEXT
        }

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PLACEHOLDER_TEXT {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != PLACEHOLDER_TEXT && textView.text != "" {
            dogModel.blurb = textView.text
        } else {
            textView.text = PLACEHOLDER_TEXT
        }
    }
}


//|----------------------------------------------------------------------|\\
//|                   UIImage Picker Controller Delegate                 |\\
//|----------------------------------------------------------------------|\\

extension DogDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        PhotoManagement.savePhoto(newNameOfFile: dogModel.uuid, mediaInfo: info) { (image) in
            if let image = image {
                self.imageView.image = image
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController.init(title: "Error", message: "couldn't save image", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                picker.present(alert, animated: true, completion: nil)
            }
        }

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
