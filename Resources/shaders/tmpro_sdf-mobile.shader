// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TextMeshPro/Mobile/Distance Field" {
    Properties {
        _FaceColor ("Face Color", Color) = (1, 1, 1, 1)
        _FaceDilate ("Face Dilate", Range(-1, 1)) = 0
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineWidth ("Outline Thickness", Range(0, 1)) = 0
        _OutlineSoftness ("Outline Softness", Range(0, 1)) = 0
        _UnderlayColor ("Border Color", Color) = (0, 0, 0, 0.5)
        _UnderlayOffsetX ("Border OffsetX", Range(-1, 1)) = 0
        _UnderlayOffsetY ("Border OffsetY", Range(-1, 1)) = 0
        _UnderlayDilate ("Border Dilate", Range(-1, 1)) = 0
        _UnderlaySoftness ("Border Softness", Range(0, 1)) = 0
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

            #pragma shader_feature UNDERLAY_ON
            

            #if UNDERLAY_ON // :DX11VertexSM40
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
                float4 color1 : COLOR1;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float _UnderlayDilate; // 312 (starting at cb0[19].z)
            float _UnderlaySoftness; // 316 (starting at cb0[19].w)
            float _TextureWidth; // 440 (starting at cb0[27].z)
            float _ScaleRatioC; // 372 (starting at cb0[23].y)
            float _TextureHeight; // 444 (starting at cb0[27].w)
            float _UnderlayOffsetX; // 304 (starting at cb0[19].x)
            float _UnderlayOffsetY; // 308 (starting at cb0[19].y)
            float4 _FaceColor; // 48 (starting at cb0[3].x)
            float _FaceDilate; // 64 (starting at cb0[4].x)
            float _OutlineSoftness; // 68 (starting at cb0[4].y)
            float4 _OutlineColor; // 80 (starting at cb0[5].x)
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
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
                o.color.w = _FaceColor.w;
                tmp3.xyz = v.color.xyz;
                tmp3.w = 1.0;
                tmp4 = tmp3 * _FaceColor;
                tmp2.xyz = tmp4.www * tmp4.xyz;
                o.color.xyz = tmp2.xyz;
                tmp5.xyz = -tmp2.xyz;
                tmp5.w = -tmp4.w;
                tmp6.xyz = _OutlineColor.www * _OutlineColor.xyz;
                tmp6.w = _OutlineColor.w;
                tmp5 = tmp5 + tmp6;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp1.xyz);
                tmp1.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp1.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp1.xy;
                tmp1.xy = abs(tmp1.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp1.xy = tmp2.ww / tmp1.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp1.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp1.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp1.xy;
                tmp0.w = rsqrt(tmp0.w);
                tmp1.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = tmp0.w * 1.5;
                tmp1.y = 1.0 - _PerspectiveFilter;
                tmp1.y = tmp1.y * abs(tmp1.x);
                tmp0.w = tmp0.w * 1.5 + -tmp1.y;
                tmp0.z = abs(tmp0.z) * tmp0.w + tmp1.y;
                tmp0.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp0.z = tmp0.w ? tmp0.z : tmp1.x;
                tmp1.xy = float2(_FaceDilate.x, _OutlineSoftness.x) * _ScaleRatioA.xx;
                tmp0.w = tmp1.y * tmp0.z + 1.0;
                tmp2.x = tmp0.z / tmp0.w;
                tmp0.w = _OutlineWidth * _ScaleRatioA;
                tmp0.w = tmp0.w * 0.5;
                tmp1.y = tmp2.x * tmp0.w;
                tmp1.y = tmp1.y + tmp1.y;
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.y = sqrt(tmp1.y);
                tmp5 = tmp5 * tmp1.yyyy;
                o.color1.xyz = tmp4.xyz * tmp4.www + tmp5.xyz;
                o.color1.w = tmp3.w * _FaceColor.w + tmp5.w;
                tmp3 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp3 = min(tmp3, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp1.yz = tmp0.xy - tmp3.xy;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp3.xy;
                o.texcoord2.xy = tmp0.xy - tmp3.zw;
                tmp0.xy = tmp3.zw - tmp3.xy;
                o.texcoord.zw = tmp1.yz / tmp0.xy;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.x = tmp1.x * 0.5 + tmp0.x;
                tmp0.x = 0.5 - tmp0.x;
                tmp2.w = tmp0.x * tmp2.x + -0.5;
                o.texcoord1.y = -tmp0.w * tmp2.x + tmp2.w;
                o.texcoord1.z = tmp0.w * tmp2.x + tmp2.w;
                o.texcoord1.xw = tmp2.xw;
                o.texcoord3.z = v.color.w;
                o.texcoord3.w = 0.0;
                tmp1 = float4(_UnderlayDilate.x, _UnderlaySoftness.x, _UnderlayOffsetX.x, _UnderlayOffsetY.x) * _ScaleRatioC.xxxx;
                tmp0.yw = -tmp1.zw * _GradientScale.xx;
                tmp0.yw = tmp0.yw / float2(_TextureWidth.x, _TextureHeight.x);
                o.texcoord3.xy = tmp0.yw + v.texcoord.xy;
                tmp0.y = tmp1.x * tmp0.z + 1.0;
                tmp0.y = tmp0.z / tmp0.y;
                tmp0.z = tmp1.y * 0.5;
                tmp0.x = tmp0.x * tmp0.y + -0.5;
                o.texcoord4.y = -tmp0.z * tmp0.y + tmp0.x;
                o.texcoord4.x = tmp0.y;
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
                float4 color1 : COLOR1;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _FaceColor; // 48 (starting at cb0[3].x)
            float _FaceDilate; // 64 (starting at cb0[4].x)
            float _OutlineSoftness; // 68 (starting at cb0[4].y)
            float4 _OutlineColor; // 80 (starting at cb0[5].x)
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
                float4 tmp4;
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
                tmp3 = v.color * _FaceColor;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                o.color = tmp3;
                tmp4.w = v.color.w * _OutlineColor.w;
                tmp4.xyz = tmp4.www * _OutlineColor.xyz;
                tmp4 = tmp4 - tmp3;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp1.xyz);
                tmp1.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp1.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp1.xy;
                tmp1.xy = abs(tmp1.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp1.xy = tmp2.ww / tmp1.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp1.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp1.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp1.xy;
                tmp0.w = rsqrt(tmp0.w);
                tmp1.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = tmp0.w * 1.5;
                tmp1.y = 1.0 - _PerspectiveFilter;
                tmp1.y = tmp1.y * abs(tmp1.x);
                tmp0.w = tmp0.w * 1.5 + -tmp1.y;
                tmp0.z = abs(tmp0.z) * tmp0.w + tmp1.y;
                tmp0.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp0.z = tmp0.w ? tmp0.z : tmp1.x;
                tmp1.xy = float2(_FaceDilate.x, _OutlineSoftness.x) * _ScaleRatioA.xx;
                tmp0.w = tmp1.y * tmp0.z + 1.0;
                tmp2.x = tmp0.z / tmp0.w;
                tmp0.z = _OutlineWidth * _ScaleRatioA;
                tmp0.z = tmp0.z * 0.5;
                tmp0.w = tmp2.x * tmp0.z;
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = sqrt(tmp0.w);
                o.color1 = tmp0.wwww * tmp4 + tmp3;
                tmp3 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp3 = min(tmp3, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp1.yz = tmp0.xy - tmp3.xy;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp3.xy;
                o.texcoord2.xy = tmp0.xy - tmp3.zw;
                tmp0.xy = tmp3.zw - tmp3.xy;
                o.texcoord.zw = tmp1.yz / tmp0.xy;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.x = tmp1.x * 0.5 + tmp0.x;
                tmp0.x = 0.5 - tmp0.x;
                tmp2.w = tmp0.x * tmp2.x + -0.5;
                o.texcoord1.y = -tmp0.z * tmp2.x + tmp2.w;
                o.texcoord1.z = tmp0.z * tmp2.x + tmp2.w;
                o.texcoord1.xw = tmp2.xw;
                return o;
            }
            #endif


            #if UNDERLAY_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _UnderlayColor; // 288 (starting at cb0[18].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp0.x = saturate(tmp0.w * inp.texcoord4.x + -inp.texcoord4.y);
                tmp1.xyz = _UnderlayColor.www * _UnderlayColor.xyz;
                tmp1.w = _UnderlayColor.w;
                tmp0 = tmp0.xxxx * tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = saturate(tmp1.w * inp.texcoord1.x + -inp.texcoord1.w);
                tmp2 = tmp1.xxxx * inp.color;
                tmp1.x = -inp.color.w * tmp1.x + 1.0;
                tmp0 = tmp0 * tmp1.xxxx + tmp2;
                tmp1.xy = _ClipRect.zw - _ClipRect.xy;
                tmp1.xy = tmp1.xy - abs(inp.texcoord2.xy);
                tmp1.xy = saturate(tmp1.xy * inp.texcoord2.zw);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0 = tmp0 * tmp1.xxxx;
                o.sv_target = tmp0 * inp.texcoord3.zzzz;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _ClipRect.zw - _ClipRect.xy;
                tmp0.xy = tmp0.xy - abs(inp.texcoord2.xy);
                tmp0.xy = saturate(tmp0.xy * inp.texcoord2.zw);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.y = saturate(tmp1.w * inp.texcoord1.x + -inp.texcoord1.w);
                tmp1 = tmp0.yyyy * inp.color;
                o.sv_target = tmp0.xxxx * tmp1;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
