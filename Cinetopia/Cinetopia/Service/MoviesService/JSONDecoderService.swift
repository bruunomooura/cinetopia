//
//  JSONDecoderService.swift
//  Cinetopia
//
//  Created by Bruno Moura on 01/08/24.
//

import Foundation

final class JSONDecoderService {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
