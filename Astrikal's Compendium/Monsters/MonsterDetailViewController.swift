//
//  MonsterDetailViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonsterDetailViewController: MonsterManualViewController, UITableViewDataSource, UITableViewDelegate  {
    var monstaIndex:String?
    @IBOutlet weak var monstaTableView: UITableView!
    @IBOutlet weak var monstaImageView: UIImageView!
    @IBOutlet weak var monstaName: UILabel!
    var monsta:Monsta?

    override func viewDidLoad() {
        super.viewDidLoad()

        monstaTableView.rowHeight = UITableView.automaticDimension
        monstaTableView.estimatedRowHeight = 58.0
        monstaTableView.register(UINib(nibName: MonstaDetailCell.moniker, bundle: nil), forCellReuseIdentifier: MonstaDetailCell.moniker)
        monstaTableView.register(UINib(nibName: MonstaDetailHeaderView.moniker, bundle: nil), forHeaderFooterViewReuseIdentifier: MonstaDetailHeaderView.moniker)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = GetMonsters.forMonsterIndex(monsterIndex: monstaIndex ?? "black-pudding", success: { (monstaEntity) in
            DispatchQueue.main.async {
                self.monsta = monstaEntity
                self.monstaName.text = self.monsta?.name
                self.monstaTableView.reloadData()
            }
            
//            if monstaEntity.name != nil {
//                GetMonsterImages.monsterImages(monster: monstaEntity.name!, imageView: self.monstaImageView)
//            }
        }, failure: { error in self.scribe?.recordInScroll(encounter: .AdventureError(.GetMonstersForMonsterIndex(error))) })
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let monstaDetailHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MonstaDetailHeaderView.moniker) as! MonstaDetailHeaderView
        
        switch section {
        case 0:
            monstaDetailHeaderView.headerLabel.text = "++ Characteristics ++"
        case 1:
            monstaDetailHeaderView.headerLabel.text = "++ Attacks ++"
        default:
            monstaDetailHeaderView.headerLabel.text = ""
        }
        
        return monstaDetailHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MonstaDetailCell = tableView.dequeueReusableCell(withIdentifier: MonstaDetailCell.moniker, for: indexPath) as! MonstaDetailCell
        
        switch indexPath.section {
            case 0:
                if let monsta = self.monsta {
                    cell.monsterLore(monsta: monsta)
                }
            case 1:
                if let actions = self.monsta?.actions as? Set<Action> {
                    cell.actionLore(actions: actions)
                }
            default:
                if let monsta = self.monsta {
                    cell.monsterLore(monsta: monsta)
                }
        }

        return cell
    }

    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

//override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//    return self.collectionView.contentSize
//}
