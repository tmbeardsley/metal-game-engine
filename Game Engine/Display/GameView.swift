import MetalKit

import Cocoa

class GameView: MTKView {
    
    // Array of vertices that is populated by function: createVertices()
    var vertices: [Vertex]!
    
    // Create gpu accessible memory
    var vertexBuffer: MTLBuffer!
    
    
    
    // Constructor
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        
        // The GPU device
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(device: self.device!)
        
        // Colour that is shown while image is being refreshed (e.g. 60 FPS) - greenish colour
        self.clearColor = Preferences.clearColour
        
        // Has to match the format of the fragment shader
        self.colorPixelFormat = Preferences.MainPixelFormat
        
        // Create vertex data
        createVertices()
        
        // Create buffers of gpu accessible memory
        createBuffers()
    }
    
    
    func createVertices() {
        self.vertices = [
            Vertex(position: SIMD3<Float>(0, 1, 0), colour: SIMD4<Float>(1, 0, 0, 1)),
            Vertex(position: SIMD3<Float>(-1, -1, 0), colour: SIMD4<Float>(0, 1, 0, 1)),
            Vertex(position: SIMD3<Float>(1, -1, 0), colour: SIMD4<Float>(0, 0, 1, 1))
        ]
    }
    
    
    func createBuffers() {
        self.vertexBuffer = self.device?.makeBuffer(bytes: self.vertices, length: Vertex.stride(self.vertices.count), options: [])
    }
    
    
    // Override the draw function
    override func draw(_ dirtyRect: NSRect) {
        
        // Try and grab the drawable and renderPassDecriptor.
        guard let drawable = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else { return }
        
        // Create a command buffer that will go into the command queue
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        
        // Create a render command encoder for the command buffer we just created.
        // renderPassDescriptor contains a lot of pixel information and buffer storage information for our view for the next drawable.
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // Set the render pipeline state of the render command encoder.
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        
        // Set the location of the data in device space. Specify that a triangle primitive should be drawn for every 3 vertices
        renderCommandEncoder?.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertices.count)
        
        renderCommandEncoder?.endEncoding()
        
        // Present the next drawable to the screen.
        commandBuffer?.present(drawable)
        
        // Commit the drawable once it's ready
        commandBuffer?.commit()
    }

}
