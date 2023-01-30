//
//  UIImage+extension.swift
//  PicGuess
//
//  Created by Sabina Huseynova on 30.01.23.
//

import Foundation
import UIKit

extension UIImage {
    
public func resized(to target: CGSize) -> UIImage {
//            let ratio = min(
//                target.height / size.height, target.width / size.width
//            )
//            let new = CGSize(
//                width: size.width * ratio, height: size.height * ratio
//            )
            let renderer = UIGraphicsImageRenderer(size: target)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: target))
            }
        }
    
}
