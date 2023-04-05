using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class ChangeColor : MonoBehaviour
{
    public float changeColorRange = 5;
    public float changeColorSpeed = 1;
    void Start()
    {
        StartCoroutine("LoopColor");
    }

    IEnumerator LoopColor()
    {
        var material = GetComponent<Renderer>().material;
        while (true)
        {
            var range = changeColorRange * Mathf.Sin(Time.time) * changeColorSpeed;
            material.SetFloat("_SplitPosition", range);
            yield return null;
        }
    }
}
