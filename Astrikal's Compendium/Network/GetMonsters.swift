//
//  GetMonsters.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/15/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import Foundation

final class GetMonsters: Network {
    init(withURL url: URL, success dataCallback: @escaping DataCallback, failure failureCallback: @escaping ErrorCallback) {
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.GET
        
        super.init(request: request, callback: { (data, response, error) in
            guard error == nil else {
                failureCallback(error!)
                return
            }
            
            dataCallback(data)
        })
    }

    static func forMonsterIndex(monsterIndex: String, success successCallback: @escaping MonsterEntityCallback, failure failureCallback: @escaping ErrorCallback) {
        if let monstaEntity = Immortality.chamber?.fetch(monsterIndex: monsterIndex) {
            successCallback(monstaEntity)
            return
        }

        _ = GetMonsters(withURL: URL(string: Endpoint.Monsters + "/" + monsterIndex)!, success: { (data) in
            if let monsterEntity = Immortality.chamber?.create(data: data!) {
                successCallback(monsterEntity)
            }
        }, failure: failureCallback)
    }

    static func forDungeonMaster(success successCallback: @escaping MonsterCongressCallback, failure failureCallback: @escaping ErrorCallback) {
        _ = GetMonsters(withURL: URL(string: Endpoint.Monsters)!, success: { (data) in
            do {
                try _ = successCallback(MonsterCongress(data: data!)!)
            } catch { failureCallback(error) }
        }, failure: failureCallback)
    }
}

struct MonsterCongress {
    let monsters:[Monster]
    let count:Int
    
    init?(data: Data) throws {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]

            monsters = JsonParser.createItemsArray(field: "results", json: json!)
            count = JsonParser.createFieldItem(field: "count", json: json!)
        } catch { throw NetworkError.JSONSerializationError(error) }
    }
}

struct Monster: JsonInitializable {
    let index:String
    let name:String
    let url:String
    
    let _id:String
    let size:String
    let type:String
    let subtype:String
    let alignment:String
    let armor_class:Int
    let hit_points:Int
    let hit_dice:String
//    let speed:{}
    let strength:Int
    let dexterity:Int
    let constitution:Int
    let intelligence:Int
    let wisdom:Int
    let charisma:Int
//    let proficiencies:{}
//    let damage_vulnerabilities:{}
//    let damage_resistances:{}
//    let damage_immunities:{}
//    let condition_immunities:{}
//    let senses:{}
    let languages:String
    let challenge_rating:Int
//    let special_abilities:{}
//    let actions:{}
//    let reactions:{}

    init(json: [String:Any]) {
        index = JsonParser.createFieldItem(field: "index", json: json)
        name = JsonParser.createFieldItem(field: "name", json: json)
        url = JsonParser.createFieldItem(field: "url", json: json)

        _id = JsonParser.createFieldItem(field: "_id", json: json)
        size = JsonParser.createFieldItem(field: "size", json: json)
        type = JsonParser.createFieldItem(field: "type", json: json)
        subtype = JsonParser.createFieldItem(field: "subtype", json: json)
        alignment = JsonParser.createFieldItem(field: "alignment", json: json)
        armor_class = JsonParser.createFieldItem(field: "armor_class", json: json)
        hit_points = JsonParser.createFieldItem(field: "hit_points", json: json)
        hit_dice = JsonParser.createFieldItem(field: "hit_dice", json: json)
        strength = JsonParser.createFieldItem(field: "strength", json: json)
        dexterity = JsonParser.createFieldItem(field: "dexterity", json: json)
        constitution = JsonParser.createFieldItem(field: "dexterity", json: json)
        intelligence = JsonParser.createFieldItem(field: "intelligence", json: json)
        wisdom = JsonParser.createFieldItem(field: "wisdom", json: json)
        charisma = JsonParser.createFieldItem(field: "charisma", json: json)
        languages = JsonParser.createFieldItem(field: "languages", json: json)
        challenge_rating = JsonParser.createFieldItem(field: "challenge_rating", json: json)
    }
    
    init?(data: Data) throws {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]

            self.init(json: json!)
        } catch { throw NetworkError.JSONSerializationError(error) }
    }
}

