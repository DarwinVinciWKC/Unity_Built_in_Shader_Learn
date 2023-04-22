// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shader Book/Chapter 6/Specular Vertex-Level" {
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
                float4 color : COLOR;
            };

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            v2f vert(a2v v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float d = saturate(dot(worldNormal, lightDirection));

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _Diffuse.xyz * _LightColor0.xyz * d;

                float3 reflectDir = normalize(reflect(-lightDirection, worldNormal));
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                fixed3 specular = _LightColor0.xyz * _Specular * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

                o.color = fixed4(ambient + diffuse + specular, 1);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.color;
            }
            ENDCG
        }
    }
}