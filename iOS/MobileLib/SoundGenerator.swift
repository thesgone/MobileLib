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
import AudioToolbox
import AVFoundation

public class SoundGenerator : NSObject {
    
    var audioPlayer : AVAudioPlayer?

    public func play(soundName : MLString, ofType : MLString?, delegate : AVAudioPlayerDelegate){
        
        SoundGenerator.playBundleSound(soundName, ofType: ofType)
    }
    
    public func stop(){
        if(self.audioPlayer != nil){
            self.audioPlayer!.stop()
        }
    }
    
 
    public class func playBundleSound(soundName : MLString, ofType : MLString?){
        
        let filePath = NSBundle.mainBundle().pathForResource(soundName, ofType: ofType)
        playSound(filePath!)
    }
    
    public class func playSystemSoundToc(){
        AudioServicesPlaySystemSound(1306)
    }
    
    public class func vibrate(){
        AudioServicesPlaySystemSound(1352)
    }
    
    private class func playSound(path : MLString){
        let fileURL = NSURL(fileURLWithPath: path)
        var soundID : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileURL, &soundID)
        AudioServicesPlaySystemSound(soundID)

    }
}
