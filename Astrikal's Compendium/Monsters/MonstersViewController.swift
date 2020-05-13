//
//  MonstersViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/15/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonstersViewController: MonsterManualViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var monstersTableView: UITableView!
    var monsterCongress:MonsterCongress?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scribe = tabBarController as? Scribe
        monstersTableView.register(UINib(nibName: CompendiumCell.moniker, bundle: nil), forCellReuseIdentifier: CompendiumCell.moniker)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = GetMonsters.forDungeonMaster(success: { (monsters) in
            DispatchQueue.main.async {
                self.monsterCongress = monsters
                self.monstersTableView.reloadData()
            }
        }, failure: { error in
//            self.scribe?.recordInScroll(status: .GetMonsterFailure(error))
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let monsterDetailViewController = segue.destination as? MonsterDetailViewController, let indexPath = sender as? IndexPath {
            monsterDetailViewController.monstaIndex = monsterCongress?.monsters[indexPath.row].index
        }
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monsterCongress?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CompendiumCell = tableView.dequeueReusableCell(withIdentifier: CompendiumCell.moniker, for: indexPath) as! CompendiumCell

        cell.entry.text = monsterCongress?.monsters[indexPath.row].name

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MonsterDetail", sender: indexPath)
    }
}
