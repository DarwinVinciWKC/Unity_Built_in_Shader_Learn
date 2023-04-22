// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shader Book/Chapter 6/Specular Pixel-Level" {
    Properties {
        _Diffuse ("Diffuse", COLOR) = (1, 1, 1, 1)
        _Specular ("Specular", COLOR) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8, 256)) = 8
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
                float3 worldNormal : NORMAL;
                float4 worldPos : TEXCOORD1;
            };

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            v2f vert(a2v v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float d = saturate(dot(i.worldNormal, lightDirection));

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _Diffuse.xyz * _LightColor0.xyz * d;

                float3 reflectDir = normalize(reflect(-lightDirection, i.worldNormal));
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 specular = _LightColor0.xyz * _Specular.xyz * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

                fixed4 color = fixed4(ambient + diffuse + specular, 1);
                return color;
            }
            ENDCG
        }
    }
}