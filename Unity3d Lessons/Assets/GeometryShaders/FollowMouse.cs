using UnityEngine;
using System.Collections;

public class FollowMouse : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		float distance = transform.position.z - Camera.main.transform.position.z;
		Vector3 targetPos = new Vector3 (Input.mousePosition.x, Input.mousePosition.y, distance);
		targetPos = Camera.main.ScreenToWorldPoint (targetPos);
		transform.position = targetPos;
	}
}
