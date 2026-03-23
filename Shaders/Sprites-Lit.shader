Shader "Sprites/Lit" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        [Space] [Toggle(AMBIENT_LERP)] _AmbientLerpEnabled ("Enable Ambient Lerp", Float) = 0
        _AmbientLerp ("Ambient Lerp", Range(0, 1)) = 1
        [Space] [Toggle(SATURATION_LERP)] _SaturationLerpEnabled ("Enable Saturation Lerp", Float) = 0
        _SaturationLerp ("Saturation Lerp", Float) = 1
        [Space] [Toggle(COLOR_FLASH)] _ColorFlashEnabled ("Enable Color Flash", Float) = 0
        _FlashColor ("Flash Color", Color) = (1, 1, 1, 1)
        _FlashAmount ("Flash Amount", Range(0, 1)) = 0
        [PerRendererData] _BlackThreadAmount ("Black Thread Amount", Range(0, 1)) = 1
        [Toggle(BLACKTHREAD)] _IsBlackThreaded ("Is Black Threaded", Float) = 0
    }
    SubShader {
        Tags {
            "CanUseSpriteAtlas"="true"
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
                "IGNOREPROJECTOR"="true"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature AMBIENT_LERP
            #pragma shader_feature BLACKTHREAD
            #pragma shader_feature COLOR_FLASH
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature INSTANCING_ON
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature SATURATION_LERP
            

            #if AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && SATURATION_LERP
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif PIXELSNAP_ON && SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.xz = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = round(tmp0.xz);
                tmp0.xz = tmp0.xz / tmp1.xy;
                o.position.xy = tmp1.ww * tmp0.xz;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && PIXELSNAP_ON
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif AMBIENT_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif SATURATION_LERP
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif COLOR_FLASH
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                // int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD
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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

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
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

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
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && COLOR_FLASH && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.x = tmp1.x * 0.85 + -0.5;
                tmp1.x = tmp1.x * 1.35 + 0.5;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif AMBIENT_LERP && COLOR_FLASH && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = saturate(_FlashAmount.xxx * tmp1.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            float _SaturationLerp; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif AMBIENT_LERP && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif COLOR_FLASH && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif AMBIENT_LERP && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif AMBIENT_LERP && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif INSTANCING_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif COLOR_FLASH && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif AMBIENT_LERP && BLACKTHREAD
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _AmbientLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = tmp0.www - tmp0.xyz;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif BLACKTHREAD && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float _SaturationLerp; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = saturate(_BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz);
                return o;
            }

            #elif BLACKTHREAD && COLOR_FLASH
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            float4 _FlashColor; // 64 (starting at cb0[4].x)
            float _FlashAmount; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.w = tmp1.w * 0.85 + -0.5;
                tmp1.w = tmp1.w * 1.35 + 0.5;
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif BLACKTHREAD && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif AMBIENT_LERP && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                return o;
            }

            #elif COLOR_FLASH && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif BLACKTHREAD && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 2
                float _EnableExternalAlpha; // 24 (starting at cb2[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif AMBIENT_LERP && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif PIXELSNAP_ON && SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif COLOR_FLASH && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif BLACKTHREAD && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif AMBIENT_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                o.sv_target.xyz = saturate(_AmbientLerp.xxx * tmp1.xyz + tmp0.xyz);
                return o;
            }

            #elif SATURATION_LERP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _SaturationLerp; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xyz = tmp0.xyz * tmp0.www + -tmp1.xxx;
                tmp0.xyz = _SaturationLerp.xxx * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz + tmp0.xyz);
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif COLOR_FLASH
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz * tmp0.www + -tmp0.xyz;
                o.sv_target.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif BLACKTHREAD
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityPerFrame) // 1
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                o.sv_target.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Sprites/Diffuse"
}
