import UIKit

class PhotoViewController: UIViewController
{
    @IBOutlet var captionView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!

    var photo: Photo?


    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }


    func configureView() {
        guard let photo = photo else {
            return
        }

        label.text = photo.caption
        imageView.image = photo.image

        let caption = photo.caption ?? ""
        captionView.isHidden = !(caption.characters.count > 0)
    }


    @IBAction func deletePhoto() {
        if let photo = self.photo {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            context.delete(photo)
            appDelegate.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }

}
