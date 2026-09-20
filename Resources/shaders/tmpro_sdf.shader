// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TextMeshPro/Distance Field" {
    Properties {
        _FaceTex ("Face Texture", 2D) = "white" {}
        _FaceUVSpeedX ("Face UV Speed X", Range(-5, 5)) = 0
        _FaceUVSpeedY ("Face UV Speed Y", Range(-5, 5)) = 0
        _FaceColor ("Face Color", Color) = (1, 1, 1, 1)
        _FaceDilate ("Face Dilate", Range(-1, 1)) = 0
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineTex ("Outline Texture", 2D) = "white" {}
        _OutlineUVSpeedX ("Outline UV Speed X", Range(-5, 5)) = 0
        _OutlineUVSpeedY ("Outline UV Speed Y", Range(-5, 5)) = 0
        _OutlineWidth ("Outline Thickness", Range(0, 1)) = 0
        _OutlineSoftness ("Outline Softness", Range(0, 1)) = 0
        _Bevel ("Bevel", Range(0, 1)) = 0.5
        _BevelOffset ("Bevel Offset", Range(-0.5, 0.5)) = 0
        _BevelWidth ("Bevel Width", Range(-0.5, 0.5)) = 0
        _BevelClamp ("Bevel Clamp", Range(0, 1)) = 0
        _BevelRoundness ("Bevel Roundness", Range(0, 1)) = 0
        _LightAngle ("Light Angle", Range(0, 6.2831855)) = 3.1416
        _SpecularColor ("Specular", Color) = (1, 1, 1, 1)
        _SpecularPower ("Specular", Range(0, 4)) = 2
        _Reflectivity ("Reflectivity", Range(5, 15)) = 10
        _Diffuse ("Diffuse", Range(0, 1)) = 0.5
        _Ambient ("Ambient", Range(1, 0)) = 0.5
        _BumpMap ("Normal map", 2D) = "bump" {}
        _BumpOutline ("Bump Outline", Range(0, 1)) = 0
        _BumpFace ("Bump Face", Range(0, 1)) = 0
        _ReflectFaceColor ("Reflection Color", Color) = (0, 0, 0, 1)
        _ReflectOutlineColor ("Reflection Color", Color) = (0, 0, 0, 1)
        _Cube ("Reflection Cubemap", Cube) = "black" {}
        _EnvMatrixRotation ("Texture Rotation", Vector) = (0, 0, 0, 0)
        _UnderlayColor ("Border Color", Color) = (0, 0, 0, 0.5)
        _UnderlayOffsetX ("Border OffsetX", Range(-1, 1)) = 0
        _UnderlayOffsetY ("Border OffsetY", Range(-1, 1)) = 0
        _UnderlayDilate ("Border Dilate", Range(-1, 1)) = 0
        _UnderlaySoftness ("Border Softness", Range(0, 1)) = 0
        _GlowColor ("Color", Color) = (0, 1, 0, 0.5)
        _GlowOffset ("Offset", Range(-1, 1)) = 0
        _GlowInner ("Inner", Range(0, 1)) = 0.05
        _GlowOuter ("Outer", Range(0, 1)) = 0.05
        _GlowPower ("Falloff", Range(1, 0)) = 0.75
        _WeightNormal ("Weight Normal", Float) = 0
        _WeightBold ("Weight Bold", Float) = 0.5
        _ShaderFlags ("Flags", Float) = 0
        _ScaleRatioA ("Scale RatioA", Float) = 1
        _ScaleRatioB ("Scale RatioB", Float) = 1
        _ScaleRatioC ("Scale RatioC", Float) = 1
        _MainTex ("Font Atlas", 2D) = "white" {}
        _TextureWidth ("Texture Width", Float) = 512
        _TextureHeight ("Texture Height", Float) = 512
        _GradientScale ("Gradient Scale", Float) = 5
        _ScaleX ("Scale X", Float) = 1
        _ScaleY ("Scale Y", Float) = 1
        _PerspectiveFilter ("Perspective Correction", Range(0, 1)) = 0.875
        _VertexOffsetX ("Vertex OffsetX", Float) = 0
        _VertexOffsetY ("Vertex OffsetY", Float) = 0
        _MaskCoord ("Mask Coordinates", Vector) = (0, 0, 10000, 10000)
        _ClipRect ("Clip Rect", Vector) = (-10000, -10000, 10000, 10000)
        _MaskSoftnessX ("Mask SoftnessX", Float) = 0
        _MaskSoftnessY ("Mask SoftnessY", Float) = 0
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }
    SubShader {
        Tags {
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name ""
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
            ColorMask 0
            ZClip On
            ZWrite Off
            Cull Off
            Stencil {
                ReadMask 0
                WriteMask 0
            }
            Fog {
                Mode Off
            }
            Tags {
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature GLOW_ON
            #pragma shader_feature UNDERLAY_ON
            

            #if GLOW_ON && UNDERLAY_ON // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 color1 : COLOR1;
            };

            // CBs for DX11VertexSM40
            float _TextureHeight; // 444 (starting at cb0[27].w)
            float _TextureWidth; // 440 (starting at cb0[27].z)
            float _ScaleRatioB; // 368 (starting at cb0[23].x)
            float4 _UnderlayColor; // 288 (starting at cb0[18].x)
            float _UnderlayOffsetX; // 304 (starting at cb0[19].x)
            float _UnderlayOffsetY; // 308 (starting at cb0[19].y)
            float _UnderlayDilate; // 312 (starting at cb0[19].z)
            float _UnderlaySoftness; // 316 (starting at cb0[19].w)
            float _GlowOffset; // 336 (starting at cb0[21].x)
            float _GlowOuter; // 340 (starting at cb0[21].y)
            float _ScaleRatioC; // 372 (starting at cb0[23].y)
            float4x4 _EnvMatrix; // 176 (starting at cb0[11].x)
            float _FaceDilate; // 64 (starting at cb0[4].x)
            float _OutlineSoftness; // 68 (starting at cb0[4].y)
            float _OutlineWidth; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 356 (starting at cb0[22].y)
            float _WeightBold; // 360 (starting at cb0[22].z)
            float _ScaleRatioA; // 364 (starting at cb0[22].w)
            float _VertexOffsetX; // 376 (starting at cb0[23].z)
            float _VertexOffsetY; // 380 (starting at cb0[23].w)
            float4 _ClipRect; // 416 (starting at cb0[26].x)
            float _MaskSoftnessX; // 432 (starting at cb0[27].x)
            float _MaskSoftnessY; // 436 (starting at cb0[27].y)
            float _GradientScale; // 448 (starting at cb0[28].x)
            float _ScaleX; // 452 (starting at cb0[28].y)
            float _ScaleY; // 456 (starting at cb0[28].z)
            float _PerspectiveFilter; // 460 (starting at cb0[28].w)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.position = tmp2;
                o.color = v.color;
                tmp0.z = v.texcoord1.x * 0.00024414;
                tmp0.z = floor(tmp0.z);
                tmp0.w = -tmp0.z * 4096.0 + v.texcoord1.x;
                o.texcoord.zw = tmp0.zw * float2(0.00195313, 0.00195313);
                o.texcoord.xy = v.texcoord.xy;
                tmp0.z = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp0.z = -_OutlineSoftness * _ScaleRatioA + tmp0.z;
                tmp0.w = -_GlowOffset * _ScaleRatioB + 1.0;
                tmp0.w = -_GlowOuter * _ScaleRatioB + tmp0.w;
                tmp0.z = min(tmp0.w, tmp0.z);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = abs(tmp2.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp2.ww / tmp2.xy;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp2.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp2.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp2.xy;
                tmp1.w = rsqrt(tmp1.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.x = tmp1.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.y = tmp2.y * abs(tmp2.x);
                tmp1.w = tmp1.w * 1.5 + -tmp2.y;
                tmp0.w = abs(tmp0.w) * tmp1.w + tmp2.y;
                tmp1.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp2.y = tmp1.w ? tmp0.w : tmp2.x;
                tmp0.w = 0.5 / tmp2.y;
                tmp0.z = tmp0.z * 0.5 + -tmp0.w;
                tmp1.w = v.texcoord1.y <= 0.0;
                tmp1.w = uint1(tmp1.w) & uint1(1);
                tmp2.x = _WeightBold - _WeightNormal;
                tmp1.w = tmp1.w * tmp2.x + _WeightNormal;
                tmp1.w = tmp1.w / _GradientScale;
                tmp2.x = _FaceDilate * _ScaleRatioA;
                tmp2.w = tmp2.x * 0.5 + tmp1.w;
                o.texcoord1.x = tmp0.z - tmp2.w;
                o.texcoord1.yw = tmp2.yw;
                tmp0.z = 0.5 - tmp2.w;
                o.texcoord1.z = tmp0.w + tmp0.z;
                tmp3 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp3 = min(tmp3, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp3.xy;
                o.texcoord2.xy = tmp0.xy - tmp3.zw;
                tmp0.xyw = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyw = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp0.xyw;
                o.texcoord3.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp0.xyw;
                tmp1 = float4(_UnderlayOffsetX.x, _UnderlayOffsetY.x, _UnderlayDilate.x, _UnderlaySoftness.x) * _ScaleRatioC.xxxx;
                tmp0.x = tmp1.x * tmp2.y + 1.0;
                tmp0.x = tmp2.y / tmp0.x;
                tmp0.y = tmp0.z * tmp0.x + -0.5;
                tmp0.z = tmp0.x * tmp1.y;
                tmp1.xy = -tmp1.zw * _GradientScale.xx;
                tmp1.xy = tmp1.xy / float2(_TextureHeight.x, _TextureWidth.x);
                o.texcoord4.xy = tmp1.xy + v.texcoord.xy;
                o.texcoord4.z = tmp0.x;
                o.texcoord4.w = -tmp0.z * 0.5 + tmp0.y;
                o.color1.xyz = _UnderlayColor.www * _UnderlayColor.xyz;
                o.color1.w = _UnderlayColor.w;
                return o;
            }

            #elif UNDERLAY_ON // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 color1 : COLOR1;
            };

            // CBs for DX11VertexSM40
            float _ScaleRatioC; // 372 (starting at cb0[23].y)
            float _TextureHeight; // 444 (starting at cb0[27].w)
            float _TextureWidth; // 440 (starting at cb0[27].z)
            float4 _UnderlayColor; // 288 (starting at cb0[18].x)
            float _UnderlayOffsetX; // 304 (starting at cb0[19].x)
            float _UnderlayOffsetY; // 308 (starting at cb0[19].y)
            float _UnderlayDilate; // 312 (starting at cb0[19].z)
            float _UnderlaySoftness; // 316 (starting at cb0[19].w)
            float4x4 _EnvMatrix; // 176 (starting at cb0[11].x)
            float _FaceDilate; // 64 (starting at cb0[4].x)
            float _OutlineSoftness; // 68 (starting at cb0[4].y)
            float _OutlineWidth; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 356 (starting at cb0[22].y)
            float _WeightBold; // 360 (starting at cb0[22].z)
            float _ScaleRatioA; // 364 (starting at cb0[22].w)
            float _VertexOffsetX; // 376 (starting at cb0[23].z)
            float _VertexOffsetY; // 380 (starting at cb0[23].w)
            float4 _ClipRect; // 416 (starting at cb0[26].x)
            float _MaskSoftnessX; // 432 (starting at cb0[27].x)
            float _MaskSoftnessY; // 436 (starting at cb0[27].y)
            float _GradientScale; // 448 (starting at cb0[28].x)
            float _ScaleX; // 452 (starting at cb0[28].y)
            float _ScaleY; // 456 (starting at cb0[28].z)
            float _PerspectiveFilter; // 460 (starting at cb0[28].w)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.position = tmp2;
                o.color = v.color;
                tmp0.z = v.texcoord1.x * 0.00024414;
                tmp0.z = floor(tmp0.z);
                tmp0.w = -tmp0.z * 4096.0 + v.texcoord1.x;
                o.texcoord.zw = tmp0.zw * float2(0.00195313, 0.00195313);
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = dot(tmp2.xyz, tmp3.xyz);
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = abs(tmp2.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp2.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp2.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp2.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp2.xy;
                tmp0.w = rsqrt(tmp0.w);
                tmp1.w = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.w * 1.5;
                tmp2.x = 1.0 - _PerspectiveFilter;
                tmp2.x = abs(tmp1.w) * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp2.x;
                tmp0.z = abs(tmp0.z) * tmp0.w + tmp2.x;
                tmp0.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp2.y = tmp0.w ? tmp0.z : tmp1.w;
                tmp0.z = v.texcoord1.y <= 0.0;
                tmp0.z = uint1(tmp0.z) & uint1(1);
                tmp0.w = _WeightBold - _WeightNormal;
                tmp0.z = tmp0.z * tmp0.w + _WeightNormal;
                tmp0.z = tmp0.z / _GradientScale;
                tmp0.w = _FaceDilate * _ScaleRatioA;
                tmp2.w = tmp0.w * 0.5 + tmp0.z;
                o.texcoord1.yw = tmp2.yw;
                tmp0.z = 0.5 / tmp2.y;
                tmp0.w = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp0.w = -_OutlineSoftness * _ScaleRatioA + tmp0.w;
                tmp0.w = tmp0.w * 0.5 + -tmp0.z;
                o.texcoord1.x = tmp0.w - tmp2.w;
                tmp0.w = 0.5 - tmp2.w;
                o.texcoord1.z = tmp0.z + tmp0.w;
                tmp3 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp3 = min(tmp3, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp3.xy;
                o.texcoord2.xy = tmp0.xy - tmp3.zw;
                tmp0.xyz = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp0.xyz;
                o.texcoord3.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp0.xyz;
                tmp1 = float4(_UnderlayOffsetX.x, _UnderlayOffsetY.x, _UnderlayDilate.x, _UnderlaySoftness.x) * _ScaleRatioC.xxxx;
                tmp0.x = tmp1.x * tmp2.y + 1.0;
                tmp0.x = tmp2.y / tmp0.x;
                tmp0.y = tmp0.w * tmp0.x + -0.5;
                tmp0.z = tmp0.x * tmp1.y;
                tmp1.xy = -tmp1.zw * _GradientScale.xx;
                tmp1.xy = tmp1.xy / float2(_TextureHeight.x, _TextureWidth.x);
                o.texcoord4.xy = tmp1.xy + v.texcoord.xy;
                o.texcoord4.z = tmp0.x;
                o.texcoord4.w = -tmp0.z * 0.5 + tmp0.y;
                o.color1.xyz = _UnderlayColor.www * _UnderlayColor.xyz;
                o.color1.w = _UnderlayColor.w;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };

            // CBs for DX11VertexSM40
            float4x4 _EnvMatrix; // 176 (starting at cb0[11].x)
            float _FaceDilate; // 64 (starting at cb0[4].x)
            float _OutlineSoftness; // 68 (starting at cb0[4].y)
            float _OutlineWidth; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 356 (starting at cb0[22].y)
            float _WeightBold; // 360 (starting at cb0[22].z)
            float _ScaleRatioA; // 364 (starting at cb0[22].w)
            float _VertexOffsetX; // 376 (starting at cb0[23].z)
            float _VertexOffsetY; // 380 (starting at cb0[23].w)
            float4 _ClipRect; // 416 (starting at cb0[26].x)
            float _MaskSoftnessX; // 432 (starting at cb0[27].x)
            float _MaskSoftnessY; // 436 (starting at cb0[27].y)
            float _GradientScale; // 448 (starting at cb0[28].x)
            float _ScaleX; // 452 (starting at cb0[28].y)
            float _ScaleY; // 456 (starting at cb0[28].z)
            float _PerspectiveFilter; // 460 (starting at cb0[28].w)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.position = tmp2;
                o.color = v.color;
                tmp0.z = v.texcoord1.x * 0.00024414;
                tmp0.z = floor(tmp0.z);
                tmp0.w = -tmp0.z * 4096.0 + v.texcoord1.x;
                o.texcoord.zw = tmp0.zw * float2(0.00195313, 0.00195313);
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = dot(tmp2.xyz, tmp3.xyz);
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = abs(tmp2.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp2.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp2.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp2.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp2.xy;
                tmp0.w = rsqrt(tmp0.w);
                tmp1.w = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.w * 1.5;
                tmp2.x = 1.0 - _PerspectiveFilter;
                tmp2.x = abs(tmp1.w) * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp2.x;
                tmp0.z = abs(tmp0.z) * tmp0.w + tmp2.x;
                tmp0.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp2.y = tmp0.w ? tmp0.z : tmp1.w;
                tmp0.z = v.texcoord1.y <= 0.0;
                tmp0.z = uint1(tmp0.z) & uint1(1);
                tmp0.w = _WeightBold - _WeightNormal;
                tmp0.z = tmp0.z * tmp0.w + _WeightNormal;
                tmp0.z = tmp0.z / _GradientScale;
                tmp0.w = _FaceDilate * _ScaleRatioA;
                tmp2.w = tmp0.w * 0.5 + tmp0.z;
                o.texcoord1.yw = tmp2.yw;
                tmp0.z = 0.5 / tmp2.y;
                tmp0.w = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp0.w = -_OutlineSoftness * _ScaleRatioA + tmp0.w;
                tmp0.w = tmp0.w * 0.5 + -tmp0.z;
                o.texcoord1.x = tmp0.w - tmp2.w;
                tmp0.w = 0.5 - tmp2.w;
                o.texcoord1.z = tmp0.z + tmp0.w;
                tmp2 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp2 = min(tmp2, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp2.xy;
                o.texcoord2.xy = tmp0.xy - tmp2.zw;
                tmp0.xyz = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp0.xyz;
                o.texcoord3.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp0.xyz;
                return o;
            }
            #endif


            #if GLOW_ON && UNDERLAY_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _GlowColor; // 320 (starting at cb0[20].x)
            float _GlowPower; // 348 (starting at cb0[21].w)
            float _GlowInner; // 344 (starting at cb0[21].z)
            float _FaceUVSpeedX; // 32 (starting at cb0[2].x)
            float _FaceUVSpeedY; // 36 (starting at cb0[2].y)
            float4 _FaceColor; // 48 (starting at cb0[3].x)
            float _OutlineUVSpeedX; // 72 (starting at cb0[4].z)
            float _OutlineUVSpeedY; // 76 (starting at cb0[4].w)
            float4 _OutlineColor; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp0 = tex2D(_OutlineTex, tmp0.xy);
                tmp0 = tmp0 * _OutlineColor;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = inp.color.xyz * _FaceColor.xyz;
                tmp2.xy = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp2 = tex2D(_FaceTex, tmp2.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.w = tmp2.w * _FaceColor.w;
                tmp2.xyz = tmp1.xyz * tmp2.www;
                tmp0 = tmp0 - tmp2;
                tmp1.x = _OutlineWidth * _ScaleRatioA;
                tmp1.x = tmp1.x * inp.texcoord1.y;
                tmp1.y = min(tmp1.x, 1.0);
                tmp1.x = tmp1.x * 0.5;
                tmp1.y = sqrt(tmp1.y);
                tmp3 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.z = inp.texcoord1.z - tmp3.w;
                tmp1.w = saturate(tmp1.z * inp.texcoord1.y + tmp1.x);
                tmp1.x = tmp1.z * inp.texcoord1.y + -tmp1.x;
                tmp1.y = tmp1.y * tmp1.w;
                tmp0 = tmp1.yyyy * tmp0 + tmp2;
                tmp1.y = _OutlineSoftness * _ScaleRatioA;
                tmp1.zw = tmp1.zy * inp.texcoord1.yy;
                tmp1.y = tmp1.y * inp.texcoord1.y + 1.0;
                tmp1.x = tmp1.w * 0.5 + tmp1.x;
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp1.x = 1.0 - tmp1.x;
                tmp2 = tmp0 * tmp1.xxxx;
                tmp0.x = -tmp0.w * tmp1.x + 1.0;
                tmp3 = tex2D(_MainTex, inp.texcoord4.xy);
                tmp0.y = saturate(tmp3.w * inp.texcoord4.z + -inp.texcoord4.w);
                tmp3 = tmp0.yyyy * inp.color1;
                tmp0 = tmp3 * tmp0.xxxx + tmp2;
                tmp1.x = _GlowOffset * _ScaleRatioB;
                tmp1.x = tmp1.x * 0.5;
                tmp1.x = -tmp1.x * inp.texcoord1.y + tmp1.z;
                tmp1.y = tmp1.x >= 0.0;
                tmp1.y = uint1(tmp1.y) & uint1(1);
                tmp1.z = _GlowOuter * _ScaleRatioB + -_GlowInner;
                tmp1.y = tmp1.y * tmp1.z + _GlowInner;
                tmp1.y = tmp1.y * 0.5;
                tmp1.z = tmp1.y * inp.texcoord1.y + 1.0;
                tmp1.y = tmp1.y * inp.texcoord1.y;
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.y = sqrt(tmp1.y);
                tmp1.x = tmp1.x / tmp1.z;
                tmp1.x = min(abs(tmp1.x), 1.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _GlowPower;
                tmp1.x = pow(2.0, tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = saturate(dot(_GlowColor.ww, tmp1.xx));
                tmp0.xyz = _GlowColor.xyz * tmp1.xxx + tmp0.xyz;
                tmp1.xy = _ClipRect.zw - _ClipRect.xy;
                tmp1.xy = tmp1.xy - abs(inp.texcoord2.xy);
                tmp1.xy = saturate(tmp1.xy * inp.texcoord2.zw);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0 = tmp0 * tmp1.xxxx;
                o.sv_target = tmp0 * inp.color.wwww;
                return o;
            }

            #elif UNDERLAY_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _FaceUVSpeedX; // 32 (starting at cb0[2].x)
            float _FaceUVSpeedY; // 36 (starting at cb0[2].y)
            float4 _FaceColor; // 48 (starting at cb0[3].x)
            float _OutlineUVSpeedX; // 72 (starting at cb0[4].z)
            float _OutlineUVSpeedY; // 76 (starting at cb0[4].w)
            float4 _OutlineColor; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp0 = tex2D(_OutlineTex, tmp0.xy);
                tmp0 = tmp0 * _OutlineColor;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = inp.color.xyz * _FaceColor.xyz;
                tmp2.xy = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp2 = tex2D(_FaceTex, tmp2.xy);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.w = tmp2.w * _FaceColor.w;
                tmp2.xyz = tmp1.xyz * tmp2.www;
                tmp0 = tmp0 - tmp2;
                tmp1.x = _OutlineWidth * _ScaleRatioA;
                tmp1.x = tmp1.x * inp.texcoord1.y;
                tmp1.y = min(tmp1.x, 1.0);
                tmp1.x = tmp1.x * 0.5;
                tmp1.y = sqrt(tmp1.y);
                tmp3 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.z = inp.texcoord1.z - tmp3.w;
                tmp1.w = saturate(tmp1.z * inp.texcoord1.y + tmp1.x);
                tmp1.x = tmp1.z * inp.texcoord1.y + -tmp1.x;
                tmp1.y = tmp1.y * tmp1.w;
                tmp0 = tmp1.yyyy * tmp0 + tmp2;
                tmp1.y = _OutlineSoftness * _ScaleRatioA;
                tmp1.z = tmp1.y * inp.texcoord1.y;
                tmp1.y = tmp1.y * inp.texcoord1.y + 1.0;
                tmp1.x = tmp1.z * 0.5 + tmp1.x;
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp1.x = 1.0 - tmp1.x;
                tmp2 = tmp0 * tmp1.xxxx;
                tmp0.x = -tmp0.w * tmp1.x + 1.0;
                tmp1 = tex2D(_MainTex, inp.texcoord4.xy);
                tmp0.y = saturate(tmp1.w * inp.texcoord4.z + -inp.texcoord4.w);
                tmp1 = tmp0.yyyy * inp.color1;
                tmp0 = tmp1 * tmp0.xxxx + tmp2;
                tmp1.xy = _ClipRect.zw - _ClipRect.xy;
                tmp1.xy = tmp1.xy - abs(inp.texcoord2.xy);
                tmp1.xy = saturate(tmp1.xy * inp.texcoord2.zw);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0 = tmp0 * tmp1.xxxx;
                o.sv_target = tmp0 * inp.color.wwww;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _FaceUVSpeedX; // 32 (starting at cb0[2].x)
            float _FaceUVSpeedY; // 36 (starting at cb0[2].y)
            float4 _FaceColor; // 48 (starting at cb0[3].x)
            float _OutlineUVSpeedX; // 72 (starting at cb0[4].z)
            float _OutlineUVSpeedY; // 76 (starting at cb0[4].w)
            float4 _OutlineColor; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.w - inp.texcoord1.x;
                tmp0.y = inp.texcoord1.z - tmp0.w;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = _OutlineWidth * _ScaleRatioA;
                tmp0.x = tmp0.x * inp.texcoord1.y;
                tmp0.z = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x * 0.5;
                tmp0.z = sqrt(tmp0.z);
                tmp0.w = saturate(tmp0.y * inp.texcoord1.y + tmp0.x);
                tmp0.x = tmp0.y * inp.texcoord1.y + -tmp0.x;
                tmp0.y = tmp0.z * tmp0.w;
                tmp0.zw = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp1 = tex2D(_OutlineTex, tmp0.zw);
                tmp1 = tmp1 * _OutlineColor;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.color.xyz * _FaceColor.xyz;
                tmp0.zw = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp3 = tex2D(_FaceTex, tmp0.zw);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.w = tmp3.w * _FaceColor.w;
                tmp3.xyz = tmp2.xyz * tmp3.www;
                tmp1 = tmp1 - tmp3;
                tmp1 = tmp0.yyyy * tmp1 + tmp3;
                tmp0.y = _OutlineSoftness * _ScaleRatioA;
                tmp0.z = tmp0.y * inp.texcoord1.y;
                tmp0.y = tmp0.y * inp.texcoord1.y + 1.0;
                tmp0.x = tmp0.z * 0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x / tmp0.y);
                tmp0.x = 1.0 - tmp0.x;
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.xy = _ClipRect.zw - _ClipRect.xy;
                tmp1.xy = tmp1.xy - abs(inp.texcoord2.xy);
                tmp1.xy = saturate(tmp1.xy * inp.texcoord2.zw);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0 = tmp0 * tmp1.xxxx;
                o.sv_target = tmp0 * inp.color.wwww;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "TextMeshPro/Mobile/Distance Field"
}
