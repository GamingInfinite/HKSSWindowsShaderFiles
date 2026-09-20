Shader "UI/BlendModes/Optimized/VividLight"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }

    SubShader
    {
        Tags
        {
            "IGNOREPROJECTOR"="true"
            "PreviewType"="Plane"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }

        Pass
        {
            ZWrite Off
            Cull Off

            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                ReadMask [_StencilReadMask]
                WriteMask [_StencilWriteMask]
            }
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask [_ColorMask]

            ZClip On
            ZWrite Off
            Cull Off

            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                ReadMask [_StencilReadMask]
                WriteMask [_StencilWriteMask]
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _GUIBlendingSharedGT;

            fixed4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color  : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.position = UnityObjectToClipPos(v.vertex);
                o.screenPos = o.position;

                o.color = v.color * _Color;
                o.texcoord = v.texcoord;

                return o;
            }

            fixed4 frag(v2f inp) : SV_Target
            {
                fixed4 src = tex2D(_MainTex, inp.texcoord) * inp.color;

                clip(src.a - 0.01);

                float2 screenUV = inp.screenPos.xy / inp.screenPos.w;
                screenUV = screenUV * 0.5 + 0.5;
                screenUV.y = 1.0 - screenUV.y;

                fixed3 dst = tex2D(_GUIBlendingSharedGT, screenUV).rgb;

                fixed3 result;

                if (src.r > 0.5)
                    result.r = dst.r / max(1.0 - (2.0 * (src.r - 0.5)), 0.0001);
                else
                    result.r = 1.0 - ((1.0 - dst.r) / max(2.0 * src.r, 0.0001));

                if (src.g > 0.5)
                    result.g = dst.g / max(1.0 - (2.0 * (src.g - 0.5)), 0.0001);
                else
                    result.g = 1.0 - ((1.0 - dst.g) / max(2.0 * src.g, 0.0001));

                if (src.b > 0.5)
                    result.b = dst.b / max(1.0 - (2.0 * (src.b - 0.5)), 0.0001);
                else
                    result.b = 1.0 - ((1.0 - dst.b) / max(2.0 * src.b, 0.0001));

                return fixed4(result, src.a);
            }

            ENDCG
        }
    }

    Fallback "UI/Default"
}