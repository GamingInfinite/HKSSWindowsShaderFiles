Shader "UI/BlendModes/Optimized/ColorBurn"
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
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest Always
        Blend SrcAlpha OneMinusSrcAlpha

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        ColorMask [_ColorMask]

        GrabPass
        {
            "_GUIBlendingSharedGT"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _GUIBlendingSharedGT;

            fixed4 _Color;

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex      : SV_POSITION;
                fixed4 color       : COLOR;
                float2 uv          : TEXCOORD0;
                float4 screenPos   : TEXCOORD1;
            };

            v2f vert(appdata_t v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);

                o.uv = v.texcoord;
                o.color = v.color * _Color;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 src = tex2D(_MainTex, i.uv) * i.color;

                clip(src.a - 0.01);

                float2 screenUV = i.screenPos.xy / i.screenPos.w;

                fixed4 dst = tex2D(_GUIBlendingSharedGT, screenUV);

                // Color Burn:
                // result = 1 - ((1 - dst) / src)

                fixed3 safeSrc = max(src.rgb, 0.001);

                fixed3 result = 1.0 - ((1.0 - dst.rgb) / safeSrc);

                return fixed4(saturate(result), src.a);
            }

            ENDCG
        }
    }

    Fallback "UI/Default"
}