using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class CurvedSurfaceImageMenu : MonoBehaviour
{
    [MenuItem("GameObject/UI/CurvedSurfaceImage")]
    static void CreateImage()
    {
        print($"<color=lime>CurvedSurfaceImage������CurvedSurfaceImage�����Curvature���Ըı�ͼƬ�������̶�</color>");

        var activeTransform = Selection.activeTransform;

        var canvas = activeTransform?.GetComponent<Canvas>();
        GameObject canvasGo;
        if (canvas?.renderMode == RenderMode.WorldSpace)//���񲻿��������ã�����Ҫ����Ѱ�Ҹ���������û��Canvas
            canvasGo = activeTransform.gameObject;
        else
        {
            canvasGo = new GameObject("Canvas");
            canvasGo.AddComponent<Canvas>();
            canvasGo.AddComponent<CanvasScaler>();
            canvasGo.AddComponent<GraphicRaycaster>();
            canvasGo.transform.SetParent(activeTransform);
        }

        var curvedSurfaceImageGo = new GameObject("CurvedSurfaceImage");
        curvedSurfaceImageGo.transform.SetParent(canvasGo.transform);
        var curvedSurfaceImage = curvedSurfaceImageGo.AddComponent<CurvedSurfaceImage>();
        curvedSurfaceImage.material = new Material(Shader.Find("UI/CurvedSurfaceImage"));

        Selection.activeTransform = curvedSurfaceImageGo.transform;

        Undo.RegisterCreatedObjectUndo(canvasGo, "Create " + curvedSurfaceImageGo.name);
    }
}
