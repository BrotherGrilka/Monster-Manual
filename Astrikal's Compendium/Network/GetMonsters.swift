//
//  GetMonsters.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/15/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import Foundation

final class GetMonsters: Network {
    init(withURL url: URL, success dataCallback: @escaping DataCallback, failure failureCallback: @escaping ErrorCallback) {
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.GET
        
        super.init(request: request, callback: { (data, response, error) in
            guard error == nil else {
                failureCallback(error!)
                return
            }
            
            dataCallback(data)
        })
    }

    static func forMonsterIndex(monsterIndex: String, success successCallback: @escaping MonsterCallback, failure failureCallback: @escaping ErrorCallback) {
//        if let monsterEntity = FiendFolio.caveDwelling?.fetch(monsterIndex: monsterIndex) {
//            print("Ozzman: \(monsterEntity.index) ::: \(monsterIndex)")
//        }

        _ = GetMonsters(withURL: URL(string: Endpoint.Monsters + "/" + monsterIndex)!, success: { (data) in
            do {
                let monster = try Monster(data: data!)!
                
//                if let monsterEntity = FiendFolio.caveDwelling?.create(data: data!) {
                    successCallback(monster)
//                }
            } catch { failureCallback(error) }
        }, failure: failureCallback)
    }

    static func forDungeonMaster(success successCallback: @escaping MonsterCongressCallback, failure failureCallback: @escaping ErrorCallback) {
        _ = GetMonsters(withURL: URL(string: Endpoint.Monsters)!, success: { (data) in
            do {
                try _ = successCallback(MonsterCongress(data: data!)!)
            } catch { failureCallback(error) }
        }, failure: failureCallback)
    }
}

struct MonsterCongress {
    let monsters:[Monster]
    let count:Int
    
    init?(data: Data) throws {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]

            monsters = JsonParser.createItemsArray(field: "results", json: json!)
            count = JsonParser.createFieldItem(field: "count", json: json!)
        } catch { throw NetworkError.JSONSerializationError(error) }
    }
}


struct Monster: JsonInitializable {
    let index:String
    let name:String
    let url:String
    
    let _id:String
    let size:String
    let type:String
    let subtype:String
    let alignment:String
    let armor_class:Int
    let hit_points:Int
    let hit_dice:String
//    let speed:{}
    let strength:Int
    let dexterity:Int
    let constitution:Int
    let intelligence:Int
    let wisdom:Int
    let charisma:Int
//    let proficiencies:{}
//    let damage_vulnerabilities:{}
//    let damage_resistances:{}
//    let damage_immunities:{}
//    let condition_immunities:{}
//    let senses:{}
    let languages:String
    let challenge_rating:Int
//    let special_abilities:{}
//    let actions:{}
//    let reactions:{}

    init(json: [String:Any]) {
        index = JsonParser.createFieldItem(field: "index", json: json)
        name = JsonParser.createFieldItem(field: "name", json: json)
        url = JsonParser.createFieldItem(field: "url", json: json)

        _id = JsonParser.createFieldItem(field: "_id", json: json)
        size = JsonParser.createFieldItem(field: "size", json: json)
        type = JsonParser.createFieldItem(field: "type", json: json)
        subtype = JsonParser.createFieldItem(field: "subtype", json: json)
        alignment = JsonParser.createFieldItem(field: "alignment", json: json)
        armor_class = JsonParser.createFieldItem(field: "armor_class", json: json)
        hit_points = JsonParser.createFieldItem(field: "hit_points", json: json)
        hit_dice = JsonParser.createFieldItem(field: "hit_dice", json: json)
        strength = JsonParser.createFieldItem(field: "strength", json: json)
        dexterity = JsonParser.createFieldItem(field: "dexterity", json: json)
        constitution = JsonParser.createFieldItem(field: "dexterity", json: json)
        intelligence = JsonParser.createFieldItem(field: "intelligence", json: json)
        wisdom = JsonParser.createFieldItem(field: "wisdom", json: json)
        charisma = JsonParser.createFieldItem(field: "charisma", json: json)
        languages = JsonParser.createFieldItem(field: "languages", json: json)
        challenge_rating = JsonParser.createFieldItem(field: "challenge_rating", json: json)
    }
    
    init?(data: Data) throws {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]

            self.init(json: json!)
        } catch { throw NetworkError.JSONSerializationError(error) }
    }
}
