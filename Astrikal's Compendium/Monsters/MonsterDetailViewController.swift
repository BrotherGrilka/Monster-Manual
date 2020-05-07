//
//  MonsterDetailViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonsterDetailViewController: MonsterManualViewController {
    var monsterIndex:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = GetMonsters.forMonsterIndex(monsterIndex: monsterIndex ?? "black-pudding", success: { (monstaEntity) in
            DispatchQueue.main.async {

//               print("Manners: \(monstaEntity)")
                
                
                //                self.monsterCongress = monsters
//                self.monstersTableView.reloadData()
            }
        }, failure: { error in self.errorScribe?.recordInErrorScroll(status: .GetMonsterFailure(error)) })
    }
}
