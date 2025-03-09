#include <metal_stdlib>
using namespace metal;

// Vertex structure on the GPU mirroring the CPU one
struct VertexIn {
    float3 position;
    float4 colour;
};

// Structure for data that will be passed to the rasterizer from the vertex shader
struct RasterizerData {
    float4 position [[ position ]];     // Labels the position data and specifies that it can't be changed by the rasterizer.
    float4 colour;                      // Will be interpolated by the rasterizer to each pixel value
};



// Note: vertex_id is the rendering pipeline equivalent of thread_position_in_group that
// is used in compute pipelines. Each vertex is processed by a different thread
vertex RasterizerData basic_vertex_shader(device VertexIn *vertices   [[ buffer(0) ]],
                                         uint vertexID        [[ vertex_id ]]) {
    RasterizerData rd;
    
    rd.position = float4(vertices[vertexID].position, 1);
    rd.colour = vertices[vertexID].colour;
    
    return rd;
}


// Uses the rasterization data from the rasterizer to determine final pixel colours.
// stage_in tells Metal that rd is an interpolated input from the rasterizer.
// This is run on a per-pixel basis.
fragment half4 basic_fragment_shader(RasterizerData rd  [[ stage_in ]]) {
    
    float4 colour = rd.colour;
    
    return half4(colour.r, colour.g, colour.b, colour.a);
}
