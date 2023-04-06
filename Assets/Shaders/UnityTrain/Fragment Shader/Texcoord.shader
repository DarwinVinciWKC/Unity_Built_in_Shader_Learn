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
                o.uv = v.texcoord;//appdata中的texcoord是Mesh中存储的uv信息，固定的，所以我们无法使用Tiling和Offset功能
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                //tex2D()是CG程序中用于采样纹理中的某一点并返回一个float4值的函数。它在给定的2D采样器中执行纹理查找，并在某些情况下执行阴影比较。如果提供了预计算的导数，该函数还可以使用它们。
                fixed4 col = tex2D(_MainTex, float2(i.uv));//tex2D()：对二维纹理进行采样，获得对应UV点的颜色信息
                //fixed4 col = tex2D(_MainTex, float2(_U, _V));
                return col;
            }

            ENDCG
        }
    }
}