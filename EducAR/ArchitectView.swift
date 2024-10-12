import SwiftUI
import RealityKit
import Photos

struct ArchitectView: View {
    @State private var isMenuOpen = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                Text("Selecciona una opcion para comenzar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .padding(.bottom, 40)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        sistemaCard(title: "Sistemas Estructurales", imageName: "estructural", destination: StructuralSystemsView())
                        sistemaCard(title: "Estilos Arquitectonicos", imageName: "archstyle", destination: ArchitecturalStylesView())
                        sistemaCard(title: "Diseño de interiores", imageName: "interior", destination: InteriorDesignView())
                        sistemaCard(title: "Planificacion Urbana", imageName: "urban", destination: UrbanPlanningView())
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    func sistemaCard(title: String, imageName: String, destination: some View) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading, 20)

                Spacer()

                Image(imageName)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .padding(.trailing, 20)
            }
            .frame(width: 350, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#5BBA6F"))
            )
            .shadow(radius: 5)
        }
    }
}

struct StructuralSystemsView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "house")
    @Environment(\.presentationMode) var presentationMode  // To manage dismissal
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)  // Extend to edges of screen
                .navigationBarBackButtonHidden(true)  // Hide default back button

            VStack {
                HStack {
                    // X Button to dismiss view, positioned in the top-left corner
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Dismiss the current view
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    .padding()
                    
                    Spacer()  // Push the button to the left
                }
                Spacer()  // Push content to top
            }
        }
    }
}

struct ArchitecturalStylesView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "barroco")
    @Environment(\.presentationMode) var presentationMode  // To manage dismissal
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)  // Extend to edges of screen
                .navigationBarBackButtonHidden(true)  // Hide default back button

            VStack {
                HStack {
                    // X Button to dismiss view, positioned in the top-left corner
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Dismiss the current view
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    .padding()
                    
                    Spacer()  // Push the button to the left
                }
                Spacer()  // Push content to top
            }
        }
    }
}

struct InteriorDesignView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "interiore")
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var menuOpen = false // Toggle state for menu
    @State private var currentModel: String = "interiore"

    let modelPreviews = [
        ("Sala", "interiore"),
        ("Cocina", "kitchen"),
        ("Dormitorio", "rest"),
        ("hospital", "hospital")
    ]
    
    var body: some View {
        ZStack {
            // AR View
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)

            // Top controls
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: takeAndSaveScreenshot) {
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    .padding()
                }
                Spacer()
            }

            
            VStack {
                Spacer()
                
                HStack {
                    if menuOpen {
                        // Horizontal scrollable previews
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(modelPreviews, id: \.0) { model in
                                    Button(action: {
                                        currentModel = model.1.lowercased()
                                        arViewModel.loadModel(named: currentModel)
                                    }) {
                                        VStack {
                                            Image(model.1)
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(10)
                                            Text(model.0)
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        }
                                        .frame(width: 100)
                                        .cornerRadius(10)
                                        .padding(.horizontal, 5)
                                    }
                                }
                            }
                            .padding(.leading, menuOpen ? 20 : 0)
                        }
                        .frame(height: 120)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            menuOpen.toggle()
                        }
                    }) {
                        Image(systemName: menuOpen ? "chevron.right" : "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .frame(width: 35, height: 90)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Screenshot"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }


    private func takeAndSaveScreenshot() {
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
                self.alertMessage = "Failed to capture screenshot"
                self.showAlert = true
                return
            }
        
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
        let screenshot = renderer.image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
        
        saveScreenshotToPhotoLibrary(screenshot)
    }
    
    private func saveScreenshotToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.alertMessage = "Captura guardada"
                            } else if let error = error {
                                self.alertMessage = "Error saving screenshot: \(error.localizedDescription)"
                            }
                            self.showAlert = true
                        }
                    }
                } else {
                    self.alertMessage = "Permission denied to save screenshot"
                    self.showAlert = true
                }
            }
        }
    }
}

struct UrbanPlanningView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "urban")
    @Environment(\.presentationMode) var presentationMode  // To manage dismissal
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)  // Extend to edges of screen
                .navigationBarBackButtonHidden(true)  // Hide default back button

            VStack {
                HStack {
                    // X Button to dismiss view, positioned in the top-left corner
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Dismiss the current view
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    .padding()
                    
                    Spacer()  // Push the button to the left
                }
                Spacer()  // Push content to top
            }
        }
    }
}
