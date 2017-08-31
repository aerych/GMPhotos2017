import UIKit
import CoreData

class PhotoCollectionViewController : UICollectionViewController
{

    lazy var resultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to prerformFetch. \(error)")
        }
        return controller
    }()

    var managedObjectContext: NSManagedObjectContext {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.managedObjectContext
        }
    }


    // MARK: - LifeCycle Methods

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView?.reloadData()
        }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }


    // MARK: - Camera Related

    @IBAction func handleCameraButtonTapped(_ sender: UIBarButtonItem) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let image = UIImage(named: "whistler.jpg")!
            saveImage(image)
            return
        }

        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.cameraCaptureMode = .photo
        controller.delegate = self

        navigationController?.present(controller, animated: true, completion: nil)
    }


    func saveImage(_ image: UIImage) {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "SavePhotoViewController") as! SavePhotoViewController
        controller.image = image

        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }


    // MARK: - Collection View Methods

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resultsController.sections?.count ?? 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsController.fetchedObjects?.count ?? 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        var availableWidth = collectionView.frame.width
        availableWidth -= 20 // horizontal insets.
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        availableWidth += flowLayout.minimumInteritemSpacing
        let count = floor(availableWidth / 100)
        let side = (availableWidth / count) - flowLayout.minimumInteritemSpacing
        return CGSize(width: side, height: side)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let side: CGFloat = 10.0
        return UIEdgeInsets(top: side, left: side, bottom: side, right: side)
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCellReuseIdentifier", for: indexPath) as! PhotoCell

        if let photo = resultsController.object(at: indexPath) as? Photo {
            cell.imageView.image = photo.image
        }

        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = resultsController.object(at: indexPath) as? Photo else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        controller.photo = photo
        navigationController?.pushViewController(controller, animated: true)
    }

}


extension PhotoCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            self.saveImage(PhotoHelper.correctPhotoRotation(image))
        }
    }
}


extension PhotoCollectionViewController: NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
}
