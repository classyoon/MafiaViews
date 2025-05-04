//
//  JSONLoadError.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//


// Add this to MafiaViews/Business/GameTextLoader.swift

import Foundation

enum JSONLoadError: Error {
    case fileNotFound
    case dataUnreadable
    case decodingFailed
}

struct GameText: Codable {
    let gameStart: [String]
    let nothingHappen: [String]
    let murder: [String]
    let night: [String]
    let tasks: [String]
}

func loadFlavorText() -> GameText? {
    do {
        guard let url = Bundle.main.url(forResource: "GameText", withExtension: "json") else {
            // For development, provide default values if JSON not found
            #if DEBUG
            print("⚠️ GameText.json not found. Using default values.")
            return GameText(
                gameStart: ["The game begins. Look for the Mafia among you."],
                nothingHappen: ["The night was quiet."],
                murder: ["Someone died last night..."],
                night: ["The town sleeps..."],
                tasks: ["Take your action"]
            )
            #else
            throw JSONLoadError.fileNotFound
            #endif
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONLoadError.dataUnreadable
        }

        return try JSONDecoder().decode(GameText.self, from: data)

    } catch {
        #if DEBUG
        print("⚠️ GameText loading failed with error: \(error)")
        #endif
        return nil
    }
}