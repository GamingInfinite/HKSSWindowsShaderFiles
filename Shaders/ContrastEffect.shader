Shader "Custom/Contrast Effect"
{
    Properties
    {
        _Contrast ("Contrast", Float) = 1
        _Mask ("Mask", 2D) = "white" {}
        [Toggle(CAN_DESATURATE)] _CanDesaturate ("Can Desaturate", Float) = 0
        _Desaturation ("Desaturation", Range(0,1)) = 0
    }

    SubShader
    {
        Tags
        {
            "QUEUE"="Transparent"
            "RenderType"="Opaque"
        }

        GrabPass {}

        Pass
        {
            Name "BASE"

            ZWrite Off
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Mask_ST;
            float _Contrast;

            sampler2D _GrabTexture;
            sampler2D _Mask;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float4 grabPos : TEXCOORD0;
                float2 maskUV : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float4 clipPos = UnityObjectToClipPos(v.vertex);

                o.position = clipPos;

                o.grabPos = ComputeGrabScreenPos(clipPos);

                o.maskUV = TRANSFORM_TEX(v.texcoord, _Mask);

                return o;
            }

            fixed4 frag(v2f inp) : SV_Target
            {
                fixed mask = tex2D(_Mask, inp.maskUV).r;

                fixed4 screenCol =
                    tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(inp.grabPos));

                float3 contrasted =
                    (screenCol.rgb - 0.2176376) *
                    _Contrast +
                    0.2176376;

                screenCol.rgb =
                    lerp(screenCol.rgb, contrasted, mask);

                return screenCol;
            }

            ENDCG
        }
    }
}