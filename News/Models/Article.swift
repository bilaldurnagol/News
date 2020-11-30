//
//  Article.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import Foundation


struct ArticleList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source?
    let author: String?
    let category: String?
    let content: String?
    let country: String?
    let description: String?
    let id: Int?
    let published_at: String?
    let read_count: Int?
    let title: String?
    let url: String?
    let url_to_image: String?

}

struct Source: Decodable, Any {
    let source_id: String?
    let source_name: String?
}


struct User: Codable {
    let name: String?
    let email: String?
    let location: String?
    let password: String?
    
}

struct Topic: Codable {
    var topic_name: String?
}


struct UserInfo: Decodable {
    let user_id: Int?
    let user_name: String?
    let user_email: String?
    let user_location: String?
    let topics: [Topics]?
}

struct Topics: Decodable {
    let topic_name: String?
}
