Shader "Hollow Knight/Grass-Diffuse" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        _SwaySpeed ("SwaySpeed", Float) = 1
        _SwayAmount ("Sway Amount", Float) = 1
        _WorldOffset ("World Offset", Float) = 1
        _HeightOffset ("Height Offset", Float) = 0
        _ClampZ ("Clamp Z Position", Float) = 1
        [PerRendererData] _PushAmount ("Push Amount (Player)", Float) = 0
        [PerRendererData] _SwayMultiplier ("Sway Multiplier (Extra)", Float) = 1
        [Toggle(PIN_TYPE)] _IsPinnedType ("Is Pinned Type", Float) = 0
        _MaxPinY ("Max Pin Y", Float) = 1
        _MinPinY ("Min Pin Y", Float) = -1
        _MaxPinX ("Max Pin X", Float) = 1
        _MinPinX ("Min Pin X", Float) = -1
        _PinMask ("Pin Mask", 2D) = "white" {}
        [Toggle(FRAMERATE_SNAPPING)] _EnableFramerateSnapping ("Enable Framerate Snapping", Float) = 0
        _SnappedFramerate ("Snapped Framerate", Float) = 12
        [Toggle(SWAP_XY)] _SwapXY ("Sway X & Y", Float) = 0
        [Space] [Toggle(SATURATION_LERP)] _SaturationLerpEnabled ("Enable Saturation Lerp", Float) = 0
        _SaturationLerp ("Saturation Lerp", Float) = 1
        [HideInInspector] _MagnitudeMultA ("", Float) = 1
        [HideInInspector] _TimeMultA ("", Float) = 1
        [HideInInspector] _MagnitudeMultB ("", Float) = 1
        [HideInInspector] _TimeMultB ("", Float) = 1
        [HideInInspector] _MagnitudeMultC ("", Float) = 1
        [HideInInspector] _TimeMultC ("", Float) = 1
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

            #pragma shader_feature CUSTOM_FUNC
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature FRAMERATE_SNAPPING
            #pragma shader_feature PIN_TYPE
            #pragma shader_feature SWAP_XY
            

            #if CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING && PIN_TYPE && SWAP_XY
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
            float _TimeMultC; // 108 (starting at cb0[6].w)
            float _MagnitudeMultC; // 104 (starting at cb0[6].z)
            float _TimeMultB; // 100 (starting at cb0[6].y)
            float _MagnitudeMultB; // 96 (starting at cb0[6].x)
            float _TimeMultA; // 92 (starting at cb0[5].w)
            float _MaxPinY; // 68 (starting at cb0[4].y)
            float _MinPinY; // 72 (starting at cb0[4].z)
            float _MaxPinX; // 76 (starting at cb0[4].w)
            float _MinPinX; // 80 (starting at cb0[5].x)
            float _SnappedFramerate; // 84 (starting at cb0[5].y)
            float _MagnitudeMultA; // 88 (starting at cb0[5].z)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40
            sampler2D _PinMask; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = _MaxPinX - _MinPinX;
                tmp0.zw = float2(_MaxPinY.x, _MaxPinX.x) - v.vertex.xy;
                tmp1.x = tmp0.z / tmp0.y;
                tmp0.y = _MaxPinY - _MinPinY;
                tmp1.y = tmp0.w / tmp0.y;
                tmp1 = tex2Dlod(_PinMask, float4(tmp1.xy, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.y = tmp0.x * tmp0.y + v.vertex.y;
                tmp0.x = v.vertex.x;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif CUSTOM_FUNC && FRAMERATE_SNAPPING && PIN_TYPE && SWAP_XY
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
            float _TimeMultC; // 108 (starting at cb0[6].w)
            float _MagnitudeMultC; // 104 (starting at cb0[6].z)
            float _TimeMultB; // 100 (starting at cb0[6].y)
            float _MagnitudeMultB; // 96 (starting at cb0[6].x)
            float _TimeMultA; // 92 (starting at cb0[5].w)
            float _MaxPinY; // 68 (starting at cb0[4].y)
            float _MinPinY; // 72 (starting at cb0[4].z)
            float _MaxPinX; // 76 (starting at cb0[4].w)
            float _MinPinX; // 80 (starting at cb0[5].x)
            float _SnappedFramerate; // 84 (starting at cb0[5].y)
            float _MagnitudeMultA; // 88 (starting at cb0[5].z)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40
            sampler2D _PinMask; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = _MaxPinX - _MinPinX;
                tmp0.zw = float2(_MaxPinY.x, _MaxPinX.x) - v.vertex.xy;
                tmp1.x = tmp0.z / tmp0.y;
                tmp0.y = _MaxPinY - _MinPinY;
                tmp1.y = tmp0.w / tmp0.y;
                tmp1 = tex2Dlod(_PinMask, float4(tmp1.xy, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.y = tmp0.x * tmp0.y + v.vertex.y;
                tmp0.x = v.vertex.x;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING && PIN_TYPE
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
            float _SnappedFramerate; // 84 (starting at cb0[5].y)
            float _MinPinX; // 80 (starting at cb0[5].x)
            float _MaxPinX; // 76 (starting at cb0[4].w)
            float _MinPinY; // 72 (starting at cb0[4].z)
            float _MaxPinY; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40
            sampler2D _PinMask; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = _MaxPinX - _MinPinX;
                tmp0.zw = float2(_MaxPinX.x, _MaxPinY.x) - v.vertex.xy;
                tmp1.x = tmp0.z / tmp0.y;
                tmp0.y = _MaxPinY - _MinPinY;
                tmp1.y = tmp0.w / tmp0.y;
                tmp1 = tex2Dlod(_PinMask, float4(tmp1.xy, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING
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
            float _TimeMultC; // 92 (starting at cb0[5].w)
            float _MagnitudeMultC; // 88 (starting at cb0[5].z)
            float _TimeMultB; // 84 (starting at cb0[5].y)
            float _MagnitudeMultB; // 80 (starting at cb0[5].x)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _TimeMultA; // 76 (starting at cb0[4].w)
            float _SnappedFramerate; // 68 (starting at cb0[4].y)
            float _MagnitudeMultA; // 72 (starting at cb0[4].z)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif FRAMERATE_SNAPPING && PIN_TYPE
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
            float _SnappedFramerate; // 84 (starting at cb0[5].y)
            float _MinPinX; // 80 (starting at cb0[5].x)
            float _MaxPinX; // 76 (starting at cb0[4].w)
            float _MinPinY; // 72 (starting at cb0[4].z)
            float _MaxPinY; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40
            sampler2D _PinMask; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = _MaxPinX - _MinPinX;
                tmp0.zw = float2(_MaxPinX.x, _MaxPinY.x) - v.vertex.xy;
                tmp1.x = tmp0.z / tmp0.y;
                tmp0.y = _MaxPinY - _MinPinY;
                tmp1.y = tmp0.w / tmp0.y;
                tmp1 = tex2Dlod(_PinMask, float4(tmp1.xy, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif CUSTOM_FUNC && FRAMERATE_SNAPPING
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
            float _TimeMultC; // 92 (starting at cb0[5].w)
            float _MagnitudeMultC; // 88 (starting at cb0[5].z)
            float _TimeMultB; // 84 (starting at cb0[5].y)
            float _MagnitudeMultB; // 80 (starting at cb0[5].x)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _TimeMultA; // 76 (starting at cb0[4].w)
            float _SnappedFramerate; // 68 (starting at cb0[4].y)
            float _MagnitudeMultA; // 72 (starting at cb0[4].z)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif ETC1_EXTERNAL_ALPHA && PIN_TYPE
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
            float _MinPinX; // 80 (starting at cb0[5].x)
            float _MaxPinX; // 76 (starting at cb0[4].w)
            float _MinPinY; // 72 (starting at cb0[4].z)
            float _MaxPinY; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40
            sampler2D _PinMask; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = _MaxPinX - _MinPinX;
                tmp0.zw = float2(_MaxPinX.x, _MaxPinY.x) - v.vertex.xy;
                tmp1.x = tmp0.z / tmp0.y;
                tmp0.y = _MaxPinY - _MinPinY;
                tmp1.y = tmp0.w / tmp0.y;
                tmp1 = tex2Dlod(_PinMask, float4(tmp1.xy, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING
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
            float _SnappedFramerate; // 68 (starting at cb0[4].y)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA
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
            float _TimeMultC; // 88 (starting at cb0[5].z)
            float _MagnitudeMultC; // 84 (starting at cb0[5].y)
            float _TimeMultB; // 80 (starting at cb0[5].x)
            float _MagnitudeMultB; // 76 (starting at cb0[4].w)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _TimeMultA; // 72 (starting at cb0[4].z)
            float _MagnitudeMultA; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif PIN_TYPE
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
            float _MinPinX; // 80 (starting at cb0[5].x)
            float _MaxPinX; // 76 (starting at cb0[4].w)
            float _MinPinY; // 72 (starting at cb0[4].z)
            float _MaxPinY; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40
            sampler2D _PinMask; // 0

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = _MaxPinX - _MinPinX;
                tmp0.zw = float2(_MaxPinX.x, _MaxPinY.x) - v.vertex.xy;
                tmp1.x = tmp0.z / tmp0.y;
                tmp0.y = _MaxPinY - _MinPinY;
                tmp1.y = tmp0.w / tmp0.y;
                tmp1 = tex2Dlod(_PinMask, float4(tmp1.xy, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif FRAMERATE_SNAPPING
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
            float _SnappedFramerate; // 68 (starting at cb0[4].y)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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

            #elif CUSTOM_FUNC
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
            float _TimeMultC; // 88 (starting at cb0[5].z)
            float _MagnitudeMultC; // 84 (starting at cb0[5].y)
            float _TimeMultB; // 80 (starting at cb0[5].x)
            float _MagnitudeMultB; // 76 (starting at cb0[4].w)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _TimeMultA; // 72 (starting at cb0[4].z)
            float _MagnitudeMultA; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb4[1].x)
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = unity_ObjectToWorld._m10 + unity_ObjectToWorld._m11;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m12;
                tmp0.y = _HeightOffset * tmp0.y + v.vertex.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(-_ClampZ, unity_ObjectToWorld._m23);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp0.y = v.vertex.y;
                tmp0.xy = tmp0.xy * _Flip;
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


            #if CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING && PIN_TYPE && SWAP_XY
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CUSTOM_FUNC && FRAMERATE_SNAPPING && PIN_TYPE && SWAP_XY
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING && PIN_TYPE
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif FRAMERATE_SNAPPING && PIN_TYPE
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CUSTOM_FUNC && FRAMERATE_SNAPPING
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIN_TYPE
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif PIN_TYPE
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif FRAMERATE_SNAPPING
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif CUSTOM_FUNC
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
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
                float4 tmp2;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp2;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
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
                float4 tmp1;
                tmp0.xyz = inp.color.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = inp.color.w;
                tmp0 = tmp0 * tmp1;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Sprites/Diffuse"
}
