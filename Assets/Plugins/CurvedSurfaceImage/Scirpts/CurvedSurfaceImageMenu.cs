using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class CurvedSurfaceImageMenu : MonoBehaviour
{
    [MenuItem("GameObject/UI/CurvedSurfaceImage")]
    static void CreateImage()
    {
        print($"<color=aqua>CurvedSurfaceImage：调整CurvedSurfaceImage组件的Curvature属性改变图片的弯曲程度</color>");

        var activeTransform = Selection.activeTransform;
        GameObject canvasGo = null;
        bool hasCanvas = false;
        if (activeTransform != null)
        {
            Canvas canvas = activeTransform.GetComponent<Canvas>();
            if (canvas != null)
                hasCanvas = true;
            else
            {
                var parent = activeTransform.parent;
                while (parent != null)
                {
                    var currentCanvas = parent.GetComponent<Canvas>();
                    if (currentCanvas != null)
                    {
                        hasCanvas = true;
                        break;
                    }
                    parent = parent.parent;
                }
            }
        }

        if (hasCanvas)
            canvasGo = activeTransform.gameObject;

        if (!hasCanvas)
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
