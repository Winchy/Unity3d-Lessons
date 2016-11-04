using UnityEngine;
using System.Collections;

public class ParticleFollowScript : MonoBehaviour {

	public ComputeShader computeShader;

	public Shader pointShader;
	Material pointMaterial;

	ComputeBuffer outputBuffer;

	/// <summary>
	/// 10 * 10 * 10 groups with 10 * 10 * 10 threads
	/// </summary>
	int vertCount = 10 * 10 * 10 * 10 * 10 * 10;

	int CSKernel;

	int init = 0;

	public Transform target;

	void InitializeBuffers() {
		outputBuffer = new ComputeBuffer (vertCount, sizeof(float) * 6);
		computeShader.SetBuffer (CSKernel, "outputBuffer", outputBuffer);
	}

	void ReleaseBuffers() {
		outputBuffer.Release ();
	}

	bool Dispatch() {
		if (!SystemInfo.supportsComputeShaders) {
			Debug.Log ("Compute shaders not supported!");
			return false;
		}
		computeShader.SetBuffer (CSKernel, "outputBuffer", outputBuffer);
		computeShader.SetVector ("targetPos", target.position);
		computeShader.SetInt ("init", init);
		computeShader.SetFloat ("t", Time.deltaTime);
		computeShader.Dispatch (CSKernel, 10, 10, 10);
		init = 1;
		return true;
	}

	void Start () {
		CSKernel = computeShader.FindKernel ("CSMain");
		pointMaterial = new Material (pointShader);

		InitializeBuffers ();
	}

	void OnRenderObject() {
		if (Dispatch ()) {
			pointMaterial.SetPass (0);
			pointMaterial.SetBuffer ("buf_points", outputBuffer);
			pointMaterial.SetVector ("worldPos", transform.position);

			Graphics.DrawProcedural (MeshTopology.Points, outputBuffer.count);
		}
	}

	void OnDestroy() {
		ReleaseBuffers ();
	}
}
