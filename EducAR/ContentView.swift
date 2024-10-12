import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var currentIndex = 0
    @State private var isMenuOpen = false
    @State private var isLanguageMenuOpen = false
    
    let items = [
        CarouselItem(title: "Medicina", modelName: "medicine.usdz"),
        CarouselItem(title: "Arquitectura", modelName: "roman.usdz")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Bienvenido")
                        .font(.system(size: 45))
                        .fontWeight(.medium)
                        .padding(20)
                        .padding(.top, 20)
                    
                    Text("Sumérgete al futuro del aprendizaje con")
                        .font(.system(size: 23))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 340)
                        .lineSpacing(8)
                        .padding(.bottom, 40)

                    
                    
                    Text("Realidad Aumentada")
                        .font(.system(size: 29))
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                        .padding(.bottom, 50)

                    
                    ZStack {
                        ForEach(0..<items.count, id: \.self) { index in
                            if index == currentIndex {
                                CarouselCard(item: items[index])
                                    .transition(.slide)
                                    .animation(.default, value: currentIndex)
                                    .frame(width: 300, height: 300) // Adjust the size of the card
                            }
                        }
                        
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    currentIndex = (currentIndex - 1 + items.count) % items.count
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 16, height: 32)
                                    .foregroundColor(.gray)
                                    .opacity(0.8)
                                    .padding()
                            }
                            
                            Spacer()
                            
                            
                            Button(action: {
                                withAnimation {
                                    currentIndex = (currentIndex + 1) % items.count
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 16, height: 32)
                                    .foregroundColor(.gray)
                                    .opacity(0.8)
                                    .padding()
                            }
                        }
                        .frame(width: 370)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 300) // Adjust the height of the ZStack
                    
                    Spacer()
                    
                    Text("Presiona algun modelo para continuar")
                        .font(.system(size: 15))
                        
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    
                }
                
                
                
                if isMenuOpen {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isMenuOpen = false
                        }
                        .transition(.opacity)
                }
                
                if isMenuOpen {
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            Link(destination: URL(string: "https://kevingael.com")!) {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.black)
                                    Text("Acerca del Proyecto")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .padding(.bottom, 120)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .transition(.move(edge: .leading))
                            
                            Button(action: {
                                withAnimation {
                                    isMenuOpen = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: "ellipsis.message.fill")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.black)
                                    Text("Feedback")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .padding(.bottom, 120)
                            }
                            .transition(.move(edge: .leading))
                            
                            Button(action: {
                                withAnimation {
                                    isMenuOpen = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.black)
                                    Text("V 1.0")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                                .padding()
                            }
                            .transition(.move(edge: .leading))
                            
                            Spacer()
                        }
                        .frame(width: 220)
                        .background(Color.white)
                        .cornerRadius(10)
                        .edgesIgnoringSafeArea(.all)
                        
                        Spacer()
                    }
                    .transition(.move(edge: .leading))
                }
                
                if isLanguageMenuOpen {
                    VStack(alignment: .trailing) {
                        Spacer()
                        
                        Button(action: {
                            print("Selected English")
                        }) {
                            HStack {
                                Text("English")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                                Image(systemName: "globe")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .padding(.bottom,70)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .transition(.move(edge: .top))
                        
                        Button(action: {
                            print("Selected French")
                        }) {
                            HStack {
                                Text("Français")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                                Image(systemName: "globe")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .transition(.move(edge: .top))
                        
                        Spacer()
                    }
                    .frame(width: 400)
                    .background(Color.white)
                    .cornerRadius(10)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.move(edge: .top))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if isMenuOpen {
                            isMenuOpen = false
                        } else {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        }
                    }) {
                        Image("menu")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Button(action: {
                            if isLanguageMenuOpen {
                                isLanguageMenuOpen = false
                            } else {
                                withAnimation {
                                    isLanguageMenuOpen.toggle()
                                }
                            }
                        }) {
                            Text("SP")
                                .font(.system(size: 25))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
                            Image(systemName: "chevron.down")
                                .resizable()
                                .frame(width: 25, height: 12)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}


struct CarouselItem {
    let title: String
    let modelName: String
}

struct CarouselCard: View {
    let item: CarouselItem
    
    var body: some View {
        NavigationLink(destination: destinationView(for: item.title)) {
            VStack {
                ARSceneView(modelName: item.modelName)
                    .frame(width: 300, height: 300)
                
                VStack {
                    Text(item.title)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.white) // Set text color to white
                        .padding() // Add padding inside the container
                        .background(Color(hex: "#5BBA6F")) // Set background color of the container
                        .cornerRadius(10) // Add corner radius to the container
                }
                .padding(.horizontal, 20) // Add padding around the container
            }
            .frame(width: 250, height: 250)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#FFFFFF")) // Card background color
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling for NavigationLink
    }
    
    func destinationView(for title: String) -> some View {
        switch title {
        case "Medicina":
            return AnyView(MedicineView())
        case "Arquitectura":
            return AnyView(ArchitectView())
        default:
            return AnyView(Text("Unknown View"))
        }
    }
}
struct ARSceneView: UIViewRepresentable {
    var modelName: String
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView(frame: .zero)
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        
        let scene = SCNScene(named: modelName) ?? SCNScene()
        
        scene.background.contents = UIColor(hex: "#FFFFFF") // Match the card color
        scnView.scene = scene
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
}


import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// Preview
#Preview {
    ContentView()
}
