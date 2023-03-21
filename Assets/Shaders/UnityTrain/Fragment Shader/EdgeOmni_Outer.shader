// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityTrain/Fragment/EdgeOmni_Outer" {
    Properties {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _Scale ("Scale", float) = 1
        _Outer ("Outer", float) = 0.2
        _MainTex ("Texture", 2D) = "white" { }
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

            float4 _MainColor;
            float _Scale;
            float _Outer;

            struct v2f {
                float4 pos : POSITION;
                fixed4 col : COLOR;
                float4 vertex : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            v2f vert(appdata_base v) {
                v.vertex.xyz += v.normal * _Outer;
                //v.vertex *= _Outer;
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

                float b = saturate(dot(N, V));

                float pb = pow(b, _Scale);

                _MainColor.a *= pb;
                return _MainColor;
            }
            ENDCG
        }

        Pass {
            Blend Zero Zero
        }
        Pass {
            tags { "LightMode" = "Vertex" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
            struct v2f {
                float4 pos : POSITION;
                fixed4 col : COLOR;
                float3 normal : NORMAL;
                float4 vertex : TEXCOORD0;
                float2 uv : TEXCOORD1;
                UNITY_FOG_COORDS(1)
            };

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.vertex = v.vertex;
                o.normal = v.normal;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
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
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                i.col *= col;
                return i.col + UNITY_LIGHTMODEL_AMBIENT;
            }
            ENDCG
        }
    }
}