//
//  RowView.swift
//  SpaceX Latest Launch
//
//  Created by Kaan Yıldız on 13.10.2021.
//

import SwiftUI
import UIKit


struct RowView: View {
    var title : String
    var text : String?
    var image : UIImage?
    var color = Color.init(white: 0.95, opacity: 1.0)
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(.gray)
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 24).foregroundColor(color).shadow(color: Color.black.opacity(0.2), radius: 10, x: 2, y: 2)
                if text != nil {
                    Text(text != "" ? text! : "No \(title)").font(.body).padding()
                } else if image != nil {
                    Image(uiImage: image!).cornerRadius(12).padding(2)
                } else {
                    ProgressView().progressViewStyle(.circular)
                }
                
            }
        }
        
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(title: "Title", text: "Text")
    }
}