struct Session: JsonInitializable {
    let ageFrom:Int
    let ageTo:Int
    let allAthletesInSession:[String]
    let athletes:[SessionsAthlete]
    let bookedSessionId:String
    let bookedSlots:Int
    let bookingId:String
    let coachBookedSessionId:String
    let coachEmail:String
    let coachId:String
    let coachName:String
    let coachTrainingSessionId:String
    let date:String
    let date_time:Date?
    let duration:Int
    let endTime:String
    let end_time:Date?
    let feedback:Feedback?
    let first_name:String
    let groupGender:String
    let groupName:String
    let groupSize:Int
    let groupType:String
    let last_name:String
    let location:Location?
    let location_change:Int
    let payments:[Payments]
    let rescheduled:Bool
    let sessionPrice:Int
    let session_id:String
    let sports:String
    let startTime:String
    let start_time:Date?
    let status:String
    let time:String
    let type:String

    init(json: [String:Any]) {
        ageFrom = JsonParser.createFieldItem(field: "ageFrom", json: json)
        ageTo = JsonParser.createFieldItem(field: "ageTo", json: json)
        allAthletesInSession = JsonParser.createFieldArray(field: "allAthletesInSession", json: json)
        athletes = JsonParser.createItemsArray(field: "athletes", json: json)
        bookedSessionId = JsonParser.createFieldItem(field: "bookedSessionId", json: json)
        bookedSlots = JsonParser.createFieldItem(field: "bookedSlots", json: json)
        bookingId = JsonParser.createFieldItem(field: "bookingId", json: json)
        coachBookedSessionId = JsonParser.createFieldItem(field: "coachBookedSessionId", json: json)
        coachEmail = JsonParser.createFieldItem(field: "coachEmail", json: json)
        coachId = JsonParser.createFieldItem(field: "coachId", json: json)
        coachName = JsonParser.createFieldItem(field: "coachName", json: json)
        coachTrainingSessionId = JsonParser.createFieldItem(field: "coachTrainingSessionId", json: json)
        date = JsonParser.createFieldItem(field: "date", json: json)
        date_time = JsonParser.createDate(field: "date_time", json: json)
        duration = JsonParser.createFieldItem(field: "duration", json: json)
        endTime = JsonParser.createFieldItem(field: "endTime", json: json)
        end_time = JsonParser.createDate(field: "end_time", json: json)
        feedback = JsonParser.createStructItem(field: "feedback", json: json)
        first_name = JsonParser.createFieldItem(field: "first_name", json: json)
        groupGender = JsonParser.createFieldItem(field: "groupGender", json: json)
        groupName = JsonParser.createFieldItem(field: "groupName", json: json)
        groupSize = JsonParser.createFieldItem(field: "groupSize", json: json)
        groupType = JsonParser.createFieldItem(field: "groupType", json: json)
        last_name = JsonParser.createFieldItem(field: "last_name", json: json)
        location = JsonParser.createStructItem(field: "location", json: json)
        location_change = JsonParser.createFieldItem(field: "location_change", json: json)
        payments = JsonParser.createItemsArray(field: "payments", json: json)
        rescheduled = JsonParser.createFieldItem(field: "rescheduled", json: json)
        sessionPrice = JsonParser.createFieldItem(field: "sessionPrice", json: json)
        session_id = JsonParser.createFieldItem(field: "session_id", json: json)
        sports = JsonParser.createFieldItem(field: "sports", json: json)
        startTime = JsonParser.createFieldItem(field: "startTime", json: json)
        start_time = JsonParser.createDate(field: "start_time", json: json)
        status = JsonParser.createFieldItem(field: "status", json: json)
        time = JsonParser.createFieldItem(field: "time", json: json)
        type = JsonParser.createFieldItem(field: "type", json: json)
    }
    
    struct SessionsAthlete: JsonInitializable {
        let firstname:String
        let gender:String
        let lastname:String
        let name:String
        let year_of_birth:String
        
        init(json: [String:Any]) {
            firstname = JsonParser.createFieldItem(field: "firstname", json: json)
            gender = JsonParser.createFieldItem(field: "gender", json: json)
            lastname = JsonParser.createFieldItem(field: "lastname", json: json)
            name = JsonParser.createFieldItem(field: "name", json: json)
            year_of_birth = JsonParser.createFieldItem(field: "year_of_birth", json: json)
        }
    }
    
