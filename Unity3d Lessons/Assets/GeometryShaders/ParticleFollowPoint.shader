Shader "Unlit/ParticleFollowPoint"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"


			struct pointInfo {
				float3 pos;
				float3 velocity;
			};

			StructuredBuffer<pointInfo> buf_points;

			float3 worldPos = float3(0, 0, 0);

			struct v2f
			{
				//UNITY_FOG_COORDS(1)
				float4 pos : SV_POSITION;
				float4 color : COLOR0;
			};
			
			v2f vert (uint idx : SV_VertexId)
			{
				v2f o;
				float3 wp = buf_points[idx].pos;
				o.pos = mul(UNITY_MATRIX_VP, float4(wp, 1.0));
				wp = buf_points[idx].velocity;
				o.color = normalize(float4(abs(wp.r), abs(wp.g), abs(wp.b), 1.0));
				//o.color = float4(normalize(wp), 1.0);
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = i.color;
				//if (col.r <= 0 && col.g <= 0 && col.b <= 0)
					//col.rgb = float3(1, 0.6, 0.3);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
