Shader "UnityTrain/Fragment/ChangeColor" {
    Properties {
        _FirstColor ("FirstColor", COLOR) = (1, 1, 1, 1)
        _SecondColor ("SecondColor", COLOR) = (1, 1, 1, 1)
        _SplitPosition ("SplitPosition", Range(-0.55, 0.55)) = 0
        _Radius ("Radius", Range(0, 0.5)) = 0.2
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
                float4 pos : POSITION;
                float colY : TEXCOORD0;
                fixed4 col : COLOR;
            };

            float4 _FirstColor;
            float4 _SecondColor;
            float _SplitPosition;
            float _Radius;

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //Unity底层对颜色进行过渡融合
                //if (v.vertex.y > 0)
                //    o.col = _FirstColor;
                //else
                //    o.col = _SecondColor;
                o.colY = v.vertex.y;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {

                if (i.colY > _SplitPosition + _Radius) {
                    return _FirstColor;
                } else if (i.colY > _SplitPosition && i.colY < _SplitPosition + _Radius) {
                    float distance = i.colY - _SplitPosition;
                    float lerpValue = 1 - distance / _Radius;
                    return lerp(_FirstColor, _SecondColor, lerpValue);
                    //return _FirstColor;

                } else if (i.colY <= _SplitPosition && i.colY > _SplitPosition - _Radius) {
                    float distance = _SplitPosition - i.colY ;
                    float lerpValue = 1 - distance / _Radius;
                    return lerp(_SecondColor, _FirstColor, lerpValue);
                } else {
                    return _SecondColor;
                }

                ////比_SplitPosition大的Y值，得到1，反之得到0，经过Lerp()函数后，当值为1时，返回的颜色值为 _FirstColor*(1-1) + _SecondColor*1 = _SecondColor，反之为_FirstColor
                //float x = i.colY - _SplitPosition;
                //x = x / abs(x);
                //x = x / 2 + 0.5;
                //return lerp(_FirstColor, _SecondColor, x);

                //if (i.colY > _SplitPosition)
                //    return _FirstColor;
                //else
                //    return _SecondColor;

            }
            ENDCG
        }
    }
}