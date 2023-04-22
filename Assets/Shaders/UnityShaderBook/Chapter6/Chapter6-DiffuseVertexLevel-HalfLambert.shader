// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shader Book/Chapter 6/Diffuse Vertex-Level Half Lambert" {
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
                float4 color : COLOR;
            };

            fixed4 _Diffuse;

            v2f vert(a2v v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float d = dot(worldNormal, lightDirection) * 0.5 + 0.5;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _Diffuse.xyz * _LightColor0.xyz * d;

                o.color = fixed4(ambient + diffuse, 1);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.color;
            }
            ENDCG
        }
    }
}