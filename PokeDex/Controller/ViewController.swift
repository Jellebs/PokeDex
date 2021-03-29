//
//  ViewController.swift
//  PokeDex
//
//  Created by Jesper Bertelsen on 23/03/2021.
//

import UIKit
import AVKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    //MARK: -           Properties
    private let PIKACHU_COLOR_CODE_YELLOW       = "#FAD61D"
                                              //red:250/255, green:214/255, blue:29/255
    private let PIKACHU_COLOR_CODE_ORANGE       = "#E19720"
    private let PIKACHU_COLOR_CODE_RED          = "#F62D14"
    private let PIKACHU_COLOR_CODE_KENYANCOPPER = "#811E09"
    private let PIKACHU_COLOR_CODE_BLACK        = "#000000"
    var pokemonDetailVC: PokemonDetailVC!
    var pokemon = [Pokemon]()
    static var musicPlayer: AVAudioPlayer!
    var isInSearchMode = false
    var filteretPokemon = [Pokemon]()
   
    
    //MARK: -           Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: -           ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        parsePokemonCSV()
        initAudioplayer()
        //          bestemmer hvad returnKeyen på tastaturen skal være. På          dansk bliver denne til OK
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    
    func initAudioplayer() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            ViewController.musicPlayer = try AVAudioPlayer(contentsOf: url)
            ViewController.musicPlayer.prepareToPlay()
            ViewController.musicPlayer.numberOfLoops = -1
//            musicPlayer.play()

        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    @IBAction func musicOnOff(sender: UIButton!) {
        if ViewController.musicPlayer.isPlaying {
            ViewController.musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            ViewController.musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokeDexID: pokeID)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    // MARK: -            UICollectinViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.identifier, for: indexPath) as? PokeCell {
            
            var poke: Pokemon!
            if isInSearchMode {
                poke = filteretPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(pokemon: poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInSearchMode {
            return filteretPokemon.count
        } else {
            return pokemon.count
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        if isInSearchMode {
            poke = filteretPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
        print("\(self.collectionView.cellForItem(at: indexPath)?.bounds.size)")
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isInSearchMode = false
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.view.endEditing(true)
                self.collectionView.reloadData()
            }
            
        } else {
            isInSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteretPokemon = pokemon.filter({$0.name.range(of: lower) != nil })
            collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
            
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }

}
