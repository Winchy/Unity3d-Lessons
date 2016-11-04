Shader "Custom/Holographic" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white"{}
		_DotProduct("Rim effect", Range(-1, 1)) = 0.25
		_RimColor("RimColor", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		LOD 200
		//Cull Off
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert alpha:fade 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		fixed4 _Color;
		fixed4 _RimColor;
		half _DotProduct;
		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float alpha = (border * ( 1 - _DotProduct) + _DotProduct);
			o.Alpha = c.a * alpha;
			o.Albedo = o.Albedo + _RimColor * border;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
