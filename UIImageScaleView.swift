import Foundation
import UIKit

class UIImageScaleView: UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var MAX_SCALE_RADIO:CGFloat = 5.0
    var MIX_SCALE_RADIO:CGFloat = 0.5
    
    var lastScaleRadio:CGFloat!
    
    var imageView: UIImageView!
    
    var lastPanGestureLocation:CGPoint!
    
    init(frame: CGRect, image:UIImage) {
        super.init(frame: frame)
        NSLog("frame: \(frame)")
        self.backgroundColor = UIColor.blackColor()
        
        imageView = UIImageView(image: image)
        resizeImageView()
        self.addSubview(imageView)
        
        var scaleRadio = (imageView.frame.height / imageView.frame.width)
        self.setZoomScale(scaleRadio, animated: true)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "hide")
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        var pinGesture = UIPinchGestureRecognizer(target: self, action: "scale:")
        pinGesture.delegate = self
        self.addGestureRecognizer(pinGesture)
        
        var panGesture = UIPanGestureRecognizer(target: self, action: "move:")
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
    }
    
    func move(sender:UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            lastPanGestureLocation = sender.locationInView(self)
            return
        }
        
        var imageCenter = imageView.center
        let location = sender.locationInView(self)
        imageCenter.x += location.x - lastPanGestureLocation.x
        imageCenter.y += location.y - lastPanGestureLocation.y
        
        imageView.center = imageCenter
        lastPanGestureLocation = location
    }

    func scale(sender:UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            return
        }
        
        var scale:CGFloat = 1.0 - (lastScaleRadio - sender.scale)
        var currentTransform:CGAffineTransform = imageView.transform
        var newTransform:CGAffineTransform = CGAffineTransformScale(currentTransform, scale, scale)
        imageView.transform = newTransform
        lastScaleRadio = sender.scale
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resizeImageView() {
        var image = self.imageView.image
        if (self.frame.height / self.frame.width) > (image!.size.height / image!.size.width) {
            var height = image!.size.height * self.frame.width / image!.size.width
            var offsetY = (self.frame.height - height) / 2.0
            imageView.frame = CGRectMake(0.0, offsetY, self.frame.width, height)
        } else {
            var width = self.frame.height * image!.size.width / image!.size.height
            var offsetX = (self.frame.width - width) / 2.0
            imageView.frame = CGRectMake(offsetX, 0.0, width, self.frame.height)
        }

    }
    
    func setImage(image:UIImage) {
        self.imageView.image = image
        resizeImageView()
    }
    
    func hide() {
        self.hidden = true
    }
    
    func show() {
        self.hidden = false
    }
}
