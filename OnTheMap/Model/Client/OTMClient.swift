//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Mike Allan on 2020-08-01.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation

class OTMClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case location
        case addLocation
        case user
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .location: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .addLocation: return Endpoints.base + "/StudentLocation"
            case .user: return Endpoints.base + "/users"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (LoginResponse?, Error?) -> Void) {
        let udacity = Udacity(username: username, password: password)
        let credentials = LoginRequest(udacity: udacity)
        taskForPOSTRequest(url: Endpoints.login.url, requestObject: credentials, responseType: LoginResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    class func postLocation(location: StudentLocation, completion: @escaping (PostLocationResponse?, Error?) -> Void) {
        var key = location.uniqueKey
        if let uniqueKey = location.uniqueKey {
            key = uniqueKey
        }
        else {
            if let accountKey = OnTheMapModel.userAccount?.key {
                key = accountKey
            }
        }
        // Hard-code a default key if there is none so the API call doesn't fail - there's no explanation of what this is supposed to be
        // Is this the account key? Is this the Session ID? 
        let postLocationRequest = PostLocation(uniqueKey: key ?? "12341234", firstName: location.firstName ?? "", lastName: location.lastName ?? "", mapString: location.mapString ?? "", mediaURL: location.mediaURL ?? "", latitude: location.latitude!, longitude: location.longitude!)
        taskForLocationPOSTRequest(url: Endpoints.addLocation.url, requestObject: postLocationRequest, responseType: PostLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        taskForDeleteRequest(url: Endpoints.logout.url, responseType: LogoutResponse.self)  { (response, error) in
            if let _ = response {
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.location.url, responseType: StudentLocationResponse.self) { (result) in
            switch result {
            case .success(let results):
                completion(results.results, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    /**
        MULTIPLE ISSUES HERE WITH THE API:
     - 5 EXTRA CRAP CHARACTERS IN THE RESPONSE
     - RESPONSE DOES NOT MATCH WHAT THE INSTRUCTIONS IN THE LESSON SAID
     - SUPPOSED TO HAVE A USER OBJECT AT THE TOP LEVEL OF THE RESPONSE
     - INSTEAD, THE DATA IN THE USER OBJECT IS RETURNED AT THE TOP LEVEL, THERE IS NO "USER" ELEMENT IN THE JSON
     - API REQUIRES A USER-ID BUT NO IDEA WHERE THIS COMES FROM
     - TRIED THE ACCOUNT.KEY RETURNED WHEN YOU POST CREDENTIALS TO LOGIN BUT RESULTS WERE ALWAYS DIFFERENT
     - STICKING WITH THE EMAIL ADDRESS USED TO LOG IN SINCE WE HAVEN'T BEEN GIVEN ENOUGH INFORMATION HERE
     - THIS PROJECT SUCKS
     */
    class func getUserDetails(completion: @escaping (User?, Error?) -> Void) {
        if let user = OnTheMapModel.loginName {
            let userDetailURL = URL(string: Endpoints.user.stringValue + "/" + user)!;
            taskForStupidGETRequest(url: userDetailURL, responseType: User.self) { (result) in
                switch result {
                case .success(let userData):
                    completion(userData, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
            
        }

    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                print("data in response is " + String(data: data, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                print("responseObject created from data")
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            }
            catch {
                do {
                    print("Error caught while decoding object: \(error)")
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)

                    DispatchQueue.main.async {
                        completion(.failure(errorResponse))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    /**
            WHERE DO WE BEGIN WITH HOW STUPID THIS API IS...
                GET USER DATA WILL INCLUDE 5 GARBAGE CHARACTERS AT THE BEGINNING OF THE RESPONSE
                GET STUDENT LOCATIONS ON THE OTHER HAND DOESN'T INCLUDE THIS 5 CHARACTER PREAMBLE OF CRAP
     */
    class func taskForStupidGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                print("data in response is " + String(data: data, encoding: .utf8)!)
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print("newData in response is " + String(data: newData, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                print("responseObject created from data")
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            }
            catch {
                do {
                    print("Error caught while decoding object: \(error)")
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data)

                    DispatchQueue.main.async {
                        completion(.failure(errorResponse))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestObject: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestObject)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("data in response to post is nil")
                    if let error = error {
                        print("Error is " + error.localizedDescription)
                    }
                    else {
                        print("Error is nil")
                    }
                    completion(nil, error)
                }
                return
            }
            print("data in response is good")
            let decoder = JSONDecoder()
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print("newData in response is " + String(data: newData, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                do {
                    print("Error trying to decode the response: \(data)")
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch {
                    print("Error happened while decoding")
                    print("Error is " + error.localizedDescription)

                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    

    /**
        GRRR - POSTING A LOCATION HAS A DIFFERENT RESPONSE THAN POSTING CREDENTIALS FOR A SESSION
     - POSTING CREDENTIALS RETURNS 5 CHARACTER GARBAGE PREAMBLE
     - POSTING LOCATION DOESN'T...
     - ERROR RESPONSE IS DIFFERENT! HAS CODE AND ERROR INSTEAD OF STATUS AND ERROR
     - THIS SUCKS
     */
    class func taskForLocationPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestObject: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestObject)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("data in response to post is nil")
                    if let error = error {
                        print("Error is " + error.localizedDescription)
                    }
                    else {
                        print("Error is nil")
                    }
                    completion(nil, error)
                } 
                return
            }
            print("data in response is good")
            let decoder = JSONDecoder()
            do {
                print("data in response is " + String(data: data, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                do {
                    print("Error trying to decode the response: \(data)")
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch {
                    print("Error happened while decoding")
                    print("Error is " + error.localizedDescription)

                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForDeleteRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print("No error in delete response")
            
            let decoder = JSONDecoder()
            guard let data = data else {
                print("No data in response")
                return
            }
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print("newData in response is " + String(data: newData, encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                do {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch {
                    print("Error happened while decoding")
                    print("Error is " + error.localizedDescription)

                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
