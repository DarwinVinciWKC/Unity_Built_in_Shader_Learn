// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UnityTrain/Fragment/UVOffset" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _Intensity ("Intensity", float) = 10
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
                float z : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Intensity;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                o.z = mul(unity_ObjectToWorld, v.vertex).z;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float dx = ddx(i.uv.x) * _Intensity;//ʹ��UV�ĵ������仯�ʣ���UV��������ƫ��
                float dy = ddx(i.uv.y) * _Intensity;
                float2 dxdx = float2(dx, dx);
                float2 dydy = float2(dy, dy);
                //float dx = ddx(i.z) * _Intensity;//ʹ��zֵ�ı仯�ʽ��в������������һ��ƽ�涼�����������ʱ���������zֵ��һ�£����û�б仯
                //float dxdx = float2(dx, dx);
                fixed4 col = tex2D(_MainTex, i.uv, dxdx, dxdx);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}