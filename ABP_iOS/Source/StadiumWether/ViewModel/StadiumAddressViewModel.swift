//
//  StadiumAdressViewModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/8/23.
//

import Foundation
import Combine


class StadiumAddressViewModel {
    
    @Published var item: AddressModel!
    
    func setAddress(body: [String:Any] ) {
        item = AddressModel(jsonData: body)
        print(item!)
    }
}
