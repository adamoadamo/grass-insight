#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float2 position [[attribute(0)]];
};

vertex float4 vertex_main(const Vertex in [[stage_in]]) {
    return float4(in.position, 0.0, 1.0);
}

fragment float4 fragment_main() {
    return float4(0.0, 1.0, 0.0, 1.0); // Grass color - green
}
