//
//  CoreDataMonsters.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/17/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit
import CoreData

class Immortality {
    let managedContext:NSManagedObjectContext
    
    func create(data: Data) -> Monsta? {
        if let monstaEntityDescription = NSEntityDescription.entity(forEntityName: "Monsta", in: managedContext) {
            let monstaEntity = NSManagedObject(entity: monstaEntityDescription, insertInto: managedContext) as! Monsta

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
                monstaEntity.parse(json: json!)
            } catch {  }

            do { try managedContext.save() }
            catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }

            return monstaEntity
        }
        
        return nil
    }
    
    func fetch(monsterIndex: String) -> Monsta? {
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Monsta")
        var monstaEntities:[Monsta]?
        
        fetch.predicate = NSPredicate(format: "index = %@", monsterIndex)
        
        do {
            monstaEntities = try managedContext.fetch(fetch) as? [Monsta]
        } catch let error as NSError {
            print("Fiend Folio fetch failure =  \(error) :: \(error.userInfo)")
        }

        if let lastEncounter = monstaEntities?.first?.last_encounter {
            let theBeforeTime = Date().addingTimeInterval(-2999998)
            
            if theBeforeTime.compare(lastEncounter) == .orderedDescending {
                self.slaughterMonsters()
            }

            return nil
        }

        return monstaEntities?.first
    }
    
    func slaughterMonsters() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Monsta")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetch)

        do {
            try managedContext.execute(batchDelete)
            try managedContext.save()
        } catch let error as NSError {
            print("Fiend Folio fetch failure =  \(error) :: \(error.userInfo)")
        }
    }

    static let chamber = Immortality()

    private init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
            
        managedContext = appDelegate.persistentContainer.viewContext
    }
}

extension NSManagedObject: JsonParsable {
    func parse(json: [String : Any]) {
        for (attributeName, _) in self.entity.attributesByName {
            guard let attributeJson = json[attributeName], !(attributeJson is NSNull) else {
                continue
            }

            self.setValue(attributeJson, forKeyPath: attributeName)
        }

        for (relationshipName, relationshipDescription) in self.entity.relationshipsByName {
            guard let relationshipJson = json[relationshipName], !(relationshipJson is NSNull) else {
                if relationshipName.starts(with: "damage") {
                    self.absorbDamage(json: json)
                }

                continue
            }

            let entityName = relationshipName.capitalized.replacingOccurrences(of: #"s$"#, with: #""#, options: .regularExpression).replacingOccurrences(of: #"ie$"#, with: #"y"#, options: .regularExpression)

            if relationshipDescription.isToMany {
                var toManySet:Set = Set<NSManagedObject>()
                
                if let relationshipMembersArray = relationshipJson as? Array<Any> {
                    for relationshipMember in relationshipMembersArray {
                        let relationshipEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: Immortality.chamber!.managedContext)

                        relationshipEntity.parse(json: relationshipMember as! [String : Any])

                        if let inverseName = relationshipDescription.inverseRelationship?.name {
                            relationshipEntity.setValue(self, forKey: inverseName)
                        }

                        toManySet.insert(relationshipEntity)
                    }
                }

                self.setValue(toManySet, forKeyPath: relationshipName)
            } else {
                let relationshipEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: Immortality.chamber!.managedContext)

                relationshipEntity.parse(json: relationshipJson as! [String : Any])                

                if let inverseName = relationshipDescription.inverseRelationship?.name {
                    relationshipEntity.setValue(self, forKey: inverseName)
                }

                self.setValue(relationshipEntity, forKeyPath: relationshipName)
            }
        }
        
        if let monsta = self as? Monsta {
            monsta.last_encounter = Date()
        }

//        DispatchQueue(label: "Search for Traps", qos: .background).async {
//            print("Ozzi searches for traps")
//        }
    }

    func absorbDamage(json: [String : Any]) {
        let damageEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage", into: Immortality.chamber!.managedContext) as! Damage

        if let damageImmunities = json["damage_immunities"] as? [String] {
            let damageImmunityEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage_Immunity", into: Immortality.chamber!.managedContext) as! Damage_Immunity

            damageImmunityEntity.immunities = damageImmunities.joined(separator: ", ")
            damageEntity.damage_immunities = damageImmunityEntity
        }

        if let damageResistances = json["damage_resistances"] as? [String] {
            let damageResistanceEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage_Resistance", into: Immortality.chamber!.managedContext) as! Damage_Resistance
            
            damageResistanceEntity.resistances = damageResistances.joined(separator: ", ")
            damageEntity.damage_resistances = damageResistanceEntity
        }

        if let damageVulnerabilities = json["damage_vulnerabilities"] as? [String] {
            let damageVulnerabilityEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage_Vulnerability", into: Immortality.chamber!.managedContext) as! Damage_Vulnerability
            
            damageVulnerabilityEntity.vulnerabilities = damageVulnerabilities.joined(separator: ", ")
            damageEntity.damage_vulnerabilities = damageVulnerabilityEntity
        }
        
        self.setValue(damageEntity, forKeyPath: "Damage")
    }
}




