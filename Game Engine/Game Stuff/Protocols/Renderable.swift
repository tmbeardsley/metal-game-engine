import MetalKit

// Akin to a C++ abstract base class
protocol Renderable {
    
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder)
    
}
