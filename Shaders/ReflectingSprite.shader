Shader "Hollow Knight/Reflecting Sprite (Diffuse)"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        [HideInInspector]
        _RendererColor ("RendererColor", Color) = (1,1,1,1)

        [HideInInspector]
        _Flip ("Flip", Vector) = (1,1,1,1)

        [PerRendererData]
        _AlphaTex ("External Alpha", 2D) = "white" {}

        [PerRendererData]
        _EnableExternalAlpha ("Enable External Alpha", Float) = 0

        _ReflectionOffset ("Reflection Offset", Float) = 0
        _Reflectance ("Reflectance", Range(0,1)) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
            "DisableBatching"="True"
        }

        GrabPass
        {
            "_GrabTexture"
        }

        Pass
        {
            Blend One OneMinusSrcAlpha
            Cull Off
            Lighting Off
            ZWrite Off
            ZTest LEqual

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _GrabTexture;

            float4 _MainTex_ST;

            fixed4 _Color;
            fixed4 _RendererColor;

            float2 _Flip;

            float _ReflectionOffset;
            float _Reflectance;

            struct appdata
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 uv       : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;

                float2 uv           : TEXCOORD0;

                fixed4 color        : COLOR0;

                float4 grabPos      : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float4 vertex = v.vertex;

                vertex.xy *= _Flip;

                float4 worldPos =
                    mul(unity_ObjectToWorld, vertex);

                o.pos = mul(UNITY_MATRIX_VP, worldPos);

                o.uv =
                    TRANSFORM_TEX(v.uv, _MainTex);

                o.color =
                    v.color * _Color * _RendererColor;

                // Reflection across camera/world Y plane

                float reflectedY =
                    (_WorldSpaceCameraPos.y * 2.0)
                    - worldPos.y
                    + _ReflectionOffset;

                float4 reflectedWorld =
                    float4(
                        worldPos.x,
                        reflectedY,
                        worldPos.z,
                        1.0
                    );

                float4 reflectedClip =
                    mul(UNITY_MATRIX_VP, reflectedWorld);

                o.grabPos =
                    ComputeGrabScreenPos(reflectedClip);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 sprite =
                    tex2D(_MainTex, i.uv) * i.color;

                // Premultiply alpha
                sprite.rgb *= sprite.a;

                float2 grabUV =
                    i.grabPos.xy / i.grabPos.w;

                fixed4 reflection =
                    tex2D(_GrabTexture, grabUV);

                fixed4 result =
                    lerp(
                        sprite,
                        reflection,
                        _Reflectance * sprite.a
                    );

                result.a = sprite.a;

                return result;
            }

            ENDCG
        }
    }

    Fallback "Sprites/Default"
}