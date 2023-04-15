using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReplacementShader : MonoBehaviour
{
    void Start()
    {
        Camera.main.SetReplacementShader(Shader.Find("UnityTrain/Fragment/ReplacedShader"), "RenderType");
    }
}
