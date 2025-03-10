import MetalKit


// Singleton pattern.
class Engine {
    
    // Reference to the GPU
    public static var Device: MTLDevice!
    
    // Single command queue for the single GPU
    public static var CommandQueue: MTLCommandQueue!
    
    public static func Ignite(device: MTLDevice) {
        self.Device = device
        self.CommandQueue = device.makeCommandQueue()
        
        // Initialise the shader library to make reusable vertex and fragment shaders
        ShaderLibrary.initialize()
        
        // Initialise the vertex descriptor library to make reusable vertex and fragment shaders
        VertexDescriptorLibrary.initialize()
        
        RenderPipelineDescriptorLibrary.initialize()
        
        RenderPipelineStateLibrary.initialize()
    }
}
