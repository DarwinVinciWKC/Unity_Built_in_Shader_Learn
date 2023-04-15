Shader "UnityTrain/Fragment/ReplacedShader" {
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

                return fixed4(0, 1, 1, 1);
            }
            ENDCG
        }
    }
}