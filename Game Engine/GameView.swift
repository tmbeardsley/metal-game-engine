import MetalKit

import Cocoa

class GameView: MTKView {
    
//    // Vertex structure
//    struct Vertex {
//        var position: SIMD3<Float>
//        var colour: SIMD4<Float>
//    }
    
    var commandQueue: MTLCommandQueue!
    var RenderPipeLineState: MTLRenderPipelineState!
    
    // Array of vertices that is populated by function: createVertices()
    var vertices: [Vertex]!
    
    // Create gpu accessible memory
    var vertexBuffer: MTLBuffer!
    
    
    
    // Constructor
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        
        // The GPU device
        self.device = MTLCreateSystemDefaultDevice()
        
        // Colour that is shown while image is being refreshed (e.g. 60 FPS) - greenish colour
        self.clearColor = MTLClearColor(red: 0.43, green: 0.73, blue: 0.35, alpha: 1.0)
        
        // Has to match the format of the fragment shader
        self.colorPixelFormat = .bgra8Unorm
        
        // Command queue for the GPU
        self.commandQueue = device?.makeCommandQueue()
        
        // Create a render pipeline state
        createRenderPipelineState()
        
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
    
    
    func createRenderPipelineState() {

        // Get an instance of the function library
        let library = device?.makeDefaultLibrary()!
        
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        
        // Create a vertexDescriptor for the renderPipelineState.
        // Allows us to pass individual vertices into the vertexFunction (instead of an array of them as previously).
        // Attributes [0] and [1] are labelled in the VertexIn struct in the metal file.
        let vertexDescriptor = MTLVertexDescriptor()
        
        // Position attribute in Vertex struct
        vertexDescriptor.attributes[0].format = .float3     // Data type for position
        vertexDescriptor.attributes[0].bufferIndex = 0      // Index of buffer storing Vertex data in the buffer memory table
        vertexDescriptor.attributes[0].offset = 0           // Index of the position data in the struct (position is first, so = 0)
        
        // Colour attribute in the Vertex struct
        vertexDescriptor.attributes[1].format = .float4     // Data type for colour
        vertexDescriptor.attributes[1].bufferIndex = 0      // Index of buffer storing Vertex data in the buffer memory table
        vertexDescriptor.attributes[1].offset = SIMD3<Float>.size() // In a Vertex struct, colour (float4) comes after the position (float3)
        
        // Amount of memory taken by successive Vertex structures in the buffer (i.e., float3 + float4 per Vertex).
        vertexDescriptor.layouts[0].stride = Vertex.stride()
        
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction                    // How vertices are transformed
        renderPipelineDescriptor.fragmentFunction = fragmentFunction                // Determines the colour of fragments given texture info from the vertexFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        // Create a render pipeline state using the render pipeline descriptor
        do {
            self.RenderPipeLineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    // Override the draw function
    override func draw(_ dirtyRect: NSRect) {
        
        // Try and grab the drawable and renderPassDecriptor.
        guard let drawable = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else { return }
        
        // Create a command buffer that will go into the command queue
        let commandBuffer = self.commandQueue?.makeCommandBuffer()
        
        // Create a render command encoder for the command buffer we just created.
        // renderPassDescriptor contains a lot of pixel information and buffer storage information for our view for the next drawable.
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // Set the render pipeline state of the render command encoder.
        renderCommandEncoder?.setRenderPipelineState(self.RenderPipeLineState)
        
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
