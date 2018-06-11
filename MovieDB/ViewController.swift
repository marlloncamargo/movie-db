//
//  ViewController.swift
//  ExemploTMDB
//
//  Created by PUCPR on 09/04/16.
//  Copyright © 2016 PUCPR. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UITableViewDataSource,
                      UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var filmes: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let apiKey: String = "3f0e54c9490c2d4c20a18ece5dded98a"
        let baseUrl: String = "https://api.themoviedb.org/3"
        let comando: String = "/discover/movie?year=2016&api_key="
        let urlFinal: String = "\(baseUrl)" + "\(comando)" + "\(apiKey)"
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
            let resultFinal: NSArray = jsonData["results"] as! NSArray
            
            self.filmes = resultFinal
            self.tableView.reloadData()
        }
        catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showdetail", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("filme", forIndexPath: indexPath) as! FilmeTableViewCell
        
        let aux: NSDictionary = self.filmes[indexPath.row] as! NSDictionary
        cell.filmeName!.text = aux["title"] as? String

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        let dtNSDate: NSDate = formatter.dateFromString(aux["release_date"] as! String)!
        
        formatter.dateFormat = "yyyy"
        let dtString: String = formatter.stringFromDate(dtNSDate)
        
        cell.filmeAno!.text = dtString

        let url: String = "http://image.tmdb.org/t/p/w300" + "\(aux["poster_path"] as! String)"
        let imagemURL: NSURL = NSURL(string: url)!
        let imagem: NSData = NSData(contentsOfURL: imagemURL)!
        cell.photoImage.image = UIImage(data: imagem)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
                case "showdetail":
                    if let NSIndexPath = self.tableView.indexPathForCell(sender as! UITableViewCell){
                        let aux: NSDictionary = self.filmes[NSIndexPath.row] as! NSDictionary
                        let id: Int = (aux["id"] as? Int)!
                        FilmeSingleton.sharedInstance.id = String(id)
                    }
                    segue.destinationViewController
                default:break
            }
        }
    }
   
}