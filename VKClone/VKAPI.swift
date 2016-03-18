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