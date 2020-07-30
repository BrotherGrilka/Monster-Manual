//
//  CoreDataMonsters.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/17/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit
import CoreData

protocol CellParsable {
}

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
        
        print("Ozzi create: ", data)

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
                return nil
            }
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
            
            if let attributeArray = attributeJson as? [String] {
                self.setValue(attributeArray.joined(separator: ", "), forKeyPath: attributeName)
                continue
            }
            
            self.setValue(attributeJson, forKeyPath: attributeName)
        }

        let childRelationships = self.entity.relationshipsByName.filter {
            $0.value.userInfo?["isParent"] == nil
        }.map { $0 }

        for (relationshipName, relationshipDescription) in childRelationships {
            if self is Option {
                if let multiattacks = json["from"] as? [[Any]] {
//                    var toManySet:Set = Set<NSManagedObject>()
                    for froms in multiattacks {
                        let multiattackEntity = NSEntityDescription.insertNewObject(forEntityName: "Multiattack", into: managedContext)

                        if let inverseName = relationshipDescription.inverseRelationship?.name {
                            multiattackEntity.setValue(self, forKey: inverseName)
                        }

                        for from in froms {
                            let fromEntity = NSEntityDescription.insertNewObject(forEntityName: "From", into: managedContext)
                            let fromRelationshipDescription = multiattackEntity.entity.relationships(forDestination: fromEntity.entity)

                            if let fromJson = from as? [String : Any] {
                                fromEntity.parse(json: fromJson)

                                if let inverseName = fromRelationshipDescription.first?.inverseRelationship?.name {
                                    fromEntity.setValue(multiattackEntity, forKey: inverseName)
                                }

                                
//                                toManySet.insert(fromEntity)
                            }
                        }
                    }
                }
            }
                                
            guard let relationshipJson = json[relationshipName], !(relationshipJson is NSNull) else {
                continue
            }

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
                            Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.JSONSerializationFailure("Failed to parse Json for to-many relationship = \(relationshipName)")))
                            continue
                        }
                    }
                }

                self.setValue(toManySet, forKeyPath: relationshipName)
            } else {
                let relationshipEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)

                if let memberJson = relationshipJson as? [Any] {
                    relationshipEntity.parse(json: [relationshipName: memberJson])
                    continue
                }

                if let mindFlayerJson = relationshipJson as? [String: Any] {
                    relationshipEntity.parse(json: mindFlayerJson)

                    if let inverseName = relationshipDescription.inverseRelationship?.name {
                        relationshipEntity.setValue(self, forKey: inverseName)
                    }

                    self.setValue(relationshipEntity, forKeyPath: relationshipName)
                } else {
                    Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.JSONSerializationFailure("Failed to parse Json for to-one relationship = \(relationshipName)")))
                    continue
                }
            }
        }
        
        if let monsta = self as? Monsta {
            monsta.last_encounter = Date()
        }

        DispatchQueue(label: "Search for Traps", qos: .background).async {
            let childProperties = self.entity.propertiesByName.filter {
                $0.value.userInfo?["isParent"] == nil
            }.map { $0.key }
            let missingFields = Set(json.keys).subtracting(Set(childProperties))
            
            if missingFields.count > 0 {
                Immortality.chamber?.scribe?.recordInScroll(encounter: .CoreDataError(.MissingField(self.entity.name ?? "Mind Flayer", missingFields.joined(separator: ", "))))
            }
        }
    }
}
