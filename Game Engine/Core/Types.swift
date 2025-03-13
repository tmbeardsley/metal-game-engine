import simd

protocol sizeable {}

extension sizeable {
    
    static var size: Int {
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int {
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int) -> Int {
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int) -> Int {
        return MemoryLayout<Self>.stride * count
    }
}

extension Float: sizeable {}
extension SIMD3: sizeable {}

// Vertex structure
struct Vertex : sizeable {
    var position:   SIMD3<Float>
    var colour:     SIMD4<Float>
}

struct ModelConstants: sizeable {
    var modelMatrix = matrix_identity_float4x4
}
