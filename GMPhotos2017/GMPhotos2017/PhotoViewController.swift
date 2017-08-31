import UIKit

class PhotoViewController: UIViewController
{
    @IBOutlet var captionView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mapButton: UIButton!

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

        if photo.coordinate.latitude != 0 && photo.longitude != 0 {
            mapButton.isHidden = false
        }
    }

    @IBAction func handleMapButton(_ button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        controller.photo = photo
        navigationController?.pushViewController(controller, animated: true)
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
