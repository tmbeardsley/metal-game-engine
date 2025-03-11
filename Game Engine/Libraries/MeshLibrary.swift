import MetalKit

enum MeshTypes {
    case Triangle_Custom
    case Quad_Custom
}


class MeshLibrary {
    
    // Dictionary holding different instantiated meshes
    private static var meshes: [MeshTypes: Mesh] = [:]                           // Mesh is a protocol specified below
    
    public static func Initialize() {
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes() {
        meshes.updateValue(Triangle_CustomMesh(),   forKey: .Triangle_Custom)       // Triangle_CustomMesh is a class specified below
        meshes.updateValue(Quad_CustomMesh(),       forKey: .Quad_Custom)           // Triangle_CustomMesh is a class specified below
    }
    
    // Retrieve a mesh by key
    public static func Mesh(_ meshType: MeshTypes) -> Mesh {
        return meshes[meshType]!
    }
    
}




// Akin to a C++ abstract base class
protocol Mesh {
    var vertexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
}


// A mesh class that conforms to the Mesh protocol
class CustomMesh: Mesh {
    
    // Array of vertices that is populated by function: createVertices()
    var vertices: [Vertex]!
    
    // Create gpu accessible memory
    var vertexBuffer: MTLBuffer!
    var vertexCount: Int! {
        return vertices.count
    }
    
    init() {
        // Create vertex data
        createVertices()
        
        // Create buffers of gpu accessible memory
        createBuffers()
    }
    
    func createVertices() { }
    
    func createBuffers() {
        self.vertexBuffer = Engine.Device.makeBuffer(bytes: self.vertices, length: Vertex.stride(self.vertices.count), options: [])
    }
}



class Triangle_CustomMesh: CustomMesh {
    override func createVertices() {
        self.vertices = [
            Vertex(position: SIMD3<Float>(0, 1, 0), colour: SIMD4<Float>(1, 0, 0, 1)),
            Vertex(position: SIMD3<Float>(-1, -1, 0), colour: SIMD4<Float>(0, 1, 0, 1)),
            Vertex(position: SIMD3<Float>(1, -1, 0), colour: SIMD4<Float>(0, 0, 1, 1))
        ]
    }

}


class Quad_CustomMesh: CustomMesh {
    override func createVertices() {
        self.vertices = [
            Vertex(position: SIMD3<Float>( 0.5,  0.5, 0), colour: SIMD4<Float>(1, 0, 0, 1)),      // top right
            Vertex(position: SIMD3<Float>(-0.5,  0.5, 0), colour: SIMD4<Float>(0, 1, 0, 1)),     // top left
            Vertex(position: SIMD3<Float>(-0.5, -0.5, 0), colour: SIMD4<Float>(0, 0, 1, 1)),     // bottom left
            
            Vertex(position: SIMD3<Float>( 0.5,  0.5, 0), colour: SIMD4<Float>(1, 0, 0, 1)),      // top right
            Vertex(position: SIMD3<Float>(-0.5, -0.5, 0), colour: SIMD4<Float>(0, 0, 1, 1)),    // bottom left
            Vertex(position: SIMD3<Float>( 0.5, -0.5, 0), colour: SIMD4<Float>(1, 0, 1, 1))      // bottom right
        ]
    }

}
