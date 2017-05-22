Shader "Custom/GrabPassBlur"
{
	Properties
	{
		_BumpAmt("Distortion", range(0, 2)) = 1
		_TintAmt("Tint Amount", Range(0,1)) = 0.1
		_MainTex("Tint Color (RGB)", 2D) = "white" {}
		_BumpMap("Normalmap", 2D) = "bump" {}
		_BlurAmt("Blur", Range(0, 10)) = 1
	}
	
	SubShader
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}
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
			float _BlurAmt;
			sampler2D _MainTex;
			sampler2D _BumpMap;

			sampler2D _GrabTexture;

			//https://en.wikipedia.org/wiki/Gaussian_blur
			float blurWeight[121];
			half4 blur(half4 col, sampler2D tex, float4 uv) {
				float2 offset = 1.0 / _ScreenParams.xy;
				for (int i = -5; i <= 5; ++i) {
					for (int j = -5; j <= 5; ++j) {
						col += tex2Dproj(tex, UNITY_PROJ_COORD(float4(uv.x + offset.x * i* _BlurAmt, uv.y + offset.y *j * _BlurAmt, uv.z, uv.w))) * blurWeight[j * 11 + i + 60];
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
				half4 mainColor = tex2D(_MainTex, i.texcoord);
				half2 distortion = UnpackNormal(tex2D(_BumpMap, i.texcoord)).rg;
				half4 col = half4(0, 0, 0, 0); 
				i.uvgrab.xy += float4(distortion * _BumpAmt, 0, 0);
				col = blur(col, _GrabTexture, i.uvgrab);
				return lerp(col, col * mainColor, _TintAmt);
			}

			ENDCG
		}
	}
}
