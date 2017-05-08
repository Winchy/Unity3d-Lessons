Shader "Custom/GrabPassBlur"
{
	Properties
	{
		_BumpAmt("Distortion", range(0,364)) = 10
		_TintAmt("Tint Amount", Range(0,1)) = 0.1
		_MainTex("Tint Color (RGB)", 2D) = "white" {}
		_BumpMap("Normalmap", 2D) = "bump" {}
	}
	
	SubShader
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Opaque+1"}
		LOD 100

		GrabPass {}

		Pass
		{
			CGPROGRAM

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

			struct appData {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
			};

			float _BumpAmt;
			float _TintAmt;
			sampler2D _MainTex;
			sampler2D _BumpMap;

			sampler2D _GrabTexture;

			//https://en.wikipedia.org/wiki/Gaussian_blur
			float blurWeight[49] = {
				0.00000067, 0.00002292, 0.00019117, 0.00038771, 0.00019117, 0.00002292, 0.00000067,
				0.00002292, 0.00078634, 0.00655965, 0.01330373, 0.00655965, 0.00078633, 0.00002292,
				0.00019117, 0.00655965, 0.05472157, 0.11098164, 0.05472157, 0.00655965, 0.00019117,
				0.00038771, 0.01330373, 0.11098164, 0.22508352, 0.11098164, 0.01330373, 0.00038771,
				0.00019117, 0.00655965, 0.05472157, 0.11098164, 0.05472157, 0.00655965, 0.00019117,
				0.00002292, 0.00078633, 0.00655965, 0.01330373, 0.00655965, 0.00078633, 0.00002292,
				0.00000067, 0.00002292, 0.00019117, 0.00038771, 0.00019117, 0.00002292, 0.00000067
			};

			half4 blur(half4 col, sampler2D tex, float2 uv) {
				float2 offset = 1.0 / _ScreenParams.xy;
				for (int i = -3; i <= 3; ++i) {
					for (int j = -3; j <= 3; ++j) {
						col += tex2D(tex, clamp(uv + float2(offset.x * i, offset.y *j)， 0， 1)) * blurWeight[j * 7 + i + 24];
					}
				}
				return col;
			}

			v2f vert(appData v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}

			half4 frag(v2f i) : COLOR{
				half4 col = half4(0, 0, 0, 0); 
				col = blur(col, _GrabTexture, i.uvgrab.xy/i.uvgrab.w);
				return col;
			}

			ENDCG
		}
	}
}
