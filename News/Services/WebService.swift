//
//  WebService.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import Foundation


class WebService {
    static let shared = WebService()
}

extension WebService {
    //Get article data in url
    public func getArticles(url: URL, completion: @escaping (Result<[Article]?, Error>) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(WebServiceError.failedToFetch))
                return
            }
            let articles = try? JSONDecoder().decode(ArticleList.self, from: data)
            completion(.success(articles?.articles))
        }).resume()
    }
}

extension WebService {
    //Errors
    enum WebServiceError: Error {
        case failedToFetch
    }
}
