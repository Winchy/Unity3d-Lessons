using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrabPassBlur : MonoBehaviour {

    private Material material;
    

    float[] blurWeight = new float[49]{
                0.00000067f,  0.00002292f,  0.00019117f,  0.00038771f,  0.00019117f,  0.00002292f,  0.00000067f,
0.00002292f,  0.00078634f,  0.00655965f,  0.01330373f,  0.00655965f,  0.00078633f,  0.00002292f,
0.00019117f,  0.00655965f,  0.05472157f,  0.11098164f,  0.05472157f,  0.00655965f,  0.00019117f,
0.00038771f,  0.01330373f,  0.11098164f,  0.22508352f,  0.11098164f,  0.01330373f,  0.00038771f,
0.00019117f,  0.00655965f,  0.05472157f,  0.11098164f,  0.05472157f,  0.00655965f,  0.00019117f,
0.00002292f,  0.00078633f,  0.00655965f,  0.01330373f,  0.00655965f,  0.00078633f,  0.00002292f,
0.00000067f,  0.00002292f,  0.00019117f,  0.00038771f,  0.00019117f,  0.00002292f,  0.00000067f
            };

    // Use this for initialization
    void Start () {
        material = GetComponent<MeshRenderer>().material;
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    
}
