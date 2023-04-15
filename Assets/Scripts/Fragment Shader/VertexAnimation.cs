using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;


public class VertexAnimation : MonoBehaviour
{
    Material material;
    void Start()
    {
        material = GetComponent<MeshRenderer>().material;
    }
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            PlayTransforAnimation();
        }
        if (Input.GetMouseButtonDown(1))
        {
            PlayVertexAnimation();
        }
        //material.SetFloat("_HeightDelta", Mathf.Cos(Time.time));
    }
    void PlayTransforAnimation()
    {
        Sequence sequence = DOTween.Sequence();
        sequence.Append(transform.DOMove(Vector3.up * 0.3f, 0.2f).SetRelative(true));
        sequence.AppendInterval(0.3f);
        sequence.Append(transform.DOMove(Vector3.down * 0.3f, 0.1f).SetRelative(true));
    }
    void PlayVertexAnimation()
    {
        Sequence sequence = DOTween.Sequence();
        var material = GetComponent<MeshRenderer>().material;
        sequence.Append(material.DOFloat(-0.3f, "_HeightDelta", 0.2f).SetRelative(true));
        sequence.AppendInterval(0.3f);
        sequence.Append(material.DOFloat(0.3f, "_HeightDelta", 0.1f).SetRelative(true));
    }
}
