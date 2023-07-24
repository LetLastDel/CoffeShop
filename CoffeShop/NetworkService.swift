//
//  NetworkService.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 18.07.2023.
//

import Foundation
import UIKit


class NetworkService {
    static let shared = NetworkService(); private init() { }
    func downloadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw NetworkErrror.badUrl}
        
        let responce = try await URLSession.shared.data(from: url)
        let data = responce.0
        
        guard let image = UIImage(data: data) else { throw NetworkErrror.invalidImage}
        return image
    }
    
    
}
enum NetworkErrror: Error{
    case badUrl
    case invalidImage
}
