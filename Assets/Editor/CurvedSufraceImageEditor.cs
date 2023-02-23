using Unity.VisualScripting;
using UnityEditor;
using UnityEditor.UI;
using UnityEngine;

[CustomEditor(typeof(CurvedSurfaceImage))]
[CanEditMultipleObjects]
public class CurvedSufraceImageEditor : ImageEditor
{
    SerializedProperty curvature;

    protected override void OnEnable()
    {
        base.OnEnable();
        curvature = serializedObject.FindProperty("curvature");
    }
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        serializedObject.Update();
        EditorGUILayout.Slider(curvature, -100, 100,new GUIContent("Curvature"));
        serializedObject.ApplyModifiedProperties();
    }
}
