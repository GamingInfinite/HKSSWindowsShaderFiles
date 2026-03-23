Shader "Sprites/Tiled Scrolling Masked" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        _ScrollTex ("Texture", 2D) = "white" {}
        _SpeedX ("Flow Rate X", Float) = 1
        _SpeedY ("Flow Rate Y", Float) = 1
        _WorldOffsetX ("World Offset X Amount", Float) = 0
        _WorldOffsetY ("World Offset Y Amount", Float) = 0
        _WorldOffsetZ ("World Offset Z Amount", Float) = 0
        [Toggle(LOCAL_SPACE_X)] _UseLocalSpaceX ("Local Space X", Float) = 0
        [Toggle(LOCAL_SPACE_Y)] _UseLocalSpaceY ("Local Space Y", Float) = 0
        [PerRendererData] _FogRotation ("Fog Rotation", Float) = 0
        [Toggle(WORLD_SCALE_FLIP)] _EnableWorldScaleFlip ("Enable World Scale Flip", Float) = 1
        [Toggle(SILHOUETTE)] _EnableSilhouette ("Is Silhouette", Float) = 0
        [Toggle(HERO_MASK)] _EnableHeroMask ("Use Hero Mask", Float) = 0
        _HeroMaskTex ("Hero Mask Texture", 2D) = "white" {}
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
            #pragma shader_feature HERO_MASK
            #pragma shader_feature INSTANCING_ON
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature SILHOUETTE
            #pragma shader_feature WORLD_SCALE_FLIP
            #pragma shader_feature LOCAL_SPACE_X
            

            #if ETC1_EXTERNAL_ALPHA && HERO_MASK && INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m03_m13 * v.vertex.wwww + tmp3.xyxy;
                tmp5 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp5 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp5;
                tmp5 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp5;
                tmp4 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp5;
                tmp0.zw = tmp4.xy / tmp4.ww;
                tmp1.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.yz;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.yz;
                o.position.xy = tmp4.ww * tmp0.zw;
                o.position.zw = tmp4.zw;
                tmp4 = v.color * _Color;
                o.color = tmp4 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp0.yz = tmp0.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp1.yz = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.yz;
                tmp0.yz = floor(tmp0.yz);
                tmp0.yz = tmp0.yz * tmp3.xy;
                tmp1.yz = tmp3.zw - _HeroWorldPos;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp2.z = _SpeedX * tmp0.z + tmp0.y;
                tmp2.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp2.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp1.yz;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && HERO_MASK && INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m03_m13 * v.vertex.wwww + tmp3.xyxy;
                tmp5 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp5 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp5;
                tmp5 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp5;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp5;
                tmp4 = v.color * _Color;
                o.color = tmp4 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp0.yz = tmp0.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp1.yz = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.yz;
                tmp0.yz = floor(tmp0.yz);
                tmp0.yz = tmp0.yz * tmp3.xy;
                tmp1.yz = tmp3.zw - _HeroWorldPos;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp2.z = _SpeedX * tmp0.z + tmp0.y;
                tmp2.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp2.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp1.yz;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif HERO_MASK && INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m03_m13 * v.vertex.wwww + tmp3.xyxy;
                tmp5 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp5 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp5;
                tmp5 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp5;
                tmp4 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp5;
                tmp0.zw = tmp4.xy / tmp4.ww;
                tmp1.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.yz;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.yz;
                o.position.xy = tmp4.ww * tmp0.zw;
                o.position.zw = tmp4.zw;
                tmp4 = v.color * _Color;
                o.color = tmp4 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp0.yz = tmp0.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp1.yz = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.yz;
                tmp0.yz = floor(tmp0.yz);
                tmp0.yz = tmp0.yz * tmp3.xy;
                tmp1.yz = tmp3.zw - _HeroWorldPos;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp2.z = _SpeedX * tmp0.z + tmp0.y;
                tmp2.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp2.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp1.yz;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && HERO_MASK && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0.xyxy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1.xy = tmp1.xy / tmp1.ww;
                tmp2.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp1.xy = round(tmp1.xy);
                tmp1.xy = tmp1.xy / tmp2.xy;
                o.position.xy = tmp1.ww * tmp1.xy;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp1.xy = tmp1.xy + unity_ObjectToWorld._m02_m12;
                tmp1.zw = tmp1.xy > float2(0.0, 0.0);
                tmp1.xy = tmp1.xy < float2(0.0, 0.0);
                tmp1.xy = tmp1.xy - tmp1.zw;
                tmp1.xy = floor(tmp1.xy);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.zw = tmp0.zw - _HeroWorldPos;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp1.x = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp1.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yz = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * tmp2.yz;
                tmp1.yz = round(tmp1.yz);
                tmp1.yz = tmp1.yz / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yz;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif HERO_MASK && INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m03_m13 * v.vertex.wwww + tmp3.xyxy;
                tmp5 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp5 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp5;
                tmp5 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp5;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp5;
                tmp4 = v.color * _Color;
                o.color = tmp4 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp0.yz = tmp0.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp1.yz = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.yz;
                tmp0.yz = floor(tmp0.yz);
                tmp0.yz = tmp0.yz * tmp3.xy;
                tmp1.yz = tmp3.zw - _HeroWorldPos;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp2.z = _SpeedX * tmp0.z + tmp0.y;
                tmp2.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp2.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp1.yz;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && HERO_MASK && SILHOUETTE && WORLD_SCALE_FLIP
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
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0.xyxy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp1.xy = tmp1.xy + unity_ObjectToWorld._m02_m12;
                tmp1.zw = tmp1.xy > float2(0.0, 0.0);
                tmp1.xy = tmp1.xy < float2(0.0, 0.0);
                tmp1.xy = tmp1.xy - tmp1.zw;
                tmp1.xy = floor(tmp1.xy);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.zw = tmp0.zw - _HeroWorldPos;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp1.x = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp1.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif HERO_MASK && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0.xyxy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1.xy = tmp1.xy / tmp1.ww;
                tmp2.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp1.xy = round(tmp1.xy);
                tmp1.xy = tmp1.xy / tmp2.xy;
                o.position.xy = tmp1.ww * tmp1.xy;
                o.position.zw = tmp1.zw;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp1.xy = tmp1.xy + unity_ObjectToWorld._m02_m12;
                tmp1.zw = tmp1.xy > float2(0.0, 0.0);
                tmp1.xy = tmp1.xy < float2(0.0, 0.0);
                tmp1.xy = tmp1.xy - tmp1.zw;
                tmp1.xy = floor(tmp1.xy);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.zw = tmp0.zw - _HeroWorldPos;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp1.x = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp1.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yz = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * tmp2.yz;
                tmp1.yz = round(tmp1.yz);
                tmp1.yz = tmp1.yz / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yz;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yz = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * tmp2.yz;
                tmp1.yz = round(tmp1.yz);
                tmp1.yz = tmp1.yz / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yz;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && LOCAL_SPACE_X && PIXELSNAP_ON
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp1.xy = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp0.z = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp1.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp1.xxxx + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1.z = unity_Builtins0Array.unity_ObjectToWorldArray._m13 * v.vertex.w + tmp3.y;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yw = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yw = tmp1.yw * tmp2.yz;
                tmp1.yw = round(tmp1.yw);
                tmp1.yw = tmp1.yw / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yw;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp1.xz, tmp3.xy);
                tmp0.z = dot(tmp1.xz, tmp3.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif HERO_MASK && SILHOUETTE && WORLD_SCALE_FLIP
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
            float4 _HeroMaskTex_ST; // 112 (starting at cb0[7].x)
            float2 _HeroWorldPos; // 96 (starting at cb0[6].x)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0.xyxy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp1.xy = tmp1.xy + unity_ObjectToWorld._m02_m12;
                tmp1.zw = tmp1.xy > float2(0.0, 0.0);
                tmp1.xy = tmp1.xy < float2(0.0, 0.0);
                tmp1.xy = tmp1.xy - tmp1.zw;
                tmp1.xy = floor(tmp1.xy);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.zw = tmp0.zw - _HeroWorldPos;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp1.x = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp1.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = float2(0.5, 0.5) / _HeroMaskTex_ST.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp0.xy = tmp0.xy - _HeroMaskTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _HeroMaskTex_ST.xy;
                return o;
            }

            #elif INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && SILHOUETTE && WORLD_SCALE_FLIP
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && LOCAL_SPACE_X
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp1.xy = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp0.z = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp1.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp1.xxxx + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1.z = unity_Builtins0Array.unity_ObjectToWorldArray._m13 * v.vertex.w + tmp3.y;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp1.xz, tmp3.xy);
                tmp0.z = dot(tmp1.xz, tmp3.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yz = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * tmp2.yz;
                tmp1.yz = round(tmp1.yz);
                tmp1.yz = tmp1.yz / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yz;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && LOCAL_SPACE_X && PIXELSNAP_ON
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp1.xy = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp0.z = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp1.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp1.xxxx + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1.z = unity_Builtins0Array.unity_ObjectToWorldArray._m13 * v.vertex.w + tmp3.y;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yw = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yw = tmp1.yw * tmp2.yz;
                tmp1.yw = round(tmp1.yw);
                tmp1.yw = tmp1.yw / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yw;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp1.xz, tmp3.xy);
                tmp0.z = dot(tmp1.xz, tmp3.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && WORLD_SCALE_FLIP
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LOCAL_SPACE_X && PIXELSNAP_ON
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.y = unity_ObjectToWorld._m13 * v.vertex.w + tmp0.y;
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
                tmp0.x = v.vertex.x;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yz = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * tmp2.yz;
                tmp1.yz = round(tmp1.yz);
                tmp1.yz = tmp1.yz / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yz;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = tmp0.x;
                tmp1.y = tmp2.x;
                tmp1.x = -tmp0.x;
                tmp0.x = dot(tmp0.zw, tmp1.xy);
                tmp0.z = dot(tmp0.zw, tmp1.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
                o.texcoord1.xy = tmp0.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif SILHOUETTE && WORLD_SCALE_FLIP
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && WORLD_SCALE_FLIP
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp1.yz = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10 + unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11;
                tmp1.yz = tmp1.yz + unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12;
                tmp2.yz = tmp1.yz > float2(0.0, 0.0);
                tmp1.yz = tmp1.yz < float2(0.0, 0.0);
                tmp1.yz = tmp1.yz - tmp2.yz;
                tmp1.yz = floor(tmp1.yz);
                tmp0.yz = tmp0.zw * tmp1.yz;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp0.yz, tmp3.xy);
                tmp0.y = dot(tmp0.yz, tmp3.yz);
                tmp0.z = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.z = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.z = tmp0.z + _Time.y;
                tmp1.z = _SpeedX * tmp0.z + tmp0.y;
                tmp1.w = _SpeedY * tmp0.z + tmp0.x;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif INSTANCING_ON && LOCAL_SPACE_X
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp1.xy = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp0.z = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp1.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp1.xxxx + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1.z = unity_Builtins0Array.unity_ObjectToWorldArray._m13 * v.vertex.w + tmp3.y;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp3.z = tmp0.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp0.x;
                tmp0.x = dot(tmp1.xz, tmp3.xy);
                tmp0.z = dot(tmp1.xz, tmp3.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LOCAL_SPACE_X
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.y = unity_ObjectToWorld._m13 * v.vertex.w + tmp0.y;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp0.x = v.vertex.x;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = tmp0.x;
                tmp1.y = tmp2.x;
                tmp1.x = -tmp0.x;
                tmp0.x = dot(tmp0.zw, tmp1.xy);
                tmp0.z = dot(tmp0.zw, tmp1.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif LOCAL_SPACE_X && PIXELSNAP_ON
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.y = unity_ObjectToWorld._m13 * v.vertex.w + tmp0.y;
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
                tmp0.x = v.vertex.x;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp1.yz = tmp3.xy / tmp3.ww;
                tmp2.yz = _ScreenParams.xy * float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * tmp2.yz;
                tmp1.yz = round(tmp1.yz);
                tmp1.yz = tmp1.yz / tmp2.yz;
                o.position.xy = tmp3.ww * tmp1.yz;
                o.position.zw = tmp3.zw;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = tmp0.x;
                tmp1.y = tmp2.x;
                tmp1.x = -tmp0.x;
                tmp0.x = dot(tmp0.zw, tmp1.xy);
                tmp0.z = dot(tmp0.zw, tmp1.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif LOCAL_SPACE_X
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.y = unity_ObjectToWorld._m13 * v.vertex.w + tmp0.y;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp0.x = v.vertex.x;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 1);
                tmp0.zw = v.vertex.xy * PerDrawSpriteArray.unity_SpriteFlipArray;
                tmp1.x = float1(int1(tmp0.x) << 3);
                tmp0.x = sin(PropsArray._FogRotation);
                tmp2.x = cos(PropsArray._FogRotation);
                tmp3 = tmp0.wwww * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * tmp0.zzzz + tmp3;
                tmp3 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp3;
                tmp4 = tmp3 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp0.zw = unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13 * v.vertex.ww + tmp3.xy;
                tmp3 = tmp4.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp4.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp4.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp4.wwww + tmp3;
                tmp3 = v.color * _Color;
                o.color = tmp3 * PerDrawSpriteArray.unity_SpriteRendererColorArray;
                tmp0.y = dot(unity_Builtins0Array.unity_ObjectToWorldArray._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_Builtins0Array.unity_ObjectToWorldArray._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = tmp0.x;
                tmp1.y = tmp2.x;
                tmp1.x = -tmp0.x;
                tmp0.x = dot(tmp0.zw, tmp1.xy);
                tmp0.z = dot(tmp0.zw, tmp1.yz);
                tmp0.z = _SpeedX * tmp0.y + tmp0.z;
                tmp0.w = _SpeedY * tmp0.y + tmp0.x;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
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
            float _SpeedX; // 48 (starting at cb0[3].x)
            float _SpeedY; // 52 (starting at cb0[3].y)
            float _WorldOffsetY; // 56 (starting at cb0[3].z)
            float _WorldOffsetX; // 60 (starting at cb0[3].w)
            float _WorldOffsetZ; // 64 (starting at cb0[4].x)
            float4 _ScrollTex_ST; // 80 (starting at cb0[5].x)
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp0.x = dot(tmp0.xy, tmp3.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp1.z = _SpeedX * tmp0.y + tmp0.x;
                tmp1.w = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord1.xy = tmp1.zw * _ScrollTex_ST.xy + _ScrollTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if ETC1_EXTERNAL_ALPHA && HERO_MASK && INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 3
            sampler2D _AlphaTex; // 1
            sampler2D _ScrollTex; // 2
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.x = tmp1.x - tmp0.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp0.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && HERO_MASK && INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 0 (starting at cb1[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 3
            sampler2D _AlphaTex; // 1
            sampler2D _ScrollTex; // 2
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.x = tmp1.x - tmp0.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp0.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif HERO_MASK && INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 2
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && HERO_MASK && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 3
            sampler2D _AlphaTex; // 1
            sampler2D _ScrollTex; // 2
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.x = tmp1.x - tmp0.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp0.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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
                tmp0.x = tmp0.x - tmp1.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif HERO_MASK && INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 2
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && HERO_MASK && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 3
            sampler2D _AlphaTex; // 1
            sampler2D _ScrollTex; // 2
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.x = tmp1.x - tmp0.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp0.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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
                tmp0.x = tmp0.x - tmp1.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif HERO_MASK && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 2
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                tmp0.x = tmp0.x - tmp1.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && LOCAL_SPACE_X && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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

            #elif HERO_MASK && SILHOUETTE && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeroPlayMode; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 2
            sampler2D _ScrollTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_HeroMaskTex, inp.texcoord2.xy);
                    tmp0.w = tmp0.w * tmp1.x;
                }
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target = tmp0;
                return o;
            }

            #elif INSTANCING_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && SILHOUETTE && WORLD_SCALE_FLIP
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
                tmp0.x = tmp0.x - tmp1.w;
                tmp0.x = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0.x = tmp0.x * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && WORLD_SCALE_FLIP
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && LOCAL_SPACE_X
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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

            #elif PIXELSNAP_ON && SILHOUETTE && WORLD_SCALE_FLIP
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
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif INSTANCING_ON && PIXELSNAP_ON && WORLD_SCALE_FLIP
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

            #elif INSTANCING_ON && LOCAL_SPACE_X && PIXELSNAP_ON
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

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && WORLD_SCALE_FLIP
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

            #elif ETC1_EXTERNAL_ALPHA && LOCAL_SPACE_X && PIXELSNAP_ON
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

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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

            #elif SILHOUETTE && WORLD_SCALE_FLIP
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
                tmp0.x = tmp0.w * inp.color.w;
                tmp1 = tex2D(_ScrollTex, inp.texcoord1.xy);
                tmp0 = tmp0.xxxx * tmp1.wxyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif INSTANCING_ON && WORLD_SCALE_FLIP
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

            #elif INSTANCING_ON && LOCAL_SPACE_X
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

            #elif ETC1_EXTERNAL_ALPHA && LOCAL_SPACE_X
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

            #elif ETC1_EXTERNAL_ALPHA && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerDrawSprite) // 0
                float _EnableExternalAlpha; // 0 (starting at cb0[0].x)
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

            #elif LOCAL_SPACE_X && PIXELSNAP_ON
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

            #elif INSTANCING_ON && PIXELSNAP_ON
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

            #elif LOCAL_SPACE_X
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

            #elif INSTANCING_ON
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
