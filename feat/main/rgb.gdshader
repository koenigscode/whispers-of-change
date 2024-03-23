shader_type canvas_item;

// Uniforms for controlling the saturation level of each channel
uniform float r_saturation : hint_range(0, 5);
uniform float g_saturation : hint_range(0, 5);
uniform float b_saturation : hint_range(0, 5);

void fragment() {
    // Sample the texture color
    vec4 tex_color = texture(TEXTURE, UV);

    // Calculate the perceived luminance of the texture color
    float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Construct the desaturated color based on overall luminance
    vec3 desaturated = vec3(luminance, luminance, luminance);

    // Determine the contribution of each channel based on its saturation setting
    vec3 saturation_levels = vec3(r_saturation / 10.0, g_saturation / 10.0, b_saturation / 10.0);

    // Apply the desaturation and saturation logic
    vec3 color_adjustment = mix(desaturated, tex_color.rgb, saturation_levels);

    // Set the fragment color, maintaining the original texture's alpha value
    COLOR = vec4(color_adjustment, tex_color.a);
}
