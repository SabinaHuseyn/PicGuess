//
//  ContentView.swift
//  PicGuess
//
//  Created by Sabina Huseynova on 13.01.23.
//

import SwiftUI
import TensorFlowLiteTaskVision

struct ContentView: View {
    
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    @State private var image = UIImage()
    private var tensorResult: TensorflowLiteInit? = TensorflowLiteInit(modelFileInfo: FileInfo("DogVsCat_metadata", "tflite"))
    var body: some View {
        NavigationView {
        
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.gray)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .aspectRatio(contentMode: .fill)

                }
                .onTapGesture {
                    self.isShowPhotoLibrary = true
                }
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                Spacer()
                
                HStack{
                    Text("Camera")
                        .foregroundColor(.blue)
                        .font(.headline)
                    Image(systemName: "camera")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .onTapGesture {
                    self.isShowCamera = true
                }
                .sheet(isPresented: $isShowCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: self.$image)
                    
                }
                .padding(.vertical)
                Spacer()
                
                var res = tensorResult?.classify(modelImage: self.image)
                VStack {
                    HStack{
                        Text("Cat:")
//                            .padding(.leading)
                            .font(.headline)
                        Text(String(format: "%.2f", (res?.classifications.categories[0].score ?? 0) * 100.0) + "%")
                            .padding(.vertical)
                            .font(.headline)
                    }
//                    .padding(.leading)
                    HStack{
                        Text("Dog:")
//                            .padding(.vertical)
                            .font(.headline)
                        Text(String(format: "%.2f", (res?.classifications.categories[1].score ?? 0) * 100.0) + "%")
                            .padding(.vertical)
                            .font(.headline)
                    }
                }
                .position(x: 60, y: 80)
                
            }
            
            .navigationTitle("It is a...")
        }
        
        
    }
    
    //    MARK: - TensorFlowLiteTaskVision initialization
    
//    func tensorModelInit(){
//        guard let modelPath = Bundle.main.path(forResource: "birds_V1", ofType: "tflite") else { return }
//
//        let options = ImageClassifierOptions(modelPath: modelPath)
//
//        // Configure any additional options:
//        // options.classificationOptions.maxResults = 3
//
//        let classifier = try ImageClassifier.classifier(options: options)
//
//        // Convert the input image to MLImage.
//        // There are other sources for MLImage. For more details, please see:
//        // https://developers.google.com/ml-kit/reference/ios/mlimage/api/reference/Classes/GMLImage
//        guard let image = UIImage (named: "sparrow.jpg"), let mlImage = MLImage(image: image) else { return }
//
//        // Run inference
//        let classificationResults = try classifier.classify(mlImage: mlImage)
//    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
