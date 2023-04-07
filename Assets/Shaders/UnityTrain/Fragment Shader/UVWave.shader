Shader "UnityTrain/Fragment/UVWave" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _A ("A", float) = 1
        _O ("O", float) = 1
        _F ("F", float) = 1
        _R ("R", float) = 1
    }
    SubShader {
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
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
            float _R;

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : COLOR {
                float2 uv = i.uv;
                float dis = distance(uv, float2(0.5, 0.5));
                float scale = _A * sin(dis * acos(-1) * _O + _F * _Time.y);

                scale*= saturate(1 - dis / _R);
                uv += uv * scale;//每个点反复运动，每个点在原始位置向圆心方向的往复运动

                //fixed4 col = tex2D(_MainTex, uv) + fixed4(1, 1, 1, 1) * scale * 100;//当scale处于[-1,0]区间时，颜色值无效，出现了间隔
                fixed4 col = tex2D(_MainTex, uv) * fixed4(1, 1, 1, 1) * saturate(scale) * 120;//当scale处于[-1,0]区间时，颜色值无效，出现了间隔
                return col;
            }

            ENDCG
        }
    }
}