//
//  CoreDataMonsters.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/17/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataError:Error {
    case SingletonFailure
    case FetchError(Error)
    case BatchDeleteError(Error)
    case JSONSerializationError(Error)
    case JSONSerializationFailure(String)
    case SaveError(Error)
    case MissingField(String, String)
    case ManagedContextInaccesible
}

class Immortality {
    static let chamber = Immortality()
    let managedContext:NSManagedObjectContext
    let scribe:Scribe?
    
    func create(data: Data) -> Monsta? {
        if let monstaEntityDescription = NSEntityDescription.entity(forEntityName: "Monsta", in: managedContext) {
            let monstaEntity = NSManagedObject(entity: monstaEntityDescription, insertInto: managedContext) as! Monsta

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
                monstaEntity.parse(json: json!)
            } catch { scribe?.recordInScroll(encounter: .CoreDataError(.JSONSerializationError(error))) }

            do { try managedContext.save() }
            catch { scribe?.recordInScroll(encounter: .CoreDataError(.SaveError(error))) }

            return monstaEntity
        }
        
        return nil
    }
    
    func fetch(monsterIndex: String) -> Monsta? {
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Monsta")
        var monstaEntities:[Monsta]?
        
        fetch.predicate = NSPredicate(format: "index = %@", monsterIndex)
        
        do { monstaEntities = try managedContext.fetch(fetch) as? [Monsta] }
        catch { scribe?.recordInScroll(encounter: .CoreDataError(.FetchError(error))) }

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
        } catch { scribe?.recordInScroll(encounter: .CoreDataError(.BatchDeleteError(error))) }
    }
    
    private init?() {
        scribe = UIApplication.shared.windows.first?.rootViewController as? Scribe

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            scribe?.recordInScroll(encounter: .CoreDataError(.SingletonFailure))
            return nil
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
}

extension NSManagedObject: JsonParsable {
    func parse(json: [String : Any]) {
        guard let managedContext = Immortality.chamber?.managedContext else {
            Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.ManagedContextInaccesible))
            return
        }
        
        for (attributeName, _) in self.entity.attributesByName {
            guard let attributeJson = json[attributeName], !(attributeJson is NSNull) else {
                continue
            }

            self.setValue(attributeJson, forKeyPath: attributeName)
        }

        let childRelationships = self.entity.relationshipsByName.filter({
            $0.value.userInfo?["isParent"] == nil
        }).map { $0 }

        for (relationshipName, relationshipDescription) in childRelationships {
            guard let relationshipJson = json[relationshipName], !(relationshipJson is NSNull) else {
                continue
            }


//            if relationshipName.starts(with: "damage") {
//                self.absorbDamage(json: relationshipJson)
//                continue
//            }

            let entityName = relationshipName.capitalized.replacingOccurrences(of: #"s$"#, with: #""#, options: .regularExpression).replacingOccurrences(of: #"ie$"#, with: #"y"#, options: .regularExpression)

            if relationshipDescription.isToMany {
                var toManySet:Set = Set<NSManagedObject>()
                
                if let relationshipMembersJsonArray = relationshipJson as? Array<Any> {
                    for relationshipMemberJson in relationshipMembersJsonArray {
                        let relationshipEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)

                        if let memberJson = relationshipMemberJson as? [String : Any] {
                            relationshipEntity.parse(json: memberJson)

                            if let inverseName = relationshipDescription.inverseRelationship?.name {
                                relationshipEntity.setValue(self, forKey: inverseName)
                            }

                            toManySet.insert(relationshipEntity)
                        } else {
                            Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.JSONSerializationFailure("Failed to parse Json for \(relationshipName)")))
                            continue
                        }
                    }
                }

                self.setValue(toManySet, forKeyPath: relationshipName)
            } else {
                let relationshipEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)

                if let mindFlayerJson = relationshipJson as? [String: Any] {
                    relationshipEntity.parse(json: mindFlayerJson)

                    if let inverseName = relationshipDescription.inverseRelationship?.name {
                        relationshipEntity.setValue(self, forKey: inverseName)
                    }

                    self.setValue(relationshipEntity, forKeyPath: relationshipName)
                } else {
                    Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.JSONSerializationFailure("Failed to parse Json for \(relationshipName)")))
                    continue
                }
            }
        }
        
        if let monsta = self as? Monsta {
            monsta.last_encounter = Date()
        }

        DispatchQueue(label: "Search for Traps", qos: .background).async {
            let childProperties = self.entity.propertiesByName.filter({
                $0.value.userInfo?["isParent"] == nil
            }).map { $0.key }
            let missingFields = Set(json.keys).subtracting(Set(childProperties))
            
            if missingFields.count > 0 {
                Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.MissingField(self.entity.name ?? "Mind Flayer", missingFields.joined(separator: ", "))))
            }
        }

        func spawn(json: [String : Any]) {
        }
    }

    func absorbDamage(json: [String : Any]) {
//        if let damageEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage", into: managedContext) as? Damage {
//            if let damageImmunities = json["damage_immunities"] as? [String] {
//                let damageImmunityEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage_Immunity", into: managedContext) as! Damage_Immunity
//
//                damageImmunityEntity.immunities = damageImmunities.joined(separator: ", ")
//                damageEntity.damage_immunities = damageImmunityEntity
//            }
//
//            if let damageResistances = json["damage_resistances"] as? [String] {
//                let damageResistanceEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage_Resistance", into: managedContext) as! Damage_Resistance
//
//                damageResistanceEntity.resistances = damageResistances.joined(separator: ", ")
//                damageEntity.damage_resistances = damageResistanceEntity
//            }
//
//            if let damageVulnerabilities = json["damage_vulnerabilities"] as? [String] {
//                let damageVulnerabilityEntity = NSEntityDescription.insertNewObject(forEntityName: "Damage_Vulnerability", into: managedContext) as! Damage_Vulnerability
//
//                damageVulnerabilityEntity.vulnerabilities = damageVulnerabilities.joined(separator: ", ")
//                damageEntity.damage_vulnerabilities = damageVulnerabilityEntity
//            }
//
//            self.setValue(damageEntity, forKeyPath: "Damage")
//        }
    }
}




