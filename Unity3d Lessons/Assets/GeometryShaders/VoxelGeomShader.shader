Shader "Custom/VoxelGeomShader"
{
	Properties
	{
		_Sprite("Sprite", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Size("Size", Float) = 1
	}
	SubShader
	{
		Tags {"Queue" = "Geometry" "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Cull Off
			CGPROGRAM
			#pragma target 5.0

			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			//CULL Off
			
			#include "UnityCG.cginc"

			sampler2D _Sprite;
			float4 _Color;
			float _Size;
			matrix world;

			struct data {
				float3 pos;
				int renderfaces[6];
			};

			StructuredBuffer<data> buf_Points;

			struct input
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL0;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			struct inputGS
			{
				float4 pos : SV_POSITION;
				int faces[6] : NORMAL1;
			};
			
			inputGS vert(uint id : SV_VertexID) {
				inputGS o;
				UNITY_INITIALIZE_OUTPUT(inputGS, o);
				o.pos = float4(buf_Points[id].pos * _Size, 1.0f);
				o.faces = buf_Points[id].renderfaces;
				return o;
			}

			[maxvertexcount(24)]
			void geom(point inputGS p[1], inout TriangleStream<input> triStream) {
				float halfS = _Size/2;

				float2 uvs[4];

				uvs[0] = float2(0.0f, 0.0f);
				uvs[1] = float2(0.0f, 1.0f);
				uvs[2] = float2(1.0f, 0.0f);
				uvs[3] = float2(1.0f, 1.0f);

				float3 normals[6];
				normals[0] = float3(0, 0, -1);
				normals[1] = float3(1, 0, 0);
				normals[2] = float3(-1, 0, 0);
				normals[3] = float3(0, 0, 1);
				normals[4] = float3(0, 1, 0);
				normals[5] = float3(0, -1, 0);

				float4 v[24];

				// Front
				v[0] = p[0].pos + float4(-halfS, -halfS, -halfS, 0);
				v[1] = p[0].pos + float4(-halfS, halfS, -halfS, 0);
				v[2] = p[0].pos + float4(halfS, -halfS, -halfS, 0);
				v[3] = p[0].pos + float4(halfS, halfS, -halfS, 0);

				// Left
				v[8] = p[0].pos + float4(halfS, -halfS, -halfS, 0);
				v[9] = p[0].pos + float4(halfS, halfS, -halfS, 0);
				v[10] = p[0].pos + float4(halfS, -halfS, halfS, 0);
				v[11] = p[0].pos + float4(halfS, halfS, halfS, 0);

				// Right
				v[4] = p[0].pos + float4(-halfS, -halfS, halfS, 0);
				v[5] = p[0].pos + float4(-halfS, halfS, halfS, 0);
				v[6] = p[0].pos + float4(-halfS, -halfS, -halfS, 0);
				v[7] = p[0].pos + float4(-halfS, halfS, -halfS, 0);

				// Back
				v[12] = p[0].pos + float4(halfS, -halfS, halfS, 0);
				v[13] = p[0].pos + float4(halfS, halfS, halfS, 0);
				v[14] = p[0].pos + float4(-halfS, -halfS, halfS, 0);
				v[15] = p[0].pos + float4(-halfS, halfS, halfS, 0);

				// Top
				v[16] = p[0].pos + float4(-halfS, halfS, -halfS, 0);
				v[17] = p[0].pos + float4(-halfS, halfS, halfS, 0);
				v[18] = p[0].pos + float4(halfS, halfS, -halfS, 0);
				v[19] = p[0].pos + float4(halfS, halfS, halfS, 0);

				// Bottom
				v[20] = p[0].pos + float4(-halfS, -halfS, halfS, 0);
				v[21] = p[0].pos + float4(-halfS, -halfS, -halfS, 0);
				v[22] = p[0].pos + float4(halfS, -halfS, halfS, 0);
				v[23] = p[0].pos + float4(halfS, -halfS, -halfS, 0);

				input pIn;

				int vidx = 0;

				for (int f = 0; f < 6; f++) {
					//p[0].faces[f] = 1;
					if (p[0].faces[f] != 0) {
						for (int fv = 0; fv < 4; fv++) {
							pIn.pos = mul(UNITY_MATRIX_VP, mul(world, v[vidx]));
							pIn.uv = uvs[fv];
							pIn.normal = normals[f];
							UNITY_TRANSFER_FOG(pIn, pIn.pos);
							triStream.Append(pIn);

							vidx++;
						}
						triStream.RestartStrip();
					} else {
						vidx += 4;
					}
				}
			}
			
			fixed4 frag (input i) : COLOR
			{
				// sample the texture
				fixed4 col = tex2D(_Sprite, i.uv) * _Color;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
