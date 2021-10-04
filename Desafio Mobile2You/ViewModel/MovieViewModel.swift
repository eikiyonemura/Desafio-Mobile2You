//
//  MovieViewModel.swift
//  Desafio Mobile2You
//
//  Created by Eiki Yonemura on 01/10/21.
//

import Foundation

protocol MovieViewModelDelegate {
    func didUpdateMovie(_ movieViewModel: MovieViewModel, movie: Movie)
    func didUpdateMovieSimilar(_ movieViewModel: MovieViewModel, movieSimilar: MovieSimilar)
    func didUpdateGenres(_ movieViewModel: MovieViewModel, genres: Genres)
    
}

class MovieViewModel {
    
    let api = "?api_key=4993f511e597d39c7131d15093daf15d"
    let url = "https://api.themoviedb.org/3/movie/950"
    let urlImg = "https://image.tmdb.org/t/p/w500"
    let urlGenre = "https://api.themoviedb.org/3/genre/movie/list"
    
    var delegate: MovieViewModelDelegate?
    
    var genreList = [[String:Any]]()
    var movieSimilarList = [[String:Any]]()
    


    func getMovie() {
        if let url = URL(string: url+api) {
            let tarefa = URLSession.shared.dataTask(with: url) { dados, requisicao, erro in
                if erro == nil {
                    if let dadosRetorno = dados {
                        if let movie = self.parseJSON(dadosRetorno, "Movie") as? Movie {
                            self.delegate?.didUpdateMovie(self, movie: movie)
                        }
                    }
                }
            }
            tarefa.resume()
        }
    }
    
    func getMovieSimilarList() {
        if let urlSimilar = URL(string: url+"/similar"+api) {
            let tarefa = URLSession.shared.dataTask(with: urlSimilar) { dados, requisicao, erro in
                if erro == nil {
                    if let dadosRetorno = dados {
                        if let movies = self.parseJSON(dadosRetorno, "MovieSimilar") as? MovieSimilar {
                            self.delegate?.didUpdateMovieSimilar(self, movieSimilar: movies)
                        }
                    }
                }
            }
            tarefa.resume()
        }
        
        
    }
    
    func getGenres(){
        if let urlGenres = URL(string: urlGenre+api+"&language=en-US"){
            let tarefa = URLSession.shared.dataTask(with: urlGenres) { dados, requisicao, erro in
                if erro == nil {
                    if let dadosRetorno = dados{
                        if let genres = self.parseJSON(dadosRetorno, "Genre") as? Genres {
                            self.delegate?.didUpdateGenres(self, genres: genres)
                        }
//                        for i in 0...genres!.genres.count - 1{
//                            //print(genres?.genres[i])
//                            let dict = ["id": genres!.genres[i].id, "name": genres!.genres[i].name] as [String : Any]
//                            self.genreList.append(dict)
//                        }
                    }
                }
            }
            tarefa.resume()
        }
    }
    
    func parseJSON(_ dados: Data,_ estrutura: String) -> Any?{
        let decoder = JSONDecoder()
        var decodedData: Any
        do{
            switch estrutura {
            case "Movie":
                decodedData = try decoder.decode(Movie.self, from: dados)
            case "MovieSimilar":
                decodedData = try decoder.decode(MovieSimilar.self, from: dados)
            case "Genre":
                decodedData = try decoder.decode(Genres.self, from: dados)
            default:
                return nil
            }
            return decodedData
        }catch{
            print("erro JSON")
            return nil
        }
    }
    
}
