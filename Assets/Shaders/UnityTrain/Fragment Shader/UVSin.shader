Shader "UnityTrain/Fragment/UVSin" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _A ("A", float) = 1
        _O ("O", float) = 1
        _F ("F", float) = 1
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

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : COLOR {
                //i.uv += _A * sin(i.uv * acos(-1) * _O + _F * _Time.y);
                //i.uv.x+= _A * sin(i.uv.x * acos(-1) * _O + _F * _Time.y);
                //i.uv.x += _A * sin(_Time.y);
                i.uv.x += _A * sin(i.uv.x + _Time.y);
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }
}