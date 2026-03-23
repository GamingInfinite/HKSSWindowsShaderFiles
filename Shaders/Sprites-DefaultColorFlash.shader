Shader "Sprites/Default-ColorFlash" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _FlashColor ("Flash Color", Color) = (1, 1, 1, 1)
        _FlashAmount ("Flash Amount", Range(0, 1)) = 0
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [Toggle(IS_CHARACTER)] _IsCharacter ("Is Character", Float) = 0
        [PerRendererData] _CharacterTintColor ("Character Tint Color", Color) = (1, 1, 1, 1)
        [Toggle(IS_HERO)] _IsHero ("Is Hero", Float) = 0
        [Toggle(CAN_DESATURATE)] _CanDesaturate ("Can Desaturate", Float) = 0
        _Desaturation ("Desaturation", Range(-2, 2)) = 0
        [Toggle(CAN_LERP_AMBIENT)] _CanLerpAmbient ("Can Lerp Ambient", Float) = 0
        _AmbientLerp ("Ambient Lerp", Range(0, 1)) = 1
        [PerRendererData] _BlackThreadAmount ("Black Thread Amount", Range(0, 1)) = 1
        [Space] [Toggle(MASKING_SPRITE)] _IsMaskingSprite ("Masking Sprite", Float) = 0
        [Toggle(LOCAL_SPACE_X)] _UseLocalSpaceX ("Local Space X", Float) = 0
        [Toggle(LOCAL_SPACE_Y)] _UseLocalSpaceY ("Local Space Y", Float) = 0
        _ScrollTexA ("Texture A", 2D) = "white" {}
        _SpeedXA ("Tex A Flow Rate X", Float) = 1
        _SpeedYA ("Tex A Flow Rate Y", Float) = 1
        _ScrollTexB ("Texture B", 2D) = "white" {}
        _SpeedXB ("Tex B Flow Rate X", Float) = 1
        _SpeedYB ("Tex B Flow Rate Y", Float) = 1
        [Space] [IntRange] _StencilRef ("Stencil Reference", Range(0, 255)) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Range(0, 255)) = 8
        [Toggle(BLACKTHREAD)] _IsBlackThreaded ("Is Black Threaded", Float) = 0
        [Toggle(CAN_HUESHIFT)] _CanHueShift ("Can Hue Shift", Float) = 0
        _HueShift ("Hue Shift", Range(-1, 1)) = 0
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
            Stencil {
            }
            Fog {
                Mode Off
            }
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

            #pragma shader_feature CAN_DESATURATE
            #pragma shader_feature IS_CHARACTER
            #pragma shader_feature IS_HERO
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature RECOLOUR
            #pragma shader_feature BLACKTHREAD
            #pragma shader_feature MASKING_SPRITE
            #pragma shader_feature CAN_HUESHIFT
            #pragma shader_feature CAN_LERP_AMBIENT
            

            #if CAN_DESATURATE && IS_CHARACTER && IS_HERO && PIXELSNAP_ON
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && IS_HERO && RECOLOUR
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && CAN_DESATURATE && IS_CHARACTER && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && IS_HERO && MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 148 (starting at cb0[9].y)
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _ScrollTexA_ST; // 96 (starting at cb0[6].x)
            float _SpeedXA; // 112 (starting at cb0[7].x)
            float _SpeedYA; // 116 (starting at cb0[7].y)
            float4 _ScrollTexB_ST; // 128 (starting at cb0[8].x)
            float _SpeedXB; // 144 (starting at cb0[9].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                o.color = tmp1 * _CharacterTintColor;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && CAN_HUESHIFT && IS_CHARACTER && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO && PIXELSNAP_ON
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && PIXELSNAP_ON
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO && RECOLOUR
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && RECOLOUR
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && IS_CHARACTER && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && CAN_DESATURATE && IS_CHARACTER
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO && MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 148 (starting at cb0[9].y)
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _ScrollTexA_ST; // 96 (starting at cb0[6].x)
            float _SpeedXA; // 112 (starting at cb0[7].x)
            float _SpeedYA; // 116 (starting at cb0[7].y)
            float4 _ScrollTexB_ST; // 128 (starting at cb0[8].x)
            float _SpeedXB; // 144 (starting at cb0[9].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                o.color = tmp1 * _CharacterTintColor;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 148 (starting at cb0[9].y)
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _ScrollTexA_ST; // 96 (starting at cb0[6].x)
            float _SpeedXA; // 112 (starting at cb0[7].x)
            float _SpeedYA; // 116 (starting at cb0[7].y)
            float4 _ScrollTexB_ST; // 128 (starting at cb0[8].x)
            float _SpeedXB; // 144 (starting at cb0[9].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                o.color = tmp1 * _CharacterTintColor;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_HUESHIFT && IS_CHARACTER && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && CAN_HUESHIFT && IS_CHARACTER
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && PIXELSNAP_ON
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_HERO && PIXELSNAP_ON
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_LERP_AMBIENT && PIXELSNAP_ON
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && RECOLOUR
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_HERO && RECOLOUR
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_LERP_AMBIENT && RECOLOUR
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && IS_CHARACTER
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif BLACKTHREAD && CAN_LERP_AMBIENT
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER && MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 148 (starting at cb0[9].y)
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _ScrollTexA_ST; // 96 (starting at cb0[6].x)
            float _SpeedXA; // 112 (starting at cb0[7].x)
            float _SpeedYA; // 116 (starting at cb0[7].y)
            float4 _ScrollTexB_ST; // 128 (starting at cb0[8].x)
            float _SpeedXB; // 144 (starting at cb0[9].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                o.color = tmp1 * _CharacterTintColor;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_HERO && MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 148 (starting at cb0[9].y)
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _ScrollTexA_ST; // 96 (starting at cb0[6].x)
            float _SpeedXA; // 112 (starting at cb0[7].x)
            float _SpeedYA; // 116 (starting at cb0[7].y)
            float4 _ScrollTexB_ST; // 128 (starting at cb0[8].x)
            float _SpeedXB; // 144 (starting at cb0[9].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                o.color = tmp1 * _CharacterTintColor;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_LERP_AMBIENT && MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 132 (starting at cb0[8].y)
            float4 _ScrollTexA_ST; // 80 (starting at cb0[5].x)
            float _SpeedXA; // 96 (starting at cb0[6].x)
            float _SpeedYA; // 100 (starting at cb0[6].y)
            float4 _ScrollTexB_ST; // 112 (starting at cb0[7].x)
            float _SpeedXB; // 128 (starting at cb0[8].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_HUESHIFT && IS_CHARACTER
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_HUESHIFT && IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_HUESHIFT && CAN_LERP_AMBIENT
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_CHARACTER
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif IS_HERO
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
            float4 _CharacterTintColor; // 80 (starting at cb0[5].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _CharacterTintColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_LERP_AMBIENT
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
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
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif RECOLOUR
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif MASKING_SPRITE
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _SpeedYB; // 132 (starting at cb0[8].y)
            float4 _ScrollTexA_ST; // 80 (starting at cb0[5].x)
            float _SpeedXA; // 96 (starting at cb0[6].x)
            float _SpeedYA; // 100 (starting at cb0[6].y)
            float4 _ScrollTexB_ST; // 112 (starting at cb0[7].x)
            float _SpeedXB; // 128 (starting at cb0[8].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp0.zw = float2(_SpeedXA.x, _SpeedYA.x) * _Time.yy + tmp0.xy;
                tmp0.xy = float2(_SpeedYB.x, _SpeedXB.x) * _Time.yy + tmp0.xy;
                o.texcoord2.xy = tmp0.xy * _ScrollTexB_ST.xy + _ScrollTexB_ST.zw;
                o.texcoord1.xy = tmp0.zw * _ScrollTexA_ST.xy + _ScrollTexA_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CAN_HUESHIFT
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
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
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if CAN_DESATURATE && IS_CHARACTER && IS_HERO && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && IS_HERO && RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.z = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + tmp0.zzz;
                tmp0.xzw = _Desaturation.xxx * tmp0.xzw + tmp1.xyz;
                tmp1.x = saturate(dot(tmp0.xzw, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xzw;
                tmp0.xzw = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xzw;
                tmp1.xyz = _FlashColor.xyz - tmp0.xzw;
                tmp0.xzw = _FlashAmount.xxx * tmp1.xyz + tmp0.xzw;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif BLACKTHREAD && CAN_DESATURATE && IS_CHARACTER && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 104 (starting at cb0[6].z)
            float _HeroDesaturation; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp0.www - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp0.www - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && IS_HERO && MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && CAN_HUESHIFT && IS_CHARACTER && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 104 (starting at cb0[6].z)
            float _HueShift; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO && RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.z = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + tmp0.zzz;
                tmp0.xzw = _HeroDesaturation.xxx * tmp0.xzw + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xzw;
                tmp0.xzw = _FlashAmount.xxx * tmp1.xyz + tmp0.xzw;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Desaturation; // 96 (starting at cb0[6].x)
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.z = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + tmp0.zzz;
                tmp0.xzw = _Desaturation.xxx * tmp0.xzw + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xzw;
                tmp0.xzw = _FlashAmount.xxx * tmp1.xyz + tmp0.xzw;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif BLACKTHREAD && IS_CHARACTER && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 100 (starting at cb0[6].y)
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
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
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp0.www - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif BLACKTHREAD && CAN_DESATURATE && IS_CHARACTER
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp0.www - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO && MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER && MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_HUESHIFT && IS_CHARACTER && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 100 (starting at cb0[6].y)
            float _HueShift; // 96 (starting at cb0[6].x)
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
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && CAN_HUESHIFT && IS_CHARACTER
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HueShift; // 100 (starting at cb0[6].y)
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_CHARACTER && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_DESATURATE && IS_CHARACTER
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Desaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _Desaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_CHARACTER && PIXELSNAP_ON
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_HERO && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_LERP_AMBIENT && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 68 (starting at cb0[4].y)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_CHARACTER && RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + _FlashColor.xyz;
                tmp0.xzw = _FlashAmount.xxx * tmp0.xzw + tmp1.xyz;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif IS_HERO && RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.z = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + tmp0.zzz;
                tmp0.xzw = _HeroDesaturation.xxx * tmp0.xzw + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xzw;
                tmp0.xzw = _FlashAmount.xxx * tmp1.xyz + tmp0.xzw;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif CAN_LERP_AMBIENT && RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + _FlashColor.xyz;
                tmp0.xzw = _FlashAmount.xxx * tmp0.xzw + tmp1.xyz;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif BLACKTHREAD && IS_CHARACTER
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 96 (starting at cb0[6].x)
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
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif BLACKTHREAD && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 100 (starting at cb0[6].y)
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
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
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp0.w = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp0.www - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif BLACKTHREAD && CAN_LERP_AMBIENT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 72 (starting at cb0[4].z)
            float _AmbientLerp; // 68 (starting at cb0[4].y)
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
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif IS_CHARACTER && MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_HERO && MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_LERP_AMBIENT && MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_HUESHIFT && IS_CHARACTER
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HueShift; // 96 (starting at cb0[6].x)
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
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_HUESHIFT && IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 100 (starting at cb0[6].y)
            float _HueShift; // 96 (starting at cb0[6].x)
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
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_HUESHIFT && CAN_LERP_AMBIENT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 72 (starting at cb0[4].z)
            float _HueShift; // 68 (starting at cb0[4].y)
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
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_CHARACTER
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif IS_HERO
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroDesaturation; // 96 (starting at cb0[6].x)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.4, 0.4, 0.4) + tmp0.xyz;
                tmp1.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = _HeroDesaturation.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_LERP_AMBIENT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _AmbientLerp; // 68 (starting at cb0[4].y)
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
                tmp1.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xyz;
                tmp0.xyz = _AmbientLerp.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = -tmp0.xyz * inp.color.xyz + _FlashColor.xyz;
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif RECOLOUR
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.y = tmp0.w * inp.color.w;
                tmp1.xyz = tmp0.xxx * inp.color.xyz;
                tmp0.xzw = -tmp0.xxx * inp.color.xyz + _FlashColor.xyz;
                tmp0.xzw = _FlashAmount.xxx * tmp0.xzw + tmp1.xyz;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.w = tmp0.y;
                return o;
            }

            #elif BLACKTHREAD
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlackThreadAmount; // 68 (starting at cb0[4].y)
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp0 * inp.color;
                tmp0.w = saturate(dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0)));
                tmp0.w = tmp0.w * 0.85 + -0.5;
                tmp0.w = tmp0.w * 1.35 + 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.xyz = -tmp0.xyz * inp.color.xyz + tmp0.www;
                tmp0.xyz = _BlackThreadAmount.xxx * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = _FlashColor.xyz - tmp0.xyz;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif MASKING_SPRITE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ScrollTexA; // 1
            sampler2D _ScrollTexB; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ScrollTexA, inp.texcoord1.xy);
                tmp1 = tex2D(_ScrollTexB, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.xyz = -tmp0.xzy * float3(0.5, 0.5, 0.5) + _FlashColor.xyz;
                tmp0 = tmp0 * float4(0.5, 0.5, 0.5, 0.5);
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xzy;
                tmp0.w = max(tmp0.w, _FlashAmount);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.w * inp.color.w;
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CAN_HUESHIFT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HueShift; // 68 (starting at cb0[4].y)
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0.xyz = -tmp2.xyz * inp.color.xyz + _FlashColor.xyz;
                tmp1 = tmp2 * inp.color;
                tmp0.xyz = _FlashAmount.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _FlashColor; // 48 (starting at cb0[3].x)
            float _FlashAmount; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = -tmp0.xyz * inp.color.xyz + _FlashColor.xyz;
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = _FlashAmount.xxx * tmp1.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
