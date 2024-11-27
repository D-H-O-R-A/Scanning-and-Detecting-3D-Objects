import Foundation
import ARKit
import SceneKit

class DetectedBoundingBox: SCNNode {
    
    // Inicialização da malha 3D com pontos e escala
    init(points: [float3], scale: CGFloat, color: UIColor = .appYellow) {
        super.init()
        
        // Calculando as extremidades mínima e máxima para determinar as dimensões da malha
        var localMin = float3(Float.greatestFiniteMagnitude)
        var localMax = float3(-Float.greatestFiniteMagnitude)
        
        for point in points {
            localMin = min(localMin, point)
            localMax = max(localMax, point)
        }
        
        // Posiciona a malha no centro dos pontos detectados
        self.simdPosition += (localMax + localMin) / 2
        
        // Extensão do objeto
        let extent = localMax - localMin
        
        // Criação de uma malha 3D a partir dos pontos detectados
        let geometry = create3DMesh(from: points, scale: scale)
        
        // Aplica a cor à malha
        let material = SCNMaterial()
        material.diffuse.contents = color
        geometry.materials = [material]
        
        // Cria o nó de visualização para a malha
        let wireframe = SCNNode(geometry: geometry)
        self.addChildNode(wireframe)
    }
    
    // Função para criar uma malha 3D a partir de pontos utilizando triangulação
    func create3DMesh(from points: [float3], scale: CGFloat) -> SCNGeometry {
        var vertices: [SCNVector3] = []
        var indices: [Int32] = []
        
        // Escala os pontos antes de usá-los para criar os vértices
        for point in points {
            let scaledPoint = SCNVector3(point.x * Float(scale), point.y * Float(scale), point.z * Float(scale))
            vertices.append(scaledPoint)
        }
        
        // Triangulação dos pontos para formar uma malha
        // Neste exemplo simplificado, vamos usar a abordagem de Delaunay para formar uma malha de triângulos
        indices = triangulatePoints(vertices: vertices)
        
        // Criando a geometria de malha (faces triangulares)
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    // Função simples de triangulação (precisa ser substituída por um algoritmo real de triangulação de Delaunay)
    func triangulatePoints(vertices: [SCNVector3]) -> [Int32] {
        // Aqui, uma triangulação simples será realizada criando faces entre os pontos (isso é uma simplificação)
        // Na prática, seria melhor usar uma biblioteca para triangulação de Delaunay 3D, mas este exemplo assume um conjunto básico de triângulos.
        
        var indices: [Int32] = []
        
        // Exemplo simplificado: criar triângulos básicos entre os pontos
        for i in 0..<(vertices.count - 2) {
            indices.append(Int32(i))
            indices.append(Int32(i + 1))
            indices.append(Int32(i + 2))
        }
        
        return indices
    }
    
    // Inicialização necessária para deserialização a partir do storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
