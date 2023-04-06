using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MatTilingOffset : MonoBehaviour
{
    Material mat;
    public float tiling_x = 1;
    public float tiling_y = 1;
    public float offset_x;
    public float offset_y;
    void Start()
    {
        mat = GetComponent<Renderer>().material;
    }

    void Update()
    {
        mat.SetFloat("tiling_x", tiling_x);
        mat.SetFloat("tiling_y", tiling_y);
        mat.SetFloat("offset_x", offset_x);
        mat.SetFloat("offset_y", offset_y);
    }
}
