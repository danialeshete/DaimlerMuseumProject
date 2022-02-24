//
//  GameEvent.swift
//  MakeMuseumsGreatAgain
//
//  Created by Niklas Schildhauer on 15.12.21.
//

import Foundation

public enum GameEvent: Codable {
    case question(_: Question)
}

extension GameEvent {
    var data: Data? {
      let encoder = JSONEncoder()
      return try? encoder.encode(self)
    }
}

public struct Question: Codable {
    let text: String
    let answers: [Answer]
    let imageName: String?
}

extension Question {
    var data: Data? {
      let encoder = JSONEncoder()
      return try? encoder.encode(self)
    }
}

public struct Answer: Codable {
    let text: String
    let isTrue: Bool
}

extension Answer {
    var data: Data? {
      let encoder = JSONEncoder()
      return try? encoder.encode(self)
    }
}
