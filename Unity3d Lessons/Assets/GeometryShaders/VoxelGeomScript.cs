using UnityEngine;
using System.Collections;

public class VoxelGeomScript : MonoBehaviour {

	public Shader geomShader;
	Material material;

	public Texture2D sprite;
	public float size = 1.0f;
	public Color color = new Color (1.0f, 0.6f, 0.3f, 0.03f);

	VoxelComputeShaderOutput cso;
	ComputeBuffer outputBuffer;

	// Use this for initialization
	void Start () {
		material = new Material (geomShader);
		cso = GetComponent<VoxelComputeShaderOutput> ();
	}

	bool getData = true;

	void OnRenderObject() {
		if (getData) {
			getData = false;
			cso.Dispatch ();
			outputBuffer = cso.outputBuffer;
		}
		if (outputBuffer == null) {
			return;
		}
		material.SetPass (0);
		material.SetColor ("_Color", color);
		material.SetBuffer ("buf_Points", cso.outputBuffer);
		material.SetTexture ("_Sprite", sprite);
		material.SetFloat ("_Size", size);
		material.SetMatrix ("world", transform.localToWorldMatrix);
		Graphics.DrawProcedural (MeshTopology.Points, cso.outputBuffer.count);
	}

}
