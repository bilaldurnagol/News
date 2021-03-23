![GitHub all releases](https://img.shields.io/github/downloads/bilaldurnagol/News/total?logo=Github&style=flat-square)
![GitHub language count](https://img.shields.io/github/languages/count/bilaldurnagol/News)
![GitHub followers](https://img.shields.io/github/followers/bilaldurnagol?style=social)
![GitHub forks](https://img.shields.io/github/forks/bilaldurnagol/News?style=social)
![GitHub Repo stars](https://img.shields.io/github/stars/bilaldurnagol/News?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/bilaldurnagol/News?style=social)
![Twitter Follow](https://img.shields.io/twitter/follow/bilaldurnagol?style=social)

<!-- PROJECT LOGO -->
<br />
<p align="center">
   <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift">
    <img src="githubImage/logo.png" alt="Logo" width="60" height="60">
  </a>

  <h3 align="center">News App Swift</h3>

  <p align="center">
    With this project, I focused on the Request library, JSON and RESTFul App.
    <br />
    <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift">View Demo</a>
    ·
    <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift/issues">Report Bug</a>
    ·
    <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift/issues">Request Feature</a>
  </p>
</p>


<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#Requirements">Requirements</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

 It is an application where you can read current news according to location and categories.
 It has been disconnected from the server so that it does not send many requests.

   <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift">
    <img src="githubImage/screenshot_1.png" alt="Logo" width="300" height="600">
  </a>
   <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift">
    <img src="githubImage/screenshot_2.png" alt="Logo" width="300" height="600">
  </a>
     <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift">
    <img src="githubImage/screenshot_3.png" alt="Logo" width="300" height="600">
  </a>
   <a href="https://github.com/bilaldurnagol/PhotoFilterRxSwift">
    <img src="githubImage/screenshot.jpg" alt="Logo" width="300" height="600">
  </a>


Here's why:
* To learn Request and JSON
* To learn how to restful application

### Built With

The frameworks I used in this project are listed below.
* Nil

<!-- GETTING STARTED -->
## Getting Started

 This is an example of how you may give instructions on setting up your project locally. To get a local copy up and running follow these simple example steps.

### Requirements

* Xcode 12.x
* Swift 5.x

### Installation
There is no external library.

<!-- USAGE EXAMPLES -->
## Usage

<table>
  <tr>
    <th width="30%">Here's an example</th>
  </tr>
  <tr>
    <td>Get all articles...</td>
  </tr>
  <tr>
    <td><div class="highlight highlight-source-swift"><pre>
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
  </tr>
</table>


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact
   <a href="https://twitter.com/bilaldurnagol">
  <img align="left" alt="Bilal Durnagöl | Twitter" width="21px" src="https://raw.githubusercontent.com/anuraghazra/anuraghazra/master/assets/twitter.svg"/>
</a>

   <a href="https://medium.com/@BilalDurnagol">
  <img align="left" alt="Bilal Durnagöl | Medium" width="21px" src="https://github.com/leungwensen/svg-icon/blob/master/dist/svg/logos/medium.svg"/>
</a>

   <a href="https://www.instagram.com/bilaldurnagol/">
  <img align="left" alt="Bilal Durnagöl | Instagram" width="21px" src="https://github.com/shgysk8zer0/logos/blob/master/instagram.svg"/>
</a>

   <a href="https://www.linkedin.com/in/bilaldurnagol">
  <img align="left" alt="Bilal Durnagöl | LinkedIn" width="21px" src="https://github.com/shgysk8zer0/logos/blob/master/linkedin.svg"/>
</a>
<br/>
<br/>
  

Project Link: [https://github.com/bilaldurnagol/News](https://github.com/bilaldurnagol/News)
