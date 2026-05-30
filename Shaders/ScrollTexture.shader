Shader "Custom/ScrollTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

        _SpeedX ("Flow Rate X", Float) = 1
        _SpeedY ("Flow Rate Y", Float) = 1

        [Toggle(USE_SECONDARY)] _UseSecondary ("Use Secondary", Float) = 0
        _SecondaryColor ("Secondary Color", Color) = (1,1,1,1)
        _SecondaryTex ("Secondary Texture", 2D) = "white" {}
        _SecondarySpeedX ("Secondary Flow Rate X", Float) = 1
        _SecondarySpeedY ("Secondary Flow Rate Y", Float) = 1

        [Space]
        [Toggle(USE_OBJECT_SCALE)] _UseObjectScale ("Use Object Scale", Float) = 0

        [Space]
        [Toggle(USE_WORLD_OFFSET)] _UseWorldOffset ("Use World Offset", Float) = 0
        _WorldOffsetX ("World Offset X Amount", Float) = 0
        _WorldOffsetY ("World Offset Y Amount", Float) = 0
        _WorldOffsetZ ("World Offset Z Amount", Float) = 0

        [Toggle(USE_MASK)] _UseMask ("Use Mask", Float) = 0
        _MaskTex ("Mask Texture", 2D) = "white" {}

        [PerRendererData]
        _TintColor ("Tint Color", Color) = (1,1,1,1)

        _StencilRef ("Stencil Ref", Range(0,255)) = 255

        [Toggle(USE_COLOR_FLASH)] _UseColorFlash ("Use Color Flash", Float) = 0
        _FlashColor ("Flash Color", Color) = (1,1,1,1)
        _FlashAmount ("Flash Amount", Range(0,1)) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
            "DisableBatching"="True"
        }

        LOD 100

        Blend One OneMinusSrcAlpha
        Cull Off
        Lighting Off
        ZWrite Off
        ZTest LEqual

        Pass
        {
            Stencil
            {
                Ref [_StencilRef]
                Comp GEqual
                Pass Keep
                Fail Keep
                ZFail Keep
            }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_SECONDARY
            #pragma shader_feature USE_MASK
            #pragma shader_feature USE_WORLD_OFFSET
            #pragma shader_feature USE_OBJECT_SCALE
            #pragma shader_feature USE_COLOR_FLASH

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _SecondaryTex;
            sampler2D _MaskTex;

            float4 _MainTex_ST;
            float4 _SecondaryTex_ST;
            float4 _MaskTex_ST;

            fixed4 _Color;
            fixed4 _SecondaryColor;
            fixed4 _TintColor;

            fixed4 _FlashColor;
            float _FlashAmount;

            float _SpeedX;
            float _SpeedY;

            float _SecondarySpeedX;
            float _SecondarySpeedY;

            float _WorldOffsetX;
            float _WorldOffsetY;
            float _WorldOffsetZ;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                fixed4 color  : COLOR;
            };

            struct v2f
            {
                float4 pos        : SV_POSITION;

                float2 uvMain     : TEXCOORD0;
                float2 uvSecond   : TEXCOORD1;
                float2 uvMask     : TEXCOORD2;

                fixed4 color      : COLOR0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float4 vertex = v.vertex;

                #ifdef USE_WORLD_OFFSET
                vertex.xyz += float3(
                    _WorldOffsetX,
                    _WorldOffsetY,
                    _WorldOffsetZ
                );
                #endif

                o.pos = UnityObjectToClipPos(vertex);

                float2 baseUV = v.uv;

                #ifdef USE_OBJECT_SCALE
                float2 scale;
                scale.x =
                    length(unity_ObjectToWorld._m00_m10_m20);

                scale.y =
                    length(unity_ObjectToWorld._m01_m11_m21);

                baseUV *= scale;
                #endif

                float2 scrollMain =
                    float2(_SpeedX, _SpeedY) * _Time.y;

                o.uvMain =
                    TRANSFORM_TEX(baseUV + scrollMain, _MainTex);

                float2 scrollSecondary =
                    float2(_SecondarySpeedX, _SecondarySpeedY) * _Time.y;

                o.uvSecond =
                    TRANSFORM_TEX(baseUV + scrollSecondary, _SecondaryTex);

                o.uvMask =
                    TRANSFORM_TEX(baseUV, _MaskTex);

                o.color = v.color * _TintColor;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col =
                    tex2D(_MainTex, i.uvMain) * _Color;

                #ifdef USE_SECONDARY
                fixed4 secondary =
                    tex2D(_SecondaryTex, i.uvSecond) * _SecondaryColor;

                col += secondary;
                #endif

                col *= i.color;

                #ifdef USE_MASK
                fixed mask =
                    tex2D(_MaskTex, i.uvMask).r;

                col.rgb *= mask;
                col.a *= mask;
                #endif

                #ifdef USE_COLOR_FLASH
                col.rgb =
                    lerp(col.rgb, _FlashColor.rgb, _FlashAmount);
                #endif

                // Premultiplied alpha output
                col.rgb *= col.a;

                return col;
            }

            ENDCG
        }
    }
}