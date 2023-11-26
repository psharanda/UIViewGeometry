//
//  Created by Pavel Sharanda on 27/10/2023.
//

import CoreGraphics

extension CGRect {
    func nearlyEqual(_ other: CGRect) -> Bool {
        let eps = 0.00001

        return abs(other.origin.x - origin.x) < eps &&
            abs(other.origin.y - origin.y) < eps &&
            abs(other.size.width - size.width) < eps &&
            abs(other.size.height - other.size.height) < eps
    }
}

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

/// Replicates the frame calculation performed by UIKit for views.
func computeFrame(bounds: CGRect,
                  center: CGPoint,
                  anchorPoint: CGPoint,
                  tranform: CGAffineTransform) -> CGRect {
    let absoluteTransform = CGAffineTransform(
            translationX: -anchorPoint.x * bounds.width,
            y: -anchorPoint.y * bounds.height
        )
        .concatenating(tranform)
        .concatenating(CGAffineTransform(translationX: center.x, y: center.y))

    let zeroOriginBounds = CGRect(origin: .zero, size: bounds.size)
    return CGRectApplyAffineTransform(zeroOriginBounds, absoluteTransform)
}
