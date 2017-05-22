using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Toggle : MonoBehaviour {

    [SerializeField]
    private GameObject[] gos;


    public void ToggleStates() {
        for (int i = 0; i < gos.Length; i++)
        {
            gos[i].SetActive(!gos[i].activeSelf);
        }
    }
}
