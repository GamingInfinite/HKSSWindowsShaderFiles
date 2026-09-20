Shader "UI/BlendModes/Optimized/HardMix"
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
        ZWrite Off
        ZTest [unity_GUIZTestMode]

        Pass
        {
            Name "HardMix"

            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask [_ColorMask]

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

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex    : SV_POSITION;
                fixed4 color     : COLOR;
                float2 uv        : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            v2f vert(appdata_t v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = o.vertex;

                o.uv = v.texcoord;
                o.color = v.color * _Color;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv) * i.color;

                clip(tex.a - 0.01);

                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                screenUV = screenUV * 0.5 + 0.5;
                screenUV.y = 1.0 - screenUV.y;

                fixed3 background = tex2D(_GUIBlendingSharedGT, screenUV).rgb;

                // Decompiled logic:
                // result = (1 - background) < source ? 1 : 0

                fixed3 threshold = 1.0 - background;
                fixed3 result = step(threshold, tex.rgb);

                return fixed4(result, tex.a);
            }
            ENDCG
        }
    }

    FallBack "UI/Default"
}