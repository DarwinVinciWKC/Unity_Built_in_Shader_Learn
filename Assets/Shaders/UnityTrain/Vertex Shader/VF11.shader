Shader "UnityTrain/Vertex/VF11" {
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : POSITION;
                fixed4 color : COLOR;
            };

            v2f vert(appdata_base v) {
                //��г�˶���https://tartan-calculator-347.notion.site/c5a3821493eb4002831f18d9b603d338
                //����һ��ˮ�������Ҫ4�����Ҳ�
                //v.vertex.y += sin(_Time.y + _Time.y);
                //v.vertex.y += 0.2 * sin(v.vertex.x + _Time.z);
                //v.vertex.y += 0.5 * sin(-length(v.vertex.xz) + _Time.z);
                v.vertex.y += 0.2 * sin((v.vertex.x + v.vertex.z) + _Time.z);
                v.vertex.y += 0.3 * sin((v.vertex.x - v.vertex.z) + _Time.z);

                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = fixed4(v.vertex.y, v.vertex.y, v.vertex.y, 1);
                //o.color = fixed4(_SinTime.x * o.pos.x, _CosTime.y * o.pos.y, _SinTime.z * o.pos.z, 1);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return i.color;
            }
            ENDCG
        }
    }
}