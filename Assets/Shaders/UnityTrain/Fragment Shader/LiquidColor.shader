Shader "UnityTrain/Fragment/LiquidColor" {
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata_base v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 col = 0.5 + 0.5 * cos(_Time.y + i.uv.xyx + float3(0, 2, 4));
                return float4(col, 1);
            }
            ENDCG
        }
    }
}