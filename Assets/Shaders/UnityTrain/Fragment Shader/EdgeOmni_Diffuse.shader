// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UnityTrain/Fragment/EdgeOmni_Diffuse" {
    Properties {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _Scale ("Scale", Range(1, 10)) = 1
        _Outer ("Outer", float) = 0.2
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader {
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back

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
                //��ʹ��UnityObjectToWorldNormal����
                float3 N = normalize(mul(i.normal, unity_WorldToObject));
                //��ʹ��WorldSpaceViewDir����
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
            //tags { "LightMode" = "Vertex" }// ʹ�ú���ShadeVertexLights()ʱ����Ҫ��������
            tags { "LightMode" = "ForwardBase" }//��Դ�����Բ�ͬ�ķ�ʽ���ݸ���ɫ��������ȡ����ʹ���ĸ���Ⱦ·���� �Լ���ɫ����ʹ�����ֹ�Դģʽͨ����ǩ��
            //https://docs.unity.cn/cn/2019.4/Manual/SL-UnityShaderVariables.html
            //_LightColor0��ǰ����Ⱦ��ForwardBase �� ForwardAdd ͨ�����ͣ�

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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };

            v2f vert(appdata v) {
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
                //n = mul(unity_ObjectToWorld, n);//*1 ���ǵȱ�����ʱ�޷��õ���ȷ�Ĺ���
                //l = mul(unity_WorldToObject, l);//*2
                /******************************************************
                unity_ObjectToWorld��unity_WorldToObject��Ϊ�����
                �ڷǵȱ������У�������ģ�͵�����ռ��ת���ò�����ȷ�ı任��
                ���������
                ʹ��unity_ObjectToWorld��������ת�ñ任������
                ******************************************************/
                n = mul(n, unity_WorldToObject);
                n = normalize(n);

                float d = saturate(dot(n, l)) ;
                
                //��Դ��ɫ����"Lighting.cginc"�ж���
                o.col = _LightColor0 * d;

                // Used in Vertex pass: Calculates diffuse lighting from lightCount lights. Specifying true to spotLight is more expensive
                // to calculate but lights are treated as spot lights otherwise they are treated as point lights.
                //o.col.rgb = ShadeVertexLights(v.vertex, v.normal);//Vertex��UnityCG.cginc�й��յĸ���������SH��Ч�ʸߵ�Ч��һ��Ĺ���ģ��
                float4 wpos = mul(unity_ObjectToWorld, v.vertex);
                // Used in ForwardBase pass: Calculates diffuse lighting from 4 point lights, with data packed in a special way.//��ʱ45
                o.col.rgb += Shade4PointLights
                (
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                    unity_4LightAtten0,
                    wpos, n
                );

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                i.col *= col;
                return i.col + UNITY_LIGHTMODEL_AMBIENT;//�����⣬һ�����͵���������ջ����������⣬������+������

            }
            ENDCG
        }
    }
}