//
//  ContentView.swift
//  PicGuess
//
//  Created by Sabina Huseynova on 13.01.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    
                    //                Button(action: {
                    //                })
                }
                .onTapGesture {
                    self.isShowPhotoLibrary = true
                }
                
                Text("Dog")
                    .padding(.vertical)
                    .font(.headline)
//                    .foreground JKLColor(.mint)
                Text("Cat")
                    .padding(.vertical)
                    .font(.headline)
//                    .foregroundColor(.accentColor)

            }
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            
            .navigationTitle("On picture is a...")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
