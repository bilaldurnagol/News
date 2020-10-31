//
//  ArticleViewModel.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import Foundation

struct ArticleListViewModel {
    let articles: [Article]
}

//table funcs
extension ArticleListViewModel {
    
    var numberOfSection: Int {
        return 3
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.articles.count
    }
    
    func articleAtIndex(_ index: Int) -> Article {
        let article = articles[index]
        return article
    }
}

struct ArticleViewModel {
    let article: Article
}


