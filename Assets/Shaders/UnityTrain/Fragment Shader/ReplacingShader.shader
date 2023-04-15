Shader "UnityTrain/Fragment/ReplacingShader" {
    SubShader {
        Tags { "RenderType" = "ReplacementShader" }
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 vert(appdata_base v) : SV_POSITION {
                return UnityObjectToClipPos(v.vertex);
            }

            fixed4 frag() : SV_Target {

                return fixed4(1, 1, 0, 1);
            }
            ENDCG
        }
    }
}