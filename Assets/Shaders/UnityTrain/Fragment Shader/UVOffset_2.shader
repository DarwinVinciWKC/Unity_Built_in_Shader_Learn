Shader "UnityTrain/Fragment/UVOffset_2" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _A ("A", float) = 1
        _O ("O", float) = 1
        _F ("F", float) = 1
        _R ("R", float) = 1
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 pos : POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _A;
            float _O;
            float _F;
            float _R;

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : COLOR {
                float2 uv = i.uv;
                float scale = _A * sin(uv * acos(-1) * _O + _F * _Time.y);

                uv += uv * scale;
                fixed4 col_1 = tex2D(_MainTex, uv);

                uv = i.uv;

                uv -= uv * scale;
                fixed4 col_2 = tex2D(_MainTex, uv);

                return (col_1 + col_2)/1.5;
            }

            ENDCG
        }
    }
}