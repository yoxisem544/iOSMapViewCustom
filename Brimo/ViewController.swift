//
//  ViewController.swift
//  Brimo
//
//  Created by David on 2015/2/4.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Social

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var manager: CLLocationManager!

    @IBOutlet var map: MKMapView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // handle facebook post
    
    @IBAction func PostToFaceBook(sender: AnyObject) {
        println("post to facebook")
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            println("ava")
            var slv: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            slv.setInitialText("Testing facebook posting")
            slv.addImage(UIImage(named: "BRIMO_ICON.png"))
            
            self.presentViewController(slv, animated: true, completion: {println("present view")})
        } else {
            println("not ava")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // location manager
        manager = CLLocationManager()
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 7.0
        manager.requestWhenInUseAuthorization()
        
        // map settings
        self.map.delegate = self
        
        //locate user position
        self.map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
//        self.setNeedsStatusBarAppearanceUpdate()
    }
    

    @IBAction func LongPressToAddPin(sender: UILongPressGestureRecognizer) {
        
        if sender.state != UIGestureRecognizerState.Ended {
            println("still pressing")
        }
        
        if sender.state == UIGestureRecognizerState.Began{
            // add pin
            var touchPoint: CGPoint = sender.locationInView(self.map) // get touch point
            var touchOnMap: CLLocationCoordinate2D = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map) // turn into point on screen
            var pa: MKPointAnnotation = MKPointAnnotation()
            pa.coordinate = touchOnMap
            pa.title = "hi"
            
            self.map.addAnnotation(pa)
        }
    }
    
    // map annotation region
    
    // is new annotation added to map
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        // when adding a annotation
        for annotationView in views {
            if annotationView.isKindOfClass(MKAnnotationView) {
                // 這裡必須參考 道MKAnnotationView，才能對annotation動作。
                var a: MKAnnotationView = annotationView as MKAnnotationView
                
                if a.annotation.isKindOfClass(MKUserLocation) {
                    println("this is user location")
                } else {
                    var endFrame = annotationView.frame;
                    var a: MKAnnotationView = annotationView as MKAnnotationView
                    a.frame = CGRectOffset(endFrame, 0, -300)
                    UIView.animateWithDuration(0.5, animations: { a.frame = endFrame })
                }
            }
        }
    }
    
    // customize pin
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil;
        }
        
        var annView = mapView.dequeueReusableAnnotationViewWithIdentifier("yo")
        
//        if annView.isKindOfClass(MKAnnotationView) {
//            annView.annotation = annotation
//        } else {
//            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "yo")
//        }
        if annView == nil {
            println("enter null class")
            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "yo")
        } else {
            println("assigning annotation")
            annView.annotation = annotation
        }
        
        annView.annotation = annotation
        
        annView.image = UIImage(named: "BRIMO_ICON.png")
        annView.canShowCallout = true
        annView.draggable = true
        annView.layer.anchorPoint = CGPointMake(0.5, 1)
        
        println("returning annView")
        return annView
    }
    
    // is pin's draggin? set drag state and animation here
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == MKAnnotationViewDragState.Starting {
            println("drag staring")
            var originPosition: CGRect = view.frame, endPostion: CGRect, dropPosition: CGRect;
            dropPosition = CGRectOffset(originPosition, 0, +10)
            endPostion = CGRectOffset(originPosition, 0, -50-10)
            
            // drop down animation
            UIView.animateWithDuration(0.1, animations: { view.frame = dropPosition })
            // go up animation
            UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionNone, animations: { view.frame = endPostion }, completion: nil)
        }
        
        if newState == MKAnnotationViewDragState.Canceling {
            println("drag cancel")
            // just go down
            var origin = view.frame, endPosition: CGRect
            endPosition = CGRectOffset(origin, 0, 50)
            UIView.animateWithDuration(0.5, animations: { view.frame = endPosition })
            view.dragState = MKAnnotationViewDragState.None
        }
        
        if newState == MKAnnotationViewDragState.Ending {
            println("drag ending")
            var originPosition: CGRect = view.frame, jumpPosition: CGRect;
            jumpPosition = CGRectOffset(originPosition, 0, -25)
            
            // go up animation
            UIView.animateWithDuration(0.3, animations: { view.frame = jumpPosition })
            // go down animation
            UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: { view.frame = originPosition }, completion: nil)
            // set to not dragging state
            view.dragState = MKAnnotationViewDragState.None
        }
        if newState == MKAnnotationViewDragState.None {
            println("drag none")
        }
        if newState == MKAnnotationViewDragState.Dragging {
            println("drag dragging")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

