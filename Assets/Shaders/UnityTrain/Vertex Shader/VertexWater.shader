Shader "UnityTrain/Vertex/VertexWater" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _Speed ("Speed", float) = 1
        _WaveLength ("WaveLength", float) = 1
        _WaveHeight ("Height", float) = 1
        _X ("X", float) = 1
        _Y ("Y", float) = 1
    }
    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Speed;
            float _WaveLength;
            float _WaveHeight;
            float _X;
            float _Y;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex + float4(0, _WaveHeight * sin(_Time.y * _WaveLength + v.vertex.x * _X), 0, 0));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                //o.uv.x += _Time.y * _Speed;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}