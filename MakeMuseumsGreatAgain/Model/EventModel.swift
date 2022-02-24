//
//  EventModel.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 19.11.21.
//

import Foundation

public enum Event: Codable {
    case showGame(gameEvent: GameEvent)
    case showARCamera
    case showAvatar
    case reload
    case dismiss
    case scroe(stars: Int)
    case read(message: String)
}

extension Event {
    var data: Data? {
      let encoder = JSONEncoder()
      return try? encoder.encode(self)
    }
}

