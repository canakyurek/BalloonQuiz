//
//  SKTextureExtension.swift
//  Magic Wordz
//
//  Created by Can Akyurek on 15.07.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import SpriteKit

extension SKTexture {
    convenience init(size: CGSize, color1: CIColor,
                     color2: CIColor) {
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector
        
        filter!.setDefaults()
        
        startVector = CIVector(x: size.width * 0.5, y: 0)
        endVector = CIVector(x: size.width * 0.5, y: size.height)
        
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        
        let image = context.createCGImage(filter!.outputImage!,
                                          from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(cgImage: image!)
    }
}
