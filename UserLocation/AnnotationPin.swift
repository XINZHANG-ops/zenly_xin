//
//  AnnotationPin.swift
//  UserLocation
//
//  Created by Xin Zhang on 2022-12-30.
//

import MapKit

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
    }
}
