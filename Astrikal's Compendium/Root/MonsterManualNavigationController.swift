//
//  MonsterManualNavigationController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/27/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit
import Network

enum Encounter {
    case CoreDataError(CoreDataError)
    case AdventureError(AdventureError)
    case NetworkError(NetworkError)
    
    func recordEncounter() {
        print(self)
    }
}

enum AdventureError:Error {
    case GetMonstersError(Error)
    case GetMonstersForMonsterIndex(Error)
}

enum CompendiumError:Error {
    case AnniError
//    var Network = NetworkError(networkError: NetworkError)
}

protocol Scribe {
    func recordInScroll(encounter: Encounter)
}

class MonsterManualNavigationController: UINavigationController, Scribe {
    let monitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }

            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
     
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "QuentinCaps", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.orange()
        ], for: .normal)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "QuentinCaps", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.orange()
        ]
    }
    
    func location() {
        do {
            let json = ["Hi": "Ozzi"]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])

            _ = PostLocation(withURL: URL(string: Endpoint.Cats)!, data: data, success: { (data) in
                print(data)
            }, failure: { error in
                print(error)
            })
        } catch {
            print(error)
        }
        
        do {
            let json = ["Hi": "Ozzi"]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])

            _ = PutLocation(withURL: URL(string: Endpoint.Cats)!, data: data, success: { (data) in
                print(data)
            }, failure: { error in
                print(error)
            })
        } catch {
            print(error)
        }
        
        do {
            let json = ["Hi": "Ozzi"]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])

            _ = DeleteLocation(withURL: URL(string: Endpoint.Cats)!, data: data, success: { (data) in
                print(data)
            }, failure: { error in
                print(error)
            })
        } catch {
            print(error)
        }
    }

    /* ++ Librarian Protocol ++ */
    
    func recordInScroll(encounter: Encounter) {
        print("\n\n||+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++||\n")
        print("            _")
        print("     ___   / |")
        print("   _/___\\_ |||")
        print("  _\\\\___//_|||")
        print(" /. \\/_\\/ .|||")
        print(" \\__\\__ . [___]")
        print(" |-   -|. [_ -\\")
        print(" \\ {/} /_/ \\__/")
        print("  \\___/=]|]")
        print("  ||  /\\  ||")
        print("  ([]|  |[])")
        print("  |_ |  | _|")
        print(" [___|  |___]")
        
        print("\n\n    Monster Manual Encounter\n")
        encounter.recordEncounter()
                
        print("\n\n||+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++||\n\n")

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
