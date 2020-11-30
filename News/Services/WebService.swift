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
    
    //MARK: - USERS FUNCS
    
    //Create new user
    public func createUser(user: User, completion: @escaping (Result<User?, Error>) -> Void) {
        guard let name = user.name, let email = user.email, let location = user.location, let password = user.password else {return}
        
        let params = [
            "name": name,
            "email": email,
            "location": location,
            "password": password
        ] as [String: Any]
        do {
            guard let url = URL(string: "http://127.0.0.1:5000/register") else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            urlRequest.httpBody = data
            URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, reponse, error in
                guard let httpResponse = reponse as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    guard let jsonError = try? JSONDecoder().decode(RegisterError.self, from: data!) else {return}
                    let newError = WebServiceError.failedToRegister(jsonError.error)
                    completion(.failure(newError))
                    return
                }
                print(String(data: jsonData, encoding: .utf8)!)
                completion(.success(user))
            }).resume()
            
            
        } catch  {
            completion(.failure(WebServiceError.failedToFetch))
        }
    }
    
    //add topics
    public func addTopic(userEmail: String, topics: [String],  completion: @escaping (Bool) -> ()) {
        var params = [
            "topics": []
        ] as [String: Any]
        
        for topic in topics {
            let topicArray: [String: Any] = ["topic_name" : topic]
            var topicsArray = params["topics"] as? [[String: Any]] ?? [[String: Any]]()
            topicsArray.append(topicArray)
            params["topics"] = topicsArray
        }
        
        guard let url = URL(string: "http://127.0.0.1:5000/add_topics/\(userEmail)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        urlRequest.httpBody = data
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            
            completion(true)
        }).resume()
    }
    
    //login
    public func login(email: String, password: String, completion: @escaping (Result<UserInfo, Error>) -> ()) {
        let params = [
            "email": email,
            "password": password
        ] as [String: Any]
        
        let data = try? JSONSerialization.data(withJSONObject: params, options: .init())
        
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                guard let jsonError = try? JSONDecoder().decode(RegisterError.self, from: data!) else {return}
                completion(.failure( WebServiceError.failedToRegister(jsonError.error)))
                return
            }
            self.getUserInfo(with: email, completion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let userInfo):
                    completion(.success(userInfo))
                }
            })
        }).resume()
    }
    
    public func getUserInfo(with email: String , completion: @escaping (Result<UserInfo, Error>) ->()) {
        print(email)
        guard let url = URL(string: "http://127.0.0.1:5000/user_info/\(email)") else {return}
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(.failure(WebServiceError.failedToFetchUserInfo))
                return
            }
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data!)
            completion(.success(userInfo!))
        }).resume()
    }
}





extension WebService {
    //Errors
    enum WebServiceError: Error {
        case failedToFetch
        case failedToRegister(String)
        case failedToFetchUserInfo
    }
}

extension WebService.WebServiceError: LocalizedError {
    public var errorDescription: String? {
            switch self {
            case .failedToRegister(let error):
                return NSLocalizedString("\(error)", comment: "Error")
            case .failedToFetch:
                return NSLocalizedString("Verileri çekerken bir hata oluştu", comment: "failedToFetch")
            case .failedToFetchUserInfo:
                return NSLocalizedString("Haber konularını çekerken hata oluştu", comment: "failedToFetchUserInfo")
            }
        }
}

struct RegisterError: Decodable {
    let error: String
}



//    public func addUser(name: String, username: String, email: String, password: String, topics: [String], completion: @escaping (Bool) -> ()){
//        guard let url = URL(string: "http://127.0.0.1:5000/register") else {return}
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        var params = [
//            "name": name,
//            "username": username,
//            "email": email,
//            "password": password,
//            "topics": []
//
//        ] as [String : Any]
//
//        for topic in topics {
//            let topics: [String: Any] = ["topic_name" : topic ]
//            var topicsArray = params["topics"] as? [[String: Any]] ?? [[String: Any]]()
//            topicsArray.append(topics)
//            params["topics"] = topicsArray
//        }
//        do {
//            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
//
//            urlRequest.httpBody = data
//            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
//
//            URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
//                guard data != nil else {return}
//                completion(true)
//            }).resume()
//        } catch  {
//            completion(false)
//        }
//    }
