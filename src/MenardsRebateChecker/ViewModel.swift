//
//  ViewModel.swift
//  MenardsRebateChecker
//
//  Created by Mitch Scobell on 6/14/23.
//

import Foundation

struct RebateWrapper: Hashable, Codable {
    let validQueryParameters: Bool
    let guestRebates: [GuestRebate]
}

struct GuestRebate: Hashable, Codable {
    let guest: Guest
    let rebates: [Rebate]
}

struct Guest: Hashable, Codable {
    let guestId: Int
    let firstInitial: String
    let firstName: String
    let lastName: String
    let houseNumber: Int
    let address: String
    let city: String
    let state: String
    let zip: String
    let active: Bool
    let statusDate: String
}

struct Rebate: Hashable, Codable {
    let checkDate: String?
    let redeemedDate: String?
    let purchaseDate: String?
    let rebateNumber: String
    let description: String
    let amount: String
    let status: String
    let maskedCheckNumber: String?
}

class ViewModel: ObservableObject {
    var firstInitial: String = ""
    var lastName: String = ""
    var houseNumber: String = ""
    var zip: String = ""
    
    @Published var guestRebates: [GuestRebate] = []
    
    func fetch() {
        
        let firstNameInitial = firstInitial.prefix(1)
    
        guard let url = URL(string: "https://www.rebateinternational.com/RebateInternational/trackByGuest.ajx?firstInitial=" + firstNameInitial + "&lastName=" + lastName + "&houseNumber=" + houseNumber + "&zip=" + zip ) else { return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // convert to json
            do {
                let rebateWrapper = try JSONDecoder().decode(RebateWrapper.self, from: data)
                DispatchQueue.main.async {
                    self?.guestRebates = rebateWrapper.guestRebates
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
