//
//  RoomType.swift
//  Hotel Manzana
//
//  Created by Konstantin Ryabtsev on 12.02.2022.
//

struct RoomType {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
}

extension RoomType: Equatable {
    static func == (lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}

extension RoomType {
    static var all: [RoomType] {
        return [
            RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
            RoomType(id: 1, name: "One King", shortName: "K", price: 209),
            RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309),
        ]
    }
}
