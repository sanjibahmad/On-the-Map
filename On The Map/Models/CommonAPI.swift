//
//  CommonAPIClient.swift
//  On The Map
//
//  Created by Sanjib Ahmad on 6/6/15.
//  Copyright (c) 2015 Object Coder. All rights reserved.
//

import Foundation

class CommonAPI {
    let session = NSURLSession.sharedSession()
    
    // can be overridden by a subclass
    var skipResponseDataLength: Int? = nil
    var additionalHTTPHeaderFields: [String:String]? = nil
    
    struct ErrorMessages {
        static let noInternet = "You appear to be offline, please connect to the Internet to use On the Map."
        static let invalidURL = "Invalid URL"
        static let emptyURL = "Empty URL"
    }
    
    func httpGet(urlString: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        if IJReachability.isConnectedToNetwork() == false {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.noInternet]))
            return
        }
        
        if urlString != "" {
            if let url = NSURL(string: urlString) {
                let request = NSMutableURLRequest(URL: url)
                if let additionalHTTPHeaderFields = additionalHTTPHeaderFields {
                    for (httpHeaderField, value) in additionalHTTPHeaderFields {
                        request.addValue(value, forHTTPHeaderField: httpHeaderField)
                    }
                }
                let task = session.dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        completionHandler(result: nil, error: error)
                        return
                    }
                    self.parseJSONData(data, completionHandler: completionHandler)
                }
                task.resume()
            } else {
                completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.invalidURL]))
            }
        } else {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.emptyURL]))
        }
        
    }
    
    func httpPost(urlString: String, httpBodyParams: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        if IJReachability.isConnectedToNetwork() == false {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.noInternet]))
            return
        }
        
        if urlString != "" {
            if let url = NSURL(string: urlString) {
                let request = NSMutableURLRequest(URL: url)
                if let additionalHTTPHeaderFields = additionalHTTPHeaderFields {
                    for (httpHeaderField, value) in additionalHTTPHeaderFields {
                        request.addValue(value, forHTTPHeaderField: httpHeaderField)
                    }
                }
                request.HTTPMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(httpBodyParams, options: nil, error: nil)
                
                let task = session.dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        completionHandler(result: nil, error: error)
                        return
                    }
                    self.parseJSONData(data, completionHandler: completionHandler)
                }
                task.resume()
            } else {
                completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.invalidURL]))
            }
        } else {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.emptyURL]))
        }
    }
    
    func httpPut(urlString: String, httpBodyParams: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        if IJReachability.isConnectedToNetwork() == false {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.noInternet]))
            return
        }
        
        if urlString != "" {
            if let url = NSURL(string: urlString) {
                let request = NSMutableURLRequest(URL: url)
                if let additionalHTTPHeaderFields = additionalHTTPHeaderFields {
                    for (httpHeaderField, value) in additionalHTTPHeaderFields {
                        request.addValue(value, forHTTPHeaderField: httpHeaderField)
                    }
                }
                request.HTTPMethod = "PUT"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(httpBodyParams, options: nil, error: nil)
                
                let task = session.dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        completionHandler(result: nil, error: error)
                        return
                    }
                    self.parseJSONData(data, completionHandler: completionHandler)
                }
                task.resume()
            } else {
                completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.invalidURL]))
            }
        } else {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.emptyURL]))
        }
    }
    
    func httpDelete(urlString: String, cookieName: String?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        if IJReachability.isConnectedToNetwork() == false {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.noInternet]))
            return
        }
        
        if urlString != "" {
            if let url = NSURL(string: urlString) {
                let request = NSMutableURLRequest(URL: url)
                if let additionalHTTPHeaderFields = additionalHTTPHeaderFields {
                    for (httpHeaderField, value) in additionalHTTPHeaderFields {
                        request.addValue(value, forHTTPHeaderField: httpHeaderField)
                    }
                }
                request.HTTPMethod = "DELETE"
                
                if let cookieName = cookieName {
                    var cookie: NSHTTPCookie? = nil
                    let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                    for sharedCookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
                        if sharedCookie.name == cookieName { cookie = sharedCookie }
                    }
                    if let cookie = cookie {
                        request.addValue(cookie.value!, forHTTPHeaderField: cookieName)
                    }
                }
                
                let task = session.dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        completionHandler(result: nil, error: error)
                        return
                    }
                    self.parseJSONData(data, completionHandler: completionHandler)
                }
                task.resume()
            } else {
                completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.invalidURL]))
            }
        } else {
            completionHandler(result: nil, error: NSError(domain: "OnTheMap Error", code: 1, userInfo: [NSLocalizedDescriptionKey : ErrorMessages.emptyURL]))
        }
    }
    
    // Method helpers for subclass
    
    func methodKeySubstitute(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    func methodParamsFromDictionary(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // Helpers for JSON parsing
    
    private func parseJSONData(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        let newData: NSData
        if skipResponseDataLength != nil {
            newData = data.subdataWithRange(NSMakeRange(skipResponseDataLength!, data.length - skipResponseDataLength!)) /* subset response data! */
        } else {
            newData = data
        }
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
}