//
//  EventModel.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import Foundation

public enum Event: Codable {
    case showGame
    case showARCamera
    case showAvatar
    case read(message: String)
}

extension Event {
    var data: Data? {
      let encoder = JSONEncoder()
      return try? encoder.encode(self)
    }
}
