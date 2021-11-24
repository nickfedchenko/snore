//
//  Bundle-Decodable.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//

import Foundation

extension Bundle {

    
    func decodePayWallsText(_ file: String) -> [PayWallText]{
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        let loaded = try! decoder.decode([PayWallText].self, from: data)
        return loaded
    }
    
    func decodePayWallsText2(_ file: String) -> [PayWallText2]{
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        let loaded = try! decoder.decode([PayWallText2].self, from: data)
        return loaded
    }
    
}
