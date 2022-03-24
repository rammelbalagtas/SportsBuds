//
//  Post.swift
//  SportsBuds
//
//  Created by Rammel on 2022-03-15.
//

import Foundation
import UIKit
import MapKit

struct Post: Codable {
    let id: Int
    let title: String
//    let sport: String
    let description: String
    let location: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let date: Date?
}
