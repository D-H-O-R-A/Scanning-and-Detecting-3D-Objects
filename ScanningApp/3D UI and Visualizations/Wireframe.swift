import Foundation
import SceneKit

class Wireframe: SCNNode {
    
    private var color = UIColor.appYellow
    private var customWireframe: SCNNode?  // Para armazenar a "segunda pele"
    
    var isHighlighted: Bool = false {
        didSet {
            customWireframe?.geometry?.firstMaterial?.diffuse.contents = isHighlighted ? UIColor.red : color
        }
    }
    
    private var flashTimer: Timer?
    private var flashDuration = 0.1
    
    init(extent: float3, color: UIColor, scale: CGFloat = 1.0) {
        super.init()
        
        // Gerar a malha que contorna o objeto, ou um "wireframe" usando pontos.
        customWireframe = createWireframe(extent: extent)
        if let wireframe = customWireframe {
            wireframe.geometry?.firstMaterial?.diffuse.contents = color
            self.addChildNode(wireframe)
        }

        self.color = color
        setupShader()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(flash),
                                               name: ObjectOrigin.movedOutsideBoxNotification,
                                               object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(extent: float3) {
        // Atualiza a escala ou ajuste do contorno, se necessário
        customWireframe?.scale = SCNVector3(extent.x, extent.y, extent.z)
    }
    
    @objc
    func flash() {
        isHighlighted = true
        
        flashTimer?.invalidate()
        flashTimer = Timer.scheduledTimer(withTimeInterval: flashDuration, repeats: false) { _ in
            self.isHighlighted = false
        }
    }
    
    // MARK: - Gerar o Wireframe ou Malha Contornando o Objeto
    func createWireframe(extent: float3) -> SCNNode {
        // Criar uma linha contornando o objeto com base em sua extensão
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(-extent.x / 2), y: CGFloat(-extent.y / 2)))
        path.addLine(to: CGPoint(x: CGFloat(extent.x / 2), y: CGFloat(-extent.y / 2)))
        path.addLine(to: CGPoint(x: CGFloat(extent.x / 2), y: CGFloat(extent.y / 2)))
        path.addLine(to: CGPoint(x: CGFloat(-extent.x / 2), y: CGFloat(extent.y / 2)))
        path.close()

        let shape = SCNShape(path: path, extrusionDepth: CGFloat(extent.z))
        let node = SCNNode(geometry: shape)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.appYellow
        return node
    }
    
    // MARK: - Shading
    func setupShader() {
        guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "art.scnassets"),
              let shader = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        
        geometry?.firstMaterial?.shaderModifiers = [.surface: shader]
    }
}
