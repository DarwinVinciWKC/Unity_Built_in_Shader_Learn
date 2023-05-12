Shader "Unlit/Blend" {
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float4 col : COLOR;
            };


            v2f vert(appdata v) {
                v2f o;
                float4 col;
                if (v.vertex.x > 0) {
                    o.col = float4(1, 0, 0, 0);
                } else {
                    o.col = float4(0, 0, 0, 0);
                }
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.col;
            }
            ENDCG
        }
        Pass {
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float4 col : COLOR;
            };


            v2f vert(appdata v) {
                v2f o;
                float4 col;
                if (v.vertex.x < 0) {
                    o.col = float4(0, 1, 0, 0);
                } else {
                    o.col = float4(0, 0, 0, 0);
                }
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.col;
            }
            ENDCG
        }
    }
}