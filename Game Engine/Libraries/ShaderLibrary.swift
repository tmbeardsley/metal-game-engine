import MetalKit

enum VertexShaderTypes {
    case Basic
}

enum FragmentShaderTypes {
    case Basic
}

class ShaderLibrary {
    
    public static var DefaultLibrary: MTLLibrary!
    
    // Cache to store instantiated shaders so they can be reused
    private static var vertexShaders:   [VertexShaderTypes:   Shader] = [:]     // key:value pairs are VertexShaderTypes: Shader
    private static var fragmentShaders: [FragmentShaderTypes: Shader] = [:]
    
    public static func Initialize() {
        DefaultLibrary = Engine.Device.makeDefaultLibrary()
        self.createDefaultShaders()
    }
    
    // Add basic shaders to the dictionaries (caches)
    public static func createDefaultShaders() {
        // Vertex Shaders
        self.vertexShaders.updateValue(Basic_VertexShader(), forKey: .Basic)
        
        // Fragment Shaders
        self.fragmentShaders.updateValue(Basic_FragmentShader(), forKey: .Basic)
    }
    
    // Function to retrieve a vertex function from the vertexShaders dictionary
    public static func Vertex(_ vertexShaderType: VertexShaderTypes) -> MTLFunction {
        return vertexShaders[vertexShaderType]!.function
    }
    
    // Function to retrieve a fragment function from the fragmentShaders dictionary
    public static func Fragment(_ fragmentShaderType: FragmentShaderTypes) -> MTLFunction {
        return fragmentShaders[fragmentShaderType]!.function
    }
    
}

// Protocol is like a C++ virtual base class
protocol Shader {
    var name: String { get }
    var functionName: String { get }    // The function name in MyShaders.Metal
    var function: MTLFunction { get }   // The function that we need to populate in our VertexDescriptor
}

// Basic_VertexShader that implements the Shader protocol
public struct Basic_VertexShader: Shader {
    public var name: String { "Basic Vertex Shader" }
    public var functionName: String { "basic_vertex_shader" }
    public var function: MTLFunction {
        let function = ShaderLibrary.DefaultLibrary?.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}

// Basic_FragmentShader that implements the Shader protocol
public struct Basic_FragmentShader: Shader {
    public var name: String { "Basic Fragment Shader" }
    public var functionName: String { "basic_fragment_shader" }
    public var function: MTLFunction {
        let function = ShaderLibrary.DefaultLibrary?.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}
