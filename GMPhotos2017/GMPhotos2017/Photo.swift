import UIKit
import CoreData


class Photo: NSManagedObject {

    @NSManaged var caption: String?
    @NSManaged var date: Date?
    @NSManaged var imageData: Data?

    lazy var image: UIImage? = {
        if let data = self.imageData {
            return UIImage(data: data)
        }
        return nil
    }()
}
