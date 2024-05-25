//
//  ImagePicker.swift
//  StepWise
//
//  Created by Linus Gierling on 13.05.24.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

struct ContentPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedFileURL: URL?
    
    var body: some View {
        #if os(iOS)
        ContentPickeriOS(selectedFileURL: $selectedFileURL)
        #elseif os(macOS)
        ContentPickerMacOS(selectedFileURL: $selectedFileURL)
        #endif
    }
}

#if os(iOS)
struct ContentPickeriOS: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedFileURL: URL?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.image", "public.movie"]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, presentationMode: presentationMode)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ContentPickeriOS
        var presentationMode: Binding<PresentationMode>
        
        init(_ parent: ContentPickeriOS, presentationMode: Binding<PresentationMode>) {
            self.parent = parent
            self.presentationMode = presentationMode
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.imageURL] as? URL {
                parent.selectedFileURL = url
            }
            presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
#endif


#if os(macOS)
struct ContentPickerMacOS: NSViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedFileURL: URL?
    
    func makeNSView(context: Context) -> NSView {
        return NSView() // Return a dummy NSView as the actual panel will be handled by the coordinator.
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // No update logic needed as we handle everything through the panel.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSOpenSavePanelDelegate {
        var parent: ContentPickerMacOS
        
        init(_ parent: ContentPickerMacOS) {
            self.parent = parent
        }
        
        func beginPanel() {
            let panel = NSOpenPanel()
            panel.delegate = self
            panel.canChooseFiles = true
            panel.allowedFileTypes = ["public.image", "public.movie"]
            panel.allowsMultipleSelection = false
            panel.begin { (result) in
                if result == .OK, let url = panel.urls.first {
                    self.parent.selectedFileURL = url
                }
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
#endif
