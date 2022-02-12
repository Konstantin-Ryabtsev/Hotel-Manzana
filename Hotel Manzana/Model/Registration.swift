//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Konstantin Ryabtsev on 12.02.2022.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType?
    var wifi: Bool
}
