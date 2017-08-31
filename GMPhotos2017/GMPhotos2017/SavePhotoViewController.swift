import UIKit
import CoreData
import CoreLocation

class SavePhotoViewController : UIViewController
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextField!
    var image: UIImage?
    var coord: CLLocationCoordinate2D?

    lazy var locationManager: CLLocationManager = {
        let mgr = CLLocationManager()
        mgr.delegate = self
        mgr.requestWhenInUseAuthorization()
        return mgr
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        locationManager.requestLocation()
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

                        if let coord = self.coord {
                            photo.latitude = NSNumber(value: coord.latitude)
                            photo.longitude = NSNumber(value: coord.longitude)
                        }

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

extension SavePhotoViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coord = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
