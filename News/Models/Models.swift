//
//  Models.swift
//  News
//
//  Created by Bilal Durnagöl on 21.12.2020.
//

import Foundation

//MARK:- User model
struct User: Codable {
    let user_id: Int?
    var user_name: String?
    var user_email: String?
    var user_password: String?
    var user_location: String?
    let topics: [Topics]?
}
struct Topics: Codable {
    let topic_name: String?
}

//MARK:- Article model
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


//MARK:- Database message
struct DatabaseMessage: Decodable {
    let message: String?
}
