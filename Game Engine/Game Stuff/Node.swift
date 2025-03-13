import MetalKit

class Node {
    
    // The translation vector used to build the translation matrix (originally called position)
    var translation: SIMD3<Float> = .zero
    
    // The scaling transformation vector.
    var scale: SIMD3<Float> = .one
    
    // Specifying angles through which we want to rotate about x, y and z.
    var rotation: SIMD3<Float> = .zero
    
    // This is a computed property (hence the curly braces).
    // A new transformation matrix is accumulated here at each frame.
    var modelMatrix: matrix_float4x4 {
        var modelMatrix = matrix_identity_float4x4              // Identity matrix required initially as transformations accumulate on top of it.
        modelMatrix.translate(direction: self.translation)      // Translate function (in Math.swift) is an extension to the matrix_float4x4 type.
        modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)     // Rotate about the x-axis. Axis variables defined in Math.swift.
        modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
        modelMatrix.scale(scaleVector: self.scale)              // Scale function (in Math.swift) is an extension to the matrix_float4x4 type.
        return modelMatrix
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
        // Attempt to cast the class instance to Renderable type.
        // If cast is successful, its doRender() function is called.
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }

    }
    
}
