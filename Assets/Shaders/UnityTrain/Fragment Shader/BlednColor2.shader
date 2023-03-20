Shader "UnityTrain/Fragment/BlendColor2" {
    Properties {
        _MainColor ("MainColor", Color) = (0, 0, 1, 1)
        _SecondColor ("SecondColor", Color) = (1, 0, 0, 1)
    }
    SubShader {
        Pass {
            Blend One One
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float4 _MainColor;
            float4 _SecondColor;

            struct v2f {
                float4 pos : POSITION;
            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return _MainColor * _SecondColor;
            }
            ENDCG
        }
    }
}