Shader "Sprites/Shining" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        [Space] _ShineTex ("Shine Texture", 2D) = "white" {}
        _ShineStrength ("Shine Strength", Range(0, 1)) = 1
        _ShineTimelineTex ("Shine Timeline Texture", 2D) = "black" {}
        [Toggle(UNSCALED_TIME)] _ShineUseUnscaledTime ("Use Unscaled Time", Float) = 0
        [Toggle(TIME_OFFSET_WORLDPOS)] _TimeOffsetWorldPos ("Use World Pos for Time Offset", Float) = 1
        [Space] _AmbientLerp ("Ambient Lerp", Range(0, 1)) = 1
    }
    SubShader {
        Tags {
            "CanUseSpriteAtlas"="true"
            "DisableBatching"="true"
            "IGNOREPROJECTOR"="true"
            "PreviewType"="Plane"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name ""
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "CanUseSpriteAtlas"="true"
                "DisableBatching"="true"
                "IGNOREPROJECTOR"="true"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature UNSCALED_TIME
            #pragma shader_feature TIME_OFFSET_WORLDPOS
            

            #if ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && UNSCALED_TIME
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 84 (starting at cb0[5].y)
            float _UnscaledGlobalTime; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _UnscaledGlobalTime;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && TIME_OFFSET_WORLDPOS
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _Time.y + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m13;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && UNSCALED_TIME
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 84 (starting at cb0[5].y)
            float _UnscaledGlobalTime; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _UnscaledGlobalTime;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && TIME_OFFSET_WORLDPOS
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _Time.y + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m13;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif PIXELSNAP_ON && UNSCALED_TIME
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 84 (starting at cb0[5].y)
            float _UnscaledGlobalTime; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _UnscaledGlobalTime;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif PIXELSNAP_ON && TIME_OFFSET_WORLDPOS
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _Time.y + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m13;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _Time.y;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif UNSCALED_TIME
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 84 (starting at cb0[5].y)
            float _UnscaledGlobalTime; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _UnscaledGlobalTime;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif TIME_OFFSET_WORLDPOS
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _Time.y + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m13;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _Time.y;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _Time.y;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float _TimeOffset; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ShineTex_ST; // 48 (starting at cb0[3].x)
            float4 _ShineTimelineTex_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40
            sampler2D _ShineTimelineTex; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                tmp0.x = _TimeOffset + _Time.y;
                tmp0.x = tmp0.x * _ShineTimelineTex_ST.x + _ShineTimelineTex_ST.z;
                tmp0 = tex2Dlod(_ShineTimelineTex, float4(tmp0.xx, 0, tmp0.x));
                tmp0.y = v.texcoord.x - 1.0;
                tmp0.z = tmp0.x * 2.0 + tmp0.y;
                tmp0.w = v.texcoord.y;
                o.texcoord1.xy = tmp0.zw * _ShineTex_ST.xy + _ShineTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && UNSCALED_TIME
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 88 (starting at cb0[5].z)
            float _AmbientLerp; // 92 (starting at cb0[5].w)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp1 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp1.yzw = -tmp1.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * _AmbientLerp;
                tmp0.xyz = tmp0.xyz / tmp1.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.yzw = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && TIME_OFFSET_WORLDPOS
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 80 (starting at cb0[5].x)
            float _AmbientLerp; // 84 (starting at cb0[5].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp1 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp1.yzw = -tmp1.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * _AmbientLerp;
                tmp0.xyz = tmp0.xyz / tmp1.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.yzw = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && UNSCALED_TIME
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 88 (starting at cb0[5].z)
            float _AmbientLerp; // 92 (starting at cb0[5].w)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp1 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp1.yzw = -tmp1.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * _AmbientLerp;
                tmp0.xyz = tmp0.xyz / tmp1.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.yzw = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && TIME_OFFSET_WORLDPOS
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 80 (starting at cb0[5].x)
            float _AmbientLerp; // 84 (starting at cb0[5].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp1 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp1.yzw = -tmp1.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * _AmbientLerp;
                tmp0.xyz = tmp0.xyz / tmp1.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.yzw = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                return o;
            }

            #elif PIXELSNAP_ON && UNSCALED_TIME
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 88 (starting at cb0[5].z)
            float _AmbientLerp; // 92 (starting at cb0[5].w)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp0.yzw = -tmp0.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _AmbientLerp;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.yzw = tmp1.xyz / tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                tmp1.xyz = tmp0.yzw * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.yzw;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                return o;
            }

            #elif PIXELSNAP_ON && TIME_OFFSET_WORLDPOS
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 80 (starting at cb0[5].x)
            float _AmbientLerp; // 84 (starting at cb0[5].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp0.yzw = -tmp0.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _AmbientLerp;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.yzw = tmp1.xyz / tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                tmp1.xyz = tmp0.yzw * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.yzw;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 84 (starting at cb0[5].y)
            float _AmbientLerp; // 88 (starting at cb0[5].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp1 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp1.yzw = -tmp1.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * _AmbientLerp;
                tmp0.xyz = tmp0.xyz / tmp1.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.yzw = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                return o;
            }

            #elif UNSCALED_TIME
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 88 (starting at cb0[5].z)
            float _AmbientLerp; // 92 (starting at cb0[5].w)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp0.yzw = -tmp0.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _AmbientLerp;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.yzw = tmp1.xyz / tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                tmp1.xyz = tmp0.yzw * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.yzw;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                return o;
            }

            #elif TIME_OFFSET_WORLDPOS
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 80 (starting at cb0[5].x)
            float _AmbientLerp; // 84 (starting at cb0[5].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp0.yzw = -tmp0.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _AmbientLerp;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.yzw = tmp1.xyz / tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                tmp1.xyz = tmp0.yzw * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.yzw;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 84 (starting at cb0[5].y)
            float _AmbientLerp; // 88 (starting at cb0[5].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp1 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp1.yzw = -tmp1.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * _AmbientLerp;
                tmp0.xyz = tmp0.xyz / tmp1.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.yzw = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.yzw = tmp1.yzw * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                return o;
            }

            #elif PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 84 (starting at cb0[5].y)
            float _AmbientLerp; // 88 (starting at cb0[5].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp0.yzw = -tmp0.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _AmbientLerp;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.yzw = tmp1.xyz / tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                tmp1.xyz = tmp0.yzw * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.yzw;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ShineStrength; // 84 (starting at cb0[5].y)
            float _AmbientLerp; // 88 (starting at cb0[5].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ShineTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ShineTex, inp.texcoord1.xy);
                tmp0.yzw = -tmp0.xyz * _ShineStrength.xxx + float3(1.0, 1.0, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _AmbientLerp;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.yzw = tmp1.xyz / tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                tmp1.xyz = tmp0.yzw * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.yzw;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Sprites/Diffuse"
}
