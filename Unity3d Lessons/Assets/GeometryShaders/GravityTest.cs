using UnityEngine;
using System.Collections;

public class GravityTest : MonoBehaviour {

	public float k;

	public Transform target;

	public Vector3 force = Vector3.zero;
	public Vector3 velocity = Vector3.forward;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		float dist = Vector3.SqrMagnitude (target.position - transform.position);
		if (dist < 0.1f)
			dist = 0.1f;
		force = Vector3.Normalize(target.position - transform.position) * k / dist;
		velocity += force * Time.deltaTime;
		transform.position += velocity * Time.deltaTime;
	}
}
