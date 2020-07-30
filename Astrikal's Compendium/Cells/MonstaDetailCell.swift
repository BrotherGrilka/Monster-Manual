//
//  MonstaDetailCell.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 6/10/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonstaDetailCell: UITableViewCell {
    static let moniker = "MonstaDetailCell"
    @IBOutlet weak var monstaStackView:UIStackView!
    @IBOutlet weak var monstaLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func monsterLore(monsta: Monsta) {
        var arcaneShift:CGFloat = 20

        contentView.backgroundColor = .lightGreen()
        
        unholyLabelSpawn(unholyLabel: "Alignment: ", incantation: monsta.alignment, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Type: ", incantation: monsta.type, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Subtype: ", incantation: monsta.subtype, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Size: ", incantation: monsta.size, arcaneShift: arcaneShift)

        unholyLabelSpawn(unholyLabel: "Armor Class: ", incantation: monsta.armor_class.description, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Hit Dice: ", incantation: monsta.hit_dice, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Hit Points: ", incantation: monsta.hit_points.description, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Challenge Rating: ", incantation: monsta.challenge_rating.description, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Languages: ", incantation: monsta.languages, arcaneShift: arcaneShift)

        arcaneShift += 20
        
        unholyLabelSpawn(unholyLabel: "Abilities", incantation: " ", arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Strength: ", unholySize: 24, incantation: monsta.strength.description, profaneSize: 21, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Intelligence: ", unholySize: 24, incantation: monsta.intelligence.description, profaneSize: 21, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Dexterity: ", unholySize: 24, incantation: monsta.dexterity.description, profaneSize: 21, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Constitution: ", unholySize: 24, incantation: monsta.constitution.description, profaneSize: 21, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Wisdom: ", unholySize: 24, incantation: monsta.wisdom.description, profaneSize: 21, arcaneShift: arcaneShift)
        unholyLabelSpawn(unholyLabel: "Charisma: ", unholySize: 24, incantation: monsta.charisma.description, profaneSize: 21, arcaneShift: arcaneShift)

        //                cell.monsterLore(monstaTrait: self.monsta?.speed)
//        speedLore(speed: monstaTrait as! Speed)
    }

    private func speedLore(speed: Speed) {
        for (mode, _) in speed.entity.attributesByName {
            if let value = speed.value(forKey: mode) as? String {
                unholyLabelSpawn(unholyLabel: mode, incantation: value, profaneSize: 27)
            }
        }
    }
    
    private func damageLore(damage: Set<Damage>, arcaneShift: CGFloat = 20.0) {
        for damageEntity in damage {
            unholyLabelSpawn(unholyLabel: "Damage Type: ", unholySize: 24, incantation: damageEntity.damage_type?.name, profaneSize: 21, arcaneShift: arcaneShift)
            unholyLabelSpawn(unholyLabel: "Damage Dice: ", unholySize: 24, incantation: damageEntity.damage_dice, profaneSize: 21, arcaneShift: arcaneShift)
            unholyLabelSpawn(unholyLabel: "Damage Bonus: ", unholySize: 24, incantation: String(damageEntity.damage_bonus), profaneSize: 21, arcaneShift: arcaneShift)
        }
    }
    
    private func dcLore(dc: Dc, arcaneShift: CGFloat = 20.0) {
        if let name = dc.dc_type?.name {
            unholyLabelSpawn(unholyLabel: "Difficulty Class: ", unholySize: 24, incantation: name + " of " + String(dc.dc_value), profaneSize: 21, arcaneShift: arcaneShift)
            unholyLabelSpawn(unholyLabel: "Success Type: ", unholySize: 24, incantation: dc.success_type, profaneSize: 21, arcaneShift: arcaneShift)
        }
    }

    private func usageLore(usage: Usage, arcaneShift: CGFloat = 20.0) {
        if usage.type != nil {
            if usage.dice != nil {
                unholyLabelSpawn(unholyLabel: usage.type!.capitalized + ": ", unholySize: 24, incantation: String(usage.min_value) + " on " + usage.dice!, profaneSize: 21, arcaneShift: arcaneShift)
            } else {
                unholyLabelSpawn(unholyLabel: "", unholySize: 24, incantation: String(usage.times) + " " + usage.type!, profaneSize: 21, arcaneShift: arcaneShift)
            }
        }
    }

    private func attackLore(attacks: Set<Attack>) {
        let arcaneShift:CGFloat = 20
        
        for attack in attacks {
            if attack.name != nil {
                unholyLabelSpawn(unholyLabel: attack.name!, unholySize: 24, incantation: "", profaneSize: 21, arcaneShift: arcaneShift)

                if let damage = attack.damage as? Set<Damage> {
                    damageLore(damage: damage, arcaneShift: 40)
                }
                
                if attack.dc != nil {
                    dcLore(dc: attack.dc!, arcaneShift: 40)
                }
            }
        }
    }

    private func multiattackLore(multiattacks: Set<Multiattack>) {
        for multiattack in multiattacks {
            if let froms = multiattack.froms as? Set<From> {
                var attackIncantation = String()

                for (i, from) in froms.enumerated() {
                    if from.name != nil, from.type != nil {
                        if i > 0 {
                            attackIncantation.append(", ")
                        }

                        attackIncantation.append(String(from.count) + " " + from.name! + " " + from.type! + " attack")
                            
                        if from.count > 1 {
                            attackIncantation.append("s")
                        }
                    }
                }

                unholyLabelSpawn(unholyLabel: " ", unholySize: 24, incantation: attackIncantation, profaneSize: 21, arcaneShift: 20)
            }
        }
    }

    func actionLore(actions: Set<Action>) {
        contentView.backgroundColor = .skyBlue(alpha: 0.3)

        for action in actions {
            unholyLabelSpawn(unholyLabel: action.name! + ": ", incantation: action.desc, profaneSize: 18)

            if action.attack_bonus > 0 {
                unholyLabelSpawn(unholyLabel: "Attack Bonus: ", unholySize: 24, incantation: String(action.attack_bonus), profaneSize: 21, arcaneShift: 20)
            }

            if let damage = action.damage as? Set<Damage> {
                damageLore(damage: damage)
            }
            
            if action.dc != nil {
                dcLore(dc: action.dc!)
            }
                        
            if action.usage != nil {
                usageLore(usage: action.usage!)
            }

            if let attacks = action.attacks as? Set<Attack> {
                attackLore(attacks: attacks)
            }
            
            if let multiattacks = action.options?.multiattacks as? Set<Multiattack> {
                multiattackLore(multiattacks: multiattacks)
            }
        }
    }
    
    func monsterLore(monster: Monster) {
        unholyLabelSpawn(unholyLabel: "Alignment: ", incantation: monster.alignment, profaneSize: 18)
    }

    private func unholyLabelSpawn(
        unholyLabel: String = "",
        unholySize: CGFloat = 30.0,
        incantation: String? = "",
        profaneSize: CGFloat = 30.0,
        arcaneShift: CGFloat = 0.0
    ) {
        
        print("Sup Oz: ", incantation, " :::: ", unholyLabel)
        
        if incantation?.count ?? 0 > 0 {
            let spawn = UINib(nibName: "MonstaTraitView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! MonstaTraitView
            
            spawn.traitIndentation.constant = arcaneShift
            spawn.descriptionIndentation.constant = arcaneShift
            
            spawn.traitLabel.text = unholyLabel
            spawn.traitLabel.font = spawn.traitLabel.font?.withSize(unholySize)
            spawn.descriptionLabel.text = incantation
            spawn.descriptionLabel.font = spawn.descriptionTextView.font?.withSize(profaneSize)
            spawn.descriptionTextView.text = incantation
            spawn.descriptionTextView.font = spawn.descriptionTextView.font?.withSize(profaneSize)
            spawn.traitLabel.sizeToFit()
            spawn.descriptionTextView.textContainer.exclusionPaths = [UIBezierPath(rect: spawn.traitLabel.frame)]

//            spawn.backgroundColor = .lightGreen(alpha: 0.3)
//            spawn.traitLabel.backgroundColor = .mistyRose(alpha: 0.3)

            monstaStackView.insertArrangedSubview(spawn, at: monstaStackView.arrangedSubviews.count)
        }
    }
    
//    private struct spawnCharacteristics {
//        let unholyLabel: String
//        let incantation: String?
//        let profaneSize: CGFloat = 30
//        let arcaneShift: CGFloat = 0
//
//        init() {
//
//        }
//    }
}

