Shader "Custom/VoxelPointShader" {
	SubShader {
		Pass {
			
			CGPROGRAM

			#pragma target 5.0

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct data {
				float3 pos;
				int renderfaces[6];
			};

			StructuredBuffer<data> buf_Points;
			float3 _worldPos;

			struct ps_input
			{
				float4 pos : SV_POSITION;
				float3 color : COLOR0;
				float3 r : COLOR1;
			};

			ps_input vert(uint id : SV_VertexID) {
				ps_input o;
				UNITY_INITIALIZE_OUTPUT(ps_input, o);
				float3 worldPos = buf_Points[id].pos + _worldPos;
				o.pos = mul(UNITY_MATRIX_VP, float4(worldPos, 1.0f));
				o.color = worldPos;
				if ((buf_Points[id].renderfaces[0] | buf_Points[id].renderfaces[1] | buf_Points[id].renderfaces[2] | buf_Points[id].renderfaces[3] | buf_Points[id].renderfaces[4] | buf_Points[id].renderfaces[5]))
					o.r = float3(1, 0, 0);
				return o;
			}

			float4 frag(ps_input i) : COLOR
			{
				float4 col = float4(i.color, 1);

				if (i.color.r <= 0 && i.color.g <= 0 && i.color.z <= 0)
					col.rgb = float3(0, 1, 1);

				if (i.r.r == 0)
					discard;

				return col;
			}

			ENDCG
		}

	}
	FallBack "Diffuse"
}
