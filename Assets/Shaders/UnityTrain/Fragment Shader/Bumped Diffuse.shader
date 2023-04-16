Shader "UnityTrain/Fragment/Bumped Diffuse" {
    Properties {
        _Color ("Main Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _BumpMap ("Normalmap", 2D) = "bump" { }
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _BumpMap;
        fixed4 _Color;

        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            //o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));//ԭʼ 
            //��UnityCG.cginc�����UnpackNormal���㷨���������㷨����ͬ���·�ʹ����UnpackNormal���㷨�����������ֱ���UnpackNormalDXT5nm��UnpackNormalmapRGorAG
            //��ͬ���㷨�в�ͬ��r,g,b�����Ĵ�ŷ�ʽ����ͬƽ̨����Ӧ��ʹ�����ʺϵ��㷨
            float3 bumpCol = tex2D(_BumpMap, IN.uv_BumpMap);
            o.Normal = bumpCol.xyz * 2 - 1;
        }
        ENDCG
    }

    FallBack "Legacy Shaders/Diffuse"
}