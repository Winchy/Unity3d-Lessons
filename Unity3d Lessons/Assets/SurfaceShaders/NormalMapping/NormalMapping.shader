Shader "Custom/NormalMapping" {
	Properties {
		_MainTint("Diffuse Tint", Color) = (1, 1, 1, 1)
		_NormalTex("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _NormalTex;
		fixed4 _MainTint;

		struct Input {
			float2 uv_NormalTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _MainTint.rgb;
			fixed3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex*10)).rgb;
			o.Normal = normalMap;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
