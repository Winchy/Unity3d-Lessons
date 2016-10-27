Shader "Hidden/Wave"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_WaveLength("Wave Length", Range(0.001, 0.2)) = 0.02
		_Frequence("Frequence", Range(1, 100)) = 10
	}

		SubShader
	{
		Pass
	{
		CGPROGRAM
#pragma vertex vert_img
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
	half _WaveLength;
	half _Frequence;

	half2 horizontalConvert(half2 uv) {
		half2 newUV = uv;
		newUV.y += sin(uv.x * 100 + _Time * 100) / 200;
		return newUV;
	}

	half2 radialConvert(half2 uv) {
		half2 newUV = uv;
		half3 dir = half3(newUV - half2(0.5, 0.5), 0);
		//half3 n = half3(0, 0, 1);
		//half3 p = cross(dir, n);
		//p = normalize(p);
		fixed l = length(dir.xy);
		newUV += sin(l / _WaveLength + _Time.y * _Frequence) * pow(l, 1)  * _WaveLength * normalize(dir.xy);
		return newUV;
	}

	fixed4 frag(v2f_img i) : COLOR
	{
		//half2 newUV = horizontalConvert(i.uv);
		half2 newUV = radialConvert(i.uv);
		fixed4 renderTex = tex2D(_MainTex, newUV);
		return renderTex;
	}

		ENDCG
	}
	}
		FallBack off
}
