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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 p = (2.0*fragCoord-iResolution.xy)/min(iResolution.y,iResolution.x);
	p = p * 3.0;
	p.y += 0.75;

	// background
	vec3 bcol = vec3(0.0, 0.0, 0.0);

	// shape
	float a = atan(p.y, p.x);
	float r = length(p);
	float wings = sin(2.0 * a - pi) / 24.0;
	float d = pow(e, sin(a)) - 2.0 * cos(4.0 * a) + pow(wings, 5.0);

	// color
	vec3 hcol = vec3(1.0, 1.0, 1.0);
	vec3 col = mix(bcol, hcol, smoothstep(-0.01, 0.01, d - r));

	fragColor = vec4(col, 1.0);
}
