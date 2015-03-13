/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.
MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

import UIKit

public class ImageHelper: NSObject {
   
    public class func scaleImage(image:UIImage, newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    public class func imageFromBundle(imageName : MLString)->UIImage{
        
        return imageFromBundle(imageName, bundle: NSBundle.mainBundle())
        
    }
    
    public class func imageFromBundle(imageName : MLString, bundle : NSBundle)->UIImage{
        
        let filePath = bundle.pathForResource(imageName, ofType: nil)
        var image = UIImage(named: filePath!)
        return image!
        
    }
    
    public class func imageToNSData(image : UIImage )->NSData{
        
        let imageData:NSData = UIImagePNGRepresentation(image)

        return imageData
    }

}
