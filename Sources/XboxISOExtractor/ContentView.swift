import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isoPath: String = ""
    @State private var outputPath: String = ""
    @State private var isExtracting: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var isSuccess: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack {
                Text("Xbox 360 ISO Extractor")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("macOS")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            // ISO Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("1. ISO Dosyasını Seç:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    TextField("ISO dosyası seçin...", text: $isoPath)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true)
                    
                    Button("Gözat") {
                        selectISOFile()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal, 20)
            
            // Output Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("2. Hedef Klasörü Seç:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    TextField("Hedef klasör seçin...", text: $outputPath)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true)
                    
                    Button("Gözat") {
                        selectOutputFolder()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal, 20)
            
            // Extract Button
            Button(action: runExtract) {
                HStack {
                    if isExtracting {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(isExtracting ? "Çıkarılıyor..." : "ISO'yu Çıkar")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isExtracting ? Color.gray : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isExtracting || isoPath.isEmpty || outputPath.isEmpty)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(width: 520, height: 300)
        .background(Color(NSColor.controlBackgroundColor))
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Tamam") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func selectISOFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [UTType(filenameExtension: "iso")!]
        panel.title = "ISO Dosyası Seç"
        
        if panel.runModal() == .OK {
            isoPath = panel.url?.path ?? ""
        }
    }
    
    private func selectOutputFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.title = "Hedef Klasör Seç"
        
        if panel.runModal() == .OK {
            outputPath = panel.url?.path ?? ""
        }
    }
    
    private func runExtract() {
        guard !isoPath.isEmpty && !outputPath.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen hem ISO dosyasını hem de hedef klasörü seçin.", isSuccess: false)
            return
        }
        
        // extract-xiso binary path - Swift Package Manager için
        let extractXisoPath = getExtractXisoPath()
        
        guard let extractXisoPath = extractXisoPath else {
            showAlert(title: "Hata", message: "'extract-xiso' dosyası bulunamadı.", isSuccess: false)
            return
        }
        
        isExtracting = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: extractXisoPath)
            process.arguments = ["-d", outputPath, isoPath]
            
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe
            
            do {
                try process.run()
                process.waitUntilExit()
                
                DispatchQueue.main.async {
                    isExtracting = false
                    
                    if process.terminationStatus == 0 {
                        showAlert(title: "Başarılı", message: "ISO başarıyla çıkarıldı!", isSuccess: true)
                    } else {
                        let data = pipe.fileHandleForReading.readDataToEndOfFile()
                        let output = String(data: data, encoding: .utf8) ?? "Bilinmeyen hata"
                        showAlert(title: "Hata", message: "Çıkarma işlemi başarısız oldu.\n\n\(output)", isSuccess: false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    isExtracting = false
                    showAlert(title: "Hata", message: "Çıkarma işlemi başarısız oldu.\n\n\(error.localizedDescription)", isSuccess: false)
                }
            }
        }
    }
    
    private func getExtractXisoPath() -> String? {
        // Swift Package Manager için binary dosyasını bulma
        let currentDirectory = FileManager.default.currentDirectoryPath
        let possiblePaths = [
            "\(currentDirectory)/Sources/XboxISOExtractor/Resources/extract-xiso",
            "\(currentDirectory)/XboxISOExtractor/extract-xiso",
            "\(currentDirectory)/extract-xiso/build/extract-xiso"
        ]
        
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        
        return nil
    }
    
    private func showAlert(title: String, message: String, isSuccess: Bool) {
        alertTitle = title
        alertMessage = message
        self.isSuccess = isSuccess
        showAlert = true
    }
}

#Preview {
    ContentView()
} 