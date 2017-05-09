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
			float4 _GrabTexture_TexelSize;

			//https://en.wikipedia.org/wiki/Gaussian_blur
			float blurWeight[49];

			half4 blur(half4 col, sampler2D tex, float4 uvrgab) {
				float2 offset = 1.0 / _ScreenParams.xy;
				for (int i = -3; i <= 3; ++i) {
					for (int j = -3; j <= 3; ++j) {
						//col += tex2Dproj(tex, uvrgab + float4(_GrabTexture_TexelSize.x * i * _BlurAmt, _GrabTexture_TexelSize.y *j * _BlurAmt, 0.0f, 0.0f)) * blurWeight[j * 7 + i + 24];
						col += tex2Dproj(tex, uvrgab + float4(offset.x * i * _BlurAmt, offset.y * j * _BlurAmt, 0.0f, 0.0f)) * blurWeight[j * 7 + i + 24];
					}
				}
				return col;
			}

			half4 blurHardCoded(half4 col, sampler2D tex, float4 uvrgab) 
			{
				float2 offset = 1.0 / _ScreenParams.xy;
				
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[0];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[1];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[2];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[3];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[4];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[5];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -3 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[6];

				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[7];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[8];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[9];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[10];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[11];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[12];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -2 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[13];

				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[14];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[15];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[16];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[17];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[18];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[19];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * -1 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[20];

				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[21];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[22];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[23];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[24];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[25];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[26];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 0 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[27];

				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[28];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[29];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[30];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[31];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[32];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[33];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 1 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[34];

				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[35];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[36];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[37];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[38];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[39];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[40];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 2 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[41];

				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * -3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[42];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * -2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[43];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * -1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[44];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * 0 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[45];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * 1 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[46];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * 2 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[47];
				col += tex2Dproj(tex, uvrgab + float4(offset.x * 3 * _BlurAmt, offset.y * 3 * _BlurAmt, 0.0f, 0.0f)) * blurWeight[48];

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
				half2 distortion = UnpackNormal(tex2D(_BumpMap, i.texcoord)).rg * _BumpAmt;
				half4 col = half4(0, 0, 0, 0); 
				float4 uvgrab = float4(i.uvgrab.x + distortion.x, i.uvgrab.y + distortion.y, i.uvgrab.z, i.uvgrab.w);
				col = blur(col, _GrabTexture, uvgrab);
				//col = blurHardCoded(col, _GrabTexture, uvgrab);
				return lerp(col, col * mainColor, _TintAmt);
			}

			ENDCG
		}
	}
}
