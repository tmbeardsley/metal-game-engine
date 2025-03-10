import MetalKit

enum RenderPipelineDescriptorTypes {
    case Basic
}

class RenderPipelineDescriptorLibrary {
    
    private static var renderPipelineDescriptors: [RenderPipelineDescriptorTypes: RenderPipelineDescriptor] = [:]
    
    public static func initialize() {
        self.createDefaultRenderPipelineDescriptors()
    }
    
    private static func createDefaultRenderPipelineDescriptors() {
        self.renderPipelineDescriptors.updateValue(Basic_RenderPipelineDescriptor(), forKey: .Basic)
    }
    
    public static func Descriptor(_ renderPipelineDescriptorType: RenderPipelineDescriptorTypes) -> MTLRenderPipelineDescriptor {
        return self.renderPipelineDescriptors[renderPipelineDescriptorType]!.renderPipelineDescriptor
    }
}


protocol RenderPipelineDescriptor {
    var name: String { get }
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor { get }
}


public struct Basic_RenderPipelineDescriptor: RenderPipelineDescriptor {
    var name: String { "Basic Render Pipeline Descriptor" }
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.Vertex(.Basic)                    // How vertices are transformed
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.Fragment(.Basic)                // Determines the colour of fragments given texture info from the vertexFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.Descriptor(.Basic)
        
        return renderPipelineDescriptor
    }
}
