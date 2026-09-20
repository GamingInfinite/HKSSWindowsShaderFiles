// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TMProOld/Distance Field 3" {
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
        _MaskCoord ("Mask Coordinates", Vector) = (0, 0, 100000, 100000)
        _ClipRect ("Clip Rect", Vector) = (-100000, -100000, 100000, 100000)
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
                float texcoord : TEXCOORD;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };

            // CBs for DX11VertexSM40
            float4x4 _EnvMatrix; // 176 (starting at cb0[11].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                o.texcoord3.xy = tmp0.xy;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.color.xyz = v.color.xyz * _FaceColor.xyz;
                o.color.w = _FaceColor.w;
                o.color1 = _OutlineColor;
                tmp1.xyz = tmp0.yyy * _EnvMatrix._m01_m11_m21;
                tmp1.xyz = _EnvMatrix._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                o.texcoord4.xyz = _EnvMatrix._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord.x = v.color.w;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp2.z = floor(tmp0.w);
                tmp2.w = -tmp2.z * 4096.0 + v.texcoord1.x;
                o.texcoord1.zw = tmp2.zw * float2(0.00195313, 0.00195313);
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.yz = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp0.yz = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp0.yz;
                tmp0.yz = abs(tmp0.yz) * float2(_ScaleX.x, _ScaleY.x);
                tmp0.yz = tmp1.ww / tmp0.yz;
                tmp0.w = dot(tmp0.yz, tmp0.yz);
                o.texcoord3.zw = float2(0.5, 0.5) / tmp0.yz;
                tmp0.y = rsqrt(tmp0.w);
                tmp0.z = abs(v.texcoord1.y) * _GradientScale;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.y * 1.5;
                tmp0.w = 1.0 - _PerspectiveFilter;
                tmp0.w = tmp0.w * tmp0.z;
                tmp0.y = tmp0.y * 1.5 + -tmp0.w;
                tmp0.x = abs(tmp0.x) * tmp0.y + tmp0.w;
                tmp0.y = UNITY_MATRIX_P._m33 == 0.0;
                tmp0.y = tmp0.y ? tmp0.x : tmp0.z;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.z = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.z + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.z = _FaceDilate * _ScaleRatioA;
                tmp0.w = tmp0.z * 0.5 + tmp0.x;
                o.texcoord2.yw = tmp0.yw;
                tmp0.x = 0.5 / tmp0.y;
                tmp0.y = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp0.y = -_OutlineSoftness * _ScaleRatioA + tmp0.y;
                tmp0.y = tmp0.y * 0.5 + -tmp0.x;
                o.texcoord2.x = tmp0.y - tmp0.w;
                tmp0.y = 0.5 - tmp0.w;
                o.texcoord2.z = tmp0.x + tmp0.y;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _FaceUVSpeedX; // 32 (starting at cb0[2].x)
            float _FaceUVSpeedY; // 36 (starting at cb0[2].y)
            float _OutlineUVSpeedX; // 72 (starting at cb0[4].z)
            float _OutlineUVSpeedY; // 76 (starting at cb0[4].w)
            float4 _ClipRect; // 416 (starting at cb0[26].x)
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
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp0.w - inp.texcoord2.x;
                tmp0.y = inp.texcoord2.z - tmp0.w;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = _OutlineWidth * _ScaleRatioA;
                tmp0.x = tmp0.x * inp.texcoord2.y;
                tmp0.z = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x * 0.5;
                tmp0.z = sqrt(tmp0.z);
                tmp0.w = saturate(tmp0.y * inp.texcoord2.y + tmp0.x);
                tmp0.x = tmp0.y * inp.texcoord2.y + -tmp0.x;
                tmp0.y = tmp0.z * tmp0.w;
                tmp0.zw = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord1.zw;
                tmp1 = tex2D(_OutlineTex, tmp0.zw);
                tmp1 = tmp1 * inp.color1;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.zw = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord1.zw;
                tmp2 = tex2D(_FaceTex, tmp0.zw);
                tmp2 = tmp2 * inp.color;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1 = tmp1 - tmp2;
                tmp1 = tmp0.yyyy * tmp1 + tmp2;
                tmp0.y = _OutlineSoftness * _ScaleRatioA;
                tmp0.z = tmp0.y * inp.texcoord2.y;
                tmp0.y = tmp0.y * inp.texcoord2.y + 1.0;
                tmp0.x = tmp0.z * 0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x / tmp0.y);
                tmp0.x = 1.0 - tmp0.x;
                tmp0 = tmp0.xxxx * tmp1;
                tmp1.xy = inp.texcoord3.xy >= _ClipRect.xy;
                tmp1.zw = _ClipRect.zw >= inp.texcoord3.xy;
                tmp1 = uint4(tmp1) & uint4(int4(1, 1, 1, 1));
                tmp1.xy = tmp1.zw * tmp1.xy;
                tmp1.x = tmp1.y * tmp1.x;
                tmp0 = tmp0 * tmp1.xxxx;
                o.sv_target = tmp0 * inp.texcoord.xxxx;
                return o;
            }
            ENDCG
            
        }
    }
    Fallback "TMProOld/Mobile/Distance Field"
}
