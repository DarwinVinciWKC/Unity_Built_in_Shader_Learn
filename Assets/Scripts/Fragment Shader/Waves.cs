using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Waves : MonoBehaviour
{
    public string shaderTextureName = "_WaveTex";

    public int waveWidth;
    public int waveHeight;

    public float attenuation = 0.0025f;

    float[,] waveA;
    float[,] waveB;

    Texture2D waveTexture;
    void Start()
    {
        waveA = new float[waveWidth, waveHeight];
        waveB = new float[waveWidth, waveHeight];

        waveTexture = new Texture2D(waveWidth, waveHeight);

        GetComponent<MeshRenderer>().material.SetTexture(shaderTextureName, waveTexture);
    }

    void Update()
    {
        ProcessWaves();
        if (Input.GetMouseButtonDown(0))
        {
            PutDrop();
        }
    }

    void PutDrop()
    {
        waveA[waveWidth / 2, waveHeight / 2] = 1;
        waveA[waveWidth / 2 - 1, waveHeight / 2] = 1;
        waveA[waveWidth / 2 + 1, waveHeight / 2] = 1;
        waveA[waveWidth / 2, waveHeight / 2 - 1] = 1;
        waveA[waveWidth / 2, waveHeight / 2 + 1] = 1;
        waveA[waveWidth / 2 - 1, waveHeight / 2 + 1] = 1;
        waveA[waveWidth / 2 + 1, waveHeight / 2 + 1] = 1;
        waveA[waveWidth / 2 + 1, waveHeight / 2 - 1] = 1;
    }

    void ProcessWaves()
    {

        for (int w = 1; w < waveWidth - 1; w++)
        {
            for (int h = 1; h < waveHeight - 1; h++)
            {
                waveB[w, h] =
                    (
                    waveA[w + 1, h] +
                    waveA[w - 1, h] +
                    waveA[w, h + 1] +
                    waveA[w, h - 1] +
                    waveA[w - 1, h + 1] +
                    waveA[w - 1, h - 1] +
                    waveA[w + 1, h + 1] +
                    waveA[w + 1, h - 1]
                    )
                    / 4 - waveB[w, h];

                if (waveB[w, h] < -1)
                    waveB[w, h] = -1;
                if (waveB[w, h] > 1)
                    waveB[w, h] = 1;

                var u_offset = (waveB[w - 1, h] - waveB[w + 1, h]) / 2;
                var v_offset = (waveB[w, h - 1] - waveB[w, h + 1]) / 2;

                //var r = u_offset / 2 + 0.5f;
                //var g = v_offset / 2 + 0.5f;

                waveTexture.SetPixel(w, h, new Color(u_offset, v_offset, 0));

                waveB[w, h] -= waveB[w, h] * attenuation;
            }
        }

        waveTexture.Apply();

        float[,] temp = waveA;
        waveA = waveB;
        waveB = temp;

    }
}
