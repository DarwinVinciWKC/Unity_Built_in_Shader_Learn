Shader "UnityTrain/Fragment/Texcoord" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _U ("U", float) = 0
        _V ("V", float) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _U;
            float _V;

            struct v2f {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;//appdata�е�texcoord��Mesh�д洢��uv��Ϣ���̶��ģ����������޷�ʹ��Tiling��Offset����
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                //tex2D()��CG���������ڲ��������е�ĳһ�㲢����һ��float4ֵ�ĺ��������ڸ�����2D��������ִ��������ң�����ĳЩ�����ִ����Ӱ�Ƚϡ�����ṩ��Ԥ����ĵ������ú���������ʹ�����ǡ�
                fixed4 col = tex2D(_MainTex, float2(i.uv));//tex2D()���Զ�ά������в�������ö�ӦUV�����ɫ��Ϣ
                //fixed4 col = tex2D(_MainTex, float2(_U, _V));
                return col;
            }

            ENDCG
        }
    }
}