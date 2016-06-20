using UnityEngine;
using System.Collections;

public class FixedRotation : MonoBehaviour {

    private Quaternion originalRotation;

    void Start()
    {
        originalRotation = transform.rotation;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        transform.rotation = originalRotation;
    }
}
