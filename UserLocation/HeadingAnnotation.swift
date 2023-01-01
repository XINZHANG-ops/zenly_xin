//
//  AnnotationPin.swift
//  UserLocation
//
//  Created by Xin Zhang on 2022-12-30.
//

import MapKit

class HeadingAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var heading: Double
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, heading: Double) {
        self.title = "heading"
        self.subtitle = "heading"
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.heading = heading
    }
}
