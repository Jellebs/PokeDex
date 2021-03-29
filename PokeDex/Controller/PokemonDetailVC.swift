//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Jesper Bertelsen on 24/03/2021.
//

import UIKit

class PokemonDetailVC: UIViewController {
    //MARK:-            Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var TypeLbl: BskLabel!
    @IBOutlet weak var defenseLbl: BskLabel!
    @IBOutlet weak var heightlbl: BskLabel!
    @IBOutlet weak var pokeIDLbl: BskLabel!
    @IBOutlet weak var weightLbl: BskLabel!
    @IBOutlet weak var baseAttLbl: BskLabel!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var evo1Img: UIImageView!
    @IBOutlet weak var evo2Img: UIImageView!
    
    var pokemon: Pokemon!
    var startVc: ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name
        pokeImg.image = UIImage(named:"\(pokemon.pokeDexID)")
        pokemon.downPokemonDetails { () -> () in
            self.updateUI()
            //This Will be called after the download has finished!!
        }
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        TypeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightlbl.text = pokemon.height
        pokeIDLbl.text = "\(pokemon.pokeDexID)"
        weightLbl.text = pokemon.weight
        baseAttLbl.text = pokemon.baseAttack
        descLbl.text = pokemon.description
        nextEvoLbl.text = pokemon.nextEvolutionText
        
        if let IDS = pokemon.nextEvolutionIDS {
            print(IDS)
            if IDS.count == 1 {
                evo1Img.image = UIImage(named: "\(pokemon.pokeDexID)")
                if let ID = IDS.first {
                    print(ID)
                    evo2Img.image = UIImage(named: "\(ID)")
                }
            }
            if IDS.count == 2 {
                if let ID1 = IDS.first {
                    print(ID1)
                    evo1Img.image = UIImage(named: "\(ID1)")
                }
                if let ID2 = IDS.last {
                    print(ID2)
                    evo2Img.image = UIImage(named: "\(ID2)")
                }
            }
        }
        
    }
    func prints() {
        print("prints")
        print("\n",TypeLbl.text)
        print(heightlbl.text)
        print(weightLbl.text)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func musicBtn(_ sender: Any) {
        if let musicPlayer = ViewController.musicPlayer {
            if musicPlayer.isPlaying {
                musicPlayer.stop()
            } else {
                musicPlayer.play()
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
