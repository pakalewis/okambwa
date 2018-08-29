import UIKit

class MyDogCell: UITableViewCell {
    class func nib() -> UINib {
        return UINib(nibName: MyDogCell.identifier, bundle: nil)
    }
    static let identifier = "MyDogCell"
    
    @IBOutlet weak var dogPhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var blurbLabel: UILabel!
    
    
    func display(dog: Dog) {
        let nameAttributes = FontsAndStyles.attributes(
            color: Colors._555555,
            font: .medium,
            size: 15,
            lineHeight: 15,
            lineHeightmultiple: 1,
            lineBreakMode: .byTruncatingTail
        )
        nameLabel.attributedText = NSAttributedString(string: dog.name, attributes: nameAttributes)
        
        let blurbAttributes = FontsAndStyles.attributes(
            color: Colors._989898,
            font: .regular,
            size: 14,
            lineHeight: 23,
            lineHeightmultiple: 1.6,
            lineBreakMode: .byTruncatingTail
        )
        blurbLabel.attributedText = NSAttributedString(string: dog.blurb, attributes: blurbAttributes)

        if let image = dog.model().image() {
            dogPhotoImageView.image = image
        } else {
            dogPhotoImageView.image = nil
            dogPhotoImageView.backgroundColor = Colors._555555
        }
    }
}
