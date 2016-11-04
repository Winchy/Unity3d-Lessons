using UnityEngine;
using System.Collections;

[AddComponentMenu("Scripts/Compute Shader Scripts/ComputeShaderOutput")]
public class ComputeShaderOutput : MonoBehaviour {

	#region Compute Shader Fileds and Properties

	/// <summary>
	/// The compute shader.
	/// </summary>
	public ComputeShader computeShader;



	public Vector3 threads = new Vector3 (10, 10, 10);
	public Vector3 threadGroups = new Vector3(10, 10, 10);

	/// <summary>
	/// The total number of vertices to calculate.
	/// 10 * 10 * 10 block render in 10 * 10 * 10 threads in 1 * 1 * 1 groups.
	/// </summary>
	int VertCount;

	public ComputeBuffer outputBuffer;

	public Shader PointShader;

	Material PointMaterial;

	public bool DebugRender = false;

	int CSKernel;

	#endregion

	void InitializeBuffers () {
		outputBuffer = new ComputeBuffer (VertCount, (sizeof(float) * 3) + (sizeof(int) * 6));
		computeShader.SetBuffer (CSKernel, "outputBuffer", outputBuffer);
		if (DebugRender)
			PointMaterial.SetBuffer ("buf_Points", outputBuffer);
	}

	public void Dispatch() {
		if (!SystemInfo.supportsComputeShaders) {
			Debug.LogWarning ("Compute shaders not supported ( not using DX11)");
			return;
		}

		computeShader.Dispatch (CSKernel, (int)threadGroups.x, (int)threadGroups.y, (int)threadGroups.z);
	}

	void ReleaseBuffers() {
		outputBuffer.Release ();
	}

	// Use this for initialization
	void Start () {
		VertCount = (int)(threads.x * threads.y * threads.z * threadGroups.x * threadGroups.y * threadGroups.z);
		CSKernel = computeShader.FindKernel ("CSMain");

		if (DebugRender) {
			PointMaterial = new Material (PointShader);
			PointMaterial.SetVector ("_worldPos", transform.position);
		}

		InitializeBuffers ();
		Dispatch ();
	}

	void OnRenderObject() {
		if (DebugRender) {
			//Dispatch ();
			if (PointMaterial == null) {
				PointMaterial = new Material (PointShader);
				PointMaterial.SetBuffer ("buf_Points", outputBuffer);
			}
			PointMaterial.SetPass (0);
			PointMaterial.SetVector ("_worldPos", transform.position);

			Graphics.DrawProcedural (MeshTopology.Points, VertCount);
		}

	}
	
	// Update is called once per frame
	void OnDisable () {
		ReleaseBuffers ();
	}
}
