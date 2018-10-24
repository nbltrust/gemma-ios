//
//  SimpleHTTPService.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

class SimpleHTTPService {
    static func requestETHPrice() -> Promise<[JSON]> {
        var request = URLRequest(url: URL(string: NetworkConfiguration.ETHPrice)!)
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = 5

        let (promise, seal) = Promise<[JSON]>.pending()
        Alamofire.request(request).responseJSON(queue: DispatchQueue.main, options: .allowFragments) { (response) in
            var rmbPrices = [JSON]()
            guard let value = response.result.value else {
                seal.fulfill([])
                return
            }
            let json = JSON(value)

            let prices = json["prices"].arrayValue
            for price in prices {
                rmbPrices.append(price)
            }
            seal.fulfill(rmbPrices)
            saveUnitToLocal(rmbPrices: rmbPrices)
        }
        return promise
    }
}
