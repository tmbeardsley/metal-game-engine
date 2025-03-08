import MetalKit

import Cocoa

class GameView: MTKView {
    
    var commandQueue: MTLCommandQueue!
    var RenderPipeLineState: MTLRenderPipelineState!
    
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
    }
    
    
    func createRenderPipelineState() {

        // Get an instance of the function library
        let library = device?.makeDefaultLibrary()!
        
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction                    // How vertices are transformed
        renderPipelineDescriptor.fragmentFunction = fragmentFunction                // Determines the colour of fragments given texture info from the vertexFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
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
        
        // TODO: SEND INFO TO RENDERCOMMANDENCODER HERE
        
        renderCommandEncoder?.endEncoding()
        
        // Present the next drawable to the screen.
        commandBuffer?.present(drawable)
        
        // Commit the drawable once it's ready
        commandBuffer?.commit()
    }

}
