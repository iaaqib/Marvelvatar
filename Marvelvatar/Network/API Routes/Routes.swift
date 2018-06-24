//
//  Routes.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit
import Alamofire

enum Routes: URLRequestConvertible {
    case characters(limit: Int?, offset:Int?, nameStartsWith: String?)
}
extension Routes {
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .characters(limit, offset, nameStartsWith):
                var params: Parameters = APIConfig.apiParams()
                if let limit = limit {
                    params["limit"] = limit
                }
                if let offset = offset{
                    params["offset"] = offset
                }
                if let nameStarts = nameStartsWith, nameStarts != ""{
                    params["nameStartsWith"] = nameStartsWith
                }
                return ("/v1/public/characters", params)
            }
        }()
        let url = try APIConfig.baseURL.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
    
}
