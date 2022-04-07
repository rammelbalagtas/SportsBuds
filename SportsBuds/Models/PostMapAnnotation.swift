//
//  PostMapAnnotation.swift
//  SportsBuds
//
//  Created by Rammel on 2022-04-07.
//

import Foundation
import MapKit

class PostMapAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String
    
    init(title: String?, coordinate: CLLocationCoordinate2D, info: String){
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
}
