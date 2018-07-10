//
//  HomeViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import HandyJSON
import SwiftyJSON

class HomeViewController: BaseViewController {
    @IBOutlet weak var mBgView: UIView!

    @IBOutlet weak var mWalletView: WalletView!
    var coordinator: (HomeCoordinatorProtocol & HomeStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        mWalletView.upDateImgView(mView: mBgView)
        
        if let abijson = EOSIO.getAbiJsonString(NetworkConfiguration.EOSIO_DEFAULT_CODE, action: EOSAction.transfer.rawValue, from: "awesome14", to: "hotwallet", quantity: "1.0000 EOS") {
            EOSIONetwork.request(target: .abi_json_to_bin(json: abijson), success: { (data) in
                
            }, error: { (code) in
                
            }) { (error) in
                
            }
        }
        
        EOSIONetwork.request(target: .get_info, success: { (json) in
            let transaction = EOSIO.getTransaction("5JbCmXuRst8WAmjjj1NGCHJtMTjNfiHjNPFrXhk9qKjUNDCHdCh", code: NetworkConfiguration.EOSIO_DEFAULT_CODE, from: "awesome14", to: "hotwallet", quantity: "1.0000 EOS", memo: "ssss", getinfo: json.rawString()!, abistr: "00002041498a15370000c82a46c3336d102700000000000004454f530000000003737373")
            
            EOSIONetwork.request(target: .push_transaction(json: transaction!), success: { (json) in
                
            }, error: { (code) in
                
            }, failure: { (error) in
                
            })
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        
       
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}
