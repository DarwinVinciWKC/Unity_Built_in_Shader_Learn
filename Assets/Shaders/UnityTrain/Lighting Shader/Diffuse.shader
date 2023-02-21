// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UnityTrain/Lighting/Diffuse" {
    SubShader {
        Pass {
            tags { "LightModel" = "ForwardBase" }//?

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2f {
                float4 pos : POSITION;
                fixed4 col : COLOR;
            };

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 n = normalize(v.normal);
                float3 l = normalize(_WorldSpaceLightPos0);
                /******************************************************
                ģ�͵ķ������͹��������ᷢ���仯����������ڳ�������תģ�ͣ�
                ���ջ��쳣�����յ����Ȼ����ģ���˶���o.pos�Ǿ���MVP�任��
                �Ķ�����Ϣ��v.normal��_WorldSpaceLightPos0û�о����任,��
                ���ֽ��������
                *1.��ģ�͵ķ�����ת�������������У�
                *2.��������ת����ģ�������У�
                ******************************************************/
                n = mul(unity_ObjectToWorld, n);//*1
                //l = mul(unity_WorldToObject, l);//*2
                 /******************************************************
                 unity_ObjectToWorld��unity_WorldToObject��Ϊ�����
                 �ڷǵȱ������У�������ģ�͵�����ռ��ת���ò�����ȷ�ı任��
                 ���������
                 ʹ��unity_ObjectToWorld��������ת�ñ任������
                ******************************************************/

                float d = saturate(dot(n, l)) ;
                
                o.col = _LightColor0 * d;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.col + UNITY_LIGHTMODEL_AMBIENT;
            }
            ENDCG
        }
    }
}