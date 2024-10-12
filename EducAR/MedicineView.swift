import SwiftUI
import Photos

struct MedicineView: View {
    @State private var isMenuOpen = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                Text("Selecciona una opcion para comenzar")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .padding(.bottom, 40)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        sistemaCard(title: "Sistema Oseo", imageName: "skelicon", destination: SkeletalSystemView())
                        sistemaCard(title: "Sistema Circulatorio", imageName: "circulatorio", destination: CirculatorySystemView())
                        sistemaCard(title: "Sistema Linfatico", imageName: "lymphatic", destination: LymphaticSystemView())
                        sistemaCard(title: "Sistema Muscular", imageName: "muscular", destination: MuscularSystemView())
                        sistemaCard(title: "Sistema de Órganos", imageName: "organs", destination: OrganSystemView())
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
                    .frame(width: 55, height: 100)
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

struct SkeletalSystemView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "oseo")
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)

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



struct CirculatorySystemView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "sanguineo")
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)

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

struct LymphaticSystemView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "linfatico")
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)

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


struct OrganSystemView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "organos")
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)

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

struct MuscularSystemView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "medicine")
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)

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
