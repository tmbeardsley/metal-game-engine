#include <metal_stdlib>
using namespace metal;

// Note: vertex_id is the rendering pipeline equivalent of thread_position_in_group that
// is used in compute pipelines. Each vertex is processed by a different thread
vertex float4 basic_vertex_shader(device float3 *vertices   [[ buffer(0) ]],
                                         uint vertexID      [[ vertex_id ]]) {
    return float4(vertices[vertexID], 1);
}


fragment half4 basic_fragment_shader() {
    return half4(1);
}
