Shader "UI/BlendModes/Optimized/Screen"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        [PerRendererData] _GUIBlendingSharedGT ("Grab Texture", 2D) = "white" {}

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

        LOD 950

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest [unity_GUIZTestMode]
            Cull Off
            Lighting Off
            ColorMask 0

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
                float4 vertex        : SV_POSITION;
                fixed4 color         : COLOR;
                float2 uv            : TEXCOORD0;
                float4 screenPos     : TEXCOORD1;
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
                fixed4 src = tex2D(_MainTex, i.uv) * i.color;

                clip(src.a - 0.01);

                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                screenUV = screenUV * 0.5 + 0.5;
                screenUV.y = 1.0 - screenUV.y;

                fixed3 dst = tex2D(_GUIBlendingSharedGT, screenUV).rgb;

                // Screen blend:
                // 1 - ((1 - A) * (1 - B))
                fixed3 result = 1.0 - ((1.0 - dst) * (1.0 - src.rgb));

                return fixed4(result, src.a);
            }

            ENDCG
        }
    }

    Fallback "Sprites/Approximate Screen"
}