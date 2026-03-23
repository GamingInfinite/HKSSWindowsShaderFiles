Shader "Sprites/Tiled Masked" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        _ScrollTex ("Texture", 2D) = "white" {}
        [PerRendererData] _FogRotation ("Fog Rotation", Float) = 0
        [Toggle(WORLD_SCALE_FLIP)] _EnableWorldScaleFlip ("Enable World Scale Flip", Float) = 1
        [Toggle(SILHOUETTE)] _EnableSilhouette ("Is Silhouette", Float) = 0
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
            #pragma shader_feature WORLD_SCALE_FLIP
            

            #if ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && WORLD_SCALE_FLIP
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
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _FogRotation; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.zw = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.xy;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.zw;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp0.zw = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.zw = tmp0.zw + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.zw > float2(0.0, 0.0);
                tmp0.zw = tmp0.zw < float2(0.0, 0.0);
                tmp0.zw = tmp0.zw - tmp1.xy;
                tmp0.zw = floor(tmp0.zw);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && WORLD_SCALE_FLIP
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
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 4
                float _FogRotation; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp0.zw = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.zw = tmp0.zw + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.zw > float2(0.0, 0.0);
                tmp0.zw = tmp0.zw < float2(0.0, 0.0);
                tmp0.zw = tmp0.zw - tmp1.xy;
                tmp0.zw = floor(tmp0.zw);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif PIXELSNAP_ON && WORLD_SCALE_FLIP
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
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _FogRotation; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.zw = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.xy;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.zw;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp0.zw = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.zw = tmp0.zw + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.zw > float2(0.0, 0.0);
                tmp0.zw = tmp0.zw < float2(0.0, 0.0);
                tmp0.zw = tmp0.zw - tmp1.xy;
                tmp0.zw = floor(tmp0.zw);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _FogRotation; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.zw = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.xy;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.zw;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif WORLD_SCALE_FLIP
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
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 4
                float _FogRotation; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp0.zw = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.zw = tmp0.zw + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.zw > float2(0.0, 0.0);
                tmp0.zw = tmp0.zw < float2(0.0, 0.0);
                tmp0.zw = tmp0.zw - tmp1.xy;
                tmp0.zw = floor(tmp0.zw);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 4
                float _FogRotation; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _FogRotation; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.zw = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.xy;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.zw;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _ScrollTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 4
                float _FogRotation; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 24 (starting at cb0[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.x;
                tmp1.x = _EnableExternalAlpha * tmp0.x + tmp1.x;
                tmp0 = tmp1 * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 24 (starting at cb0[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.x;
                tmp1.x = _EnableExternalAlpha * tmp0.x + tmp1.x;
                tmp0 = tmp1 * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif PIXELSNAP_ON && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0.wxyz * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 24 (starting at cb0[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.x;
                tmp1.x = _EnableExternalAlpha * tmp0.x + tmp1.x;
                tmp0 = tmp1 * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0.wxyz * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 24 (starting at cb0[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 2
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.x;
                tmp1.x = _EnableExternalAlpha * tmp0.x + tmp1.x;
                tmp0 = tmp1 * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0.wxyz * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0.wxyz * inp.color.wxyz;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0 * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
