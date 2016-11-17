precision mediump float;
uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iGlobalTime;           // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
//uniform samplerXX iChannel0..3;        // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

#define pi 3.141593
#define e 2.71828

vec3 blackwhite_fade(vec2 p) {
    vec3 bw = vec3(0.5 * sin(iGlobalTime) + 0.5 * sin(p.x + p.y),
                   0.5 * sin(iGlobalTime) + 0.5 * sin(p.x + p.y),
                   0.5 * sin(iGlobalTime) + 0.5 * sin(p.x + p.y));
    return bw;
}

// from hughsk "2D SDF Toy" https://www.shadertoy.com/view/XsyGRW
float draw_solid(float d) {
  return smoothstep(0.0, 3.0 / iResolution.y, max(0.0, d));
}

vec3 draw_distance(float d, vec2 p) {
  float t = clamp(d * 0.85, 0.0, 1.0);
  vec3 grad = mix(vec3(253.0, 252.0, 221.0) / 255.0,
                  vec3(222.0, 242.0, 242.0) / 255.0,
                  t);
  grad -= mix(vec3(8.0, 87.0, 18.0) / 255.0, vec3(0.0), draw_solid(d));
  grad -= mix(blackwhite_fade(p), vec3(0.0), draw_solid(d));

  return grad;
}

float shape_butterfly(vec2 p) {
  float angle = atan(p.y, p.x);
  float radius = length(p);
  float curve = pow(e, sin(angle)) - 2.0 * cos(4.0 * angle);
  return radius - curve;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 p = (2.0 * fragCoord - iResolution.xy) / min(iResolution.y,iResolution.x);
  p = p * 3.0;
  p.y += 0.75;

  vec3 bg_color = vec3(0.0, 0.0, 0.0);

  float shape = shape_butterfly(p);

  vec2 uv = fragCoord.xy / iResolution.xy;
  vec3 color = draw_distance(shape, p);

  fragColor = vec4(color, 1.0);
}
