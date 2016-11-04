Shader "Custom/DefaultLambert" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Tint ("Tint Color", Color) = (1, 1, 1, 1)
	}

	SubShader {
		Tags {"RenderType"="Opaque"}
		LOD 200

		CGPROGRAM

		#pragma surface surf Lambert fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Tint;

		struct Input {
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Tint.rgb;
			o.Alpha = c.a;
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
