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
    var monsta:Monsta?

    override func viewDidLoad() {
        super.viewDidLoad()

        monstaTableView.register(UINib(nibName: MonstaCell.moniker, bundle: nil), forCellReuseIdentifier: MonstaCell.moniker)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = GetMonsters.forMonsterIndex(monsterIndex: monstaIndex ?? "black-pudding", success: { (monstaEntity) in
            DispatchQueue.main.async {
                self.monsta = monstaEntity
                self.monstaTableView.reloadData()
            }
                        
            _ = GetMonsterImages(forMonster: monstaEntity.name ?? "Gray Ooze", success: { (data) in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String:Any]
                    
                    if let itemsArray = json!["items"] as? [AnyObject] {
                        let linkArray = itemsArray.map { $0["link"] }
                        let dieRoll = Int.random(in: 0 ..< linkArray.count)
                        
                        if let imageLink = linkArray[dieRoll] as? String {
                            self.monstaImageView.downloadImage(string: imageLink)
                        }
                    }
                } catch {}
            }, failure: { _ in  })
        }, failure: { error in
//            self.scribe?.recordInScroll(encounter: .GetMonsterFailure(error))
            
        })
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MonstaCell = tableView.dequeueReusableCell(withIdentifier: MonstaCell.moniker, for: indexPath) as! MonstaCell

        switch indexPath.row {
            case 0:
                cell.monstaLabel.text = self.monsta?.name
            default:
                cell.monstaLabel.text = self.monsta?.name
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
