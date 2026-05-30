Shader "Custom/Tracking Trail"
{
    Properties
    {
        [PerRendererData] _TintColor ("Tint Color", Color) = (1,1,1,1)
        _Color ("Primary Color", Color) = (1,1,1,1)
        _MainTex ("Primary Texture", 2D) = "white" {}

        _SpeedX ("Primary Scroll X", Float) = 1
        _SpeedY ("Primary Scroll Y", Float) = 1

        _SecondaryColor ("Secondary Color", Color) = (1,1,1,1)
        _SecondaryTex ("Secondary Texture", 2D) = "white" {}

        _SecondarySpeedX ("Secondary Scroll X", Float) = 1
        _SecondarySpeedY ("Secondary Scroll Y", Float) = 1

        _PointMaskTex ("Point Mask Texture", 2D) = "white" {}
        _PointLightTex ("Point Light Texture", 2D) = "white" {}

        _HeroWorldPos ("Hero World Pos", Vector) = (0,0,0,0)
        _HeroPlayMode ("Hero Play Mode", Float) = 0
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

        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off
        ZWrite Off
        ZTest LEqual

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _SecondaryTex;
            sampler2D _PointMaskTex;
            sampler2D _PointLightTex;

            float4 _MainTex_ST;
            float4 _SecondaryTex_ST;
            float4 _PointMaskTex_ST;
            float4 _PointLightTex_ST;

            fixed4 _TintColor;
            fixed4 _Color;
            fixed4 _SecondaryColor;

            float _SpeedX;
            float _SpeedY;

            float _SecondarySpeedX;
            float _SecondarySpeedY;

            float2 _HeroWorldPos;
            float _HeroPlayMode;

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv       : TEXCOORD0;
                fixed4 color    : COLOR;
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;

                float2 uvMain       : TEXCOORD0;
                float2 uvSecondary  : TEXCOORD1;
                float2 uvLight      : TEXCOORD2;
                float2 uvMask       : TEXCOORD3;

                fixed4 color        : COLOR0;

                float2 worldPos     : TEXCOORD4;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                float2 timePrimary =
                    float2(_SpeedX, _SpeedY) * _Time.y;

                float2 timeSecondary =
                    float2(_SecondarySpeedX, _SecondarySpeedY) * _Time.y;

                o.uvMain =
                    TRANSFORM_TEX(v.uv + timePrimary, _MainTex);

                o.uvSecondary =
                    TRANSFORM_TEX(v.uv + timeSecondary, _SecondaryTex);

                float2 worldPos =
                    mul(unity_ObjectToWorld, v.vertex).xy;

                o.worldPos = worldPos;

                o.uvMask =
                    TRANSFORM_TEX(worldPos, _PointMaskTex);

                float2 lightUV =
                    worldPos - _HeroWorldPos;

                o.uvLight =
                    TRANSFORM_TEX(lightUV, _PointLightTex);

                o.color = v.color * _TintColor;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 mainTex =
                    tex2D(_MainTex, i.uvMain) * _Color;

                fixed4 secondaryTex =
                    tex2D(_SecondaryTex, i.uvSecondary) * _SecondaryColor;

                fixed4 col =
                    (mainTex + secondaryTex) * i.color;

                fixed mask =
                    tex2D(_PointMaskTex, i.uvMask).r;

                col.a *= mask;
                col.rgb *= mask;

                if (_HeroPlayMode != 0)
                {
                    fixed lightMask =
                        tex2D(_PointLightTex, i.uvLight).r;

                    col.rgb *= lightMask;
                    col.a *= lightMask;
                }

                return col;
            }

            ENDCG
        }
    }
}