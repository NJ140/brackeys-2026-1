shader_type canvas_item;

/*
  Balanced edge-only vignette.
  - strength is driven by script (0..1)
  - edge_start/edge_end control where the vignette begins/ends
  - optional subtle pulse when low (set pulse_amount > 0)
*/

uniform float strength : hint_range(0.0, 1.0) = 0.0;        // driven by script
uniform float edge_start : hint_range(0.0, 1.0) = 0.85;      // bigger = less vignette
uniform float edge_end   : hint_range(0.0, 2.0) = 1.05;      // where it reaches full

uniform float max_strength : hint_range(0.0, 1.0) = 0.35;    // cap so it stays "edge-only"
uniform float curve : hint_range(0.5, 4.0) = 2.0;            // higher = more edge-focused

uniform float pulse_amount : hint_range(0.0, 1.0) = 0.12;    // 0 = no pulse, small = subtle
uniform float pulse_speed  : hint_range(0.0, 10.0) = 3.0;

uniform vec4 vignette_color : source_color = vec4(0.69, 0.07, 0.07, 1.0); // #B01212-ish

void fragment() {
    vec2 p = UV * 2.0 - 1.0;

    // Keep the vignette circular regardless of aspect ratio
    p.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

    float d = length(p);

    // 0 in center -> 1 near edges
    float mask = smoothstep(edge_start, edge_end, d);

    // Shape it so it favors corners/edges and keeps the center cleaner
    mask = pow(mask, curve);

    // Optional subtle pulse (only affects strength, not the color)
    float pulse = 1.0 + pulse_amount * sin(TIME * pulse_speed);

    // Final alpha (edge-only, capped)
    float a = mask * clamp(strength, 0.0, 1.0) * max_strength * pulse;

    COLOR = vec4(vignette_color.rgb, a);
}
