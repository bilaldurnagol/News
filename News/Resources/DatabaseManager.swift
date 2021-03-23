//
//  DatabaseManager.swift
//  News
//
//  Created by Bilal Durnagöl on 2.11.2020.
//

import Foundation


class DatabaseManager {
    static let shared = DatabaseManager()
    let localhost: String = "host"
    
    //MARK:- Account funcs
    
    // User login function
    public func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        let params = [
            "email": email,
            "password": password
        ]
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        
        guard let url = URL(string: "\(localhost)/login") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = data
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { [self]data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let message = try? JSONDecoder().decode(DatabaseMessage.self, from: data!)
                guard let error = message?.message else {return}
                completion(.failure(DatabaseManagerError.failedToLogin(error: error)))
                return
            }
            getUserInfo(email: email, completion: {result in
                switch result {
                case .failure(_):
                    completion(.failure(DatabaseManagerError.failedToGetUserInfo))
                case .success(let user):
                    completion(.success(user))
                }
            })
        }).resume()
    }
    //Get user info
    public func getUserInfo(email: String, completion: @escaping (Result<User, Error>) -> ()) {
        guard let url = URL(string: "\(localhost)/user_info/\(email)") else {return}
        
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(DatabaseManagerError.failedToGetUserInfo))
                return
            }
            guard let userInfo = try? JSONDecoder().decode(User.self, from: data!) else {return}
            completion(.success(userInfo))
        }).resume()
    }
    
    //Create user func
    public func createNewUser(user: User, completion: @escaping (Result<User, Error>) -> ()) {
        let params = [
            "user_name": user.user_name,
            "user_email": user.user_email,
            "user_password": user.user_password,
            "user_location": user.user_location
        ]
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        guard let url = URL(string: "\(localhost)/register") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = data
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let message = try? JSONDecoder().decode(DatabaseMessage.self, from: data!)
                guard let error = message?.message else {return}
                completion(.failure(DatabaseManagerError.failedToCreateNewUser(error: error)))
                return
            }
            let user = try? JSONDecoder().decode(User.self, from: data!)
            completion(.success(user!))
        }).resume()
    }
    
    //MARK:- Topic Funcs
    
    //add topics
    public func addTopic(email: String, chooseTopicsArray: [String], completion: @escaping (Result<String,Error>) -> ()) {
        var params = [
            "topics": []
        ]
        for topic in chooseTopicsArray {
            let topicArray = ["topic_name": topic]
            var topicsArray = params ["topics"]
            topicsArray!.append(topicArray)
            params["topics"] = topicsArray
        }
        print(params)
        
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        
        guard let url = URL(string: "\(localhost)/add_topics/\(email)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = data
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, _ in
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(.failure(DatabaseManagerError.failedToAddTopic))
                return
            }
            let message = try? JSONDecoder().decode(DatabaseMessage.self, from: data!)
            guard let safeMessage = message?.message else {return}
            completion(.success(safeMessage))
        }).resume()
    }
    
    //MARK:- Articles Funcs
    
    //Get all articles
    public func getArticles(url: String, completion: @escaping (Result<[Article]?, Error>) -> ()) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(DatabaseManagerError.failedToFetchArticles))
                return
            }
            let articles = try? JSONDecoder().decode(ArticleList.self, from: data)
            completion(.success(articles?.articles))
        }).resume()
    }
    
    //Get featured articles
    public func getFeaturedArticle(url: String, completion: @escaping (Result<[Article]?, Error>) -> ()) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(DatabaseManagerError.failedToFetchFeaturedArticles))
                return
            }
            let articles = try? JSONDecoder().decode(ArticleList.self, from: data)
            completion(.success(articles?.articles))
        }).resume()
    }
    //MARK:- Setting Funcs
    //Edit profile
    public func editProfile(userID: Int, userName: String, userEmail: String, userPassword: String, completion: @escaping (Bool)->()) {
        let params = [
            "name": userName,
            "email": userEmail,
            "password": userPassword
        ]
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        
        guard let url = URL(string: "\(localhost)/user_info_update/\(userID)") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = data
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {_, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }).resume()
    }
    
    //Update topics
    public func updateTopics(topics: [String], userID: Int, completion: @escaping (Bool) -> ()) {
        var params = [
            "topics": []
        ] as [String: Any]
        
        for topic in topics {
            let topicArray: [String: Any] = ["topic_name" : topic]
            var topicsArray = params["topics"] as? [[String: Any]] ?? [[String: Any]]()
            topicsArray.append(topicArray)
            params["topics"] = topicsArray
        }
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        
        guard let url = URL(string: "\(localhost)/update_topic/\(userID)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = data
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }).resume()
    }
    
    //Update Location
    public func updateLocation(user: User?, completion: @escaping (Bool) -> ()) {
        guard let location = user?.user_location, let id = user?.user_id else {return}
       let params = [
            "location": location
        ]
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        
        guard let url = URL(string: "\(localhost)/update_location/\(id)") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        urlRequest.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }).resume()
    }
}


//MARK:- Database Errors
extension DatabaseManager {
    enum DatabaseManagerError: Error {
        case failedToLogin(error: String)
        case failedToGetUserInfo
        case failedToCreateNewUser(error: String)
        case failedToAddTopic
        case failedToFetchArticles
        case failedToFetchFeaturedArticles
    }
}

extension DatabaseManager.DatabaseManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToLogin(error: let error):
            return NSLocalizedString("\(error)", comment: "Error")
        case .failedToGetUserInfo:
            return NSLocalizedString("Failed to get user info.", comment: "Error")
        case .failedToCreateNewUser(error: let error):
            return NSLocalizedString("\(error)", comment: "Error")
        case .failedToAddTopic:
            return NSLocalizedString("Failed add user's choose topics.", comment: "Error")
        case .failedToFetchArticles:
            return NSLocalizedString("Failed to get news.", comment: "Error")
        case .failedToFetchFeaturedArticles:
            return NSLocalizedString("Failed to get featured news.", comment: "Error")
        }
    }
}
