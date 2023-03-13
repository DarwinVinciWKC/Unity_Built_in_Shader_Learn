using System.Linq;
using UnityEngine;
using UnityEditor.AnimatedValues;
using UnityEngine.UI;
namespace UnityEditor.UI
{
    [CustomEditor(typeof(CurvedSurfaceImage))]
    [CanEditMultipleObjects]
    public class CurvedSufraceImageEditor : GraphicEditor
    {
        SerializedProperty m_FillMethod;
        SerializedProperty m_FillOrigin;
        SerializedProperty m_FillAmount;
        SerializedProperty m_FillClockwise;
        SerializedProperty m_Type;
        SerializedProperty m_FillCenter;
        SerializedProperty m_Sprite;
        SerializedProperty m_PreserveAspect;
        SerializedProperty m_UseSpriteMesh;
        SerializedProperty m_PixelsPerUnitMultiplier;
        SerializedProperty m_Curvature;
        GUIContent m_SpriteContent;
        GUIContent m_SpriteTypeContent;
        GUIContent m_ClockwiseContent;
        AnimBool m_ShowSlicedOrTiled;
        AnimBool m_ShowSliced;
        AnimBool m_ShowTiled;
        AnimBool m_ShowFilled;
        AnimBool m_ShowType;
        AnimBool m_ShowCurved;
        bool m_bIsDriven;

        private class Styles
        {
            public static GUIContent text = EditorGUIUtility.TrTextContent("Fill Origin");
            public static GUIContent[] OriginHorizontalStyle =
            {
                EditorGUIUtility.TrTextContent("Left"),
                EditorGUIUtility.TrTextContent("Right")
            };

            public static GUIContent[] OriginVerticalStyle =
            {
                EditorGUIUtility.TrTextContent("Bottom"),
                EditorGUIUtility.TrTextContent("Top")
            };

            public static GUIContent[] Origin90Style =
            {
                EditorGUIUtility.TrTextContent("BottomLeft"),
                EditorGUIUtility.TrTextContent("TopLeft"),
                EditorGUIUtility.TrTextContent("TopRight"),
                EditorGUIUtility.TrTextContent("BottomRight")
            };

            public static GUIContent[] Origin180Style =
            {
                EditorGUIUtility.TrTextContent("Bottom"),
                EditorGUIUtility.TrTextContent("Left"),
                EditorGUIUtility.TrTextContent("Top"),
                EditorGUIUtility.TrTextContent("Right")
            };

            public static GUIContent[] Origin360Style =
            {
                EditorGUIUtility.TrTextContent("Bottom"),
                EditorGUIUtility.TrTextContent("Right"),
                EditorGUIUtility.TrTextContent("Top"),
                EditorGUIUtility.TrTextContent("Left")
            };
        }

        protected override void OnEnable()
        {
            base.OnEnable();

            m_SpriteContent = EditorGUIUtility.TrTextContent("Source Image");
            m_SpriteTypeContent = EditorGUIUtility.TrTextContent("Image Type");
            m_ClockwiseContent = EditorGUIUtility.TrTextContent("Clockwise");

            m_Sprite = serializedObject.FindProperty("m_Sprite");
            m_Type = serializedObject.FindProperty("_Type");
            m_FillCenter = serializedObject.FindProperty("m_FillCenter");
            m_FillMethod = serializedObject.FindProperty("m_FillMethod");
            m_FillOrigin = serializedObject.FindProperty("m_FillOrigin");
            m_FillClockwise = serializedObject.FindProperty("m_FillClockwise");
            m_FillAmount = serializedObject.FindProperty("m_FillAmount");
            m_PreserveAspect = serializedObject.FindProperty("m_PreserveAspect");
            m_UseSpriteMesh = serializedObject.FindProperty("m_UseSpriteMesh");
            m_PixelsPerUnitMultiplier = serializedObject.FindProperty("m_PixelsPerUnitMultiplier");
            m_Curvature = serializedObject.FindProperty("m_Curvature");

            m_ShowType = new AnimBool(m_Sprite.objectReferenceValue != null);
            m_ShowType.valueChanged.AddListener(Repaint);

            var typeEnum = (CurvedSurfaceImage.Type)m_Type.enumValueIndex;

            m_ShowSlicedOrTiled = new AnimBool(!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Sliced);
            m_ShowSliced = new AnimBool(!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Sliced);
            m_ShowTiled = new AnimBool(!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Tiled);
            m_ShowFilled = new AnimBool(!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Filled);
            m_ShowCurved = new AnimBool(!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Curved);
            m_ShowSlicedOrTiled.valueChanged.AddListener(Repaint);
            m_ShowSliced.valueChanged.AddListener(Repaint);
            m_ShowTiled.valueChanged.AddListener(Repaint);
            m_ShowFilled.valueChanged.AddListener(Repaint);

            SetShowNativeSize(true);

            m_bIsDriven = false;
        }

