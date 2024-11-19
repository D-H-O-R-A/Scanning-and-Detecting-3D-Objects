import Foundation
import ARKit
import SceneKit

class DetectedBoundingBox: SCNNode {
    
    // Inicialização da caixa com pontos e escala
    init(points: [float3], scale: CGFloat, color: UIColor = .appYellow) {
        super.init()
        
        // Calculando as extremidades mínima e máxima para determinar as dimensões da caixa
        var localMin = float3(Float.greatestFiniteMagnitude)
        var localMax = float3(-Float.greatestFiniteMagnitude)
        
        for point in points {
            localMin = min(localMin, point)
            localMax = max(localMax, point)
        }
        
        // Posiciona a caixa no centro dos pontos detectados
        self.simdPosition += (localMax + localMin) / 2
        
        // Extensão do objeto
        let extent = localMax - localMin
        
        // Cria uma caixa (ou outra forma geométrica) com base na extensão calculada
        let geometry = SCNBox(width: CGFloat(extent.x) * scale,
                              height: CGFloat(extent.y) * scale,
                              length: CGFloat(extent.z) * scale,
                              chamferRadius: 0)
        
        // Aplica cor à caixa
        let material = SCNMaterial()
        material.diffuse.contents = color
        geometry.materials = [material]
        
        // Cria o nó de visualização para a caixa
        let wireframe = SCNNode(geometry: geometry)
        self.addChildNode(wireframe)
    }
    
    // Inicialização necessária para deserialização a partir do storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
