//
//  Network.swift
//  Astrikal's Compendium
//
//  Created by Dunc on 4/15/20.
//  Copyright © 2020 Mmyrmidons. All rights reserved.
//

import Foundation

enum NetworkError:Error {
    case StatusCodeFailure
    case NonOKResponse(StatusCode)
    case GetMonsterFailure(Error)
    case JSONSerializationError(Error)
    case LocksmithError(Error)
    init?(networkError: NetworkError) {
        self = networkError
    }
}

enum Endpoint {
    static let Urtheaters = "http://urtheaters.com:3099"
    static let Domain = "http://www.dnd5eapi.co"
    private static let DnDApi = Endpoint.Domain + "/api"
    static let Monsters = Endpoint.DnDApi + "/monsters"
    private static let CatsApi = Endpoint.Urtheaters + "/api"
    static let Cats = Endpoint.CatsApi + "/cats"
}

enum HTTPMethod {
    static let GET = "GET"
    static let POST = "POST"
    static let PUT = "PUT"
    static let DELETE = "DELETE"
}

enum StatusCode:Int {
    case OK = 200
    case Created = 201
    case Moved_Permanently = 301
    case Bad_Request = 400
    case Unauthorized = 401
    case Not_Found = 404
    case Internal_Server_Error = 500
    case Service_Unavailable = 503
    case Gateway_Timeout = 504
    case Unknown
    init(statusCode: Int) {
        self = StatusCode(rawValue: statusCode) ?? .Unknown
    }
}

typealias URLSessionCallback = (Data?, URLResponse?, Error?) -> ()
typealias StringCallback = (String) -> ()

class Network {
    static let timeoutInterval:TimeInterval = 58.0
    
    init(request: URLRequest, callback: @escaping URLSessionCallback) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Network.timeoutInterval
        
        let urlSession = URLSession(configuration: config)

        print("Birdi Jr's Endpoint = \(String(describing: request.url?.absoluteString))")
        
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == StatusCode.OK.rawValue {
                    callback(data, response, error)
                } else  {
                    callback(data, response, NetworkError(networkError: .NonOKResponse(StatusCode(statusCode: statusCode))))
                }
            } else {
                callback(data, response, NetworkError(networkError: .StatusCodeFailure))
            }
        })
        
        task.resume()
    }
}

protocol JsonInitializable {
    init(json: [String:Any])
}

protocol JsonParsable {
    func parse(json: [String:Any])
}

protocol VoidInitializable {
    associatedtype Voidster
    static var voidster:Voidster { get }
}

extension Int:VoidInitializable {
    typealias Voidster = Int
    static var voidster:Voidster {
        return Int()
    }
}

extension String:VoidInitializable {
    typealias Voidster = String
    static var voidster:Voidster {
        return String()
    }
}

extension Bool:VoidInitializable {
    typealias Voidster = Bool
    static var voidster:Voidster {
        return false
    }
}

final class JsonParser {
    static func createItemsArray<T: JsonInitializable>(field: String, json: [String:Any]) -> [T] {
        if let jsonItems = json[field] as? [[String:Any]] {
            var items = [T]()
            
            for jsonItem in jsonItems {
                items.append(T(json: jsonItem))
            }
            
            return items
        }

        return [T]()
    }

    static func createStructItem<T: JsonInitializable>(field: String, json: [String:Any]) -> T? {
        if let jsonItem = json[field] as? [String:Any] {
            return T(json: jsonItem)
        }
        
        return nil
    }

    static func createFieldItem<T: VoidInitializable>(field: String, json: [String:Any]) -> T {
        return json[field] as? T ?? T.voidster as! T
    }

    static func createFieldArray<T: VoidInitializable>(field: String, json: [String:Any]) -> [T] {
        if let jsonItems = json[field] as? [T] {
            return jsonItems
        }
        
        return [T]()
    }

    static func createDate(field: String, json: [String:Any]) -> Date? {
        let dateString:String = JsonParser.createFieldItem(field: field, json: json)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter.date(from: dateString) ?? nil
    }
    
    static func createId(json: [String:Any]) -> String {
        if let jsonId = json["id"] as? [String:Any], let oid = jsonId["$oid"] as? String {
            return oid
        }
        
        return String()
    }
}

