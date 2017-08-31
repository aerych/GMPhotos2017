import UIKit
import CoreData

class SavePhotoViewController : UIViewController
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextField!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }


    func configureView() {
        guard let image = image else {
            return
        }

        imageView.image = image
    }


    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func saveImage() {
        self.dismiss(animated: true, completion: nil)

        guard let image = image else {
            return
        }


        DispatchQueue.global(qos: .background).async {
            let imageData = UIImagePNGRepresentation(image)

            DispatchQueue.main.async(execute: {
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }

                    let context = appDelegate.managedObjectContext

                    if let photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
                        photo.date = Date()
                        photo.caption = self.textField.text
                        photo.imageData = imageData

                        appDelegate.saveContext()
                    }
                }
            })

        }

        DispatchQueue.global(qos: .background).async {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
