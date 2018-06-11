//
//  FilmesDetailViewController.swift
//  MovieDB
//
//  Created by Marllon Camargo on 22/05/16.
//  Copyright © 2016 PUCPR. All rights reserved.
//

import UIKit

class FilmesDetailViewController: UIViewController {

    @IBOutlet weak var filmeImage: UIImageView!
    @IBOutlet weak var filmeName: UILabel!
    @IBOutlet weak var filmeAno: UILabel!
    @IBOutlet weak var filmeGenero: UILabel!
    @IBOutlet weak var filmeAvaliacao: UILabel!
    @IBOutlet weak var filmeSinopse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiKey: String = "3f0e54c9490c2d4c20a18ece5dded98a"
        let baseUrl: String = "https://api.themoviedb.org/3/movie/"
        let filmeID: String = FilmeSingleton.sharedInstance.id
        let comando: String = "?&api_key="
        let urlFinal: String = "\(baseUrl)" + "\(filmeID)" + "\(comando)" + "\(apiKey)"
    
        self.getResults(urlFinal)
    }

    func getResults(url: String) {
        let URL: NSURL = NSURL(string: url)!
        
        let request = NSMutableURLRequest(URL: URL)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request)
        { (data, response, error) -> Void in
            do {
                guard let data = data else {
                    // erro
                    return
                }
                // Recuperar os dados
                self.formatResults(data)
            }
            }.resume()
    }
    
    func formatResults (data: NSData) {
        // Decodificar os dados do formato JSON
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            guard let jsonData: NSDictionary = result as? NSDictionary else {
                return
            }
            
            self.filmeName.text = jsonData["title"] as? String
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-mm-dd"
            let dtNSDate: NSDate = formatter.dateFromString(jsonData["release_date"] as! String)!
            
            formatter.dateFormat = "dd/mm/yyyy"
            let dtString: String = formatter.stringFromDate(dtNSDate)
            self.filmeAno.text = dtString
            
            let text = jsonData["overview"] as? String
            
            self.filmeSinopse.text = text
            let avaliacao = jsonData["vote_average"] as? Double
            
            self.filmeAvaliacao.text = String(format:"%.1f", avaliacao!)
            
            let genres: NSArray = (jsonData["genres"] as? NSArray)!
            
            var gener: String = ""
            for item in genres {
                gener += (item["name"] as! String) + ", "
            }
            
            self.filmeGenero.text = gener
            
            let url: String = "http://image.tmdb.org/t/p/w300" + "\(jsonData["poster_path"] as! String)"
            let imagemURL: NSURL = NSURL(string: url)!
            let imagem: NSData = NSData(contentsOfURL: imagemURL)!
            
            self.filmeImage.image = UIImage(data: imagem)

        }
        catch {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
