import UIKit
import CoreData

class PhotoPagerViewController : UIPageViewController
{
    var index: Int = 0

    var photos = [Photo]()


    // MARK: - Lifecycle Methods


    class func controller(_ photos: [Photo], startingIndex: Int) -> PhotoPagerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotoPagerViewController") as! PhotoPagerViewController

        controller.photos = photos
        controller.index = startingIndex

        return controller
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        let startingController: PhotoViewController = controllerForPhotoAtIndex(index)
        let viewControllers = [startingController]
        setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)

    }


    func controllerForPhotoAtIndex(_ index: Int) -> PhotoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        controller.photo = photos[index]

        navigationItem.title = controller.navigationItem.title
        navigationItem.rightBarButtonItems = controller.navigationItem.rightBarButtonItems

        return controller
    }


    func indexOfViewController(_ controller: PhotoViewController) -> Int {
        guard let photo = controller.photo else {
            return NSNotFound
        }
        return photos.index(of: photo)!
    }

}


extension PhotoPagerViewController : UIPageViewControllerDataSource
{

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController as! PhotoViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }

        index -= 1
        return controllerForPhotoAtIndex(index)
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController as! PhotoViewController)
        if index == NSNotFound {
            return nil
        }

        index += 1
        if index == photos.count {
            return nil
        }

        return controllerForPhotoAtIndex(index)
    }
}
