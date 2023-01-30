//
//  TensorflowLiteInit.swift
//  PicGuess
//
//  Created by Sabina Huseynova on 20.01.23.
//

import TensorFlowLiteTaskVision
import UIKit

/// A result from the `Classifications`.
struct ImageClassificationResult {
    //  let inferenceTime: Double
    let classifications: Classifications
}

/// Information about a model file or labels file.
typealias FileInfo = (name: String, extension: String)

/// This class handles all data preprocessing and makes calls to run inference on a given frame
/// by invoking the TFLite `ImageClassifier`. It then returns the top N results for a successful
/// inference.
class TensorflowLiteInit {
    
    // MARK: - Model Parameters
    /// TensorFlow Lite `Interpreter` object for performing inference on a given model.
    private var classifier: ImageClassifier
    
    /// Information about the alpha component in RGBA data.
    //  private let alphaComponent = (baseOffset: 4, moduloRemainder: 3)
    
    // MARK: - Initialization
    /// A failable initializer for `ClassificationHelper`. A new instance is created if the model and
    /// labels files are successfully loaded from the app's main bundle. Default `threadCount` is 1.
    init?(modelFileInfo: FileInfo) {
        let modelFilename = modelFileInfo.name
        // Construct the path to the model file.
        guard
            let modelPath = Bundle.main.path(
                forResource: modelFilename,
                ofType: modelFileInfo.extension
            )
        else {
            print("Failed to load the model file with name: \(modelFilename).")
            return nil
        }
        //      guard let modelPath = Bundle.main.path(forResource: "birds_V1", ofType: "tflite") else { return }
        
        // Configures the initialization options.
        //    let options = ImageClassifierOptions(modelPath: modelPath)
        //      options.baseOptions.computeSettings.cpuSettings.numThreads = Int(threadCount)
        //    options.classificationOptions.maxResults = resultCount
        //    options.classificationOptions.scoreThreshold = scoreThreshold
        
        let options = ImageClassifierOptions(modelPath: modelPath)
        
        do {
            classifier = try ImageClassifier.classifier(options: options)
        } catch let error {
            print("Failed to create the interpreter with error: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    //      MARK: -
    
    
    // Configure any additional options:
    // options.classificationOptions.maxResults = 3
    
    //        let classifier = try ImageClassifier.classifier(options: options)
    
    // Convert the input image to MLImage.
    // There are other sources for MLImage. For more details, please see:
    // https://developers.google.com/ml-kit/reference/ios/mlimage/api/reference/Classes/GMLImage
    func classify(modelImage: UIImage?) -> ImageClassificationResult? {
        
        
        guard let image = modelImage else { return nil}
        let imgSize = CGSize(width: 250, height: 250)
        let newImg = image.resized(to: imgSize)
        
        guard let mlImage = MLImage(image: newImg) else { return nil}
        // Run inference
        do {
            let classificationResults = try classifier.classify(mlImage: mlImage)
            guard let classifications = classificationResults.classifications.first else { return nil }
            return ImageClassificationResult(classifications: classifications)
            
        }
        catch let error {
            print("Failed to invoke the interpreter with error: \(error.localizedDescription)")
            return nil
        }
    }
    
}


// MARK: - Internal Methods
/// Performs image preprocessing, invokes the `ImageClassifier`, and processes the inference
/// results.
//  func classify(frame pixelBuffer: CVPixelBuffer) -> ImageClassificationResult? {
//    // Convert the `CVPixelBuffer` object to an `MLImage` object.
//    guard let mlImage = MLImage(pixelBuffer: pixelBuffer) else { return nil }
//
//    // Run inference using the `ImageClassifier{ object.
//    do {
//      let startDate = Date()
//      let classificationResults = try classifier.classify(mlImage: mlImage)
//      let inferenceTime = Date().timeIntervalSince(startDate) * 1000
//
//      // As all models used in this sample app are single-head models, gets the classification
//      // result from the first (and only) classification head and return to the view controller to
//      // display.
//      guard let classifications = classificationResults.classifications.first else { return nil }
//      return ImageClassificationResult(
//        inferenceTime: inferenceTime, classifications: classifications)
//    } catch let error {
//      print("Failed to invoke the interpreter with error: \(error.localizedDescription)")
//      return nil
//    }
//struct TensorflowLiteInit {
//    
//    // Initialization
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
//    }
//    
//    
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//
//    @Binding var selectedImage: UIImage
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = sourceType
//        imagePicker.delegate = context.coordinator
//
//        return imagePicker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//        var parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                parent.selectedImage = image
//            }
//
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}