        protected override void OnDisable()
        {
            base.OnDisable();

            m_ShowType.valueChanged.RemoveListener(Repaint);
            m_ShowSlicedOrTiled.valueChanged.RemoveListener(Repaint);
            m_ShowSliced.valueChanged.RemoveListener(Repaint);
            m_ShowTiled.valueChanged.RemoveListener(Repaint);
            m_ShowFilled.valueChanged.RemoveListener(Repaint);
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            CurvedSurfaceImage image = target as CurvedSurfaceImage;
            RectTransform rect = image.GetComponent<RectTransform>();
            m_bIsDriven = (rect.drivenByObject as Slider)?.fillRect == rect;

            SpriteGUI();
            AppearanceControlsGUI();
            RaycastControlsGUI();
            MaskableControlsGUI();

            m_ShowType.target = m_Sprite.objectReferenceValue != null;
            if (EditorGUILayout.BeginFadeGroup(m_ShowType.faded))
                TypeGUI();
            EditorGUILayout.EndFadeGroup();

            SetShowNativeSize(false);
            if (EditorGUILayout.BeginFadeGroup(m_ShowNativeSize.faded))
            {
                EditorGUI.indentLevel++;

                CurvedSurfaceImage.Type type = (CurvedSurfaceImage.Type)m_Type.enumValueIndex;
                if (type == CurvedSurfaceImage.Type.Simple)
                    EditorGUILayout.PropertyField(m_UseSpriteMesh);
                if (type == CurvedSurfaceImage.Type.Simple || type == CurvedSurfaceImage.Type.Filled)
                    EditorGUILayout.PropertyField(m_PreserveAspect);
                EditorGUI.indentLevel--;
            }
            EditorGUILayout.EndFadeGroup();
            NativeSizeButtonGUI();

            serializedObject.ApplyModifiedProperties();
        }

        void SetShowNativeSize(bool instant)
        {
            CurvedSurfaceImage.Type type = (CurvedSurfaceImage.Type)m_Type.enumValueIndex;
            bool showNativeSize = (type == CurvedSurfaceImage.Type.Simple || type == CurvedSurfaceImage.Type.Filled || type == CurvedSurfaceImage.Type.Curved) && m_Sprite.objectReferenceValue != null;
            base.SetShowNativeSize(showNativeSize, instant);
        }

        protected void SpriteGUI()
        {
            EditorGUI.BeginChangeCheck();
            EditorGUILayout.PropertyField(m_Sprite, m_SpriteContent);
            if (EditorGUI.EndChangeCheck())
            {
                var newSprite = m_Sprite.objectReferenceValue as Sprite;
                if (newSprite)
                {
                    CurvedSurfaceImage.Type oldType = (CurvedSurfaceImage.Type)m_Type.enumValueIndex;
                    if (newSprite.border.SqrMagnitude() > 0)
                    {
                        m_Type.enumValueIndex = (int)CurvedSurfaceImage.Type.Sliced;
                    }
                    else if (oldType == CurvedSurfaceImage.Type.Sliced)
                    {
                        m_Type.enumValueIndex = (int)CurvedSurfaceImage.Type.Simple;
                    }
                }
                (serializedObject.targetObject as CurvedSurfaceImage).DisableSpriteOptimizations();
            }
        }

