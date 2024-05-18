//
//  ImagePicker.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import SwiftUI
import UIKit
import Photos

struct ContentPicker: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedFileURL: URL?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ContentPicker

        init(_ parent: ContentPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Attempt to extract a local identifier from the picked asset
            if let asset = info[.phAsset] as? PHAsset {
                let assetLocalIdentifier = asset.localIdentifier
                // Construct an asset URL using the local identifier (this is just a representation)
                let assetURL = "assets-library://asset/asset.JPG?id=\(assetLocalIdentifier)&ext=JPG"
                parent.selectedFileURL = URL(string: assetURL)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image", "public.movie"]
        return picker
    }
}
