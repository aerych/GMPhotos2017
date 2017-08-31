import Foundation
import CoreData


class Photo: NSManagedObject {

    @NSManaged var caption: String?
    @NSManaged var date: Date?
    @NSManaged var imageData: Data?

}