        protected void TypeGUI()
        {
            EditorGUILayout.PropertyField(m_Type, m_SpriteTypeContent);

            ++EditorGUI.indentLevel;
            {
                CurvedSurfaceImage.Type typeEnum = (CurvedSurfaceImage.Type)m_Type.enumValueIndex;

                bool showSlicedOrTiled = (!m_Type.hasMultipleDifferentValues && (typeEnum == CurvedSurfaceImage.Type.Sliced || typeEnum == CurvedSurfaceImage.Type.Tiled));
                if (showSlicedOrTiled && targets.Length > 1)
                    showSlicedOrTiled = targets.Select(obj => obj as CurvedSurfaceImage).All(img => img.hasBorder);

                m_ShowSlicedOrTiled.target = showSlicedOrTiled;
                m_ShowSliced.target = (showSlicedOrTiled && !m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Sliced);
                m_ShowTiled.target = (showSlicedOrTiled && !m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Tiled);
                m_ShowFilled.target = (!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Filled);
                m_ShowCurved.target = (!m_Type.hasMultipleDifferentValues && typeEnum == CurvedSurfaceImage.Type.Curved);

                CurvedSurfaceImage image = target as CurvedSurfaceImage;
                if (EditorGUILayout.BeginFadeGroup(m_ShowSlicedOrTiled.faded))
                {
                    if (image.hasBorder)
                        EditorGUILayout.PropertyField(m_FillCenter);
                    EditorGUILayout.PropertyField(m_PixelsPerUnitMultiplier);
                }
                EditorGUILayout.EndFadeGroup();

                if (EditorGUILayout.BeginFadeGroup(m_ShowSliced.faded))
                {
                    if (image.sprite != null && !image.hasBorder)
                        EditorGUILayout.HelpBox("This CurvedSurfaceImage doesn't have a border.", MessageType.Warning);
                }
                EditorGUILayout.EndFadeGroup();

                if (EditorGUILayout.BeginFadeGroup(m_ShowTiled.faded))
                {
                    if (image.sprite != null && !image.hasBorder && (image.sprite.texture.wrapMode != TextureWrapMode.Repeat || image.sprite.packed))
                        EditorGUILayout.HelpBox("It looks like you want to tile a sprite with no border. It would be more efficient to modify the Sprite properties, clear the Packing tag and set the Wrap mode to Repeat.", MessageType.Warning);
                }
                EditorGUILayout.EndFadeGroup();

                if (EditorGUILayout.BeginFadeGroup(m_ShowFilled.faded))
                {
                    EditorGUI.BeginChangeCheck();
                    EditorGUILayout.PropertyField(m_FillMethod);
                    if (EditorGUI.EndChangeCheck())
                    {
                        m_FillOrigin.intValue = 0;
                    }
                    var shapeRect = EditorGUILayout.GetControlRect(true);
                    switch ((CurvedSurfaceImage.FillMethod)m_FillMethod.enumValueIndex)
                    {
                        case CurvedSurfaceImage.FillMethod.Horizontal:
                            Popup(shapeRect, m_FillOrigin, Styles.OriginHorizontalStyle, Styles.text);
                            break;
                        case CurvedSurfaceImage.FillMethod.Vertical:
                            Popup(shapeRect, m_FillOrigin, Styles.OriginVerticalStyle, Styles.text);
                            break;
                        case CurvedSurfaceImage.FillMethod.Radial90:
                            Popup(shapeRect, m_FillOrigin, Styles.Origin90Style, Styles.text);
                            break;
                        case CurvedSurfaceImage.FillMethod.Radial180:
                            Popup(shapeRect, m_FillOrigin, Styles.Origin180Style, Styles.text);
                            break;
                        case CurvedSurfaceImage.FillMethod.Radial360:
                            Popup(shapeRect, m_FillOrigin, Styles.Origin360Style, Styles.text);
                            break;
                    }

                    if (m_bIsDriven)
                        EditorGUILayout.HelpBox("The Fill amount property is driven by Slider.", MessageType.None);
                    using (new EditorGUI.DisabledScope(m_bIsDriven))
                    {
                        EditorGUILayout.PropertyField(m_FillAmount);
                    }

                    if ((CurvedSurfaceImage.FillMethod)m_FillMethod.enumValueIndex > CurvedSurfaceImage.FillMethod.Vertical)
                    {
                        EditorGUILayout.PropertyField(m_FillClockwise, m_ClockwiseContent);
                    }
                }
                EditorGUILayout.EndFadeGroup();

                if (EditorGUILayout.BeginFadeGroup(m_ShowCurved.faded))
                {
                    EditorGUILayout.Slider(m_Curvature, -100, 100, new GUIContent("Curvature"));
                }
                EditorGUILayout.EndFadeGroup();
            }
            --EditorGUI.indentLevel;
        }
        void Popup(Rect position, SerializedProperty property, GUIContent[] displayedOptions, GUIContent label)
        {
            label = EditorGUI.BeginProperty(position, label, property);
            EditorGUI.BeginChangeCheck();
            int intValue = EditorGUI.Popup(position, label, property.hasMultipleDifferentValues ? (-1) : property.intValue, displayedOptions);
            if (EditorGUI.EndChangeCheck())
            {
                property.intValue = intValue;
            }

            EditorGUI.EndProperty();
        }

