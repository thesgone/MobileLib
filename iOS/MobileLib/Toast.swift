/*
This file is part of MobileLib, a free-software/open source library
for mobile app development.
MobileLib is free software: you can redistribute it and/or modify it
under the terms of the MobileLib license.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

import Foundation

func /(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}

/*
*  Toast Config
*/
public class ToastConfing{
    
    public enum Position{
        case Bottom
        case Top
        case Center
    }
    
    public var duration  =   3.0
    public var fadeDuration = 0.2
    public var horizontalMargin :CGFloat = 10.0
    public var verticalMargin :CGFloat = 10.0
    
    public var position = Position.Bottom
    
    public var toastActivityWidth : CGFloat = 100.0
    public var toastActivityHeight : CGFloat = 100.0
    
    public var toastImageViewWidth : CGFloat = 40.0
    public var toastImageViewHeight: CGFloat = 40.0
    public var toastImageViewCornerRadius : CGFloat = 10.0
    
    public var toastMaxWidth : CGFloat = 0.8;      // 80% of parent view width
    public var toastMaxHeight : CGFloat = 0.8;
    public var toastFontSize : CGFloat = 16.0
    public var toastMaxTitleLines = 0
    public var toastMaxMessageLines = 0
    
    public var toastShadowOpacity : CGFloat = 0.8
    public var toastShadowRadius : CGFloat = 6.0
    public var toastShadowOffset : CGSize = CGSizeMake(CGFloat(4.0), CGFloat(4.0))
    
    public var toastOpacity : CGFloat = 0.6
    public var toastCornerRadius : CGFloat = 10.0
    
    public var toastHidesOnTap = true
    public var toastDisplayShadow = true

}

var HRToastActivityView: UnsafePointer<UIView>    =   nil
var HRToastTimer: UnsafePointer<NSTimer>          =   nil

/*
*  Custom Config
*/
//let HRToastHidesOnTap       =   true
//let HRToastDisplayShadow    =   true

//HRToast (UIView + Toast using Swift)

public extension UIView {
    
    /*
    *  public methods
    */
    public func makeToast(message msg: String, toastConfing: ToastConfing, title: String?, image: UIImage?) {
        var toast = self.viewForMessage(msg, title: title, image: image, toastConfing : toastConfing)
        self.showToast(toast: toast!, toastConfing : toastConfing)
    }
    
    public func makeToast(message msg: String, duration : Double, position: ToastConfing.Position, title: String?, image: UIImage?) {
        let toastConfing = ToastConfing()
        toastConfing.duration = duration
        toastConfing.position = position
        self.makeToast(message: msg, toastConfing : toastConfing, title : title, image : image)
    }
    
    public func makeToast(message msg: String) {
        let duration = 3.0
        let position = ToastConfing.Position.Bottom
        self.makeToast(message : msg, duration: duration, position: position, title : nil, image : nil)
    }
    
    public func makeToast(message msg: String, duration: Double, position: ToastConfing.Position) {
        self.makeToast(message : msg, duration: duration, position: position, title : nil, image : nil)

    }
    
    public func makeToast(message msg: String, duration: Double, position: ToastConfing.Position, title: String) {
        self.makeToast(message : msg, duration: duration, position: position, title : title, image : nil)

    }
    
    public func makeToast(message msg: String, duration: Double, position: ToastConfing.Position, image: UIImage) {
        self.makeToast(message : msg, duration : duration, position: position, title : nil, image : image)
    }
    
   
    
    public func showToast(#toast: UIView) {
        let toastConfing = ToastConfing()
        self.showToast(toast: toast, toastConfing: toastConfing)
    }
    
