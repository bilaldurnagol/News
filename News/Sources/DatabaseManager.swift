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
}

extension DatabaseManager {
    
    public func isExistArticle(with articles: [Article], completion: @escaping (Bool) -> ()) {
        
        for article in articles {
            
            guard let articleURL = article.url else {
                return
            }
            db.collection("articlesURL").document((articleURL.safeURL())).getDocument(completion: { document, error in
                if let document = document, document.exists {
                    print(document.get("readCounter")!)
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
            
            guard let title = article.title,
                  let publishedAt = article.publishedAt,
                  let urlToImage = article.urlToImage,
                  let description = article.description,
                  let name = article.source?.name,
                  let url = article.url else {
                return
            }
            let data:[String: Any] = ["title": title,
                                      "publishedAt": publishedAt,
                                      "urlToImage": urlToImage,
                                      "description": description,
                                      "name": name,
                                      "url": url,
                                      "readCounter": 0]
            
            db.collection("articlesURL").document(articleURL.safeURL()).setData(data, merge: true, completion: {error in
                if error == nil {
                    print("OK! Added articleURL")
                    completion(true)
                } else {
                    print(DatabaseError.failedToSet)
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
                    if readCount >= maxRead {
                        maxRead = readCount
                        featuredArticle = document.data()
                    }
                }
                completion(.success(featuredArticle ?? ["":""]))
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
        case failedToSet
    }
}