        public override bool HasPreviewGUI() { return true; }

        public override void OnPreviewGUI(Rect rect, GUIStyle background)
        {
            CurvedSurfaceImage image = target as CurvedSurfaceImage;
            if (image == null) return;

            Sprite sf = image.sprite;
            if (sf == null) return;

            SpriteDrawUtility.DrawSprite(sf, rect, image.canvasRenderer.GetColor());
        }
        class SpriteDrawUtility
        {
            static Texture2D s_ContrastTex;

            static Texture2D contrastTexture
            {
                get
                {
                    if (s_ContrastTex == null)
                        s_ContrastTex = CreateCheckerTex(
                            new Color(0f, 0.0f, 0f, 0.5f),
                            new Color(1f, 1f, 1f, 0.5f));
                    return s_ContrastTex;
                }
            }

            static Texture2D CreateCheckerTex(Color c0, Color c1)
            {
                Texture2D tex = new Texture2D(16, 16);
                tex.name = "[Generated] Checker Texture";
                tex.hideFlags = HideFlags.DontSave;

                for (int y = 0; y < 8; ++y) for (int x = 0; x < 8; ++x) tex.SetPixel(x, y, c1);
                for (int y = 8; y < 16; ++y) for (int x = 0; x < 8; ++x) tex.SetPixel(x, y, c0);
                for (int y = 0; y < 8; ++y) for (int x = 8; x < 16; ++x) tex.SetPixel(x, y, c0);
                for (int y = 8; y < 16; ++y) for (int x = 8; x < 16; ++x) tex.SetPixel(x, y, c1);

                tex.Apply();
                tex.filterMode = FilterMode.Point;
                return tex;
            }

            static Texture2D CreateGradientTex()
            {
                Texture2D tex = new Texture2D(1, 16);
                tex.name = "[Generated] Gradient Texture";
                tex.hideFlags = HideFlags.DontSave;

                Color c0 = new Color(1f, 1f, 1f, 0f);
                Color c1 = new Color(1f, 1f, 1f, 0.4f);

                for (int i = 0; i < 16; ++i)
                {
                    float f = Mathf.Abs((i / 15f) * 2f - 1f);
                    f *= f;
                    tex.SetPixel(0, i, Color.Lerp(c0, c1, f));
                }

                tex.Apply();
                tex.filterMode = FilterMode.Bilinear;
                return tex;
            }

            static void DrawTiledTexture(Rect rect, Texture tex)
            {
                float u = rect.width / tex.width;
                float v = rect.height / tex.height;

                Rect texCoords = new Rect(0, 0, u, v);
                TextureWrapMode originalMode = tex.wrapMode;
                tex.wrapMode = TextureWrapMode.Repeat;
                GUI.DrawTextureWithTexCoords(rect, tex, texCoords);
                tex.wrapMode = originalMode;
            }

