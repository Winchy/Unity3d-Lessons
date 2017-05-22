// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/rm_shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform float4x4 _FrustumCornersES;
			uniform float4x4 _CameraInvViewMatrix;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 ray : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;

				half index = v.vertex.z;
				v.vertex.z = 0.1;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv.xy;

				#if UNITY_UV_STARTS_AT_TOP
				o.uv.y = 1 - o.uv.y;
				#endif

				o.ray = _FrustumCornersES[(int)index].xyz;
				// Transform the ray from eyespace to worldspace
				// Note: _CameraInvViewMatrix was provided by the script
				o.ray = mul(_CameraInvViewMatrix, o.ray);
				return o;
			}
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(i.ray, 1);
				return col;
			}
			ENDCG
		}
	}
}
