using UnityEngine;
using System.Collections;

public class GrabForce : MonoBehaviour {

    [SerializeField]
    private Transform target;

    [SerializeField]
    private float force = 5.0f;

    private bool mouseHolding = false;

    private bool moving = false;

    private Vector3 originalPos;

    private Vector3 currentActualPos;

    private float actualDistance;

    void Start()
    {
        transform.LookAt(target);

        Vector3 toObjectVector = transform.position - Camera.main.transform.position;
        Vector3 linearDistanceVector = Vector3.Project(toObjectVector, Camera.main.transform.forward);
        actualDistance = linearDistanceVector.magnitude;

        originalPos = transform.position;
    }

    void OnMouseDown()
    {
        Debug.Log("Touched");
        mouseHolding = true;
        currentActualPos = transform.position;
    }

    void OnMouseUp()
    {
        mouseHolding = false;
        Debug.Log("Touch Released");
    }
	void FixedUpdate()
    {
        if (mouseHolding) {
            Vector3 pos = Input.mousePosition;
            pos.z = actualDistance;
            pos = Camera.main.ScreenToWorldPoint(pos);

            if (pos != currentActualPos && Vector3.Distance(pos, currentActualPos) > 0.02f) {
                currentActualPos = Vector3.Lerp(currentActualPos, pos, 10.0f * Time.fixedDeltaTime);
                transform.position = currentActualPos;

                transform.LookAt(target);

            }

            moving = true;
        }
        else
        {
            if (moving && Vector3.Distance(transform.position, target.position) < 0.02f)
            {
                transform.position = target.position;
                moving = false;
            }
            else if (moving)
            {
                transform.position = Vector3.Lerp(transform.position, originalPos, force * Time.fixedDeltaTime);
                transform.LookAt(target);
            }
        }
    }
}
