//
//  CoreDataMonsters.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/17/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit
import CoreData

class FiendFolio {
    let managedContext:NSManagedObjectContext
    
    func create(data: Data) -> MonsterEntity? {
        if let monsterEntityDescription = NSEntityDescription.entity(forEntityName: "MonsterEntity", in: managedContext) {
            let monsterEntity = NSManagedObject(entity: monsterEntityDescription, insertInto: managedContext) as! MonsterEntity

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
                
                
                monsterEntity.setValue(JsonParser.createFieldItem(field: "_id", json: json!) as String, forKeyPath: "id")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "index", json: json!) as String, forKeyPath: "index")

                monsterEntity.setValue(JsonParser.createFieldItem(field: "name", json: json!) as String, forKeyPath: "name")



                monsterEntity.setValue(JsonParser.createFieldItem(field: "size", json: json!) as String, forKeyPath: "size")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "type", json: json!) as String, forKeyPath: "type")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "subtype", json: json!) as String, forKeyPath: "subtype")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "alignment", json: json!) as String, forKeyPath: "alignment")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "armor_class", json: json!) as Int, forKeyPath: "armor_class")

                monsterEntity.setValue(JsonParser.createFieldItem(field: "hit_points", json: json!) as Int, forKeyPath: "hit_points")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "hit_dice", json: json!) as String, forKeyPath: "hit_dice")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "strength", json: json!) as Int, forKeyPath: "strength")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "dexterity", json: json!) as Int, forKeyPath: "dexterity")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "constitution", json: json!) as Int, forKeyPath: "constitution")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "intelligence", json: json!) as Int, forKeyPath: "intelligence")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "wisdom", json: json!) as Int, forKeyPath: "wisdom")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "charisma", json: json!) as Int, forKeyPath: "charisma")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "challenge_rating", json: json!) as Int, forKeyPath: "challenge_rating")
                monsterEntity.setValue(JsonParser.createFieldItem(field: "url", json: json!) as String, forKeyPath: "url")

            } catch {  }


            do {
                try managedContext.save()
            } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }

            return monsterEntity
        }
        
        return nil
    }
    
    func fetch(monsterIndex: String) -> MonsterEntity? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MonsterEntity")
        var monsterEntities:[MonsterEntity]?
        
        fetchRequest.predicate = NSPredicate(format: "index = %@", monsterIndex)

        do {
            monsterEntities = try managedContext.fetch(fetchRequest) as? [MonsterEntity]
        } catch let error as NSError {
            print("Fiend Folio fetch failure =  \(error) :: \(error.userInfo)")
        }
        
        return monsterEntities?.first
    }

    static let caveDwelling = FiendFolio()

    private init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
            
        managedContext = appDelegate.persistentContainer.viewContext
    }
}
