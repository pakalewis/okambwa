import UIKit

protocol DogDatumViewDelegate: class {
    func contentEdited(newValue: String, dogDatumView: DogDatumView)
}

class DogDatumView: UIView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("DogDatumView", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    deinit {
        print("-- Deinit DogDatumView")
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var descriptorLabel: UILabel!    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var divider: UIView!
    
    weak var delegate: DogDatumViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        descriptorLabel.font = FontsAndStyles.SFUIDisplayFont.medium.font(size: 15)
        descriptorLabel.textColor = Colors._555555

        textField.font = FontsAndStyles.SFUIDisplayFont.regular.font(size: 15)
        textField.textColor = Colors._777777
        textField.placeholder = nil
        textField.delegate = self
        
        divider.backgroundColor = Colors._DFDFDF
    }
    
    func configure(descriptor: String, datum: String, delegate: DogDatumViewDelegate) {
        self.delegate = delegate
        descriptorLabel.text = descriptor
        textField.text = datum
        textField.autocorrectionType = .no
    }
    
    func notifyContentUpdates() {
        let newValue = textField.text ?? ""
        self.delegate?.contentEdited(newValue: newValue, dogDatumView: self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        notifyContentUpdates()
    }
}

extension DogDatumView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("did begin editing")
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        notifyContentUpdates()
    }
}
