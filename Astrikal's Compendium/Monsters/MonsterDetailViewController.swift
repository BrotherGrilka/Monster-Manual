//
//  MonsterDetailViewController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/16/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

class MonsterDetailViewController: CompendiumViewController {
    var monsterIndex:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _ = GetMonsters.forMonsterIndex(monsterIndex: monsterIndex ?? "black-pudding", success: { (monsterEntity) in
            DispatchQueue.main.async {

               print(monsterEntity)
                
                
                //                self.monsterCongress = monsters
//                self.monstersTableView.reloadData()
            }
        }, failure: { error in self.errorScribe?.recordInErrorScroll(status: .GetMonsterFailure(error)) })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
