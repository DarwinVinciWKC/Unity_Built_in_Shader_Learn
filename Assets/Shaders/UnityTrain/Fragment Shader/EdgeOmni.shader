// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityTrain/Fragment/EdgeOmni" {
    Properties {
        _Scale ("Scale", Range(1, 10)) = 1
    }
    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _Scale;

            struct v2f {
                float4 pos : POSITION;
                fixed4 col : COLOR;
                float4 vertex : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.col = o.pos;
                o.vertex = v.vertex;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                //可使用UnityObjectToWorldNormal函数
                float3 N = normalize(mul(i.normal, unity_WorldToObject));
                //可使用WorldSpaceViewDir函数
                float3 V = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, i.vertex));

                float b = 1 - saturate(dot(N, V));

                float pb = pow(b, _Scale);

                return fixed4(1, 1, 1, 1) * pb;
            }
            ENDCG
        }
    }
}