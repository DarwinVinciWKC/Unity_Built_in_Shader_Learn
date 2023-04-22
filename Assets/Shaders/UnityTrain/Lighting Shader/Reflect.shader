// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "UnityTrain/Lighting/Reflect" {
    Properties {
        _SpecularColor ("SpecularColor", Color) = (1, 1, 1, 1)
        _Shininess ("_Shininess", Range(1, 64)) = 1
    }
    SubShader {
        Tags { "LightModel" = "ForwardBase" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            float4 _SpecularColor;
            float _Shininess;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            v2f vert(a2v v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 n = normalize(mul(v.normal, unity_WorldToObject));
                float3 l = normalize(_WorldSpaceLightPos0);
                float d = saturate(dot(n, l));

                float3 L = -WorldSpaceLightDir(v.vertex);
                float3 R = reflect(L, n);
                float3 V = WorldSpaceViewDir(v.vertex);
                float s = pow(saturate(mul(normalize(V), normalize(R))), _Shininess);
                float4 c = _SpecularColor * s;
                
                o.color = _LightColor0 * d + c;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.color;
            }
            ENDCG
        }
    }
}