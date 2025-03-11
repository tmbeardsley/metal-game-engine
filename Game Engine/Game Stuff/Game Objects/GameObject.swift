import MetalKit


class GameObject: Node {
    
    var mesh: Mesh!
    
    init(meshType: MeshTypes) {
        mesh = MeshLibrary.Mesh(meshType)
    }
}



extension GameObject: Renderable {                                              // Declares that GameObject now conforms to the Renderable protocol.
    func doRender(_ renderCommandEncoder: any MTLRenderCommandEncoder) {
        
        //renderCommandEncoder.setTriangleFillMode(.lines)
        
        // Set the render pipeline state of the render command encoder.
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        
        // Set the location of the data in device space. Specify that a triangle primitive should be drawn for every 3 vertices
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
        
    }
}
