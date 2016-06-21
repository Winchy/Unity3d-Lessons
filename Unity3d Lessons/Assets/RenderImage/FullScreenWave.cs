using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class FullScreenWave : MonoBehaviour {

    [SerializeField]
    private Shader transShader;

    [SerializeField, Range(0.001f, 0.5f)]
    private float waveLength = 0.02f;

    [SerializeField, Range(1f, 100f)]
    private float frequence = 10.0f;

    private Material transMaterial;

    Material material
    {
        get
        {
            if (transMaterial == null)
            {
                transMaterial = new Material(transShader);
                transMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return transMaterial;
        }
    }

    // Use this for initialization
    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!transShader && !transShader.isSupported)
        {
            enabled = false;
        }
    }

    void Update()
    {
        material.SetFloat("_WaveLength", waveLength);
        material.SetFloat("_Frequence", frequence);
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (transShader != null)
        {
            material.SetColor("_Color", new Color(0.5f, 0.5f, 0, 1.0f));
            Graphics.Blit(sourceTexture, destTexture, material);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    void OnDisable()
    {
        if (transShader)
        {
            DestroyImmediate(transMaterial);
        }
    }
}
