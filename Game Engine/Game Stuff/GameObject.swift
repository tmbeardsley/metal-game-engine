import MetalKit

class GameObject {
    
    // Array of vertices that is populated by function: createVertices()
    var vertices: [Vertex]!
    
    // Create gpu accessible memory
    var vertexBuffer: MTLBuffer!
    
    
    init() {
        // Create vertex data
        createVertices()
        
        // Create buffers of gpu accessible memory
        createBuffers()
    }
    
    
    private func createVertices() {
        self.vertices = [
            Vertex(position: SIMD3<Float>(0, 1, 0), colour: SIMD4<Float>(1, 0, 0, 1)),
            Vertex(position: SIMD3<Float>(-1, -1, 0), colour: SIMD4<Float>(0, 1, 0, 1)),
            Vertex(position: SIMD3<Float>(1, -1, 0), colour: SIMD4<Float>(0, 0, 1, 1))
        ]
    }
    
    
    private func createBuffers() {
        self.vertexBuffer = Engine.Device.makeBuffer(bytes: self.vertices, length: Vertex.stride(self.vertices.count), options: [])
    }
    
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
        // Set the render pipeline state of the render command encoder.
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        
        // Set the location of the data in device space. Specify that a triangle primitive should be drawn for every 3 vertices
        renderCommandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertices.count)
    }
}
