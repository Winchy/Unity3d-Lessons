Shader "Custom/Toon" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex ("Ramp", 2D) = "white" {}
		_CelShadingLevels1("Shading Levels1", Range(0, 1)) = 0.5
		_CelShadingLevels2("Shading Levels2", Range(1, 20)) = 10
	}
	SubShader {
		Tags {"RenderType"="Opaque"}
		LOD 200

		CGPROGRAM

		#pragma surface surf Toon
		//#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _RampTex;
		fixed _CelShadingLevels1;
		float _CelShadingLevels2;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
		}

		fixed4 LightingToon(SurfaceOutput s, fixed3 LightDir, fixed atten) {
			fixed NdotL = dot(s.Normal, LightDir);
			//NdotL = tex2D(_RampTex, float2(NdotL, 0.5));
			//NdotL = clamp(floor((NdotL * _CelShadingLevels1)/(_CelShadingLevels1 - 0.5)));
			//_CelShadingLevels2 = floor(_CelShadingLevels2);
			NdotL = clamp(floor(NdotL * _CelShadingLevels2)/_CelShadingLevels2, 0, 1);
			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten * 2;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
