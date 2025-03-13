// vertices -> vertex shader -> rasterizer -> fragment shader -> RETURN PIXELS

#include <metal_stdlib>
using namespace metal;

// Vertex structure on the GPU mirroring the CPU one
struct VertexIn {
    float3 position [[ attribute(0) ]];
    float4 colour   [[ attribute(1) ]];
};

// Structure for data that will be passed to the rasterizer from the vertex shader
struct RasterizerData {
    float4 position [[ position ]];     // Labels the position data and specifies that it can't be changed by the rasterizer.
    float4 colour;                      // Will be interpolated by the rasterizer to each pixel value
};

struct ModelConstants {
    float4x4 modelMatrix;
};


// Having added a MTLVertexDescriptor() to our MTLRenderPipelineDescriptor(),
// stage_in specifies that each vertex (in the buffer) is processed by a different thread without the need
// for passing in an array of them and accessing them by thread id. Tidies up the code.
vertex RasterizerData basic_vertex_shader(const VertexIn vIn    [[ stage_in ]],
                                          constant ModelConstants &modelConstants    [[buffer(1)]]) {
    RasterizerData rd;
    
    // Apply the transformation matrix to the coordinated of the current vertex
    rd.position = modelConstants.modelMatrix * float4(vIn.position, 1);
    
    rd.colour = vIn.colour;
    
    return rd;
}


// Uses the rasterization data from the rasterizer to determine final pixel colours.
// stage_in tells Metal that rd is an interpolated input from the rasterizer.
// This is run on a per-pixel basis.
fragment half4 basic_fragment_shader(RasterizerData rd  [[ stage_in ]]) {
    
    float4 colour = rd.colour;
    
    return half4(colour.r, colour.g, colour.b, colour.a);
}
