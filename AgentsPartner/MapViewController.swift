//
//  MapViewController.swift
//  Agents Partner
//
//  Created by Mohaiminul Islam on 5/18/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  let kDistanceMeters: CLLocationDistance = 500
  
  var locationManager = CLLocationManager()
  var userLocated = false
  var lastAnnotation: MKAnnotation!
  
  //MARK: - Helper Methods
  
  func centerToUsersLocation() {
    let center = mapView.userLocation.coordinate
    let zoomRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, kDistanceMeters, kDistanceMeters)
    mapView.setRegion(zoomRegion, animated: true)
  }
  
  func addNewPin() {
    if lastAnnotation != nil {
      let alertController = UIAlertController(title: "Annotation already dropped", message: "There is an annotation on screen. Try dragging it if you want to change its location!", preferredStyle: .Alert)
      let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) { alert in
        alertController.dismissViewControllerAnimated(true, completion: nil)
      }
      alertController.addAction(alertAction)
      presentViewController(alertController, animated: true, completion: nil)
      
    } else {
      let specimen = SpecimenAnnotation(coordinate: mapView.centerCoordinate, title: "Empty", subtitle: "Uncategorized")
      
      mapView.addAnnotation(specimen)
      lastAnnotation = specimen
    }
  }
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(Realm.Configuration.defaultConfiguration.path!)
    title = "Map"
    
    locationManager.delegate = self
    
    if CLLocationManager.authorizationStatus() == .NotDetermined {
      locationManager.requestWhenInUseAuthorization()
    } else {
      locationManager.startUpdatingLocation()
    }
  }
  
  //MARK: - Actions & Segues
  
  @IBAction func centerToUserLocationTapped(sender: AnyObject) {
    centerToUsersLocation()
  }
  
  @IBAction func addNewEntryTapped(sender: AnyObject) {
    addNewPin()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "NewEntry") {
      let controller = segue.destinationViewController as! AddNewEntryController
      let specimenAnnotation = sender as! SpecimenAnnotation
      controller.selectedAnnotation = specimenAnnotation
    }
  }
  
  @IBAction func unwindFromAddNewEntry(segue: UIStoryboardSegue) {
    if let lastAnnotation = lastAnnotation {
      mapView.removeAnnotation(lastAnnotation)
    }
    
    lastAnnotation = nil
  }
  
}

//MARK: - CLLocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    status != .NotDetermined ? mapView.showsUserLocation = true : print("Authorization to use location data denied")
  }
}

//MARK: - MKMapview Delegate
extension MapViewController: MKMapViewDelegate {
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

    guard let subtitle = annotation.subtitle! else { return nil }
    
    if (annotation is SpecimenAnnotation) {
      if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(subtitle) {
        return annotationView
      } else {
        
        let currentAnnotation = annotation as! SpecimenAnnotation
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: subtitle)
        
        switch subtitle {
        case "Uncategorized":
          annotationView.image = UIImage(named: "IconUncategorized")
        case "Arachnids":
          annotationView.image = UIImage(named: "IconArachnid")
        case "Birds":
          annotationView.image = UIImage(named: "IconBird")
        case "Mammals":
          annotationView.image = UIImage(named: "IconMammal")
        case "Flora":
          annotationView.image = UIImage(named: "IconFlora")
        case "Reptiles":
          annotationView.image = UIImage(named: "IconReptile")
        default:
          annotationView.image = UIImage(named: "IconUncategorized")
        }
        
        annotationView.enabled = true
        annotationView.canShowCallout = true
        let detailDisclosure = UIButton(type: UIButtonType.DetailDisclosure)
        annotationView.rightCalloutAccessoryView = detailDisclosure
        
        if currentAnnotation.title == "Empty" {
          annotationView.draggable = true
        }
        
        return annotationView
      }
    }
    return nil
    
    
  }
  
  func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
    
    for annotationView in views {
      if (annotationView.annotation is SpecimenAnnotation) {
        annotationView.transform = CGAffineTransformMakeTranslation(0, -500)
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveLinear, animations: {
          annotationView.transform = CGAffineTransformMakeTranslation(0, 0)
          }, completion: nil)
      }
    }
    
  }
  
  func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if let specimenAnnotation =  annotationView.annotation as? SpecimenAnnotation {
      performSegueWithIdentifier("NewEntry", sender: specimenAnnotation)
    }
  }
  
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
    if newState == .Ending {
      view.dragState = .None
    }
  }
}
