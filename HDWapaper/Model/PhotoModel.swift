//
//  PhotoModel.swift
//  HDWapaper
//
//  Created by BAC Vuong Toan (VTI.Intern) on 2/24/21.
//

import Foundation

struct Flickr: Codable {
    var photos: Photos
}

struct Photos: Codable {
    var photo: [Photo]
}

struct Photo: Codable {
    var id: String
    var title: String
    var url_l: String
}
