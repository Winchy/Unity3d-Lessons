// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GrabPassGlass"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_BumpMap("Bump", 2D) = "bump" {}
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_Magnitude("Magnitude", Range(0, 1)) = 0.05
		_TintAmount("TintAmount", Range(0, 1)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" "Queue"="Transparent"}
			LOD 100

			GrabPass {}

			Pass
			{
				CGPROGRAM

	#pragma vertex vert
	#pragma fragment frag

	#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			sampler2D _MainTex;
			sampler2D _BumpMap;
			float _Magnitude;
			float _TintAmount;
			half4 _Tint;

			struct appData {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
			};

			v2f vert(appData v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			half4 frag(v2f i) : COLOR{
				half4 mainColor = tex2D(_MainTex, i.texcoord);
				half4 bump = tex2D(_BumpMap, i.texcoord);
				half2 distortion = UnpackNormal(bump).rg;
				i.uvgrab.xy += distortion * _Magnitude;
				half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				return lerp(col, col * mainColor * _Tint, _TintAmount);
			}

			ENDCG
		}
	}
}
