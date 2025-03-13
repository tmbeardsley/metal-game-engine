import MetalKit


// Useful for specifying axis of rotation.
public var X_AXIS: SIMD3<Float> {
    return SIMD3<Float>(1, 0, 0)
}

public var Y_AXIS: SIMD3<Float> {
    return SIMD3<Float>(0, 1, 0)
}

public var Z_AXIS: SIMD3<Float> {
    return SIMD3<Float>(0, 0, 1)
}


extension matrix_float4x4 {
    
    // mutating required for acting on self.
    mutating func translate(direction: SIMD3<Float>) {
        
        var result = matrix_identity_float4x4
        
        let tx: Float = direction.x
        let ty: Float = direction.y
        let tz: Float = direction.z
        
        // Specify the columns of the matrix
        result.columns = (
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(tx, ty, tz, 1)
        )
        
        // self represents the original state of the transformation matrix.
        // This accumulates the new tranformation (translation) into the original matrix.
        self = matrix_multiply(self, result)
    }
    
    
    // mutating required for acting on self.
    mutating func scale(scaleVector: SIMD3<Float>) {
        
        var result = matrix_identity_float4x4
        
        let sx: Float = scaleVector.x
        let sy: Float = scaleVector.y
        let sz: Float = scaleVector.z
        
        // Specify the columns of the matrix
        result.columns = (
            SIMD4<Float>(sx, 0,  0,  0),
            SIMD4<Float>(0,  sy, 0,  0),
            SIMD4<Float>(0,  0,  sz, 0),
            SIMD4<Float>(0,  0,  0,  1)
        )
        
        // self represents the original state of the transformation matrix.
        // This accumulates the new tranformation (translation) into the original matrix.
        self = matrix_multiply(self, result)
    }
    
    
    // Performs rotation about x, y or z axis only (not compound rotations).
    // By setting axis = (1,0,0), (0,1,0) or (0,0,1), it formulatea the
    // appropriate rotation matrix: Rx(angle), Ry(angle) or Rz(angle).
    mutating func rotate(angle: Float, axis: SIMD3<Float>){
        var result = matrix_identity_float4x4
        
        // Only one of these should be 1. Other two should = 0.
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            SIMD4<Float>(r1c1, r2c1, r3c1, r4c1),
            SIMD4<Float>(r1c2, r2c2, r3c2, r4c2),
            SIMD4<Float>(r1c3, r2c3, r3c3, r4c3),
            SIMD4<Float>(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
    
}
