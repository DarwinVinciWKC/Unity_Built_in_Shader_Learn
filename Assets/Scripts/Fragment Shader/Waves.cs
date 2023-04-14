using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using UnityEngine;

public class Waves : MonoBehaviour
{
    public string shaderTextureName = "_WaveTex";

    public int waveWidth;
    public int waveHeight;

    public float attenuation = 0.0025f;

    public int waveRadius = 20;

    public float listenToPutDropIntervalTime;

    float[,] waveA;
    float[,] waveB;

    Texture2D waveTexture;

    int sleepTime;
    Color[] colorBuffer;
    bool isRun = true;
    void Start()
    {
        Init();
    }
    void Init()
    {
        waveA = new float[waveWidth, waveHeight];
        waveB = new float[waveWidth, waveHeight];

        waveTexture = new Texture2D(waveWidth, waveHeight);

        GetComponent<MeshRenderer>().material.SetTexture(shaderTextureName, waveTexture);

        Thread thread = new Thread(ProcessWaves);
        thread.Start();

        colorBuffer = new Color[waveWidth * waveHeight];

        StartCoroutine(ListenToPutDrop(listenToPutDropIntervalTime));
    }
    void Update()
    {
        sleepTime = (int)(Time.deltaTime * 1000);

        waveTexture.SetPixels(colorBuffer);
        waveTexture.Apply();
    }
    IEnumerator ListenToPutDrop(float intervalTime)
    {
        Vector3 lastPostion = Vector3.zero;
        while (isRun)
        {
            if (Input.GetMouseButton(0))
            {
                if (GetClickedPoint(out Vector2 pos))
                {
                    if (lastPostion != Input.mousePosition)
                    {
                        lastPostion = Input.mousePosition;
                        PutDrop((int)pos.x, (int)pos.y);
                    }
                    yield return new WaitForSeconds(intervalTime);
                }
            }
            yield return null;
        }
    }
    bool GetClickedPoint(out Vector2 pos)
    {
        RaycastHit raycastHit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out raycastHit))
        {
            var clickedPos = transform.worldToLocalMatrix.MultiplyPoint(raycastHit.point);
            pos.x = (int)((clickedPos.x + 0.5) * waveWidth);
            pos.y = (int)((clickedPos.y + 0.5) * waveHeight);
            return true;
        }
        pos = Vector2.zero;
        return false;
    }
    void PutDrop(int x, int y)
    {
        float distance;
        for (int i = -waveRadius; i <= waveRadius; i++)
        {
            for (int j = -waveRadius; j <= waveRadius; j++)
            {
                if (x + i >= 0 && y + j >= 0 && x + i < waveWidth && y + j < waveHeight)
                {
                    distance = MathF.Sqrt(i * i + j * j);
                    if (distance < waveRadius)
                        waveA[x + i, y + j] = MathF.Cos(distance * MathF.PI / waveRadius);
                }
            }
        }
    }
    void ProcessWaves()
    {
        while (isRun)
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

                    colorBuffer[w + waveHeight * h] = new Color(u_offset, v_offset, 0);

                    waveB[w, h] -= waveB[w, h] * attenuation;
                }
            }

            float[,] temp = waveA;
            waveA = waveB;
            waveB = temp;

            Thread.Sleep(sleepTime);
        }
    }
    void OnDisable()
    {
        isRun = false;
    }
}
