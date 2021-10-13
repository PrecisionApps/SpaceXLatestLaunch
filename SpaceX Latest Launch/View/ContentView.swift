//
//  ContentView.swift
//  SpaceX Latest Launch
//
//  Created by Kaan Yıldız on 13.10.2021.
//

import SwiftUI
import UIKit // Used just for colors, a seperate color class would be better in a larger project

struct ContentView: View {
    @ObservedObject var viewModel : SpaceXLaunchFetcher
    var body: some View {
        switch viewModel.launch {
        case nil:
            if viewModel.error != nil {
                Text(viewModel.error)
            } else {
                ProgressView().progressViewStyle(.circular)
            }
            
            
        default:
            
            
            ZStack { // For outer rectangle
                VStack {
                    //Name
                    
                    RowView(title: "Launch Name", text: viewModel.launch.name)
                    if viewModel.patchImageResponse.image != nil {
                        //Image is retrieved
                        RowView(title: "Patch", image: viewModel.patchImageResponse.image,color: Color.init(hue: 0.55, saturation: 0.2, brightness: 0.85))
                    } else {
                        RowView(title: "Patch", text: viewModel.patchImageResponse.error,color: Color.init(hue: 0.55, saturation: 0.2, brightness: 0.85))
                    }
                    
                    
                    RowView(title: "Details",text: viewModel.launch.details ?? "",color: Color.init(hue: 0.35, saturation: 0.24, brightness: 0.85))
                    
                    
                    
                }.padding()
                
                
            }
            
            
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: SpaceXLaunchFetcher())
    }
}
