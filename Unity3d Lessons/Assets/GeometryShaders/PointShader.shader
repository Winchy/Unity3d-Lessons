Shader "Custom/PointShader" {
	SubShader {

		Pass {

			CGPROGRAM

			#pragma target 5.0

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct data {
				float3 pos;
			};

			StructuredBuffer<data> buf_Points;
			float3 _worldPos = float3(0, 0, 0);

			struct ps_input
			{
				float4 pos : SV_POSITION;
				float3 color : COLOR0;
			};

			ps_input vert(uint id : SV_VertexID) {
				ps_input o;
				UNITY_INITIALIZE_OUTPUT(ps_input, o);
				float3 worldPos = buf_Points[id].pos + _worldPos;
				o.pos = mul(UNITY_MATRIX_VP, float4(worldPos, 1.0f));
				o.color = worldPos;
				return o;
			}

			float4 frag(ps_input i) : COLOR
			{
				float4 col = float4(i.color, 1);

				if (i.color.r <= 0 && i.color.g <= 0 && i.color.z <= 0)
					col.rgb = float3(0, 1, 1);

				return col;
			}

			ENDCG
		}

	}
	FallBack "Diffuse"
}
