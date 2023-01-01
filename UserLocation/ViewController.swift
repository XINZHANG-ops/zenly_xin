//
//  ViewController.swift
//  UserLocation
//
//  Created by Xin Zhang on 2022-12-30.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    var currentAnnotation:AnnotationPin!
    
    var headingImageView: UIImageView?
    var ifTab = false
    
    
    @IBOutlet weak var ifCenterBotton: UIButton!
    @IBAction func ifCenter(_ sender: Any) {
        centerMyView()
    }
    
    @IBOutlet weak var showFetch: UILabel!
    
    //    @IBAction func ifFetch(_ sender: Any) {
    //        createLandMark()
    //    }
    @IBOutlet weak var ifSendData: UISwitch!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var myHeading: UILabel!
    
    @IBOutlet weak var myLat: UILabel!
    
    @IBOutlet weak var myLong: UILabel!
    
    
    override func viewDidLoad() {
        FirebaseApp.configure()
        super.viewDidLoad()
        // set the view start from transparent when load into memory
        self.view.alpha = 0.0
        // locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // minimal degree to detect
        locationManager.headingFilter = 10
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        //        mapView.setUserTrackingMode(.followWithHeading, animated: false)
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        // mapView.mapType = .satellite
//        let trackingButton = MKUserTrackingButton(mapView: mapView)
//        trackingButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
//        trackingButton.layer.borderColor = UIColor.white.cgColor
//        trackingButton.layer.borderWidth = 1
//        trackingButton.layer.cornerRadius = 5
//        trackingButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(trackingButton)
//
//        // Constraints to center the tracking button
//        let trackingButtonConstraints = [
//            trackingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            trackingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
//        ]
//        NSLayoutConstraint.activate(trackingButtonConstraints)
        
        
//        let walmartPin = MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 43.47029077475355, longitude: -80.51586408851273), title: "walwart", subtitle: "walwart")
//
//        var currentPin = AnnotationPin(coordinate: mapView.userLocation.coordinate, title: "walwart", subtitle: "walwart", image: UIImage(named: "huihui")!)
//        mapView.addAnnotation(walmartPin)
//        mapView.addAnnotation(currentPin)

    }
    
    // this zoom in first location when app appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5){
            self.view.alpha = 1.0
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    // this add own pic as the pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: currentAnnotation, reuseIdentifier: "MyLoc")
        annotationView.image = UIImage(named: "huihui")
        let transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        annotationView.transform = transform
        return annotationView
    }
    
    
    // this update info from current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if ifSendData.isOn{
            upLoadLocationInfo()
        }
        myLat.text = String("\(location.coordinate.latitude)")
        myLong.text = String("\(location.coordinate.longitude)")

    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if ifSendData.isOn{
            upLoadLocationInfo()
        }
        myHeading.text = String("\(locationManager.heading!.trueHeading)")
    }
    
    
    // this give the icon bouncy effect
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            // Add a scaling and position animation to the annotation view
            let scale = CAKeyframeAnimation(keyPath: "transform.scale")
            scale.values = [0.3, 0.4, 0.3]
            scale.keyTimes = [0, 0.5, 1]
            scale.duration = 1
            scale.repeatCount = .infinity
            scale.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
            view.layer.add(scale, forKey: "scale")
        }
    }
    
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //        // Pause the scaling and position animations of the selected annotation view
    //        let pausedTime = view.layer.convertTime(CACurrentMediaTime(), from: nil)
    //        view.layer.speed = 0
    //        view.layer.timeOffset = pausedTime
    //    }
    //
    //    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    //        // Resume the scaling and position animations of the deselected annotation view
    //        let pausedTime = view.layer.timeOffset
    //        view.layer.speed = 1
    //        view.layer.timeOffset = 0
    //        view.layer.beginTime = 0
    //    }
    
    
    func centerMyView() {
        let defaultValue = 150.0
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: defaultValue, longitudinalMeters: defaultValue)
        mapView.setRegion(region, animated: true)
    }
    
    func upLoadLocationInfo() {
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS AM"
        let currentDateTime = dateFormatter.string(from: Date())
        ref.child("xin").setValue([
            "longitude": locationManager.location!.coordinate.longitude,
            "latitude": locationManager.location!.coordinate.latitude,
            "heading": locationManager.heading!.trueHeading,
            "TimeStamp": currentDateTime
        ])
    }
    
    //    func createLandMark() {
    //        let ref = Database.database().reference(withPath: "walmart")
    //
    //        ref.observe(.value, with: {
    //            snapshot in
    //            let value = snapshot.value as! NSDictionary
    //            let latitude = value["latitude"] ?? ""
    //            let longitude = value["longitude"] ?? ""
    //            self.landmarkpin.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
    //            self.landmarkpin.image = UIImage(named: "arrow")
    //        })
    //        mapView.addAnnotation(landmarkpin)
    //
    //
    //        showFetch.text = timeRef.
    //    }
    
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1
            return circleRenderer
            }

            return MKOverlayRenderer()
            }

            
    
}
