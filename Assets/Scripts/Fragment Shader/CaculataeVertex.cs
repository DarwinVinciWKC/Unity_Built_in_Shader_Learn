using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CaculataeVertex : MonoBehaviour
{
    Func<Vector3, float> getXVertex;
    Func<Vector3, float> getYVertex;
    Func<Vector3, float> getZVertex;
    void Start()
    {
        getXVertex = GetXVertex;
        print(transform.name + " X max vertex: " + GetComponent<MeshFilter>().mesh.vertices.Max(getXVertex));
        print(transform.name + " X min vertex: " + GetComponent<MeshFilter>().mesh.vertices.Min(delegate (Vector3 vertex) { return vertex.x; }));
        getYVertex = GetYVertex;
        print(transform.name + " Y max vertex: " + GetComponent<MeshFilter>().mesh.vertices.Max(getYVertex));
        print(transform.name + " Y min vertex: " + GetComponent<MeshFilter>().mesh.vertices.Min(delegate (Vector3 vertex) { return vertex.y; }));
        getZVertex = GetZVertex;
        print(transform.name + " Z max vertex: " + GetComponent<MeshFilter>().mesh.vertices.Max(getZVertex));
        print(transform.name + " Z min vertex: " + GetComponent<MeshFilter>().mesh.vertices.Min(delegate (Vector3 vertex) { return vertex.z; }));
    }
    float GetXVertex(Vector3 vertex)
    {
        return vertex.x;
    }
    float GetYVertex(Vector3 vertex)
    {
        return vertex.y;
    }
    float GetZVertex(Vector3 vertex)
    {
        return vertex.z;
    }
}
