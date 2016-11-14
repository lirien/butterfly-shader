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

float shape_butterfly(vec2 p) {
  float angle = atan(p.y, p.x);
  float shape = pow(e, sin(angle)) - 2.0 * cos(4.0 * angle);
  return shape;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 p = (2.0 * fragCoord - iResolution.xy) / min(iResolution.y,iResolution.x);
  p = p * 3.0;
  p.y += 0.75;

  vec3 bg_color = vec3(0.0, 0.0, 0.0);

  float radius = length(p);
  float shape = shape_butterfly(p);

  vec2 uv = fragCoord.xy / iResolution.xy;
  vec3 shape_color = vec3(uv, 0.5 + 0.5 * sin(iGlobalTime));
  vec3 color = mix(bg_color, shape_color, smoothstep(-0.01, 0.01, shape - radius));

  fragColor = vec4(color, 1.0);
}
