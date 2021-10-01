//
//  ViewController.swift
//  Desafio Mobile2You
//
//  Created by Eiki Yonemura on 01/10/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imagemFilme: UIImageView!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var movieViewModel = MovieViewModel()
    
    var genreList = [[String:Any]]()
    var movieSimilarList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        movieViewModel.delegate = self
        movieViewModel.getMovie()
        movieViewModel.getMovieSimilarList()
        //movieViewModel.getGenres()
        
    }

    @IBAction func likeButton(_ sender: Any) {
        
        if likeButton.currentImage == UIImage(named: "heart"){
            likeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        
    }
    
    //MARK: - TabelView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSimilarList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieSimilarCell
        cell.tituloLabel.text = movieSimilarList[indexPath.row]["titulo"] as? String
        let dataLancamento = movieSimilarList[indexPath.row]["data"] as? String
        cell.infoLabel.text = String(dataLancamento!.prefix(4))
        
        let backdrop = movieSimilarList[indexPath.row]["backdrop_path"] as! String
        let movieImg = URL.init(string: "https://image.tmdb.org/t/p/w500"+backdrop)
        do{
            let data = try Data(contentsOf: movieImg!)
            cell.imagemFilme.image = UIImage(data: data)
            
        }catch{
            print("Erro\(error)")
        }
        return cell
    }

    
    
    
}

//MARK: - MovieViewDelegte

extension ViewController: MovieViewModelDelegate{
    
    func didUpdateMovie(_ movieViewModel: MovieViewModel, movie: Movie) {
        DispatchQueue.main.async {
            self.tituloLabel.text = movie.original_title
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.locale = Locale(identifier: "pt_BR")
            let nfLike = nf.string(from: movie.vote_count as NSNumber)
            self.likesLabel.text = nfLike
            self.viewsLabel.text = "\(movie.popularity)"
            let imgURL = URL.init(string: "https://image.tmdb.org/t/p/w500/"+movie.backdrop_path)
            do{
                let data = try Data(contentsOf: imgURL!)
                self.imagemFilme.image = UIImage(data: data)
                
            }catch{
                print("Erro:\(error)")
            }
            
        }
    }
    
    func didUpdateMovieSimilar(_ movieViewModel: MovieViewModel, movieSimilar: MovieSimilar) {
        for i in 0...movieSimilar.results.count - 1{
            let titulo = movieSimilar.results[i].title
            let dataLancamento = movieSimilar.results[i].release_date
            let backdrop = movieSimilar.results[i].backdrop_path
            var genreId = [Int]()
            for y in 0...movieSimilar.results[i].genre_ids.count - 1{
                genreId.append(movieSimilar.results[i].genre_ids[y])
            }
            movieSimilarList.append(["titulo": titulo, "data": dataLancamento, "backdrop_path": backdrop, "genreId": genreId])
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func didUpdateGenres(_ movieViewModel: MovieViewModel, genres: Genres) {
        for i in 0...genres.genres.count - 1{
            let dict = ["id": genres.genres[i].id, "name":genres.genres[i].name] as [String:Any]
            self.genreList.append(dict)
        }
    }
}
