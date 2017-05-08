using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrabPassBlur : MonoBehaviour {

    private Material material;

	// Use this for initialization
	void Start () {
        material = GetComponent<MeshRenderer>().material;
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnRenderObject()
    {
    }
}
