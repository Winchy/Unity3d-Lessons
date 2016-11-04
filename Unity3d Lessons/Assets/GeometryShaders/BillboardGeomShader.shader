Shader "Custom/BillboardGeomShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Sprite ("Sprite", 2D) = "white" {}
		_Size ("Size", Vector) = (1, 1, 0, 0)
		_Wind ("Wind", Vector) = (0, 0, 0, 0)
	}

	SubShader {
		Tags {"Queue" = "Overlay+100" "RenderType" = "Transparent"}

		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha

		Cull off
		ZWrite off //turn off because this is for a particle

		Pass {
			CGPROGRAM
			#pragma target 5.0

			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag

			#pragma multi_compile_fog


			#include "UnityCG.cginc"

			sampler2D _Sprite;
			float4 _Color;
			float2 _Size;
			float3 _worldPos;
			float3 _Wind = float3(0, 0, 0);

			int _StaticCylinderSpherical = 0;

			struct data {
				float3 pos;
			};

			StructuredBuffer<data> buf_Points;

			struct input {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			input vert(uint id : SV_VertexID) {
				input o;
				UNITY_INITIALIZE_OUTPUT(input, o);
				o.pos = float4(buf_Points[id].pos + _worldPos, 1.0f);
				return o;
			}

			float4 RotPoint(float4 p, float3 offset, float3 sideVector, float3 upVector) {
				float3 finalPos = p.xyz;

				finalPos += offset.x * sideVector;
				finalPos += offset.y * upVector;

				return float4(finalPos, 1);
			}

			[maxvertexcount(4)] //the number of vertices this shader should push out
			void geom(point input p[1], inout TriangleStream<input> triStream) {
				float2 halfS = _Size;

				float4 v[4];

				if (_StaticCylinderSpherical == 0) {
					v[0] = p[0].pos.xyzw + float4(-halfS.x, -halfS.y, 0, 0);
					v[1] = p[0].pos.xyzw + float4(-halfS.x, halfS.y, 0, 0);
					v[2] = p[0].pos.xyzw + float4(halfS.x, -halfS.y, 0, 0);
					v[3] = p[0].pos.xyzw + float4(halfS.x, halfS.y, 0, 0);
				} else {
					float3 up = normalize(float3(0, 1, 0) + (_Wind * -0.5));
					float3 look = _WorldSpaceCameraPos - p[0].pos.xyz;

					if (_StaticCylinderSpherical == 1)
						look.y = 0;

					look = normalize(look);
					float3 right = normalize(cross(look, up));
					up = normalize(cross(right, look));

					v[0] = RotPoint(p[0].pos, float3(-halfS.x, -halfS.y, 0), right, up);
					v[1] = RotPoint(p[0].pos, float3(-halfS.x, halfS.y, 0), right, up);
					v[2] = RotPoint(p[0].pos, float3(halfS.x, -halfS.y, 0), right, up);
					v[3] = RotPoint(p[0].pos, float3(halfS.x, halfS.y, 0), right, up);
				}

				input pIn;

				pIn.pos = mul(UNITY_MATRIX_VP, v[0]);
				pIn.uv = float2(0.0f, 0.0f);
				UNITY_TRANSFER_FOG(pIn, pIn.pos);
				triStream.Append(pIn);

				pIn.pos = mul(UNITY_MATRIX_VP, v[1]);
				pIn.uv = float2(0.0f, 1.0f);
				UNITY_TRANSFER_FOG(pIn, pIn.pos);
				triStream.Append(pIn);

				pIn.pos = mul(UNITY_MATRIX_VP, v[2]);
				pIn.uv = float2(1.0f, 0.0f);
				UNITY_TRANSFER_FOG(pIn, pIn.pos);
				triStream.Append(pIn);

				pIn.pos = mul(UNITY_MATRIX_VP, v[3]);
				pIn.uv = float2(1.0f, 1.0f);
				UNITY_TRANSFER_FOG(pIn, pIn.pos);
				triStream.Append(pIn);
			}

			float4 frag(input i) : COLOR {
				fixed4 col = tex2D(_Sprite, i.uv) * _Color;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}

			ENDCG
		}

	}

	FallBack "Diffuse"
}