            public static void DrawSprite(Sprite sprite, Rect drawArea, Color color)
            {
                if (sprite == null)
                    return;

                Texture2D tex = sprite.texture;
                if (tex == null)
                    return;

                Rect outer = sprite.rect;
                Rect inner = outer;
                inner.xMin += sprite.border.x;
                inner.yMin += sprite.border.y;
                inner.xMax -= sprite.border.z;
                inner.yMax -= sprite.border.w;

                Vector4 uv4 = UnityEngine.Sprites.DataUtility.GetOuterUV(sprite);
                Rect uv = new Rect(uv4.x, uv4.y, uv4.z - uv4.x, uv4.w - uv4.y);
                Vector4 padding = UnityEngine.Sprites.DataUtility.GetPadding(sprite);
                padding.x /= outer.width;
                padding.y /= outer.height;
                padding.z /= outer.width;
                padding.w /= outer.height;

                DrawSprite(tex, drawArea, padding, outer, inner, uv, color, null);
            }

            public static void DrawSprite(Texture tex, Rect drawArea, Rect outer, Rect uv, Color color)
            {
                DrawSprite(tex, drawArea, Vector4.zero, outer, outer, uv, color, null);
            }

            private static void DrawSprite(Texture tex, Rect drawArea, Vector4 padding, Rect outer, Rect inner, Rect uv, Color color, Material mat)
            {
                Rect outerRect = drawArea;
                outerRect.width = Mathf.Abs(outer.width);
                outerRect.height = Mathf.Abs(outer.height);

                if (outerRect.width > 0f)
                {
                    float f = drawArea.width / outerRect.width;
                    outerRect.width *= f;
                    outerRect.height *= f;
                }

                if (drawArea.height > outerRect.height)
                {
                    outerRect.y += (drawArea.height - outerRect.height) * 0.5f;
                }
                else if (outerRect.height > drawArea.height)
                {
                    float f = drawArea.height / outerRect.height;
                    outerRect.width *= f;
                    outerRect.height *= f;
                }

                if (drawArea.width > outerRect.width)
                    outerRect.x += (drawArea.width - outerRect.width) * 0.5f;

                EditorGUI.DrawTextureTransparent(outerRect, null, ScaleMode.ScaleToFit, outer.width / outer.height);

                GUI.color = color;

                Rect paddedTexArea = new Rect(
                    outerRect.x + outerRect.width * padding.x,
                    outerRect.y + outerRect.height * padding.w,
                    outerRect.width - (outerRect.width * (padding.z + padding.x)),
                    outerRect.height - (outerRect.height * (padding.w + padding.y))
                );

                if (mat == null)
                {
                    GUI.DrawTextureWithTexCoords(paddedTexArea, tex, uv, true);
                }
                else
                {
                    EditorGUI.DrawPreviewTexture(paddedTexArea, tex, mat);
                }

                GUI.BeginGroup(outerRect);
                {
                    tex = contrastTexture;
                    GUI.color = Color.white;

                    if (inner.xMin != outer.xMin)
                    {
                        float x = (inner.xMin - outer.xMin) / outer.width * outerRect.width - 1;
                        DrawTiledTexture(new Rect(x, 0f, 1f, outerRect.height), tex);
                    }

                    if (inner.xMax != outer.xMax)
                    {
                        float x = (inner.xMax - outer.xMin) / outer.width * outerRect.width - 1;
                        DrawTiledTexture(new Rect(x, 0f, 1f, outerRect.height), tex);
                    }

                    if (inner.yMin != outer.yMin)
                    {
                        float y = (inner.yMin - outer.yMin) / outer.height * outerRect.height - 1;
                        DrawTiledTexture(new Rect(0f, outerRect.height - y, outerRect.width, 1f), tex);
                    }

                    if (inner.yMax != outer.yMax)
                    {
                        float y = (inner.yMax - outer.yMin) / outer.height * outerRect.height - 1;
                        DrawTiledTexture(new Rect(0f, outerRect.height - y, outerRect.width, 1f), tex);
                    }
                }

                GUI.EndGroup();
            }
        }

        public override string GetInfoString()
        {
            CurvedSurfaceImage image = target as CurvedSurfaceImage;
            Sprite sprite = image.sprite;

            int x = (sprite != null) ? Mathf.RoundToInt(sprite.rect.width) : 0;
            int y = (sprite != null) ? Mathf.RoundToInt(sprite.rect.height) : 0;

            return string.Format("Image Size: {0}x{1}", x, y);
        }
    }
}
