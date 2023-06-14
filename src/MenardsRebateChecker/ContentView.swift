//
//  ContentView.swift
//  MenardsRebateChecker
//
//  Created by Mitch Scobell on 6/14/23.
//

import SwiftUI

struct RebateView: View {
    var firstInitial: String
    var lastName: String
    var houseNumber: String
    var zipCode: String
    
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
                List {
                    ForEach(viewModel.guestRebates, id: \.self) { guestRebate in
                        Text(guestRebate.guest.lastName + ", " + guestRebate.guest.firstName)
                            .bold()
                            
                        ForEach(guestRebate.rebates, id: \.self) {
                            rebate in
                            HStack {
                                Text (rebate.amount + ": ")
                                    .bold()
                                Text (rebate.status)
                            }
                        }
                        
                    }
                }
                .onAppear{
                    viewModel.firstInitial = firstInitial
                    viewModel.lastName = lastName
                    viewModel.houseNumber = houseNumber
                    viewModel.zip = zipCode
                    
                    viewModel.fetch()
                }
           
        }.navigationTitle("Rebates")
    }
}

struct LandingScreen: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var houseNumber = ""
    @State private var zipCode = ""
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }
                    Section(header: Text("Address Information")) {
                        TextField("House Number", text: $houseNumber)
                        TextField("Zip Code", text: $zipCode)
                    }
                }
                    
                NavigationLink(destination: RebateView(firstInitial: $firstName.wrappedValue, lastName: $lastName.wrappedValue, houseNumber: $houseNumber.wrappedValue, zipCode: $zipCode.wrappedValue), label: {
                    Text("Search for Rebates 🔍")
                        .bold()
                        .frame(width: 280, height: 50)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                
            }.navigationTitle("Rebate Information")
        }
    }
}

struct CircleNumberView: View {
    var color: Color
    var number: Int
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
            Text("\(number)")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .bold))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen()
    }
}
