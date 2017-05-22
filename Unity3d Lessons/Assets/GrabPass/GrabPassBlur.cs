using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GrabPassBlur : MonoBehaviour {

	[SerializeField]
	private float deviation = 1.0f;


    private Material material;

	float[] GaussianMatrix = new float[121];/*{
                0.00000067f,  0.00002292f,  0.00019117f,  0.00038771f,  0.00019117f,  0.00002292f,  0.00000067f,
0.00002292f,  0.00078634f,  0.00655965f,  0.01330373f,  0.00655965f,  0.00078633f,  0.00002292f,
0.00019117f,  0.00655965f,  0.05472157f,  0.11098164f,  0.05472157f,  0.00655965f,  0.00019117f,
0.00038771f,  0.01330373f,  0.11098164f,  0.22508352f,  0.11098164f,  0.01330373f,  0.00038771f,
0.00019117f,  0.00655965f,  0.05472157f,  0.11098164f,  0.05472157f,  0.00655965f,  0.00019117f,
0.00002292f,  0.00078633f,  0.00655965f,  0.01330373f,  0.00655965f,  0.00078633f,  0.00002292f,
0.00000067f,  0.00002292f,  0.00019117f,  0.00038771f,  0.00019117f,  0.00002292f,  0.00000067f
            };*/


	void Awake() {
		//CalculateGaussianMatrix (deviation);
	}

    // Use this for initialization
    void Start () {
        
	}
	
	// Update is called once per frame
	void Update () {
		#if UNITY_EDITOR
		CalculateGaussianMatrix(deviation);
		#endif
	}

	void CalculateGaussianMatrix(float d) {
		Debug.Log (d);
		int x = 0;
		int y = 0;
		//Debug.Log (Mathf.Exp(-(x * x + y * y)/(2.0f * d * d)) / (2.0f * Mathf.PI * d * d));

		float sum = 0.0f;
		for (x = -5; x <= 5; ++x) {
			for (y = -5; y <= 5; ++y) {
				GaussianMatrix[y * 11 + x + 60] = Mathf.Exp(-(x * x + y * y)/(2.0f * d * d)) / (2.0f * Mathf.PI * d * d);
				sum += GaussianMatrix [y * 11 + x + 60];
			}
		}

		//normalize
		sum = 1.0f / sum;
		for (int i = 0; i < GaussianMatrix.Length; i++) {
			GaussianMatrix [i] *= sum;
		}

		Debug.Log (GaussianMatrix [24]);

		material = GetComponent<MeshRenderer>().sharedMaterial;
		material.SetFloatArray ("blurWeight", GaussianMatrix);
	}
}
