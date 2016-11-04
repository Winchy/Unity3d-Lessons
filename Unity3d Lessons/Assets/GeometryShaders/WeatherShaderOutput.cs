using UnityEngine;
using System.Collections;

public class WeatherShaderOutput : MonoBehaviour {

	public ComputeShader computeShader;

	/// <summary>
	/// The total number of vertices to calculate. We are going to have 32 * 32 work groups, each processing 16 * 16 * 1 points.
	/// </summary>
	public const int VertCount = 32 * 32 * 16 * 16 * 1;

	ComputeBuffer startPointBuffer;

	public ComputeBuffer outputBuffer;

	ComputeBuffer constantBuffer;

	ComputeBuffer modBuffer;

	public Shader PointShader;
	Material PointMaterial;


	[Tooltip("Speed weather is falling at, 1 would be slow like snow, 10, rain")]
	[Range(1, 200)]
	public float speed = 1;

	public bool wobble = false;

	public Vector3 wind = Vector3.zero;

	public float spacing = 5.0f;

	public bool DebugRender = false;

	int CSKernel;

	void InitializeBuffers() {
		startPointBuffer = new ComputeBuffer (VertCount, sizeof(float));

		constantBuffer = new ComputeBuffer(1, sizeof(float));

		modBuffer = new ComputeBuffer (VertCount, sizeof(float) * 2);

		outputBuffer = new ComputeBuffer (VertCount, sizeof(float) * 3);

		float[] values = new float[VertCount];
		Vector2[] mods = new Vector2[VertCount];

		for (int i = 0; i < VertCount; i++) {
			values [i] = Random.value * 2 * Mathf.PI;
			mods [i] = new Vector2 (.1f + Random.value, .1f + Random.value);
		}

		modBuffer.SetData (mods);

		startPointBuffer.SetData (values);

		computeShader.SetBuffer (CSKernel, "startPointBuffer", startPointBuffer);
	}

	public void Dispatch () {
		constantBuffer.SetData (new [] { Time.time * .01f });

		computeShader.SetBuffer (CSKernel, "modBuffer", modBuffer);
		computeShader.SetBuffer (CSKernel, "constBuffer", constantBuffer);
		computeShader.SetBuffer (CSKernel, "outputBuffer", outputBuffer);
		computeShader.SetFloat ("Speed", speed);
		computeShader.SetInt ("wobble", wobble ? 1 : 0);
		computeShader.SetVector ("wind", wind);
		computeShader.SetFloat ("spacing", spacing);

		computeShader.Dispatch (CSKernel, 32, 32, 1);
	}

	void ReleaseBuffers() {
		modBuffer.Release ();
		constantBuffer.Release ();
		outputBuffer.Release ();
		startPointBuffer.Release ();
	}

	// Use this for initialization
	void Start () {
		CSKernel = computeShader.FindKernel ("CSMain");
		PointMaterial = new Material (PointShader);
		InitializeBuffers ();
	}
	
	void OnRenderObject () {
		if (!SystemInfo.supportsComputeShaders) {
			Debug.Log ("Compute shaders not supported (not using DX11?)");
			return;
		}

		Dispatch ();

		if (DebugRender) {
			PointMaterial.SetPass (0);
			PointMaterial.SetBuffer ("buf_Points", outputBuffer);

			Graphics.DrawProcedural (MeshTopology.Points, VertCount);
		}
	}

	void OnDisable () {
		ReleaseBuffers ();
	}
}
