//
//  MonstersViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/15/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonsterCongressViewController: MonsterManualViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var monstersTableView: UITableView!
    @IBOutlet weak var monstaBackgroundImageView: UIImageView!
    var monsterCongress:MonsterCongress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scribe = navigationController as? Scribe
        monstersTableView.register(UINib(nibName: CompendiumCell.moniker, bundle: nil), forCellReuseIdentifier: CompendiumCell.moniker)
        monstersTableView.register(UINib(nibName: CapitalHeaderView.moniker, bundle: nil), forHeaderFooterViewReuseIdentifier: CapitalHeaderView.moniker)
        monstersTableView.sectionIndexColor = UIColor.black
        monstaBackgroundImageView.downloadImage(string: "https://media-waterdeep.cursecdn.com/avatars/thumbnails/0/139/1000/1000/636252756930565101.jpeg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = GetMonsters.forDungeonMaster(success: { (monsters) in
            DispatchQueue.main.async {
                self.monsterCongress = monsters
                self.monstersTableView.reloadData()
                
//                let indexPath = IndexPath(row: 4, section: 12)
//                self.monstersTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
//                self.monstersTableView.delegate?.tableView!(self.monstersTableView, didSelectRowAt: indexPath)
                
            }
        }, failure: { error in self.scribe?.recordInScroll(encounter: .AdventureError(.GetMonstersError(error))) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let monsterDetailViewController = segue.destination as? MonsterDetailViewController, let indexPath = sender as? IndexPath {
            monsterDetailViewController.monstaIndex = monsterCongress?.monsterPosses[indexPath.section][indexPath.row].1
        }
    }
    
    func monsterLetters() -> [String]? {
        return monsterCongress?.monsterPosses.map({ $0.first?.0.prefix(1).description ?? "" })
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let capitalHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CapitalHeaderView.moniker) as! CapitalHeaderView
        
        capitalHeaderView.indexCapital.text = monsterLetters()?[section]
        
        return capitalHeaderView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return monsterCongress?.monsterPosses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monsterCongress?.monsterPosses[section].count ?? 0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return monsterLetters()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CompendiumCell = tableView.dequeueReusableCell(withIdentifier: CompendiumCell.moniker, for: indexPath) as! CompendiumCell

        cell.entry.text = monsterCongress?.monsterPosses[indexPath.section][indexPath.row].0 ?? ""

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MonsterDetail", sender: indexPath)
    }
}
