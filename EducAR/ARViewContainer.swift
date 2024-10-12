import SwiftUI
import ARKit
import RealityKit

struct ARViewContainerView: View {
    @StateObject private var arViewModel = ARViewModel(modelName: "your_model_name")
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        
                        print("Dismissed AR view")
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var arViewModel: ARViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = arViewModel.arView
        arViewModel.setupARView()

       
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinchGesture(_:)))
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePanGesture(_:)))

        arView.addGestureRecognizer(pinchGesture)
        arView.addGestureRecognizer(panGesture)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        arViewModel.updateARView()
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(arViewModel: arViewModel)
    }

    class Coordinator: NSObject {
        var arViewModel: ARViewModel

        init(arViewModel: ARViewModel) {
            self.arViewModel = arViewModel
        }

        @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
            guard let entity = arViewModel.modelEntity else { return }
            let scale = Float(gesture.scale)
            entity.scale *= SIMD3<Float>(repeating: scale)
            gesture.scale = 1.0
        }

        @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let entity = arViewModel.modelEntity else { return }
            let translation = gesture.translation(in: gesture.view)
            let translation3D = SIMD3<Float>(Float(translation.x) * 0.01, Float(translation.y) * 0.01, 0)
            entity.position += translation3D
            gesture.setTranslation(.zero, in: gesture.view)
        }
    }
}



class ARViewModel: ObservableObject {
    @Published var modelName: String

    
    let arView = ARView(frame: .zero)
    var modelEntity: ModelEntity?
    var currentAnchor: AnchorEntity?

    init(modelName: String) {
        self.modelName = modelName
        loadModel(named: modelName)
    }



    func setupARView() {
            guard let modelEntity = modelEntity else {
                print("Model not loaded. AR setup aborted.")
                return
            }

            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            arView.session.run(configuration)

            arView.scene.anchors.removeAll()

            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.addChild(modelEntity)
            modelEntity.position = [0, 0, 0]
            arView.scene.addAnchor(anchorEntity)

            print("ARView setup complete. Model should be visible.")
        }

    func updateARView() {
    }

    func loadModel(named modelName: String) {
        Task {
            do {
                print("Attempting to load model: \(modelName)")
                let model = try await ModelEntity.loadModel(named: modelName)
                self.modelEntity = model
                print("Model \(modelName) loaded successfully.")
                setupARView()
            } catch {
                print("Error loading model: \(error.localizedDescription)")
            }
        }
    }
}
