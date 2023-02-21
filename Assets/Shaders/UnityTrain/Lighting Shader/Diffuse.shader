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
                模型的法向量和光向量不会发生变化，所以如果在场景中旋转模型，
                光照会异常：光照的亮度会跟着模型运动，o.pos是经过MVP变换后
                的顶点信息，v.normal和_WorldSpaceLightPos0没有经过变换,有
                两种解决方案：
                *1.将模型的法向量转换到世界坐标中；
                *2.将光向量转换到模型坐标中；
                ******************************************************/
                n = mul(unity_ObjectToWorld, n);//*1
                //l = mul(unity_WorldToObject, l);//*2
                 /******************************************************
                 unity_ObjectToWorld与unity_WorldToObject互为逆矩阵
                 在非等比缩放中，法向量模型到世界空间的转换得不到正确的变换，
                 解决方法：
                 使用unity_ObjectToWorld的逆矩阵的转置变换法向量
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