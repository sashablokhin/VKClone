//
//  VKAPI.swift
//  VKClone
//
//  Created by Alexander Blokhin on 18.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import Foundation


class VKAPI {
    static let sharedInstance = VKAPI()
    
    var accessToken: String?
    var userID: String?
}



class PostInfo: NSObject {
    var image: String?
    var title: String?
    var time: String?
    var text: String?
    var likes: String?
    var comments: String?
    var reposts: String?    
}