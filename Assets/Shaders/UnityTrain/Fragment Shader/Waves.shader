Shader "UnityTrain/Fragment/Waves" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" { }
        _WaveTex ("WaveTex", 2D) = "black" { }
        _Intensity ("Intensity", float) = 0.025
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _WaveTex;
            float _Intensity;

            v2f vert(appdata_base v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {

                float2 waveUV = tex2D(_WaveTex, i.uv).xy;
                waveUV *= _Intensity;
                i.uv += waveUV;

                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}