Shader "Sprites/Screen (VividLight)" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [MaterialToggle] DitheringNoise ("Dithering noise", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
    }

    SubShader {
        Tags {
            "CanUseSpriteAtlas"="true"
            "IGNOREPROJECTOR"="true"
            "PreviewType"="Plane"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }

        GrabPass { "_GrabTexture" }

        Pass {
            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature DITHERING_NOISE

            #include "UnityCG.cginc"

            float4 _Color;
            float4 _RendererColor;
            float2 _Flip;

            sampler2D _MainTex;
            sampler2D _GrabTexture;

            struct appdata {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 grabPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float4 pos;
                pos.xy = v.vertex.xy * _Flip;
                pos.zw = v.vertex.zw;

                pos = mul(unity_ObjectToWorld, pos);
                o.position = mul(unity_MatrixVP, pos);

                #ifdef PIXELSNAP_ON
                float4 screenPos;
                screenPos.xy = o.position.xy / o.position.w;
                screenPos.xy = round(screenPos.xy * (_ScreenParams.xy * 0.5)) / (_ScreenParams.xy * 0.5);
                screenPos.xy *= o.position.w;
                screenPos.zw = o.position.zw;
                o.position = screenPos;
                #endif

                o.color = v.color * _Color * _RendererColor;
                o.texcoord = v.texcoord;
                o.grabPos = ComputeGrabScreenPos(o.position);

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.texcoord) * i.color;
                float4 b = tex2D(_GrabTexture, i.grabPos.xy / i.grabPos.w);

                float3 src = c.rgb;
                float3 dst = b.rgb;

                float3 dodge = dst / (2.0 - 2.0 * src);
                float3 burn = 1.0 - (1.0 - dst) / (2.0 * src);
                float3 vivid = src > 0.5 ? dodge : burn;

                #ifdef DITHERING_NOISE
                float dither = frac(dot(i.position.xy, float2(0.06711056, 0.00583715)) * 52.98292) * 0.00392157 - 0.00196078;
                return float4(vivid + dither, c.a + dither);
                #endif

                return float4(vivid, c.a);
            }
            ENDCG
        }
    }
}