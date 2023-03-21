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
            //tags { "LightMode" = "Vertex" }// 使用函数ShadeVertexLights()时，需要此项设置
            tags { "LightMode" = "ForwardBase" }//光源参数以不同的方式传递给着色器，具体取决于使用哪个渲染路径， 以及着色器中使用哪种光源模式通道标签。
            //https://docs.unity.cn/cn/2019.4/Manual/SL-UnityShaderVariables.html
            //_LightColor0是前向渲染（ForwardBase 和 ForwardAdd 通道类型）

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
                模型的法向量和光向量不会发生变化，所以如果在场景中旋转模型，
                光照会异常：光照的亮度会跟着模型运动，o.pos是经过MVP变换后
                的顶点信息，v.normal和_WorldSpaceLightPos0没有经过变换,有
                两种解决方案：
                *1.将模型的法向量转换到世界坐标中；
                *2.将光向量转换到模型坐标中；
                ******************************************************/
                //n = mul(unity_ObjectToWorld, n);//*1 当非等比缩放时无法得到正确的光照
                //l = mul(unity_WorldToObject, l);//*2
                /******************************************************
                unity_ObjectToWorld与unity_WorldToObject互为逆矩阵
                在非等比缩放中，法向量模型到世界空间的转换得不到正确的变换，
                解决方法：
                使用unity_ObjectToWorld的逆矩阵的转置变换法向量
                ******************************************************/
                n = mul(n, unity_WorldToObject);
                n = normalize(n);

                float d = saturate(dot(n, l)) ;
                
                //光源颜色，在"Lighting.cginc"中定义
                o.col = _LightColor0 * d;

                // Used in Vertex pass: Calculates diffuse lighting from lightCount lights. Specifying true to spotLight is more expensive
                // to calculate but lights are treated as spot lights otherwise they are treated as point lights.
                //o.col.rgb = ShadeVertexLights(v.vertex, v.normal);//Vertex，UnityCG.cginc中光照的辅助函数，SH，效率高但效果一半的光照模拟
                float4 wpos = mul(unity_ObjectToWorld, v.vertex);
                // Used in ForwardBase pass: Calculates diffuse lighting from 4 point lights, with data packed in a special way.//课时45
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
                return i.col + UNITY_LIGHTMODEL_AMBIENT;//环境光，一个典型的漫反射光照还包含环境光，漫反射+环境光

            }
            ENDCG
        }
    }
}