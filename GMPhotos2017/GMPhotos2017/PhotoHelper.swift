import Foundation
import UIKit

class PhotoHelper
{

    /// Borrowed and tweaked from
    /// https://stackoverflow.com/a/33479054
    class func correctPhotoRotation(_ image: UIImage) -> UIImage {
        let imageOrientation = image.imageOrientation
        let size = image.size

        // No-op if the orientation is already correct
        if imageOrientation == UIImageOrientation.up {
            return image
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity

        if imageOrientation == UIImageOrientation.down || imageOrientation == UIImageOrientation.downMirrored {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if imageOrientation == UIImageOrientation.left || imageOrientation == UIImageOrientation.leftMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }

        if imageOrientation == UIImageOrientation.right || imageOrientation == UIImageOrientation.rightMirrored {
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0))
        }

        if imageOrientation == UIImageOrientation.upMirrored || imageOrientation == UIImageOrientation.downMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if imageOrientation == UIImageOrientation.leftMirrored || imageOrientation == UIImageOrientation.rightMirrored {
            transform = transform.translatedBy(x: size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let imageRef = image.cgImage!
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                       bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 0,
                                       space: imageRef.colorSpace!,
                                       bitmapInfo: imageRef.bitmapInfo.rawValue)!

        ctx.concatenate(transform)

        if ( imageOrientation == UIImageOrientation.left ||
            imageOrientation == UIImageOrientation.leftMirrored ||
            imageOrientation == UIImageOrientation.right ||
            imageOrientation == UIImageOrientation.rightMirrored ) {
            ctx.draw(imageRef, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        } else {
            ctx.draw(imageRef, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }

}
