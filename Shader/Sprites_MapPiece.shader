Shader "Sprites/MapPiece"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0

        [HideInInspector] _RendererColor ("RendererColor", Color) = (1,1,1,1)
        [HideInInspector] _Flip ("Flip", Vector) = (1,1,1,1)

        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0

        _GreyTransLerp ("Greyscale Transparency Lerp", Range(0,1)) = 1
    }

    SubShader
    {
        Tags
        {
            "CanUseSpriteAtlas"="true"
            "IGNOREPROJECTOR"="true"
            "PreviewType"="Plane"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            fixed4 _Color;
            fixed4 _RendererColor;
            float2 _Flip;
            float _GreyTransLerp;

            struct appdata
            {
                float4 vertex   : POSITION;
                fixed4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 uv       : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float4 pos = v.vertex;
                pos.xy *= _Flip;

                o.vertex = UnityObjectToClipPos(pos);
                o.uv = v.texcoord;

                o.color = v.color * _Color * _RendererColor;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);

                float alphaMul =
                    (_GreyTransLerp * (tex.r - 1.0)) + 1.0;

                tex.a *= alphaMul;

                tex *= i.color;

                tex.rgb *= tex.a;

                return tex;
            }

            ENDCG
        }
    }
}