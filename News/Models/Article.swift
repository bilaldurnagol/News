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
    var title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Decodable, Any {
    let id: String?
    let name: String?
}


struct Topics {
    var topicArray: [String]
}
