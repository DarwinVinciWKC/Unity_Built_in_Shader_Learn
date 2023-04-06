using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UVAnimation : MonoBehaviour
{
    public int width;
    public int height;
    public float fps;
    int currentIndex;
    IEnumerator Start()
    {
        var material = GetComponent<MeshRenderer>().material;
        var scale_x = 1.0f / width;
        var scale_y = 1.0f / height;
        var scale = new Vector2(scale_x, scale_y);
        while (true)
        {
            var offset_x = currentIndex % width * scale_x;
            var offset_y = currentIndex / height * scale_y;
            var offset = new Vector2(offset_x, offset_y);
            material.SetTextureScale("_MainTex", scale);
            material.SetTextureOffset("_MainTex", offset);
            yield return new WaitForSeconds(1 / fps);
            currentIndex = ++currentIndex % (width * height);
        }
    }
}
