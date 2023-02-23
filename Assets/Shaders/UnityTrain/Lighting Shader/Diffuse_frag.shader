// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UnityTrain/Lighting/Diffuse_frag" {
    SubShader {
        Pass {
            tags { "LightMode" = "Vertex" }//?

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2f {
                float4 pos : POSITION;
                fixed4 col : COLOR;
                float3 normal : NORMAL;
                float4 vertex : TEXCOORD0;
            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.vertex = v.vertex;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 n = normalize(i.normal);
                float3 l = normalize(_WorldSpaceLightPos0);
                n = mul(n, unity_WorldToObject);
                n = normalize(n);
                float d = saturate(dot(n, l)) ;
                i.col = _LightColor0 * d;
                i.col.rgb = ShadeVertexLights(i.vertex, i.normal);
                return i.col + UNITY_LIGHTMODEL_AMBIENT;
            }
            ENDCG
        }
    }
}