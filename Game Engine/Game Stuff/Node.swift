import MetalKit

class Node {
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
        // Attempt to cast the class instance to Renderable type.
        // If cast is successful, its doRender() function is called.
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }

    }
    
}