    public func showToast(#toast: UIView, toastConfing : ToastConfing) {
        toast.center = self.centerPointForPosition(toastConfing, toast: toast)
        toast.alpha = 0.0
        
        if toastConfing.toastHidesOnTap {
            var tapRecognizer = UITapGestureRecognizer(target: toast, action: Selector("handleToastTapped:"))
            toast.addGestureRecognizer(tapRecognizer)
            toast.userInteractionEnabled = true;
            toast.exclusiveTouch = true;
        }
        
        self.addSubview(toast)
        
        UIView.animateWithDuration(toastConfing.fadeDuration,
            delay: 0.0, options: (.CurveEaseOut | .AllowUserInteraction),
            animations: {
                toast.alpha = 1.0
            },
            completion: { (finished: Bool) in
                var timer = NSTimer.scheduledTimerWithTimeInterval(toastConfing.duration, target: self, selector: Selector("toastTimerDidFinish:"), userInfo: toast, repeats: false)
                objc_setAssociatedObject(toast, &HRToastTimer, timer, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        })
    }
    
    func makeToastActivity() {
        let toastConfing = ToastConfing()
        self.makeToastActivity(toastConfing)
    }
    
    func makeToastActivityWithMessage(message msg: String){
        let toastConfing = ToastConfing()
        self.makeToastActivity(toastConfing, message: msg)
    }
    
    func makeToastActivity(toastConfing : ToastConfing, message msg: String = "") {
        var existingActivityView: UIView? = objc_getAssociatedObject(self, &HRToastActivityView) as? UIView
        if existingActivityView != nil { return }
        
        var activityView = UIView(frame: CGRectMake(0, 0, toastConfing.toastActivityWidth, toastConfing.toastActivityHeight))
        activityView.center = self.centerPointForPosition(toastConfing, toast: activityView)
        activityView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(toastConfing.toastOpacity)
        activityView.alpha = 0.0
        activityView.autoresizingMask = (.FlexibleLeftMargin | .FlexibleTopMargin | .FlexibleRightMargin | .FlexibleBottomMargin)
        activityView.layer.cornerRadius = toastConfing.toastCornerRadius
        
        if toastConfing.toastDisplayShadow {
            activityView.layer.shadowColor = UIColor.blackColor().CGColor
            activityView.layer.shadowOpacity = Float(toastConfing.toastShadowOpacity)
            activityView.layer.shadowRadius = toastConfing.toastShadowRadius
            activityView.layer.shadowOffset = toastConfing.toastShadowOffset
        }
        
        var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2)
        activityView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        if (!msg.isEmpty){
            activityIndicatorView.frame.origin.y -= 10
            var activityMessageLabel = UILabel(frame: CGRectMake(activityView.bounds.origin.x, (activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 10), activityView.bounds.size.width, 20))
            activityMessageLabel.textColor = UIColor.whiteColor()
            activityMessageLabel.font = (countElements(msg)<=10) ? UIFont(name:activityMessageLabel.font.fontName, size: 16) : UIFont(name:activityMessageLabel.font.fontName, size: 13)
            activityMessageLabel.textAlignment = .Center
            activityMessageLabel.text = msg
            activityView.addSubview(activityMessageLabel)
        }
        
        self.addSubview(activityView)
        
        // associate activity view with self
        objc_setAssociatedObject(self, &HRToastActivityView, activityView, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
        UIView.animateWithDuration(toastConfing.fadeDuration,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                activityView.alpha = 1.0
            },
            completion: nil)
    }
    
    func hideToastActivity(toastConfing : ToastConfing) {
        var existingActivityView: UIView? = objc_getAssociatedObject(self, &HRToastActivityView) as? UIView
        if existingActivityView == nil { return }
        UIView.animateWithDuration(toastConfing.fadeDuration,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                existingActivityView!.alpha = 0.0
            },
            completion: { (finished: Bool) in
                existingActivityView!.removeFromSuperview()
                objc_setAssociatedObject(self, &HRToastActivityView, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        })
    }
    
