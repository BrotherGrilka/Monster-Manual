//
//  MonsterManualNavigationController.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/27/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import UIKit

enum CompendiumError:Error {
//    var Network = NetworkError(networkError: NetworkError)
}

protocol ErrorScribe {
    func recordInErrorScroll(status: NetworkError)
}

class MonsterManualNavigationController: UINavigationController, ErrorScribe {

    override func viewDidLoad() {
        super.viewDidLoad()
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

    /* ++ ErrorScribe Protocol ++ */
    
    func recordInErrorScroll(status: NetworkError) {
        print("||+++++++++++++++++++++++++++++++++++++++++++||\n\n")
        
        print("Monster Manual Error :: ", status)
        
        print("\n\n||+++++++++++++++++++++++++++++++++++++++++++||")

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
