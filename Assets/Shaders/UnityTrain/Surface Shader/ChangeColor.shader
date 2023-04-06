Shader "UnityTrain/Surface/ChangeColor" {
    Properties {
        _FirstColor ("FirstColor", COLOR) = (1, 1, 1, 1)
        _SecondColor ("SecondColor", COLOR) = (1, 1, 1, 1)
        _SplitPosition ("SplitPosition", Range(-5, 5)) = 0
        _Radius ("Radius", Range(0, 1)) = 0.2

        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _Metallic ("Metallic", Range(0, 1)) = 0.0

        [ToggleOff] _SpecularHighlights ("Specular Highlights", Float) = 1.0
    }
    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
            float z;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float4 _FirstColor;
        float4 _SecondColor;
        float _SplitPosition;
        float _Radius;

        void vert(inout appdata_full v, out Input i) {
            i. uv_MainTex = v.texcoord;
            i.z = v.vertex.z;
        }

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o) {
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;

            float blendPos = IN.z - _SplitPosition;
            float blendScale = blendPos / _Radius;
            float blendLerpValue = blendScale / 2 + 0.5f;
            o.Albedo = lerp(_FirstColor, _SecondColor, blendLerpValue);//重点在于把两个颜色的融合插值控制在[0.5,1]之间

        }
        ENDCG
    }
    FallBack "Diffuse"
}