    /*
    *  private methods (helper)
    */
    func hideToast(#toast: UIView, toastConfing : ToastConfing) {
        UIView.animateWithDuration(toastConfing.fadeDuration,
            delay: 0.0,
            options: (.CurveEaseIn | .BeginFromCurrentState),
            animations: {
                toast.alpha = 0.0
            },
            completion: { (isFinished: Bool) in
                toast.removeFromSuperview()
                objc_setAssociatedObject(self, &HRToastActivityView, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        })
    }
    
    func toastTimerDidFinish(timer: NSTimer) {
        let toastConfing = ToastConfing()
        self.hideToast(toast: timer.userInfo as UIView, toastConfing: toastConfing)
    }
    
    func handleToastTapped(recognizer: UITapGestureRecognizer) {
        var timer = objc_getAssociatedObject(self, &HRToastTimer) as NSTimer
        timer.invalidate()
        let toastConfing = ToastConfing()
        self.hideToast(toast: recognizer.view!, toastConfing : toastConfing)
    }
    
    func centerPointForPosition(toastConfing: ToastConfing, toast: UIView) -> CGPoint {
            var toastSize = toast.bounds.size
            var viewSize  = self.bounds.size
        
        switch(toastConfing.position){
        case ToastConfing.Position.Top:
            return CGPointMake(viewSize.width/2, toastSize.height/2 + toastConfing.verticalMargin)
        case ToastConfing.Position.Bottom:
            return CGPointMake(viewSize.width/2, viewSize.height - toastSize.height/2 - toastConfing.verticalMargin)
        case ToastConfing.Position.Center:
            return CGPointMake(viewSize.width/2, viewSize.height/2)
        default:
            ML.fail(message: "Invalid position for toast")
        }
        return CGPoint()
    }
    
    func viewForMessage(msg: String?, title: String?, image: UIImage?, toastConfing : ToastConfing) -> UIView? {
        if msg == nil && title == nil && image == nil { return nil }
        
        var msgLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?
        
        var wrapperView = UIView()
        wrapperView.autoresizingMask = (.FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin | .FlexibleBottomMargin)
        wrapperView.layer.cornerRadius = toastConfing.toastCornerRadius
        wrapperView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(toastConfing.toastOpacity)
    
        if toastConfing.toastDisplayShadow {
            wrapperView.layer.shadowColor = UIColor.blackColor().CGColor
            wrapperView.layer.shadowOpacity = Float(toastConfing.toastShadowOpacity)
            wrapperView.layer.shadowRadius = toastConfing.toastShadowRadius
            wrapperView.layer.shadowOffset = toastConfing.toastShadowOffset
        }
        
        if image != nil {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .ScaleAspectFit
            imageView!.frame = CGRectMake(toastConfing.horizontalMargin, toastConfing.verticalMargin, CGFloat(toastConfing.toastImageViewWidth), CGFloat(toastConfing.toastImageViewHeight))
            imageView!.layer.cornerRadius = toastConfing.toastImageViewCornerRadius
            imageView!.clipsToBounds = true
            
        }
        
        var imageWidth: CGFloat, imageHeight: CGFloat, imageLeft: CGFloat
        if imageView != nil {
            imageWidth = imageView!.bounds.size.width
            imageHeight = imageView!.bounds.size.height
            imageLeft = toastConfing.horizontalMargin
        } else {
            imageWidth  = 0.0; imageHeight = 0.0; imageLeft   = 0.0
        }
        
        if title != nil {
            titleLabel = UILabel()
            titleLabel!.numberOfLines = toastConfing.toastMaxTitleLines
            titleLabel!.font = UIFont.boldSystemFontOfSize(toastConfing.toastFontSize)
            titleLabel!.textAlignment = .Left
            titleLabel!.lineBreakMode = .ByWordWrapping
            titleLabel!.textColor = UIColor.whiteColor()
            titleLabel!.backgroundColor = UIColor.clearColor()
            titleLabel!.alpha = 1.0
            titleLabel!.text = title
            
            // size the title label according to the length of the text
            var maxSizeTitle = CGSizeMake((self.bounds.size.width * toastConfing.toastMaxWidth) - imageWidth, self.bounds.size.height * toastConfing.toastMaxHeight);
            var expectedHeight = title!.stringHeightWithFontSize(toastConfing.toastFontSize, width: maxSizeTitle.width)
            titleLabel!.frame = CGRectMake(0.0, 0.0, maxSizeTitle.width, expectedHeight)
        }
        
        if msg != nil {
            msgLabel = UILabel();
            msgLabel!.numberOfLines = toastConfing.toastMaxMessageLines
            msgLabel!.font = UIFont.systemFontOfSize(toastConfing.toastFontSize)
            msgLabel!.lineBreakMode = .ByWordWrapping
            msgLabel!.textAlignment = .Left
            msgLabel!.textColor = UIColor.whiteColor()
            msgLabel!.backgroundColor = UIColor.clearColor()
            msgLabel!.alpha = 1.0
            msgLabel!.text = msg
            
            var maxSizeMessage = CGSizeMake((self.bounds.size.width * toastConfing.toastMaxWidth) - imageWidth, self.bounds.size.height * toastConfing.toastMaxHeight)
            var expectedHeight = msg!.stringHeightWithFontSize(toastConfing.toastFontSize, width: maxSizeMessage.width)
            msgLabel!.frame = CGRectMake(0.0, 0.0, maxSizeMessage.width, expectedHeight)
        }
        
        var titleWidth: CGFloat, titleHeight: CGFloat, titleTop: CGFloat, titleLeft: CGFloat
        if titleLabel != nil {
            titleWidth = titleLabel!.bounds.size.width
            titleHeight = titleLabel!.bounds.size.height
            titleTop = toastConfing.verticalMargin
            titleLeft = imageLeft + imageWidth + toastConfing.horizontalMargin
        } else {
            titleWidth = 0.0; titleHeight = 0.0; titleTop = 0.0; titleLeft = 0.0
        }
        
        var msgWidth: CGFloat, msgHeight: CGFloat, msgTop: CGFloat, msgLeft: CGFloat
        if msgLabel != nil {
            msgWidth = msgLabel!.bounds.size.width
            msgHeight = msgLabel!.bounds.size.height
            msgTop = titleTop + titleHeight + toastConfing.verticalMargin
            msgLeft = imageLeft + imageWidth + toastConfing.horizontalMargin
        } else {
            msgWidth = 0.0; msgHeight = 0.0; msgTop = 0.0; msgLeft = 0.0
        }
        
        var largerWidth = max(titleWidth, msgWidth)
        var largerLeft  = max(titleLeft, msgLeft)
        
        // set wrapper view's frame
        var wrapperWidth  = max(imageWidth + toastConfing.horizontalMargin * 2, largerLeft + largerWidth + toastConfing.horizontalMargin)
        var wrapperHeight = max(msgTop + msgHeight + toastConfing.verticalMargin, imageHeight + toastConfing.verticalMargin * 2)
        wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight)
        
        // add subviews
        if titleLabel != nil {
            titleLabel!.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight)
            wrapperView.addSubview(titleLabel!)
        }
        if msgLabel != nil {
            msgLabel!.frame = CGRectMake(msgLeft, msgTop, msgWidth, msgHeight)
            wrapperView.addSubview(msgLabel!)
        }
        if imageView != nil {
            wrapperView.addSubview(imageView!)
        }
        
        return wrapperView
    }
    
}

extension String {
    
    func stringHeightWithFontSize(fontSize: CGFloat,width: CGFloat) -> CGFloat {
        var font = UIFont.systemFontOfSize(fontSize)
        var size = CGSizeMake(width, CGFloat.max)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        var attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var text = self as NSString
        var rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
}