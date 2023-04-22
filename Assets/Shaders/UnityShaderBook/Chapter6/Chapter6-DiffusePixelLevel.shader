// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shader Book/Chapter 6/Diffuse Pixel-Level" {
    Properties {
        _Diffuse ("Diffuse", COLOR) = (1, 1, 1, 1)
    }
    SubShader {
        Tags { "LightModel" = "ForwardBase" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 vertex : POSITION;
                float3 worldNormal : TEXCOORD1;
                float3 lightDirection : TEXCOORD2;
            };

            fixed4 _Diffuse;

            v2f vert(a2v v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
                o.lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float d = saturate(dot(i.worldNormal, i.lightDirection));
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _Diffuse.xyz * _LightColor0.xyz * d;

                return fixed4(ambient + diffuse, 1);
            }
            ENDCG
        }
    }
}