    struct Feedback: JsonInitializable {
        let feedback_id:String
        let feedback_status:String
        
        init(json: [String:Any]) {
            feedback_id = JsonParser.createFieldItem(field: "feedback_id", json: json)
            feedback_status = JsonParser.createFieldItem(field: "feedback_status", json: json)
        }
    }

    struct Location: JsonInitializable {
        let address:Address?
        let name:String
        
        init(json: [String:Any]) {
            address = JsonParser.createStructItem(field: "address", json: json)
            name = JsonParser.createFieldItem(field: "name", json: json)
        }

        struct Address: JsonInitializable {
            let city:String
            let state:String
            let street:String
            let zip:String
            
            init(json: [String:Any]) {
                city = JsonParser.createFieldItem(field: "city", json: json)
                state = JsonParser.createFieldItem(field: "state", json: json)
                street = JsonParser.createFieldItem(field: "street", json: json)
                zip = JsonParser.createFieldItem(field: "zip", json: json)
            }
        }
    }
    
    struct Payments: JsonInitializable {
        let athletes_count:Int
        let cardType:String
        let date:Date?
        let last4:Int
        let paymentId:String
        let sessionFee:Int
        let totalPrice:Int
        
        init(json: [String:Any]) {
            athletes_count = JsonParser.createFieldItem(field: "athletes_count", json: json)
            cardType = JsonParser.createFieldItem(field: "cardType", json: json)
            date = JsonParser.createDate(field: "date", json: json)
            last4 = JsonParser.createFieldItem(field: "last4", json: json)
            paymentId = JsonParser.createFieldItem(field: "paymentId", json: json)
            sessionFee = JsonParser.createFieldItem(field: "sessionFee", json: json)
            totalPrice = JsonParser.createFieldItem(field: "totalPrice", json: json)
        }
    }
}

//struct Athlete {
    //        firstname = Eli;
    //        gender = "<null>";
    //        lastname = Ross;
    //        name = "Eli Ross";
    //        "year_of_birth" = "<null>";
    
//}

//Birdie Jr's Sessions =  {
//ageFrom = "<null>";
//ageTo = 15;
//allAthletesInSession =     (
//    "Eli Ross"
//);
//athletes =     (
//    {
//        firstname = Eli;
//        gender = "<null>";
//        lastname = Ross;
//        name = "Eli Ross";
//        "year_of_birth" = "<null>";
//    }
//);
//bookedSessionId = 58c024cee5d6305dc0153207;
//bookedSlots = 0;
//bookingId = 58c024cee5d6305dc0153209;
//coachBookedSessionId = "<null>";
//coachEmail = "trevorholbrook@msn.com";
//coachId = 58b82fd9e5d630388a5fb20d;
//coachName = Trevor;
//coachTrainingSessionId = 58c024cee5d6305dc0153208;
//date = "Fri (Mar 10th)";
//"date_time" = "2017-03-10T17:00:00.000-07:00";
//duration = 1;
//endTime = " 6:00 PM";
//"end_time" = "2017-03-11T01:00:00.000+00:00";
//feedback =     {
//    "feedback_id" = 58c41c83e5d6306cb81531fe;
//    "feedback_status" = completed;
//};
//"first_name" = Carrie;
//groupGender = "<null>";
//groupName = "Eli's Group";
//groupSize = "<null>";
//groupType = "<null>";
//"last_name" = Ross;
//location =     {
//    address =         {
//        city = Littleton;
//        state = CO;
//        street = "7922 South Carr Street";
//        zip = 80128;
//    };
//    name = "Coronado Elementary School";
//};
//"location_change" = 0;
//payments =     (
//    {
//        "athletes_count" = 1;
//        cardType = MasterCard;
//        date = "2017-03-08T07:00:00.000+00:00";
//        last4 = 2809;
//        paymentId = c7e124dba3;
//        sessionFee = 62;
//        totalPrice = 62;
//    }
//);
//rescheduled = 0;
//sessionPrice = 62;
//"session_id" = "-KeEvOlUsTJwzYAMXOto";
//sports = soccer;
//startTime = " 5:00 PM";
//"start_time" = "2017-03-11T00:00:00.000+00:00";
//status = Completed;
//time = " 5:00 PM";
//type = Individual;
//}
