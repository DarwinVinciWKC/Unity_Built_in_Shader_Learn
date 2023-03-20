using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class ArchedImgae : Image
{
    float innerCircleRadius;
    float outerCircleRadius ;

    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        toFill.Clear();

        innerCircleRadius= rectTransform.rect.width;
        outerCircleRadius= rectTransform.rect.height;

        List<Vector2> innerLinePoints = new List<Vector2>();
        List<Vector2> outerLinePoints = new List<Vector2>();
        for (float i = 0; i <= Mathf.PI; i += Mathf.PI / 100)
        {
            var innerX = innerCircleRadius * Mathf.Cos(i);
            var innerY = innerCircleRadius * Mathf.Sin(i);
            innerLinePoints.Add(new Vector2(innerX, innerY));

            var outerX = outerCircleRadius * Mathf.Cos(i);
            var outerY = outerCircleRadius * Mathf.Sin(i);
            outerLinePoints.Add(new Vector2(outerX, outerY));
        }

        List<UIVertex> vertices = new List<UIVertex>();
        vertices.AddRange(GetUIVertex(innerLinePoints, color, 0));
        vertices.AddRange(GetUIVertex(outerLinePoints, color, 1));

        List<int> indices = new List<int>();
        for (int i = 0; i < innerLinePoints.Count - 1; i++)
        {
            indices.Add(i + innerLinePoints.Count);
            indices.Add(i + 1);
            indices.Add(i);
        }
        for (int i = outerLinePoints.Count; i < outerLinePoints.Count * 2 - 1; i++)
        {
            indices.Add(i);
            indices.Add(i + 1);
            indices.Add(i - outerLinePoints.Count + 1);
        }

        toFill.AddUIVertexStream(vertices, indices);
    }
    List<UIVertex> GetUIVertex(List<Vector2> points, Color color, float y)
    {
        List<UIVertex> uiVertices = new List<UIVertex>();
        for (int i = 0; i < points.Count; i++)
        {
            UIVertex v = new UIVertex();
            v.color = color;
            v.position = points[i];
            v.uv0 = new Vector2((float)i / points.Count, y);
            uiVertices.Add(v);
        }
        return uiVertices;
    }
}
