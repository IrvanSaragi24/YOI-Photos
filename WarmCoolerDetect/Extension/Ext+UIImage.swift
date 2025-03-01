//
//  Ext+UIImage.swift
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    func forcePortraitOrientation() -> UIImage {
        let isLandscape = size.width > size.height
        guard isLandscape else { return self.fixOrientation() }
        
        let newSize = CGSize(width: size.height, height: size.width)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // Rotate and flip the image
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: .pi/2)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(
            x: -size.width/2,
            y: -size.height/2,
            width: size.width,
            height: size.height
        )
        
        context.draw(cgImage!, in: rect)
        let portraitImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return portraitImage
    }
}
