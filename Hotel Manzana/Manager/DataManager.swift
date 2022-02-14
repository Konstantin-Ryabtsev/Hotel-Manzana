//
//  DataManager.swift
//  Hotel Manzana
//
//  Created by Konstantin Ryabtsev on 15.02.2022.
//

import Foundation

class DataManager {
    var archiveURL: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentDirectory.appendingPathComponent("guestList").appendingPathExtension("plist")
    }
    
    func loadGuestList() -> [Registration]? {
        guard let archiveURL = archiveURL else { return nil }
        guard let encodedGuestList = try? Data(contentsOf: archiveURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Registration].self, from: encodedGuestList)
    }
    
    func saveGuestList(_ guestList: [Registration]) {
        guard let archiveURL = archiveURL else { return }
        
        let encoder = PropertyListEncoder()
        guard let encodedGuestList = try? encoder.encode(guestList) else { return }
        
        try? encodedGuestList.write(to: archiveURL, options: .noFileProtection)
    }
}
