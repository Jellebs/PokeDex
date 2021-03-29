//
//  Pokemon.swift
//  PokeDex
//
//  Created by Jesper Bertelsen on 23/03/2021.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String?
    private var _pokeDexID: Int?
    private var _description: String!
    private var _type = ""
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _pokeURL: String!
    private var _evoURL: String!
    private var _descURL: String!
    private var _nextEvolvl: String!
    private var _nextEvolutionID: String!
    private var _nextEvolution: String!
    private var _evolutions = [String]()
    private var _evolutionlvls = [String]()
    private var _evolutionID = [String?]()
    
    var name: String {
        return _name ?? "no name"
    }
    var pokeDexID: Int {
        return _pokeDexID ?? 1
    }
    var type: String {
        return _type
    }
    var defense: String {
        if _defense == nil {
            _defense = "no defense"
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = "no height"
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = "no weight"
        }
        return _weight
    }
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = "no baseAttack"
        }
        return _baseAttack
    }
    var description: String {
        if _description == nil {
            _description = "not good enough for a description"
        }
        return _description
    }
    var evolutions: [String] {
        return _evolutions
    }
    var evolutionsLvls: [String?] {
        return _evolutionlvls
    }
    var evolutionID: [String?] {
        return _evolutionID
    }
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return "\(pokeDexID+1)"
    }
    var nextEvolutionIDS: [String]? {
        if _evolutions.count == 2 {
            return ["\(nextEvolutionID)","\(pokeDexID+2)"]
        }
        if _evolutions.count == 1 {
            return [nextEvolutionID]
        }
        return [""]
    }
    var nextEvolutionlvl: String {
        if _nextEvolvl == nil {
            return "et eller andet"
        }
        return _nextEvolvl
    }
    var nextEvolutionText: String {
        if _nextEvolution == nil {
            return ""
        }
        return "Next evolution is: \(_nextEvolution!) at lvl \(nextEvolutionlvl)"
    }
    
    
    init(name: String, pokeDexID: Int) {
        _name = name
        _pokeDexID = pokeDexID
        _pokeURL = "\(URL_BASE)\(URL_POKEMON)\(_pokeDexID!)/"
        _evoURL = "\(URL_BASE)\(URL_EVOLUTIONS)\(_pokeDexID!)/"
        _descURL = "\(URL_BASE)\(URL_DESCRIPTION)\(_pokeDexID!)/"
    }
    func downPokemonDetails(completed: @escaping(downloadComplete)) {
        AF.request(_pokeURL).responseJSON { response in
            if let dict = response.value {
                let JSON = dict as? Dictionary <String, AnyObject>
                if let weight = JSON?["weight"] {
                    self._weight = "\(weight)"
                }
                if let height = JSON?["height"] {
                    self._height = "\(height)"
                }
                if let attacks = JSON?["stats"] as? [Dictionary<String,AnyObject>] {
                    if attacks.count > 0 {
                        for x in stride(from: 0, to: attacks.count, by: +1) {
                            if let stat = attacks[x]["stat"] {
                                if stat["name"] as! String == "attack" {
                                    if let baseAtt = attacks[x]["base_stat"] {
                                        self._baseAttack = "\(baseAtt)"
                                    }
                                    
                                
                                }
                            }
                        }
                    } else {
                        self._baseAttack = "1000"
                    }
                }
                
                
                if let stats = JSON?["stats"] as? [Dictionary<String,AnyObject>] {
                    if stats.count > 0 {
                        for x in stride(from: 0, to: stats.count, by: +1) {
                            if let stat = stats[x]["stat"] {
                                if stat["name"] as! String == "defense" {
                                    if let baseDef = stats[x]["base_stat"] {
                                        self._defense = "\(baseDef)"
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        self._defense = "1000"
                    }
                }
                if let types = JSON?["types"] as? [Dictionary<String,AnyObject>] {
                    if types.count == 1 {
                        
                        if let type = types[0]["type"] {
                            if let name = type["name"] as? String {
                                self._type.append("\(name.capitalized)")
                            }
                        }
                    }
                    if types.count == 2 {
                        for x in stride(from: 0, to: types.count, by: +1) {
                            if let type = types[x]["type"] {
                                if x == 0 {
                                    if let name = type["name"] as? String {
                                        self._type.append("\(name.capitalized)/")
                                    }
                                }
                                if x == 1 {
                                    if let name = type["name"] as? String {
                                        self._type.append("\(name.capitalized)")
                                    }
                                }
                            }
                        }
                    } 
                }
            }
            
        }
        AF.request(_evoURL).responseJSON { response in
            if let dict = response.value {
                let JSON = dict as? Dictionary <String,AnyObject?>
                if let chain = JSON?["chain"] {
                    if let evo1 = chain?["evolves_to"] as? [Dictionary<String,AnyObject?>] {
                        if evo1.count > 0 {
                            if let species = evo1[0]["species"] as? Dictionary<String,AnyObject?> {
                                if let evoName = species["name"] as? String? {
                                    self._evolutions = [evoName ?? ""]
                                    self._nextEvolution = evoName
                                    
                                }
                                if let evoNr = species["url"] as? String? {
                                    let evoNumber = evoNr?.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                    let number = evoNumber?.replacingOccurrences(of: "/", with: "")
                                    self._evolutionID.append(number)
                                    self._nextEvolutionID = number
                                }
                            }
                            if let details = evo1[0]["evolution_details"] as? [Dictionary<String,AnyObject?>] {
                                if let minLvl = details[0]["min_level"] as? Int? {
                                    if minLvl != nil {
                                        self._evolutionlvls.append("\(minLvl!)")
                                        self._nextEvolvl = "\(minLvl!)"
                                    }
                                }
                            }
                            
                            if let evo2 = evo1[0]["evolves_to"] as? [Dictionary<String,AnyObject?>] {
                                if evo2.count > 0 {
                                    if let species = evo2[0]["species"] {
                                        if let name2 = species?["name"] as? String? {
                                            self._evolutions.append(name2 ?? "")
                                        }
                                        if let evoNr = species?["url"] as? String? {
                                            let evoNumber = evoNr?.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                            let number = evoNumber?.replacingOccurrences(of: "/", with: "")
                                            self._evolutionID.append(number)
                                            
                                    }
                                    if let details = evo2[0]["evolution_details"] as? [Dictionary<String,AnyObject?>] {
                                        if let minLvl = details[0]["min_level"] as? String? {
                                            self._evolutionlvls.append("\(minLvl ?? "")")
                                            }
                                        }
                                        else {
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        AF.request(_descURL).responseJSON { response in
            if let dict = response.value {
                let JSON = dict as? Dictionary<String,AnyObject>
                if let genera = JSON?["genera"] as? [Dictionary<String,AnyObject>] {
                    for x in stride(from: 0, to: genera.count, by: +1) {
                        if let language = genera[x]["language"] as? Dictionary <String,AnyObject> {
                            if let english = language["name"] as? String {
                                if english == "en" {
                                    if let name = genera[x]["genus"] as? String {
                                        self._description = name
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
    
}

