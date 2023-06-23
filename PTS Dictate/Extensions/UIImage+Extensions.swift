//
//  UIImage+Extensions.swift
//  PTS Dictate
//
//  Created by Swaraj Samanta on 20/05/23.
//

import Foundation
extension UIImage {


    func scaled(to size: CGSize, scale displayScale: CGFloat = UIScreen.main.scale) -> UIImage {
        let format = UIGraphicsImageRendererFormat.preferred()
        format.scale = displayScale
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
