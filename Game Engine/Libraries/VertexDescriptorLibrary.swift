import MetalKit

enum VertexDescriptorTypes {
    case Basic
}


class VertexDescriptorLibrary {
    
    private static var vertexDescriptors: [VertexDescriptorTypes: VertexDescriptor] = [:]
    
    public static func Initialize() {
        createDefaultVertexDescriptors()
    }
    
    private static func createDefaultVertexDescriptors() {
        self.vertexDescriptors.updateValue(Basic_VertexDescriptor(), forKey: .Basic)
    }
    
    public static func Descriptor(_ vertexDescriptorType: VertexDescriptorTypes) -> MTLVertexDescriptor {
        return self.vertexDescriptors[vertexDescriptorType]!.vertexDescriptor
    }
}


protocol VertexDescriptor {
    var name: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
}


public struct Basic_VertexDescriptor: VertexDescriptor {
    
    var name: String = "Basic Vertex Descriptor"
    
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // Position attribute in Vertex struct
        vertexDescriptor.attributes[0].format = .float3     // Data type for position
        vertexDescriptor.attributes[0].bufferIndex = 0      // Index of buffer storing Vertex data in the buffer memory table
        vertexDescriptor.attributes[0].offset = 0           // Index of the position data in the struct (position is first, so = 0)
        
        // Colour attribute in the Vertex struct
        vertexDescriptor.attributes[1].format = .float4     // Data type for colour
        vertexDescriptor.attributes[1].bufferIndex = 0      // Index of buffer storing Vertex data in the buffer memory table
        vertexDescriptor.attributes[1].offset = SIMD3<Float>.size // In a Vertex struct, colour (float4) comes after the position (float3)
        
        // Amount of memory taken by successive Vertex structures in the buffer (i.e., float3 + float4 per Vertex).
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        return vertexDescriptor
    }
    
}
