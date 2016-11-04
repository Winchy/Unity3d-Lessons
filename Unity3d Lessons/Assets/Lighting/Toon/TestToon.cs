using UnityEngine;
using System.Collections;

public class TestToon : MonoBehaviour {

	// Use this for initialization
	void Start () {
		float clevel = 20.0f;
		for (int i = 0; i < 1000; i++) {
			float d = (float)i / 1000;
			d = Mathf.Floor (d * clevel) / clevel;
			Debug.Log (d);
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
