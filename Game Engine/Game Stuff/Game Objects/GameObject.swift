import MetalKit


class GameObject: Node {
    
    var modelConstants = ModelConstants()       // 4x4 float matrix object specified in Types
    
    var mesh: Mesh!
    
    init(meshType: MeshTypes) {
        mesh = MeshLibrary.Mesh(meshType)
    }
    
    var time: Float = 0.0
    
    func update(_ deltaTime: Float) {
        self.time += deltaTime
        
        // translation, scale and rotation are inherited from Node
        self.translation.x = cos(time)
        self.scale = SIMD3<Float>(repeating: 0.5*cos(time))
        self.rotation.z = cos(time)
        
        updateModelConstants()
    }
    
    private func updateModelConstants() {
        // LHS is from GameObject. RHS is modelMatrix inherited from Node.
        // self.modelMatrix computes the translation matrix.
        self.modelConstants.modelMatrix = self.modelMatrix
    }
}



extension GameObject: Renderable {                                              // Declares that GameObject now conforms to the Renderable protocol.
    func doRender(_ renderCommandEncoder: any MTLRenderCommandEncoder) {
        
        //renderCommandEncoder.setTriangleFillMode(.lines)
        
        // setVertexBytes used because should have more than 4kB to create a buffer. Allows us to pass reference to bytes.
        // The index attribute in renderCommandEncoder is part of a shared namespace for all vertex inputs
        // (buffers, constants, and textures) that are bound to the vertex shader.
        // Allows the GPU to access the translation matrix contained in the modelConstants object.
        renderCommandEncoder.setVertexBytes(&(self.modelConstants), length: ModelConstants.stride, index: 1)
        
        // Set the render pipeline state of the render command encoder.
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        
        // Set the location of the data in device space. Specify that a triangle primitive should be drawn for every 3 vertices
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
        
    }
}
