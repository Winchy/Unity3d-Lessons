using UnityEngine;
using System.Collections;

public class VoxelComputeShaderOutput : MonoBehaviour {

	#region Compute Shader fields and properties

	public ComputeShader computeShader;

	Material material;

	int VertCount;

	public Vector2 Seed = Vector2.zero;

	public ComputeBuffer outputBuffer;
	public ComputeBuffer mapBuffer;

	public Shader PointShader;
	Material PointMaterial;

	public int cubeMultiplier = 5;
	public bool DebugRender = false;
	public float PerlinScale = 20.0f;
	public float HeightScale = 0.2f;
	public float offset = 0.0f;

	int CSKernel;

	#endregion

	/*
	struct data {
		public Vector3 pos;
		public int f1;
		public int f2;
		public int f3;
		public int f4;
		public int f5;
		public int f6;
	};
	data[] points;
	*/

	void InitializeBuffers() {
		VertCount = 10 * 10 * 10 * cubeMultiplier * cubeMultiplier * cubeMultiplier;

		outputBuffer = new ComputeBuffer (VertCount, (sizeof(float) * 3) + (sizeof(int) * 6));
		mapBuffer = new ComputeBuffer (VertCount, sizeof(int));

		int width = 10 * cubeMultiplier;
		int height = 10 * cubeMultiplier;
		int depth = 10 * cubeMultiplier;

		//PerlinNoise.Seed = Seed;
		float[,] fmap = new float[width,depth]; //PerlinNoise.GeneratePerlinNoise (width, height, 8);

		for (int x = 0; x < width; x++) {
			for (int z = 0; z < depth; z++) {
				fmap [x,z] = Mathf.PerlinNoise ((float)x /PerlinScale, (float)z/PerlinScale);
				//Debug.Log (fmap [x, z]);
			}
		}

		int[] map = new int[VertCount];

		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				for (int z = 0; z < depth; z++) {
					int idx = x + (y * 10 * cubeMultiplier) + (z * 10 * cubeMultiplier * 10 * cubeMultiplier);
					if (fmap [x,z] >= y / (float)height) {
						map [idx] = 1;
					} else {
						map [idx] = 0;
					}
				}
			}
		}

		mapBuffer.SetData (map);

		computeShader.SetBuffer (CSKernel, "outputBuffer", outputBuffer);
		computeShader.SetBuffer (CSKernel, "mapBuffer", mapBuffer);

		computeShader.SetVector ("group_size", new Vector3 (cubeMultiplier, cubeMultiplier, cubeMultiplier));

		if (DebugRender) {
			PointMaterial.SetBuffer ("buf_Points", outputBuffer);
		}

		transform.position -= (Vector3.one * 10 * cubeMultiplier) * 0.5f;
	}

	public void Dispatch () {
		if (!SystemInfo.supportsComputeShaders) {
			Debug.LogWarning ("");
			return;
		}
		int width = 10 * cubeMultiplier;
		int height = 10 * cubeMultiplier;
		int depth = 10 * cubeMultiplier;

		//PerlinNoise.Seed = Seed;
		float[,] fmap = new float[width,depth]; //PerlinNoise.GeneratePerlinNoise (width, height, 8);

		for (int x = 0; x < width; x++) {
			for (int z = 0; z < depth; z++) {
				offset += Time.deltaTime * 0.001f;
				fmap [x,z] = Mathf.PerlinNoise ((float)x /PerlinScale, (float)(z + offset)/PerlinScale) * HeightScale;

				//Debug.Log (fmap [x, z]);
			}
		}

		int[] map = new int[VertCount];

		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				for (int z = 0; z < depth; z++) {
					int idx = x + (y * 10 * cubeMultiplier) + (z * 10 * cubeMultiplier * 10 * cubeMultiplier);
					if (fmap [x,z] >= y / (float)height) {
						map [idx] = 1;
					} else {
						map [idx] = 0;
					}
				}
			}
		}

		mapBuffer.SetData (map);
		computeShader.SetBuffer (CSKernel, "mapBuffer", mapBuffer);
		computeShader.Dispatch (CSKernel, cubeMultiplier, cubeMultiplier, cubeMultiplier);
		/*
		points = new data[VertCount];
		outputBuffer.GetData (points);
		Debug.Log (points.Length);
		for (int i = 0; i < points.Length; i++) {
			Debug.Log (points [i].pos);
			Debug.LogFormat ("{0}, {1}, {2}, {3}, {4}, {5}", points [i].f1, points [i].f2, points [i].f3, points [i].f4, points [i].f5, points [i].f6);
			Debug.Log("---");

		}
*/
	}

	void ReleaseBuffers() {
		outputBuffer.Release ();
		mapBuffer.Release ();
	}

	// Use this for initialization
	void Start () {
		CSKernel = computeShader.FindKernel ("CSMain");

		if (DebugRender) {
			PointMaterial = new Material (PointShader);
			PointMaterial.SetVector ("_worldPos", transform.position);
		}

		InitializeBuffers ();
		Dispatch ();
	}
	
	// Update is called once per frame
	void OnRenderObject () {
		if (DebugRender) {
			//Dispatch ();
			PointMaterial.SetPass (0);
			PointMaterial.SetVector ("_worldPos", transform.position);
			Graphics.DrawProcedural (MeshTopology.Points, VertCount);
		}
	}

	void OnDisable() {
		ReleaseBuffers ();
	}
}
