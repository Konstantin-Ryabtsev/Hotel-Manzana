//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Konstantin Ryabtsev on 12.02.2022.
//

import Foundation

struct Registration: Codable {
    var firstName: String
    var lastName: String
    var emailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType?
    var wifi: Bool
    
    init(firstName: String, lastName: String, emailAdress: String, checkInDate: Date, checkOutDate: Date, numberOfAdults: Int, numberOfChildren: Int, roomType: RoomType, wifi: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAdress = emailAdress
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.numberOfAdults = numberOfAdults
        self.numberOfChildren = numberOfChildren
        self.roomType = roomType
        self.wifi = wifi
    }
    
    init() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        
        self.firstName = ""
        self.lastName = ""
        self.emailAdress = ""
        self.checkInDate = midnightToday
        self.checkOutDate = midnightToday
        self.numberOfAdults = 1
        self.numberOfChildren = 0
        self.wifi = true
    }
}

extension Registration {
    static var all: [Registration] {
        return [
            Registration(
                firstName: "Ivan",
                lastName: "Ivanov",
                emailAdress: "ivan@ivanov.com",
                checkInDate: Date(timeIntervalSince1970: 0),
                checkOutDate: Date(timeIntervalSince1970: 60 * 60 * 24),
                numberOfAdults: 2,
                numberOfChildren: 1,
                roomType: RoomType.all[0],
                wifi: true),
            Registration(
                firstName: "Petr",
                lastName: "Petrov",
                emailAdress: "petr@petrov.ru",
                checkInDate: Date(timeIntervalSinceReferenceDate: 0),
                checkOutDate: Date(timeIntervalSinceReferenceDate: 2 * 60 * 60 * 24),
                numberOfAdults: 1,
                numberOfChildren: 0,
                roomType: RoomType.all[1],
                wifi: false),
        ]
    }
    
    static func loadDefaults() -> [Registration] {
        return all
    }
}

extension Registration {
    var fullName: String {
        let additionalGuests: String = numberOfAdults - 1 > 0 ? "+\(numberOfAdults - 1)" : ""
                
        return "\(firstName) \(lastName) \(additionalGuests)"
    }
    
    static func getFormatedDate(from date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.locale = Locale.current
        
        return dateFormater.string(from: date)
    }
    
    var registrationDesc: String {
        return "\(roomType?.name ?? "Not Set") from \(Registration.getFormatedDate(from: checkInDate)) till \(Registration.getFormatedDate(from: checkOutDate))"
    }
}
