Shader "Custom/Heat Effect (Masked)"
{
    Properties
    {
        _BumpAmt ("Distortion", Range(0,128)) = 10

        [Normal]
        _BumpMap ("Normalmap", 2D) = "bump" {}

        [Toggle(OBJ_UVS)]
        _UseObjUvs ("Use Object UVs", Float) = 0

        _SpeedX ("Speed X", Float) = 1
        _SpeedY ("Speed Y", Float) = 1

        _MaskTex ("Mask", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        GrabPass
        {
            "_GrabTexture"
        }

        Pass
        {
            Name "BASE"

            Cull Off
            ZWrite Off
            ZTest LEqual

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature OBJ_UVS

            #include "UnityCG.cginc"

            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize;

            sampler2D _BumpMap;
            sampler2D _MaskTex;

            float4 _BumpMap_ST;
            float4 _MaskTex_ST;

            float _BumpAmt;
            float _SpeedX;
            float _SpeedY;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos         : SV_POSITION;

                float4 grabPos     : TEXCOORD0;

                float2 bumpUV      : TEXCOORD1;
                float2 maskUV      : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.grabPos = ComputeGrabScreenPos(o.pos);

                float2 uv;

                #ifdef OBJ_UVS
                    uv = v.vertex.xy;
                #else
                    uv = v.uv;
                #endif

                o.bumpUV =
                    TRANSFORM_TEX(uv, _BumpMap);

                o.maskUV =
                    TRANSFORM_TEX(v.uv, _MaskTex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 scroll =
                    float2(_SpeedX, _SpeedY) * _Time.y;

                float2 bumpUV =
                    i.bumpUV + scroll;

                fixed4 bump =
                    tex2D(_BumpMap, bumpUV);

                // Unity normal unpack approximation
                float2 distortion =
                    ((bump.xy * 2.0) - 1.0);

                distortion *= _BumpAmt;
                distortion *= _GrabTexture_TexelSize.xy;

                fixed mask =
                    tex2D(_MaskTex, i.maskUV).r;

                distortion *= mask;

                float2 grabUV =
                    i.grabPos.xy / i.grabPos.w;

                grabUV += distortion;

                fixed4 col =
                    tex2D(_GrabTexture, grabUV);

                return col;
            }

            ENDCG
        }
    }

    Fallback Off
}