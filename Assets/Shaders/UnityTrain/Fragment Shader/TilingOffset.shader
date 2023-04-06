Shader "UnityTrain/Fragment/TilingOffset" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
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
            float4 _MainTex_ST;//����һ���������Ƽ�_ST�ı�����Unity���Զ�Ϊ�临�ƣ���xy��������Tiling��zw��������Offset

            //float tiling_x;
            //float tiling_y;
            //float offset_x;
            //float offset_y;

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                //o.uv.x *= tiling_x;//ʹ�ó������Tiling��Offset
                //o.uv.y *= tiling_y;
                //o.uv.x += offset_x;
                //o.uv.y += offset_y;

                //o.uv *= _MainTex_ST.xy;//ʹ�ò��ʱ������Ƽ�_ST��������Tiling��Offset
                //o.uv += _MainTex_ST.zw;

                // Transforms 2D UV by scale/bias property #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)     Unity��UV�Ĵ����
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);//ʹ��Unity�еĺ����Tiling��Offset

                return o;
            }

            fixed4 frag(v2f i) : COLOR {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }
}