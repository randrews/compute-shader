@group(0) @binding(0)
var out_texture: texture_storage_2d<bgra8unorm, write>;

struct WindowGeometry {
    fill: vec4<f32>,
    size: vec2<u32>,
    topleft: vec2<u32>,
    bottomright: vec2<u32>,
    dummy: vec2<u32>
}

struct VulcanState {
    /// The bitmap font
    font: array<u8, 2048>,

    /// The palette
    palette: array<u8, 16>,

    /// Number of rows in the "virtual" screen
    rows: u32,

    /// Number of columns in the "virtual" screen
    columns: u32,

    /// Offset in rows from the top for the displayed area
    row_offset: u32,

    /// Offset in columns from the left for the displayed area
    column_offset: u32,

    /// The base pointer for the screen in `memory`
    screen: u32,

    /// We have to just copy the entire machine state over because otherwise we have to do the
    /// row / column stuff on the CPU side; we can't tell exactly what region of memory to copy
    /// without that
    memory: array<u8, 131072>,

    /// Which graphics mode we're using
    mode: u8
}

@group(0) @binding(1)
var<uniform> geometry: WindowGeometry;

@group(0) @binding(2)
var<uniform> state: VulcanState;

@compute
@workgroup_size(1)
fn pixel_shader(@builtin(global_invocation_id) global_id: vec3<u32>) {
    // if (global_id.x < geometry.topleft.x || global_id.x >= geometry.bottomright.x || global_id.y < geometry.topleft.y || global_id.y >= geometry.bottomright.y) {
    if (global_id.x >= 200 || global_id.x < 100 || global_id.y >= 200 || global_id.y < 100) {
       textureStore(out_texture, vec2<u32>(global_id.x, global_id.y), geometry.fill);
       //textureStore(out_texture, vec2<u32>(global_id.x, global_id.y), vec4<f32>(0.1, 0.1, 0.3, 1.0));
    } else {
       textureStore(out_texture, vec2<u32>(global_id.x, global_id.y), vec4<f32>(0, 0.5, 0.5, 1.0));
    }
}