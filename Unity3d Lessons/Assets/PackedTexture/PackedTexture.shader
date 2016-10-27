Shader "Custom/PackedTexture" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
		_ColorA ("Terrain Color A", Color) = (1, 1, 1, 1)
		_ColorB ("Terrain Color B", Color) = (1, 1, 1, 1)
		_RTexture ("Red Channel Texture", 2D) = "" {}
		_GTexture ("Green Channel Texture", 2D) = "" {}
		_BTexture ("Blue Channel Texture", 2D) = "" {}
		_BlendTex ("Blend Texture", 2D) = "" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTex;
		};

		fixed4 _MainTint;
		fixed4 _ColorA;
		fixed4 _ColorB;
		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTex;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 blendData = tex2D(_BlendTex, IN.uv_BlendTex);
			fixed4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
			fixed4 gTexData = tex2D(_GTexture, IN.uv_GTexture);
			fixed4 bTexData = tex2D(_BTexture, IN.uv_BTexture);
			fixed4 aTexData = tex2D(_ATexture, IN.uv_ATexture);

			fixed4 finalColor = lerp(rTexData, gTexData, blendData.g);
			finalColor = lerp(finalColor, bTexData, blendData.b);
			//finalColor = lerp(finalColor, aTexData, blendData.a);
			finalColor.a = 1.0;
			fixed4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers;
			finalColor = saturate(finalColor);
			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
