import MetalKit

class Renderer: NSObject {
    
    var player = Player()   // Player extends the GameObject class
    
}


// MTKViewDelegate is a protocol that allows you to receive updates from an MTKView (Metal View).
// Allows handling of two key events: (1) Resizing the view, (2) Drawing the view.
extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Fires when the window is resized (has be be overridden)
    }
    
    func draw(in view: MTKView) {
        // Will be passing in the view we are delegating from. draw() will be called automatically.
        
        // Try and grab the drawable and renderPassDecriptor.
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        // Create a command buffer that will go into the command queue
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        
        // Create a render command encoder for the command buffer we just created.
        // renderPassDescriptor contains a lot of pixel information and buffer storage information for our view for the next drawable.
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        self.player.update(1.0 / Float(view.preferredFramesPerSecond))
        
        // Render the game object
        self.player.render(renderCommandEncoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        
        // Present the next drawable to the screen.
        commandBuffer?.present(drawable)
        
        // Commit the drawable once it's ready
        commandBuffer?.commit()
    }
}
