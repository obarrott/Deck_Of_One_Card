//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Owen Barrott on 9/22/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import Foundation
import UIKit.UIImage

class CardController{
    
    static let baseURL = URL(string:"https://deckofcardsapi.com/api/deck/new/draw")
    
    static func fetchCard(completion: @escaping (Result<Card, CardError>) -> Void) {
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.invalidData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else {return completion(.failure(.invalidData))}
                return completion(.success(card))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result<UIImage, CardError>) -> Void) {
        
        let imageURL = card.image
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
        
            guard let data = data else {return completion(.failure(.invalidData))}
        
            guard let image = UIImage(data: data) else {return completion(.failure(.invalidData))}
            
            return completion(.success(image))
        }.resume()
    }
}
