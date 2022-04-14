//
//  PostMapAnnotation.swift
//  SportsBuds
//
//  Created by Rammel on 2022-04-07.
//

import Foundation
import MapKit

class PostMapAnnotation : NSObject, MKAnnotation {
    
    let id: Int
    let title: String?
    let info: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: Int, title: String?, coordinate: CLLocationCoordinate2D, info: String){
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
}
