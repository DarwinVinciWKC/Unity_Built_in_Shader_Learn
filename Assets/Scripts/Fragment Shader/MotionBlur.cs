using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlur : MonoBehaviour
{
    public float speed = 1;
    void Update()
    {
            GetComponent<MeshRenderer>().material.SetFloat("speed", (Time.time * speed) * (Time.time * speed));
    }
}
