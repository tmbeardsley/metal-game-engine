import MetalKit

import Cocoa

class GameView: MTKView {
    
    var renderer: Renderer!         // needs Engine.Ignite(device: self.device!) to fire before it can be instantiated
    
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
        
        // instantiate a GameObject
        self.renderer = Renderer()
        
        // All draw functionality of this (self) GameView:MTKView object will be delegated to a Renderer class object.
        self.delegate = self.renderer
    }
    
    
    // Mouse Input
    
    // Keyboard Input

}
