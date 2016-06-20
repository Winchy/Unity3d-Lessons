using UnityEngine;
using System.Collections;

public class StretchToTarget : MonoBehaviour { 

    [SerializeField]
    private float stretchForce = 0.1f;

    private Vector3 originalPosition;

	// Use this for initialization
	void Start () {
        originalPosition = transform.position;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        transform.localScale = Vector3.forward * stretchForce * Vector3.Distance(transform.position, originalPosition) + new Vector3(1, 1, 1);
    }
}
