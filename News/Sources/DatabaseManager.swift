//
//  DatabaseManager.swift
//  News
//
//  Created by Bilal Durnagöl on 2.11.2020.
//

import Foundation
import FirebaseFirestore


class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    func safeArticleURL(articleURL: String) -> String {
        let safeURL = articleURL.replacingOccurrences(of: "/", with: "_")
        return safeURL
    }
    
    
}

extension DatabaseManager {
    
    public func isExistArticle(with articles: [Article], completion: @escaping (Bool) -> ()) {
        
        for arcticle in articles {
            let safeURL = safeArticleURL(articleURL: arcticle.url!)
            db.collection("articlesURL").document(safeURL).getDocument(completion: { document, error in
                if let document = document, document.exists {
                    print(document.get("readCounter"))
                    completion(true)
                } else {
                    
                    print("Document does not exist")
                    completion(false)
                }
            })
        }
    }
    
    public func addArticle(with articles: [Article], completion: @escaping (Bool) ->()) {
        for article in articles {
            let articleURL = article.url!
            let safeURL = safeArticleURL(articleURL: articleURL)
            
            let data = ["title": article.title!,
                        "publishedAt": article.publishedAt!,
                        "urlToImage": article.urlToImage!,
                        "description": article.description!,
                        "name": article.source?.name ?? "News",
                        "readCounter": 0] as [String: Any]
            
            db.collection("articlesURL").document(safeURL).setData(data, merge: true, completion: {error in
                if error == nil {
                    print("OK! Added articleURL")
                    completion(true)
                } else {
                    print("\(error?.localizedDescription)")
                    completion(false)
                }
            })
        }
    }
    
    public func getFeaturedArticle(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        var maxRead = 0
        var featuredArticle: [String: Any]?
        db.collection("articlesURL").addSnapshotListener({snapshot, error in
            if error != nil {
                completion(.failure(DatabaseError.failedToFetch))
            } else {
                for document in snapshot!.documents {
                    guard let readCount = document.get("readCounter") as? Int else {
                        return
                    }
                    if readCount > maxRead {
                        maxRead = readCount
                        featuredArticle = document.data()
                    }
                }
                completion(.success(featuredArticle!))
            }
        })
    }
}

/*
 self.articleTitleLabel.text = model.title
 self.articlePublishedAtLabel.text = model.publishedAt?.stringToPublishedAt()
 self.articleImageView.sd_setImage(with: URL(string: model.urlToImage ?? ""), completed: nil)
 self.articleContentLabel.attributedText = NSMutableAttributedString(string: model.description ?? "nil")
 self.navBarTitle.text = model.source?.name
 */


extension DatabaseManager {
    //Errors
    enum DatabaseError: Error {
        case failedToFetch
    }
}
