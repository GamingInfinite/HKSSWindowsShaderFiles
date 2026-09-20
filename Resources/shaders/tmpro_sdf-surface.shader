// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TextMeshPro/Distance Field (Surface)" {
    Properties {
        _FaceTex ("Fill Texture", 2D) = "white" {}
        _FaceUVSpeedX ("Face UV Speed X", Range(-5, 5)) = 0
        _FaceUVSpeedY ("Face UV Speed Y", Range(-5, 5)) = 0
        _FaceColor ("Fill Color", Color) = (1, 1, 1, 1)
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
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _BumpOutline ("Bump Outline", Range(0, 1)) = 0.5
        _BumpFace ("Bump Face", Range(0, 1)) = 0.5
        _ReflectFaceColor ("Face Color", Color) = (0, 0, 0, 1)
        _ReflectOutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _Cube ("Reflection Cubemap", Cube) = "black" {}
        _EnvMatrixRotation ("Texture Rotation", Vector) = (0, 0, 0, 0)
        _SpecColor ("Specular Color", Color) = (0, 0, 0, 1)
        _FaceShininess ("Face Shininess", Range(0, 1)) = 0
        _OutlineShininess ("Outline Shininess", Range(0, 1)) = 0
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
    }
    SubShader {
        Tags {
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 300
        Pass {
            Name "FORWARD"
            LOD 300
            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "IGNOREPROJECTOR"="true"
                "LIGHTMODE"="FORWARDBASE"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile DIRECTIONAL
            #pragma shader_feature LIGHTPROBE_SH
            #pragma shader_feature VERTEXLIGHT_ON
            

            #if DIRECTIONAL && LIGHTPROBE_SH && VERTEXLIGHT_ON // FORWARD:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4x4 _EnvMatrix; // 208 (starting at cb0[13].x)
            float _FaceDilate; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 388 (starting at cb0[24].y)
            float _WeightBold; // 392 (starting at cb0[24].z)
            float _ScaleRatioA; // 396 (starting at cb0[24].w)
            float _VertexOffsetX; // 408 (starting at cb0[25].z)
            float _VertexOffsetY; // 412 (starting at cb0[25].w)
            float _GradientScale; // 480 (starting at cb0[30].x)
            float _ScaleX; // 484 (starting at cb0[30].y)
            float _ScaleY; // 488 (starting at cb0[30].z)
            float _PerspectiveFilter; // 492 (starting at cb0[30].w)
            float4 _MainTex_ST; // 512 (starting at cb0[32].x)
            float4 _FaceTex_ST; // 528 (starting at cb0[33].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_4LightPosX0; // 48 (starting at cb2[3].x)
            // CBUFFER_END
            // float4 unity_4LightPosY0; // 64 (starting at cb2[4].x)
            // float4 unity_4LightPosZ0; // 80 (starting at cb2[5].x)
            // float4 unity_4LightAtten0; // 96 (starting at cb2[6].x)
            // float4 unity_LightColor[8]; // 112 (starting at cb2[7].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // CBUFFER_START(UnityPerDraw) // 3
                // float4 unity_WorldTransformParams; // 144 (starting at cb3[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0 = tmp0.xxxx * tmp3.xyzz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp4.xyz = tmp0.wxy * tmp3.xyz;
                tmp4.xyz = tmp0.ywx * tmp3.yzx + -tmp4.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp1.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.z = tmp0.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord1.w = tmp1.x;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp0.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord2.w = tmp1.y;
                o.texcoord3.z = tmp0.w;
                o.texcoord3.w = tmp1.z;
                o.color = v.color;
                tmp1.w = v.texcoord1.y <= 0.0;
                tmp1.w = uint1(tmp1.w) & uint1(1);
                tmp3.x = _WeightBold - _WeightNormal;
                tmp1.w = tmp1.w * tmp3.x + _WeightNormal;
                tmp1.w = tmp1.w / _GradientScale;
                tmp3.x = _FaceDilate * _ScaleRatioA;
                o.texcoord4.x = tmp3.x * 0.5 + tmp1.w;
                tmp1.w = tmp2.y * unity_MatrixVP._m31;
                tmp1.w = unity_MatrixVP._m30 * tmp2.x + tmp1.w;
                tmp1.w = unity_MatrixVP._m32 * tmp2.z + tmp1.w;
                tmp1.w = unity_MatrixVP._m33 * tmp2.w + tmp1.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp1.ww / tmp2.xy;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.x = tmp1.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.x = tmp2.y * tmp2.x;
                tmp1.w = tmp1.w * 1.5 + -tmp2.x;
                tmp2.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                tmp3.x = dot(tmp2.yzw, tmp2.yzw);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp2.yzw * tmp3.xxx;
                tmp3.x = dot(tmp0.xyw, tmp3.xyz);
                o.texcoord4.y = abs(tmp3.x) * tmp1.w + tmp2.x;
                tmp3.xyz = tmp2.zzz * _EnvMatrix._m01_m11_m21;
                tmp2.xyz = _EnvMatrix._m00_m10_m20 * tmp2.yyy + tmp3.xyz;
                o.texcoord5.xyz = _EnvMatrix._m02_m12_m22 * tmp2.www + tmp2.xyz;
                tmp2 = unity_4LightPosY0 - tmp1.yyyy;
                tmp3 = tmp0.yyyy * tmp2;
                tmp2 = tmp2 * tmp2;
                tmp4 = unity_4LightPosX0 - tmp1.xxxx;
                tmp1 = unity_4LightPosZ0 - tmp1.zzzz;
                tmp3 = tmp4 * tmp0.xxxx + tmp3;
                tmp2 = tmp4 * tmp4 + tmp2;
                tmp2 = tmp1 * tmp1 + tmp2;
                tmp1 = tmp1 * tmp0.wwzw + tmp3;
                tmp2 = max(tmp2, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp3 = rsqrt(tmp2);
                tmp2 = tmp2 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp2 = float4(1.0, 1.0, 1.0, 1.0) / tmp2;
                tmp1 = tmp1 * tmp3;
                tmp1 = max(tmp1, float4(0.0, 0.0, 0.0, 0.0));
                tmp1 = tmp2 * tmp1;
                tmp2.xyz = tmp1.yyy * unity_LightColor[1].xyz;
                tmp2.xyz = unity_LightColor[0].xyz * tmp1.xxx + tmp2.xyz;
                tmp1.xyz = unity_LightColor[2].xyz * tmp1.zzz + tmp2.xyz;
                tmp1.xyz = unity_LightColor[3].xyz * tmp1.www + tmp1.xyz;
                tmp2.xyz = tmp1.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp2.xyz = tmp1.xyz * tmp2.xyz + float3(0.01252288, 0.01252288, 0.01252288);
                tmp1.w = tmp0.y * tmp0.y;
                tmp1.w = tmp0.x * tmp0.x + -tmp1.w;
                tmp0 = tmp0.ywzx * tmp0;
                tmp3.x = dot(unity_SHBr, tmp0);
                tmp3.y = dot(unity_SHBg, tmp0);
                tmp3.z = dot(unity_SHBb, tmp0);
                tmp0.xyz = unity_SHC.xyz * tmp1.www + tmp3.xyz;
                o.texcoord6.xyz = tmp1.xyz * tmp2.xyz + tmp0.xyz;
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH // FORWARD:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4x4 _EnvMatrix; // 208 (starting at cb0[13].x)
            float _FaceDilate; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 388 (starting at cb0[24].y)
            float _WeightBold; // 392 (starting at cb0[24].z)
            float _ScaleRatioA; // 396 (starting at cb0[24].w)
            float _VertexOffsetX; // 408 (starting at cb0[25].z)
            float _VertexOffsetY; // 412 (starting at cb0[25].w)
            float _GradientScale; // 480 (starting at cb0[30].x)
            float _ScaleX; // 484 (starting at cb0[30].y)
            float _ScaleY; // 488 (starting at cb0[30].z)
            float _PerspectiveFilter; // 492 (starting at cb0[30].w)
            float4 _MainTex_ST; // 512 (starting at cb0[32].x)
            float4 _FaceTex_ST; // 528 (starting at cb0[33].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // CBUFFER_END
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // CBUFFER_START(UnityPerDraw) // 3
                // float4 unity_WorldTransformParams; // 144 (starting at cb3[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0 = tmp0.xxxx * tmp3.xyzz;
                o.texcoord1.z = tmp0.x;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp4.xyz = tmp0.wxy * tmp3.xyz;
                tmp4.xyz = tmp0.ywx * tmp3.yzx + -tmp4.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp1.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.w = tmp1.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp0.y;
                o.texcoord2.w = tmp1.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.w = tmp1.z;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                o.texcoord3.z = tmp0.w;
                o.color = v.color;
                tmp1.w = tmp2.y * unity_MatrixVP._m31;
                tmp1.w = unity_MatrixVP._m30 * tmp2.x + tmp1.w;
                tmp1.w = unity_MatrixVP._m32 * tmp2.z + tmp1.w;
                tmp1.w = unity_MatrixVP._m33 * tmp2.w + tmp1.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp1.ww / tmp2.xy;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.x = tmp1.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.x = tmp2.y * tmp2.x;
                tmp1.w = tmp1.w * 1.5 + -tmp2.x;
                tmp2.y = dot(tmp1.xyz, tmp1.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp1.xyz * tmp2.yyy;
                tmp2.y = dot(tmp0.xyw, tmp2.yzw);
                o.texcoord4.y = abs(tmp2.y) * tmp1.w + tmp2.x;
                tmp1.w = v.texcoord1.y <= 0.0;
                tmp1.w = uint1(tmp1.w) & uint1(1);
                tmp2.x = _WeightBold - _WeightNormal;
                tmp1.w = tmp1.w * tmp2.x + _WeightNormal;
                tmp1.w = tmp1.w / _GradientScale;
                tmp2.x = _FaceDilate * _ScaleRatioA;
                o.texcoord4.x = tmp2.x * 0.5 + tmp1.w;
                tmp2.xyz = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp1.xyw = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp2.xyz;
                o.texcoord5.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp1.xyw;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp0 = tmp0.ywzx * tmp0;
                tmp2.x = dot(unity_SHBr, tmp0);
                tmp2.y = dot(unity_SHBg, tmp0);
                tmp2.z = dot(unity_SHBb, tmp0);
                o.texcoord6.xyz = unity_SHC.xyz * tmp1.xxx + tmp2.xyz;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4x4 _EnvMatrix; // 208 (starting at cb0[13].x)
            float _FaceDilate; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 388 (starting at cb0[24].y)
            float _WeightBold; // 392 (starting at cb0[24].z)
            float _ScaleRatioA; // 396 (starting at cb0[24].w)
            float _VertexOffsetX; // 408 (starting at cb0[25].z)
            float _VertexOffsetY; // 412 (starting at cb0[25].w)
            float _GradientScale; // 480 (starting at cb0[30].x)
            float _ScaleX; // 484 (starting at cb0[30].y)
            float _ScaleY; // 488 (starting at cb0[30].z)
            float _PerspectiveFilter; // 492 (starting at cb0[30].w)
            float4 _MainTex_ST; // 512 (starting at cb0[32].x)
            float4 _FaceTex_ST; // 528 (starting at cb0[33].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // CBUFFER_END
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // CBUFFER_START(UnityPerDraw) // 3
                // float4 unity_WorldTransformParams; // 144 (starting at cb3[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0 = tmp0.xxxx * tmp3.xyzz;
                o.texcoord1.z = tmp0.x;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp4.xyz = tmp0.wxy * tmp3.xyz;
                tmp4.xyz = tmp0.ywx * tmp3.yzx + -tmp4.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp1.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.w = tmp1.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp0.y;
                o.texcoord2.w = tmp1.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.w = tmp1.z;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                o.texcoord3.z = tmp0.w;
                o.color = v.color;
                tmp1.w = tmp2.y * unity_MatrixVP._m31;
                tmp1.w = unity_MatrixVP._m30 * tmp2.x + tmp1.w;
                tmp1.w = unity_MatrixVP._m32 * tmp2.z + tmp1.w;
                tmp1.w = unity_MatrixVP._m33 * tmp2.w + tmp1.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp1.ww / tmp2.xy;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.x = tmp1.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.x = tmp2.y * tmp2.x;
                tmp1.w = tmp1.w * 1.5 + -tmp2.x;
                tmp2.y = dot(tmp1.xyz, tmp1.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp1.xyz * tmp2.yyy;
                tmp2.y = dot(tmp0.xyw, tmp2.yzw);
                o.texcoord4.y = abs(tmp2.y) * tmp1.w + tmp2.x;
                tmp1.w = v.texcoord1.y <= 0.0;
                tmp1.w = uint1(tmp1.w) & uint1(1);
                tmp2.x = _WeightBold - _WeightNormal;
                tmp1.w = tmp1.w * tmp2.x + _WeightNormal;
                tmp1.w = tmp1.w / _GradientScale;
                tmp2.x = _FaceDilate * _ScaleRatioA;
                o.texcoord4.x = tmp2.x * 0.5 + tmp1.w;
                tmp2.xyz = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp1.xyw = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp2.xyz;
                o.texcoord5.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp1.xyw;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp0 = tmp0.ywzx * tmp0;
                tmp2.x = dot(unity_SHBr, tmp0);
                tmp2.y = dot(unity_SHBg, tmp0);
                tmp2.z = dot(unity_SHBb, tmp0);
                o.texcoord6.xyz = unity_SHC.xyz * tmp1.xxx + tmp2.xyz;
                return o;
            }
            #endif


            #if DIRECTIONAL && LIGHTPROBE_SH // FORWARD:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            float _FaceUVSpeedX; // 64 (starting at cb0[4].x)
            float _FaceUVSpeedY; // 68 (starting at cb0[4].y)
            float4 _FaceColor; // 80 (starting at cb0[5].x)
            float _OutlineSoftness; // 100 (starting at cb0[6].y)
            float _OutlineUVSpeedX; // 104 (starting at cb0[6].z)
            float _OutlineUVSpeedY; // 108 (starting at cb0[6].w)
            float4 _OutlineColor; // 112 (starting at cb0[7].x)
            float _OutlineWidth; // 128 (starting at cb0[8].x)
            float _Bevel; // 132 (starting at cb0[8].y)
            float _BevelOffset; // 136 (starting at cb0[8].z)
            float _BevelWidth; // 140 (starting at cb0[8].w)
            float _BevelClamp; // 144 (starting at cb0[9].x)
            float _BevelRoundness; // 148 (starting at cb0[9].y)
            float _BumpOutline; // 152 (starting at cb0[9].z)
            float _BumpFace; // 156 (starting at cb0[9].w)
            float4 _ReflectFaceColor; // 160 (starting at cb0[10].x)
            float4 _ReflectOutlineColor; // 176 (starting at cb0[11].x)
            float _ShaderFlags; // 384 (starting at cb0[24].x)
            float _TextureWidth; // 472 (starting at cb0[29].z)
            float _TextureHeight; // 476 (starting at cb0[29].w)
            float _FaceShininess; // 496 (starting at cb0[31].x)
            float _OutlineShininess; // 500 (starting at cb0[31].y)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_START(UnityProbeVolume) // 4
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb4[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb4[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb4[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb4[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3
            samplerCUBE _Cube; // 4

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.y = inp.texcoord1.w;
                tmp0.z = inp.texcoord2.w;
                tmp0.w = inp.texcoord3.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp2.z = 0.0;
                tmp3 = inp.texcoord.xyxy - tmp2.xzzy;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp2 = tmp2.xzzy + inp.texcoord.xyxy;
                tmp5 = tex2D(_MainTex, tmp2.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp6 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = 0.5 - tmp6.w;
                tmp1.w = tmp1.w - inp.texcoord4.x;
                tmp1.w = tmp1.w * inp.texcoord4.y + 0.5;
                tmp3.x = _OutlineWidth * _ScaleRatioA;
                tmp3.y = _OutlineSoftness * _ScaleRatioA;
                tmp3.xz = tmp3.xy * inp.texcoord4.yy;
                tmp6 = inp.color * _FaceColor;
                tmp4.x = inp.color.w * _OutlineColor.w;
                tmp4.yz = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_FaceTex, tmp4.yz);
                tmp6 = tmp6 * tmp7;
                tmp4.yz = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_OutlineTex, tmp4.yz);
                tmp5.xyz = tmp7.xyz * _OutlineColor.xyz;
                tmp7.w = tmp4.x * tmp7.w;
                tmp4.x = -tmp3.x * 0.5 + tmp1.w;
                tmp3.z = tmp3.z * 0.5 + tmp4.x;
                tmp3.y = tmp3.y * inp.texcoord4.y + 1.0;
                tmp3.y = saturate(tmp3.z / tmp3.y);
                tmp3.y = 1.0 - tmp3.y;
                tmp1.w = saturate(tmp3.x * 0.5 + tmp1.w);
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp1.w * tmp3.x;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp7.xyz = tmp5.xyz * tmp7.www;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp3.xxxx * tmp7 + tmp6;
                tmp6 = tmp3.yyyy * tmp6;
                tmp3.x = max(tmp6.w, 0.0001);
                tmp3.xyz = tmp6.xyz / tmp3.xxx;
                tmp4.x = _ShaderFlags * 0.5;
                tmp4.y = tmp4.x >= -tmp4.x;
                tmp4.x = frac(abs(tmp4.x));
                tmp4.x = tmp4.y ? tmp4.x : -tmp4.x;
                tmp4.x = tmp4.x >= 0.5;
                tmp4.y = inp.texcoord4.x + _BevelOffset;
                tmp2.x = tmp4.w;
                tmp2.y = tmp5.w;
                tmp2.z = tmp3.w;
                tmp2 = tmp4.yyyy + tmp2;
                tmp3.w = _BevelWidth + _OutlineWidth;
                tmp3.w = max(tmp3.w, 0.01);
                tmp2 = tmp2 - float4(0.5, 0.5, 0.5, 0.5);
                tmp2 = tmp2 / tmp3.wwww;
                tmp2 = saturate(tmp2 + float4(0.5, 0.5, 0.5, 0.5));
                tmp5 = tmp2 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp5 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp5);
                tmp2 = tmp4.xxxx ? tmp5 : tmp2;
                tmp4 = tmp2 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp2;
                tmp2 = _BevelRoundness.xxxx * tmp4 + tmp2;
                tmp4.x = 1.0 - _BevelClamp;
                tmp2 = min(tmp2, tmp4.xxxx);
                tmp3.w = tmp3.w * _Bevel;
                tmp3.w = tmp3.w * _GradientScale;
                tmp3.w = tmp3.w * -2.0;
                tmp2.xz = tmp2.xz * tmp3.ww;
                tmp2.yz = tmp2.wy * tmp3.ww + -tmp2.zx;
                tmp2.xw = float2(-1.0, 1.0);
                tmp2.w = dot(tmp2.zw, tmp2.zw);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.yz = tmp2.ww * float2(1.0, 0.0);
                tmp4.x = tmp2.w * tmp2.z;
                tmp2.w = dot(tmp2.xy, tmp2.xy);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.z = 0.0;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp5.xyz = tmp2.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.zxy * tmp2.yzx + -tmp5.xyz;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.w = dot(tmp4.xy, tmp4.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp4.z = sqrt(tmp2.w);
                tmp2.w = _BumpOutline - _BumpFace;
                tmp2.w = tmp1.w * tmp2.w + _BumpFace;
                tmp4.xyz = tmp4.xyz * tmp2.www + float3(-0.0, -0.0, -1.0);
                tmp4.xyz = tmp6.www * tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp4.xyz = tmp2.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp4.xyz = unity_ObjectToWorld._m00_m10_m20 * tmp2.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m02_m12_m22 * tmp2.zzz + tmp4.xyz;
                tmp2.w = dot(inp.texcoord5.xyz, tmp4.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp4.xyz = tmp4.xyz * -tmp2.www + inp.texcoord5.xyz;
                tmp4 = texCUBE(_Cube, tmp4.xyz);
                tmp5.xyz = _ReflectOutlineColor.xyz - _ReflectFaceColor.xyz;
                tmp5.xyz = tmp1.www * tmp5.xyz + _ReflectFaceColor.xyz;
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp2.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp1.w * tmp2.w + _FaceShininess;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp3.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord2.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord1.www + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.www + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp3.www ? tmp5.xyz : tmp0.yzw;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp3.w = tmp5.y * 0.25 + 0.75;
                    tmp4.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp3.w, tmp4.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp3.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp5.x = dot(inp.texcoord1.xyz, -tmp2.xyz);
                tmp5.y = dot(inp.texcoord2.xyz, -tmp2.xyz);
                tmp5.z = dot(inp.texcoord3.xyz, -tmp2.xyz);
                tmp2.x = dot(tmp5.xyz, tmp5.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp5.xyz = tmp2.xxx * tmp5.xyz;
                tmp2.xyz = tmp3.www * _LightColor0.xyz;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp6.xyz = inp.texcoord2.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord1.www + tmp6.xyz;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.www + tmp6.xyz;
                    tmp6.xyz = tmp6.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.yzw = tmp2.www ? tmp6.xyz : tmp0.yzw;
                    tmp0.yzw = tmp0.yzw - unity_ProbeVolumeMin;
                    tmp7.yzw = tmp0.yzw * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp7.y * 0.25;
                    tmp0.z = unity_ProbeVolumeParams.z * 0.5;
                    tmp0.w = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp0.y = max(tmp0.z, tmp0.y);
                    tmp7.x = min(tmp0.w, tmp0.y);
                    tmp8 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xzw);
                    tmp0.yzw = tmp7.xzw + float3(0.25, 0.0, 0.0);
                    tmp9 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.yzw);
                    tmp0.yzw = tmp7.xzw + float3(0.5, 0.0, 0.0);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.yzw);
                    tmp5.w = 1.0;
                    tmp6.x = dot(tmp8, tmp5);
                    tmp6.y = dot(tmp9, tmp5);
                    tmp6.z = dot(tmp7, tmp5);
                } else {
                    tmp5.w = 1.0;
                    tmp6.x = dot(unity_SHAr, tmp5);
                    tmp6.y = dot(unity_SHAg, tmp5);
                    tmp6.z = dot(unity_SHAb, tmp5);
                }
                tmp0.yzw = tmp6.xyz + inp.texcoord6.xyz;
                tmp0.yzw = max(tmp0.yzw, float3(0.0, 0.0, 0.0));
                tmp0.yzw = log(tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.yzw = pow(2.0, tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp0.yzw = max(tmp0.yzw, float3(0.0, 0.0, 0.0));
                tmp1.xyz = tmp1.xyz * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.x = dot(tmp5.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp1.x = dot(tmp5.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = tmp1.w * 128.0;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = pow(2.0, tmp1.x);
                tmp1.yzw = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _SpecColor.xyz;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = tmp3.xyz * tmp0.yzw + tmp1.xyz;
                o.sv_target.xyz = tmp4.xyz * tmp6.www + tmp0.xyz;
                o.sv_target.w = tmp6.w;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            float _FaceUVSpeedX; // 64 (starting at cb0[4].x)
            float _FaceUVSpeedY; // 68 (starting at cb0[4].y)
            float4 _FaceColor; // 80 (starting at cb0[5].x)
            float _OutlineSoftness; // 100 (starting at cb0[6].y)
            float _OutlineUVSpeedX; // 104 (starting at cb0[6].z)
            float _OutlineUVSpeedY; // 108 (starting at cb0[6].w)
            float4 _OutlineColor; // 112 (starting at cb0[7].x)
            float _OutlineWidth; // 128 (starting at cb0[8].x)
            float _Bevel; // 132 (starting at cb0[8].y)
            float _BevelOffset; // 136 (starting at cb0[8].z)
            float _BevelWidth; // 140 (starting at cb0[8].w)
            float _BevelClamp; // 144 (starting at cb0[9].x)
            float _BevelRoundness; // 148 (starting at cb0[9].y)
            float _BumpOutline; // 152 (starting at cb0[9].z)
            float _BumpFace; // 156 (starting at cb0[9].w)
            float4 _ReflectFaceColor; // 160 (starting at cb0[10].x)
            float4 _ReflectOutlineColor; // 176 (starting at cb0[11].x)
            float _ShaderFlags; // 384 (starting at cb0[24].x)
            float _TextureWidth; // 472 (starting at cb0[29].z)
            float _TextureHeight; // 476 (starting at cb0[29].w)
            float _FaceShininess; // 496 (starting at cb0[31].x)
            float _OutlineShininess; // 500 (starting at cb0[31].y)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_START(UnityProbeVolume) // 4
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb4[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb4[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb4[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb4[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3
            samplerCUBE _Cube; // 4

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.y = inp.texcoord1.w;
                tmp0.z = inp.texcoord2.w;
                tmp0.w = inp.texcoord3.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp2.z = 0.0;
                tmp3 = inp.texcoord.xyxy - tmp2.xzzy;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp2 = tmp2.xzzy + inp.texcoord.xyxy;
                tmp5 = tex2D(_MainTex, tmp2.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp6 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = 0.5 - tmp6.w;
                tmp1.w = tmp1.w - inp.texcoord4.x;
                tmp1.w = tmp1.w * inp.texcoord4.y + 0.5;
                tmp3.x = _OutlineWidth * _ScaleRatioA;
                tmp3.y = _OutlineSoftness * _ScaleRatioA;
                tmp3.xz = tmp3.xy * inp.texcoord4.yy;
                tmp6 = inp.color * _FaceColor;
                tmp4.x = inp.color.w * _OutlineColor.w;
                tmp4.yz = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_FaceTex, tmp4.yz);
                tmp6 = tmp6 * tmp7;
                tmp4.yz = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_OutlineTex, tmp4.yz);
                tmp5.xyz = tmp7.xyz * _OutlineColor.xyz;
                tmp7.w = tmp4.x * tmp7.w;
                tmp4.x = -tmp3.x * 0.5 + tmp1.w;
                tmp3.z = tmp3.z * 0.5 + tmp4.x;
                tmp3.y = tmp3.y * inp.texcoord4.y + 1.0;
                tmp3.y = saturate(tmp3.z / tmp3.y);
                tmp3.y = 1.0 - tmp3.y;
                tmp1.w = saturate(tmp3.x * 0.5 + tmp1.w);
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp1.w * tmp3.x;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp7.xyz = tmp5.xyz * tmp7.www;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp3.xxxx * tmp7 + tmp6;
                tmp6 = tmp3.yyyy * tmp6;
                tmp3.x = max(tmp6.w, 0.0001);
                tmp3.xyz = tmp6.xyz / tmp3.xxx;
                tmp4.x = _ShaderFlags * 0.5;
                tmp4.y = tmp4.x >= -tmp4.x;
                tmp4.x = frac(abs(tmp4.x));
                tmp4.x = tmp4.y ? tmp4.x : -tmp4.x;
                tmp4.x = tmp4.x >= 0.5;
                tmp4.y = inp.texcoord4.x + _BevelOffset;
                tmp2.x = tmp4.w;
                tmp2.y = tmp5.w;
                tmp2.z = tmp3.w;
                tmp2 = tmp4.yyyy + tmp2;
                tmp3.w = _BevelWidth + _OutlineWidth;
                tmp3.w = max(tmp3.w, 0.01);
                tmp2 = tmp2 - float4(0.5, 0.5, 0.5, 0.5);
                tmp2 = tmp2 / tmp3.wwww;
                tmp2 = saturate(tmp2 + float4(0.5, 0.5, 0.5, 0.5));
                tmp5 = tmp2 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp5 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp5);
                tmp2 = tmp4.xxxx ? tmp5 : tmp2;
                tmp4 = tmp2 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp2;
                tmp2 = _BevelRoundness.xxxx * tmp4 + tmp2;
                tmp4.x = 1.0 - _BevelClamp;
                tmp2 = min(tmp2, tmp4.xxxx);
                tmp3.w = tmp3.w * _Bevel;
                tmp3.w = tmp3.w * _GradientScale;
                tmp3.w = tmp3.w * -2.0;
                tmp2.xz = tmp2.xz * tmp3.ww;
                tmp2.yz = tmp2.wy * tmp3.ww + -tmp2.zx;
                tmp2.xw = float2(-1.0, 1.0);
                tmp2.w = dot(tmp2.zw, tmp2.zw);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.yz = tmp2.ww * float2(1.0, 0.0);
                tmp4.x = tmp2.w * tmp2.z;
                tmp2.w = dot(tmp2.xy, tmp2.xy);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.z = 0.0;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp5.xyz = tmp2.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.zxy * tmp2.yzx + -tmp5.xyz;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.w = dot(tmp4.xy, tmp4.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp4.z = sqrt(tmp2.w);
                tmp2.w = _BumpOutline - _BumpFace;
                tmp2.w = tmp1.w * tmp2.w + _BumpFace;
                tmp4.xyz = tmp4.xyz * tmp2.www + float3(-0.0, -0.0, -1.0);
                tmp4.xyz = tmp6.www * tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp4.xyz = tmp2.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp4.xyz = unity_ObjectToWorld._m00_m10_m20 * tmp2.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m02_m12_m22 * tmp2.zzz + tmp4.xyz;
                tmp2.w = dot(inp.texcoord5.xyz, tmp4.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp4.xyz = tmp4.xyz * -tmp2.www + inp.texcoord5.xyz;
                tmp4 = texCUBE(_Cube, tmp4.xyz);
                tmp5.xyz = _ReflectOutlineColor.xyz - _ReflectFaceColor.xyz;
                tmp5.xyz = tmp1.www * tmp5.xyz + _ReflectFaceColor.xyz;
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp2.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp1.w * tmp2.w + _FaceShininess;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp3.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord2.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord1.www + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.www + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp3.www ? tmp5.xyz : tmp0.yzw;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp3.w = tmp5.y * 0.25 + 0.75;
                    tmp4.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp3.w, tmp4.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp3.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp5.x = dot(inp.texcoord1.xyz, -tmp2.xyz);
                tmp5.y = dot(inp.texcoord2.xyz, -tmp2.xyz);
                tmp5.z = dot(inp.texcoord3.xyz, -tmp2.xyz);
                tmp2.x = dot(tmp5.xyz, tmp5.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp5.xyz = tmp2.xxx * tmp5.xyz;
                tmp2.xyz = tmp3.www * _LightColor0.xyz;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp6.xyz = inp.texcoord2.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord1.www + tmp6.xyz;
                    tmp6.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.www + tmp6.xyz;
                    tmp6.xyz = tmp6.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.yzw = tmp2.www ? tmp6.xyz : tmp0.yzw;
                    tmp0.yzw = tmp0.yzw - unity_ProbeVolumeMin;
                    tmp7.yzw = tmp0.yzw * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp7.y * 0.25;
                    tmp0.z = unity_ProbeVolumeParams.z * 0.5;
                    tmp0.w = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp0.y = max(tmp0.z, tmp0.y);
                    tmp7.x = min(tmp0.w, tmp0.y);
                    tmp8 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp7.xzw);
                    tmp0.yzw = tmp7.xzw + float3(0.25, 0.0, 0.0);
                    tmp9 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.yzw);
                    tmp0.yzw = tmp7.xzw + float3(0.5, 0.0, 0.0);
                    tmp7 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp0.yzw);
                    tmp5.w = 1.0;
                    tmp6.x = dot(tmp8, tmp5);
                    tmp6.y = dot(tmp9, tmp5);
                    tmp6.z = dot(tmp7, tmp5);
                } else {
                    tmp5.w = 1.0;
                    tmp6.x = dot(unity_SHAr, tmp5);
                    tmp6.y = dot(unity_SHAg, tmp5);
                    tmp6.z = dot(unity_SHAb, tmp5);
                }
                tmp0.yzw = tmp6.xyz + inp.texcoord6.xyz;
                tmp0.yzw = max(tmp0.yzw, float3(0.0, 0.0, 0.0));
                tmp0.yzw = log(tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.yzw = pow(2.0, tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp0.yzw = max(tmp0.yzw, float3(0.0, 0.0, 0.0));
                tmp1.xyz = tmp1.xyz * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.x = dot(tmp5.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp1.x = dot(tmp5.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = tmp1.w * 128.0;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = pow(2.0, tmp1.x);
                tmp1.yzw = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _SpecColor.xyz;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp1.xyz = tmp1.yzw * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = tmp3.xyz * tmp0.yzw + tmp1.xyz;
                o.sv_target.xyz = tmp4.xyz * tmp6.www + tmp0.xyz;
                o.sv_target.w = tmp6.w;
                return o;
            }
            #endif
            ENDCG
            
        }
        Pass {
            Name "FORWARD"
            LOD 300
            Blend SrcAlpha One, SrcAlpha One
            ColorMask RGB
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "IGNOREPROJECTOR"="true"
                "LIGHTMODE"="FORWARDADD"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile POINT DIRECTIONAL SPOT POINT_COOKIE DIRECTIONAL_COOKIE
            

            #if POINT // FORWARD:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 color : COLOR;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
            };

            // CBs for DX11VertexSM40
            float _FaceDilate; // 160 (starting at cb0[10].x)
            float _WeightNormal; // 452 (starting at cb0[28].y)
            float _WeightBold; // 456 (starting at cb0[28].z)
            float _ScaleRatioA; // 460 (starting at cb0[28].w)
            float _VertexOffsetX; // 472 (starting at cb0[29].z)
            float _VertexOffsetY; // 476 (starting at cb0[29].w)
            float _GradientScale; // 544 (starting at cb0[34].x)
            float _ScaleX; // 548 (starting at cb0[34].y)
            float _ScaleY; // 552 (starting at cb0[34].z)
            float _PerspectiveFilter; // 556 (starting at cb0[34].w)
            float4 _MainTex_ST; // 576 (starting at cb0[36].x)
            float4 _FaceTex_ST; // 592 (starting at cb0[37].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            float4x4 _EnvMatrix; // 272 (starting at cb0[17].x)
            // CBUFFER_START(UnityPerDraw) // 2
                // float4 unity_WorldTransformParams; // 144 (starting at cb2[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.z = tmp0.y;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp0.xyz * tmp3.xyz;
                tmp4.xyz = tmp0.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.z = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.z = tmp0.x;
                tmp3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                o.texcoord4.xyz = tmp3.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - tmp3.xyz;
                o.color = v.color;
                tmp0.w = tmp2.y * unity_MatrixVP._m31;
                tmp0.w = unity_MatrixVP._m30 * tmp2.x + tmp0.w;
                tmp0.w = unity_MatrixVP._m32 * tmp2.z + tmp0.w;
                tmp0.w = unity_MatrixVP._m33 * tmp2.w + tmp0.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp0.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.x = tmp0.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.x = tmp2.y * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp2.x;
                tmp2.y = dot(tmp3.xyz, tmp3.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp2.yyy * tmp3.xyz;
                tmp0.x = dot(tmp0.yzx, tmp2.yzw);
                o.texcoord5.y = abs(tmp0.x) * tmp0.w + tmp2.x;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.y = _FaceDilate * _ScaleRatioA;
                o.texcoord5.x = tmp0.y * 0.5 + tmp0.x;
                tmp0.xyz = tmp3.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp3.xxx + tmp0.xyz;
                o.texcoord6.xyz = _EnvMatrix._m02_m12_m22 * tmp3.zzz + tmp0.xyz;
                tmp0.xyz = tmp1.yyy * unity_WorldToLight._m01_m11_m21;
                tmp0.xyz = unity_WorldToLight._m00_m10_m20 * tmp1.xxx + tmp0.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp1.zzz + tmp0.xyz;
                o.texcoord7.xyz = unity_WorldToLight._m03_m13_m23 * tmp1.www + tmp0.xyz;
                return o;
            }

            #elif DIRECTIONAL // FORWARD:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 color : COLOR;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float _FaceDilate; // 96 (starting at cb0[6].x)
            float _WeightNormal; // 388 (starting at cb0[24].y)
            float _WeightBold; // 392 (starting at cb0[24].z)
            float _ScaleRatioA; // 396 (starting at cb0[24].w)
            float _VertexOffsetX; // 408 (starting at cb0[25].z)
            float _VertexOffsetY; // 412 (starting at cb0[25].w)
            float _GradientScale; // 480 (starting at cb0[30].x)
            float _ScaleX; // 484 (starting at cb0[30].y)
            float _ScaleY; // 488 (starting at cb0[30].z)
            float _PerspectiveFilter; // 492 (starting at cb0[30].w)
            float4 _MainTex_ST; // 512 (starting at cb0[32].x)
            float4 _FaceTex_ST; // 528 (starting at cb0[33].x)
            float4x4 _EnvMatrix; // 208 (starting at cb0[13].x)
            // CBUFFER_START(UnityPerDraw) // 2
                // float4 unity_WorldTransformParams; // 144 (starting at cb2[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.z = tmp0.y;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp0.xyz * tmp3.xyz;
                tmp4.xyz = tmp0.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.z = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.z = tmp0.x;
                o.texcoord4.xyz = tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                o.color = v.color;
                tmp0.w = tmp2.y * unity_MatrixVP._m31;
                tmp0.w = unity_MatrixVP._m30 * tmp2.x + tmp0.w;
                tmp0.w = unity_MatrixVP._m32 * tmp2.z + tmp0.w;
                tmp0.w = unity_MatrixVP._m33 * tmp2.w + tmp0.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp0.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.w = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.w * 1.5;
                tmp2.x = 1.0 - _PerspectiveFilter;
                tmp1.w = tmp1.w * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp1.w;
                tmp2.x = dot(tmp1.xyz, tmp1.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp1.xyz * tmp2.xxx;
                tmp0.x = dot(tmp0.yzx, tmp2.xyz);
                o.texcoord5.y = abs(tmp0.x) * tmp0.w + tmp1.w;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.y = _FaceDilate * _ScaleRatioA;
                o.texcoord5.x = tmp0.y * 0.5 + tmp0.x;
                tmp0.xyz = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp0.xyz;
                o.texcoord6.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp0.xyz;
                return o;
            }

            #elif SPOT // FORWARD:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 color : COLOR;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };

            // CBs for DX11VertexSM40
            float _FaceDilate; // 160 (starting at cb0[10].x)
            float _WeightNormal; // 452 (starting at cb0[28].y)
            float _WeightBold; // 456 (starting at cb0[28].z)
            float _ScaleRatioA; // 460 (starting at cb0[28].w)
            float _VertexOffsetX; // 472 (starting at cb0[29].z)
            float _VertexOffsetY; // 476 (starting at cb0[29].w)
            float _GradientScale; // 544 (starting at cb0[34].x)
            float _ScaleX; // 548 (starting at cb0[34].y)
            float _ScaleY; // 552 (starting at cb0[34].z)
            float _PerspectiveFilter; // 556 (starting at cb0[34].w)
            float4 _MainTex_ST; // 576 (starting at cb0[36].x)
            float4 _FaceTex_ST; // 592 (starting at cb0[37].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            float4x4 _EnvMatrix; // 272 (starting at cb0[17].x)
            // CBUFFER_START(UnityPerDraw) // 2
                // float4 unity_WorldTransformParams; // 144 (starting at cb2[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.z = tmp0.y;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp0.xyz * tmp3.xyz;
                tmp4.xyz = tmp0.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.z = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.z = tmp0.x;
                tmp3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                o.texcoord4.xyz = tmp3.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - tmp3.xyz;
                o.color = v.color;
                tmp0.w = tmp2.y * unity_MatrixVP._m31;
                tmp0.w = unity_MatrixVP._m30 * tmp2.x + tmp0.w;
                tmp0.w = unity_MatrixVP._m32 * tmp2.z + tmp0.w;
                tmp0.w = unity_MatrixVP._m33 * tmp2.w + tmp0.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp0.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.x = tmp0.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.x = tmp2.y * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp2.x;
                tmp2.y = dot(tmp3.xyz, tmp3.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp2.yyy * tmp3.xyz;
                tmp0.x = dot(tmp0.yzx, tmp2.yzw);
                o.texcoord5.y = abs(tmp0.x) * tmp0.w + tmp2.x;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.y = _FaceDilate * _ScaleRatioA;
                o.texcoord5.x = tmp0.y * 0.5 + tmp0.x;
                tmp0.xyz = tmp3.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp3.xxx + tmp0.xyz;
                o.texcoord6.xyz = _EnvMatrix._m02_m12_m22 * tmp3.zzz + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp0 = unity_WorldToLight._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_WorldToLight._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.texcoord7 = unity_WorldToLight._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif POINT_COOKIE // FORWARD:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 color : COLOR;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
            };

            // CBs for DX11VertexSM40
            float _FaceDilate; // 160 (starting at cb0[10].x)
            float _WeightNormal; // 452 (starting at cb0[28].y)
            float _WeightBold; // 456 (starting at cb0[28].z)
            float _ScaleRatioA; // 460 (starting at cb0[28].w)
            float _VertexOffsetX; // 472 (starting at cb0[29].z)
            float _VertexOffsetY; // 476 (starting at cb0[29].w)
            float _GradientScale; // 544 (starting at cb0[34].x)
            float _ScaleX; // 548 (starting at cb0[34].y)
            float _ScaleY; // 552 (starting at cb0[34].z)
            float _PerspectiveFilter; // 556 (starting at cb0[34].w)
            float4 _MainTex_ST; // 576 (starting at cb0[36].x)
            float4 _FaceTex_ST; // 592 (starting at cb0[37].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            float4x4 _EnvMatrix; // 272 (starting at cb0[17].x)
            // CBUFFER_START(UnityPerDraw) // 2
                // float4 unity_WorldTransformParams; // 144 (starting at cb2[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.z = tmp0.y;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp0.xyz * tmp3.xyz;
                tmp4.xyz = tmp0.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.z = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.z = tmp0.x;
                tmp3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                o.texcoord4.xyz = tmp3.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - tmp3.xyz;
                o.color = v.color;
                tmp0.w = tmp2.y * unity_MatrixVP._m31;
                tmp0.w = unity_MatrixVP._m30 * tmp2.x + tmp0.w;
                tmp0.w = unity_MatrixVP._m32 * tmp2.z + tmp0.w;
                tmp0.w = unity_MatrixVP._m33 * tmp2.w + tmp0.w;
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp0.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.x = tmp0.w * 1.5;
                tmp2.y = 1.0 - _PerspectiveFilter;
                tmp2.x = tmp2.y * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp2.x;
                tmp2.y = dot(tmp3.xyz, tmp3.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp2.yyy * tmp3.xyz;
                tmp0.x = dot(tmp0.yzx, tmp2.yzw);
                o.texcoord5.y = abs(tmp0.x) * tmp0.w + tmp2.x;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.y = _FaceDilate * _ScaleRatioA;
                o.texcoord5.x = tmp0.y * 0.5 + tmp0.x;
                tmp0.xyz = tmp3.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp3.xxx + tmp0.xyz;
                o.texcoord6.xyz = _EnvMatrix._m02_m12_m22 * tmp3.zzz + tmp0.xyz;
                tmp0.xyz = tmp1.yyy * unity_WorldToLight._m01_m11_m21;
                tmp0.xyz = unity_WorldToLight._m00_m10_m20 * tmp1.xxx + tmp0.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp1.zzz + tmp0.xyz;
                o.texcoord7.xyz = unity_WorldToLight._m03_m13_m23 * tmp1.www + tmp0.xyz;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color : COLOR;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 color : COLOR;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord7 : TEXCOORD7;
                float3 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float _FaceDilate; // 160 (starting at cb0[10].x)
            float _WeightNormal; // 452 (starting at cb0[28].y)
            float _WeightBold; // 456 (starting at cb0[28].z)
            float _ScaleRatioA; // 460 (starting at cb0[28].w)
            float _VertexOffsetX; // 472 (starting at cb0[29].z)
            float _VertexOffsetY; // 476 (starting at cb0[29].w)
            float _GradientScale; // 544 (starting at cb0[34].x)
            float _ScaleX; // 548 (starting at cb0[34].y)
            float _ScaleY; // 552 (starting at cb0[34].z)
            float _PerspectiveFilter; // 556 (starting at cb0[34].w)
            float4 _MainTex_ST; // 576 (starting at cb0[36].x)
            float4 _FaceTex_ST; // 592 (starting at cb0[37].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            float4x4 _EnvMatrix; // 272 (starting at cb0[17].x)
            // CBUFFER_START(UnityPerDraw) // 2
                // float4 unity_WorldTransformParams; // 144 (starting at cb2[9].x)
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
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp0.w = v.texcoord1.x * 0.00024414;
                tmp3.z = floor(tmp0.w);
                tmp3.w = -tmp3.z * 4096.0 + v.texcoord1.x;
                tmp3.xy = tmp3.zw * _FaceTex_ST.xy;
                o.texcoord.zw = tmp3.xy * float2(0.00195313, 0.00195313) + _FaceTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3.xyz = _WorldSpaceCameraPos * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * _WorldSpaceCameraPos + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_WorldToObject._m03_m13_m23;
                tmp0.z = v.vertex.z;
                tmp0.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.x = dot(v.normal.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp3.y = dot(tmp0.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.z = dot(tmp0.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.x = dot(tmp0.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.z = tmp0.y;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp0.xyz * tmp3.xyz;
                tmp4.xyz = tmp0.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.z = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord3.z = tmp0.x;
                tmp3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                o.texcoord4.xyz = tmp3.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - tmp3.xyz;
                o.color = v.color;
                tmp4.xy = tmp1.yy * unity_WorldToLight._m01_m11;
                tmp1.xy = unity_WorldToLight._m00_m10 * tmp1.xx + tmp4.xy;
                tmp1.xy = unity_WorldToLight._m02_m12 * tmp1.zz + tmp1.xy;
                o.texcoord7.xy = unity_WorldToLight._m03_m13 * tmp1.ww + tmp1.xy;
                tmp0.w = tmp2.y * unity_MatrixVP._m31;
                tmp0.w = unity_MatrixVP._m30 * tmp2.x + tmp0.w;
                tmp0.w = unity_MatrixVP._m32 * tmp2.z + tmp0.w;
                tmp0.w = unity_MatrixVP._m33 * tmp2.w + tmp0.w;
                tmp1.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp1.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(_ScaleX.x, _ScaleY.x);
                tmp1.xy = tmp0.ww / tmp1.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = tmp0.w * 1.5;
                tmp1.y = 1.0 - _PerspectiveFilter;
                tmp1.x = tmp1.y * tmp1.x;
                tmp0.w = tmp0.w * 1.5 + -tmp1.x;
                tmp1.y = dot(tmp3.xyz, tmp3.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp1.yzw = tmp1.yyy * tmp3.xyz;
                tmp0.x = dot(tmp0.yzx, tmp1.yzw);
                o.texcoord5.y = abs(tmp0.x) * tmp0.w + tmp1.x;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = uint1(tmp0.x) & uint1(1);
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x / _GradientScale;
                tmp0.y = _FaceDilate * _ScaleRatioA;
                o.texcoord5.x = tmp0.y * 0.5 + tmp0.x;
                tmp0.xyz = tmp3.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp3.xxx + tmp0.xyz;
                o.texcoord6.xyz = _EnvMatrix._m02_m12_m22 * tmp3.zzz + tmp0.xyz;
                return o;
            }
            #endif


            #if POINT // FORWARD:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _OutlineShininess; // 564 (starting at cb0[35].y)
            float _FaceShininess; // 560 (starting at cb0[35].x)
            float _FaceUVSpeedX; // 128 (starting at cb0[8].x)
            float _FaceUVSpeedY; // 132 (starting at cb0[8].y)
            float4 _FaceColor; // 144 (starting at cb0[9].x)
            float _OutlineSoftness; // 164 (starting at cb0[10].y)
            float _OutlineUVSpeedX; // 168 (starting at cb0[10].z)
            float _OutlineUVSpeedY; // 172 (starting at cb0[10].w)
            float4 _OutlineColor; // 176 (starting at cb0[11].x)
            float _OutlineWidth; // 192 (starting at cb0[12].x)
            float _Bevel; // 196 (starting at cb0[12].y)
            float _BevelOffset; // 200 (starting at cb0[12].z)
            float _BevelWidth; // 204 (starting at cb0[12].w)
            float _BevelClamp; // 208 (starting at cb0[13].x)
            float _BevelRoundness; // 212 (starting at cb0[13].y)
            float _BumpOutline; // 216 (starting at cb0[13].z)
            float _BumpFace; // 220 (starting at cb0[13].w)
            float _ShaderFlags; // 448 (starting at cb0[28].x)
            float _TextureWidth; // 536 (starting at cb0[33].z)
            float _TextureHeight; // 540 (starting at cb0[33].w)
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 3
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb3[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb3[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb3[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb3[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3
            sampler2D _LightTexture0; // 4

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp2.z = 0.0;
                tmp3 = inp.texcoord.xyxy - tmp2.xzzy;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp2 = tmp2.xzzy + inp.texcoord.xyxy;
                tmp5 = tex2D(_MainTex, tmp2.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp6 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = 0.5 - tmp6.w;
                tmp1.w = tmp1.w - inp.texcoord5.x;
                tmp1.w = tmp1.w * inp.texcoord5.y + 0.5;
                tmp3.x = _OutlineWidth * _ScaleRatioA;
                tmp3.y = _OutlineSoftness * _ScaleRatioA;
                tmp3.xz = tmp3.xy * inp.texcoord5.yy;
                tmp6 = inp.color * _FaceColor;
                tmp4.x = inp.color.w * _OutlineColor.w;
                tmp4.yz = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_FaceTex, tmp4.yz);
                tmp6 = tmp6 * tmp7;
                tmp4.yz = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_OutlineTex, tmp4.yz);
                tmp5.xyz = tmp7.xyz * _OutlineColor.xyz;
                tmp7.w = tmp4.x * tmp7.w;
                tmp4.x = -tmp3.x * 0.5 + tmp1.w;
                tmp3.z = tmp3.z * 0.5 + tmp4.x;
                tmp3.y = tmp3.y * inp.texcoord5.y + 1.0;
                tmp3.y = saturate(tmp3.z / tmp3.y);
                tmp3.y = 1.0 - tmp3.y;
                tmp1.w = saturate(tmp3.x * 0.5 + tmp1.w);
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp1.w * tmp3.x;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp7.xyz = tmp5.xyz * tmp7.www;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp3.xxxx * tmp7 + tmp6;
                tmp6 = tmp3.yyyy * tmp6;
                tmp3.x = max(tmp6.w, 0.0001);
                tmp3.xyz = tmp6.xyz / tmp3.xxx;
                tmp4.x = _ShaderFlags * 0.5;
                tmp4.y = tmp4.x >= -tmp4.x;
                tmp4.x = frac(abs(tmp4.x));
                tmp4.x = tmp4.y ? tmp4.x : -tmp4.x;
                tmp4.x = tmp4.x >= 0.5;
                tmp4.y = inp.texcoord5.x + _BevelOffset;
                tmp2.x = tmp4.w;
                tmp2.y = tmp5.w;
                tmp2.z = tmp3.w;
                tmp2 = tmp4.yyyy + tmp2;
                tmp3.w = _BevelWidth + _OutlineWidth;
                tmp3.w = max(tmp3.w, 0.01);
                tmp2 = tmp2 - float4(0.5, 0.5, 0.5, 0.5);
                tmp2 = tmp2 / tmp3.wwww;
                tmp2 = saturate(tmp2 + float4(0.5, 0.5, 0.5, 0.5));
                tmp5 = tmp2 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp5 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp5);
                tmp2 = tmp4.xxxx ? tmp5 : tmp2;
                tmp4 = tmp2 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp2;
                tmp2 = _BevelRoundness.xxxx * tmp4 + tmp2;
                tmp4.x = 1.0 - _BevelClamp;
                tmp2 = min(tmp2, tmp4.xxxx);
                tmp3.w = tmp3.w * _Bevel;
                tmp3.w = tmp3.w * _GradientScale;
                tmp3.w = tmp3.w * -2.0;
                tmp2.xz = tmp2.xz * tmp3.ww;
                tmp2.yz = tmp2.wy * tmp3.ww + -tmp2.zx;
                tmp2.xw = float2(-1.0, 1.0);
                tmp2.w = dot(tmp2.zw, tmp2.zw);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.yz = tmp2.ww * float2(1.0, 0.0);
                tmp4.x = tmp2.w * tmp2.z;
                tmp2.w = dot(tmp2.xy, tmp2.xy);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.z = 0.0;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp5.xyz = tmp2.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.zxy * tmp2.yzx + -tmp5.xyz;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.w = dot(tmp4.xy, tmp4.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp4.z = sqrt(tmp2.w);
                tmp2.w = _BumpOutline - _BumpFace;
                tmp2.w = tmp1.w * tmp2.w + _BumpFace;
                tmp4.xyz = tmp4.xyz * tmp2.www + float3(-0.0, -0.0, -1.0);
                tmp4.xyz = tmp6.www * tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp1.w * tmp2.w + _FaceShininess;
                tmp4.xyz = inp.texcoord4.yyy * unity_WorldToLight._m01_m11_m21;
                tmp4.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord4.xxx + tmp4.xyz;
                tmp4.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord4.zzz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz + unity_WorldToLight._m03_m13_m23;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord4.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord4.xxx + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.zzz + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp2.www ? tmp5.xyz : inp.texcoord4.xyz;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.w = tmp5.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp2.w, tmp3.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp2.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp3.w = dot(tmp4.xyz, tmp4.xyz);
                tmp4 = tex2D(_LightTexture0, tmp3.ww);
                tmp2.w = tmp2.w * tmp4.x;
                tmp4.x = dot(inp.texcoord1.xyz, -tmp2.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, -tmp2.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, -tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp4.xyz = tmp2.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = dot(tmp2.xyz, tmp1.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.z = tmp1.w * 128.0;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = pow(2.0, tmp0.y);
                tmp1.xyz = tmp3.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.xyz * _SpecColor.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.xxx + tmp0.yzw;
                o.sv_target.w = tmp6.w;
                return o;
            }

            #elif DIRECTIONAL // FORWARD:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _OutlineShininess; // 500 (starting at cb0[31].y)
            float _FaceShininess; // 496 (starting at cb0[31].x)
            float _FaceUVSpeedX; // 64 (starting at cb0[4].x)
            float _FaceUVSpeedY; // 68 (starting at cb0[4].y)
            float4 _FaceColor; // 80 (starting at cb0[5].x)
            float _OutlineSoftness; // 100 (starting at cb0[6].y)
            float _OutlineUVSpeedX; // 104 (starting at cb0[6].z)
            float _OutlineUVSpeedY; // 108 (starting at cb0[6].w)
            float4 _OutlineColor; // 112 (starting at cb0[7].x)
            float _OutlineWidth; // 128 (starting at cb0[8].x)
            float _Bevel; // 132 (starting at cb0[8].y)
            float _BevelOffset; // 136 (starting at cb0[8].z)
            float _BevelWidth; // 140 (starting at cb0[8].w)
            float _BevelClamp; // 144 (starting at cb0[9].x)
            float _BevelRoundness; // 148 (starting at cb0[9].y)
            float _BumpOutline; // 152 (starting at cb0[9].z)
            float _BumpFace; // 156 (starting at cb0[9].w)
            float _ShaderFlags; // 384 (starting at cb0[24].x)
            float _TextureWidth; // 472 (starting at cb0[29].z)
            float _TextureHeight; // 476 (starting at cb0[29].w)
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 3
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb3[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb3[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb3[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb3[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp1.z = 0.0;
                tmp2 = inp.texcoord.xyxy - tmp1.xzzy;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp1 = tmp1.xzzy + inp.texcoord.xyxy;
                tmp4 = tex2D(_MainTex, tmp1.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp5 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.x = 0.5 - tmp5.w;
                tmp2.x = tmp2.x - inp.texcoord5.x;
                tmp2.x = tmp2.x * inp.texcoord5.y + 0.5;
                tmp2.y = _OutlineWidth * _ScaleRatioA;
                tmp2.y = tmp2.y * inp.texcoord5.y;
                tmp2.z = _OutlineSoftness * _ScaleRatioA;
                tmp3.x = tmp2.z * inp.texcoord5.y;
                tmp5 = inp.color * _FaceColor;
                tmp3.y = inp.color.w * _OutlineColor.w;
                tmp4.xy = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp6 = tex2D(_FaceTex, tmp4.xy);
                tmp5 = tmp5 * tmp6;
                tmp4.xy = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp6 = tex2D(_OutlineTex, tmp4.xy);
                tmp4.xyz = tmp6.xyz * _OutlineColor.xyz;
                tmp6.w = tmp3.y * tmp6.w;
                tmp3.y = -tmp2.y * 0.5 + tmp2.x;
                tmp3.x = tmp3.x * 0.5 + tmp3.y;
                tmp2.z = tmp2.z * inp.texcoord5.y + 1.0;
                tmp2.z = saturate(tmp3.x / tmp2.z);
                tmp2.z = 1.0 - tmp2.z;
                tmp2.x = saturate(tmp2.y * 0.5 + tmp2.x);
                tmp2.y = min(tmp2.y, 1.0);
                tmp2.y = sqrt(tmp2.y);
                tmp2.y = tmp2.y * tmp2.x;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp6.xyz = tmp4.xyz * tmp6.www;
                tmp6 = tmp6 - tmp5;
                tmp5 = tmp2.yyyy * tmp6 + tmp5;
                tmp5 = tmp2.zzzz * tmp5;
                tmp2.y = max(tmp5.w, 0.0001);
                tmp3.xyz = tmp5.xyz / tmp2.yyy;
                tmp2.y = _ShaderFlags * 0.5;
                tmp2.z = tmp2.y >= -tmp2.y;
                tmp2.y = frac(abs(tmp2.y));
                tmp2.y = tmp2.z ? tmp2.y : -tmp2.y;
                tmp2.y = tmp2.y >= 0.5;
                tmp2.z = inp.texcoord5.x + _BevelOffset;
                tmp1.x = tmp3.w;
                tmp1.y = tmp4.w;
                tmp1.z = tmp2.w;
                tmp1 = tmp2.zzzz + tmp1;
                tmp2.z = _BevelWidth + _OutlineWidth;
                tmp2.z = max(tmp2.z, 0.01);
                tmp1 = tmp1 - float4(0.5, 0.5, 0.5, 0.5);
                tmp1 = tmp1 / tmp2.zzzz;
                tmp1 = saturate(tmp1 + float4(0.5, 0.5, 0.5, 0.5));
                tmp4 = tmp1 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp4 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp4);
                tmp1 = tmp2.yyyy ? tmp4 : tmp1;
                tmp4 = tmp1 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp1;
                tmp1 = _BevelRoundness.xxxx * tmp4 + tmp1;
                tmp2.y = 1.0 - _BevelClamp;
                tmp1 = min(tmp1, tmp2.yyyy);
                tmp2.y = tmp2.z * _Bevel;
                tmp2.y = tmp2.y * _GradientScale;
                tmp2.y = tmp2.y * -2.0;
                tmp1.xz = tmp1.xz * tmp2.yy;
                tmp1.yz = tmp1.wy * tmp2.yy + -tmp1.zx;
                tmp1.xw = float2(-1.0, 1.0);
                tmp1.w = dot(tmp1.zw, tmp1.zw);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.yz = tmp1.ww * float2(1.0, 0.0);
                tmp4.x = tmp1.w * tmp1.z;
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.z = 0.0;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.yzw = tmp1.xyz * tmp4.xyz;
                tmp1.xyz = tmp4.zxy * tmp1.yzx + -tmp2.yzw;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp4.xy, tmp4.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp4.z = sqrt(tmp1.w);
                tmp1.w = _BumpOutline - _BumpFace;
                tmp1.w = tmp2.x * tmp1.w + _BumpFace;
                tmp2.yzw = tmp4.xyz * tmp1.www + float3(-0.0, -0.0, -1.0);
                tmp2.yzw = tmp5.www * tmp2.yzw + float3(0.0, 0.0, 1.0);
                tmp1.xyz = tmp1.xyz - tmp2.yzw;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp2.x * tmp1.w + _FaceShininess;
                tmp2.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.x) {
                    tmp2.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.yzw = inp.texcoord4.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord4.xxx + tmp2.yzw;
                    tmp2.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.zzz + tmp2.yzw;
                    tmp2.yzw = tmp2.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp2.xxx ? tmp2.yzw : inp.texcoord4.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.y = tmp2.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp2.y, tmp3.w);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp2.x = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp4.x = dot(inp.texcoord1.xyz, -tmp1.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, -tmp1.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, -tmp1.xyz);
                tmp1.x = dot(tmp4.xyz, tmp4.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * tmp4.xyz;
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp0.y = tmp1.w * 128.0;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = pow(2.0, tmp0.x);
                tmp1.xyz = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _SpecColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                o.sv_target.w = tmp5.w;
                return o;
            }

            #elif SPOT // FORWARD:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _OutlineShininess; // 564 (starting at cb0[35].y)
            float _FaceShininess; // 560 (starting at cb0[35].x)
            float _FaceUVSpeedX; // 128 (starting at cb0[8].x)
            float _FaceUVSpeedY; // 132 (starting at cb0[8].y)
            float4 _FaceColor; // 144 (starting at cb0[9].x)
            float _OutlineSoftness; // 164 (starting at cb0[10].y)
            float _OutlineUVSpeedX; // 168 (starting at cb0[10].z)
            float _OutlineUVSpeedY; // 172 (starting at cb0[10].w)
            float4 _OutlineColor; // 176 (starting at cb0[11].x)
            float _OutlineWidth; // 192 (starting at cb0[12].x)
            float _Bevel; // 196 (starting at cb0[12].y)
            float _BevelOffset; // 200 (starting at cb0[12].z)
            float _BevelWidth; // 204 (starting at cb0[12].w)
            float _BevelClamp; // 208 (starting at cb0[13].x)
            float _BevelRoundness; // 212 (starting at cb0[13].y)
            float _BumpOutline; // 216 (starting at cb0[13].z)
            float _BumpFace; // 220 (starting at cb0[13].w)
            float _ShaderFlags; // 448 (starting at cb0[28].x)
            float _TextureWidth; // 536 (starting at cb0[33].z)
            float _TextureHeight; // 540 (starting at cb0[33].w)
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 3
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb3[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb3[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb3[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb3[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3
            sampler2D _LightTexture0; // 4
            sampler2D _LightTextureB0; // 5

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp2.z = 0.0;
                tmp3 = inp.texcoord.xyxy - tmp2.xzzy;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp2 = tmp2.xzzy + inp.texcoord.xyxy;
                tmp5 = tex2D(_MainTex, tmp2.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp6 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = 0.5 - tmp6.w;
                tmp1.w = tmp1.w - inp.texcoord5.x;
                tmp1.w = tmp1.w * inp.texcoord5.y + 0.5;
                tmp3.x = _OutlineWidth * _ScaleRatioA;
                tmp3.y = _OutlineSoftness * _ScaleRatioA;
                tmp3.xz = tmp3.xy * inp.texcoord5.yy;
                tmp6 = inp.color * _FaceColor;
                tmp4.x = inp.color.w * _OutlineColor.w;
                tmp4.yz = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_FaceTex, tmp4.yz);
                tmp6 = tmp6 * tmp7;
                tmp4.yz = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_OutlineTex, tmp4.yz);
                tmp5.xyz = tmp7.xyz * _OutlineColor.xyz;
                tmp7.w = tmp4.x * tmp7.w;
                tmp4.x = -tmp3.x * 0.5 + tmp1.w;
                tmp3.z = tmp3.z * 0.5 + tmp4.x;
                tmp3.y = tmp3.y * inp.texcoord5.y + 1.0;
                tmp3.y = saturate(tmp3.z / tmp3.y);
                tmp3.y = 1.0 - tmp3.y;
                tmp1.w = saturate(tmp3.x * 0.5 + tmp1.w);
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp1.w * tmp3.x;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp7.xyz = tmp5.xyz * tmp7.www;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp3.xxxx * tmp7 + tmp6;
                tmp6 = tmp3.yyyy * tmp6;
                tmp3.x = max(tmp6.w, 0.0001);
                tmp3.xyz = tmp6.xyz / tmp3.xxx;
                tmp4.x = _ShaderFlags * 0.5;
                tmp4.y = tmp4.x >= -tmp4.x;
                tmp4.x = frac(abs(tmp4.x));
                tmp4.x = tmp4.y ? tmp4.x : -tmp4.x;
                tmp4.x = tmp4.x >= 0.5;
                tmp4.y = inp.texcoord5.x + _BevelOffset;
                tmp2.x = tmp4.w;
                tmp2.y = tmp5.w;
                tmp2.z = tmp3.w;
                tmp2 = tmp4.yyyy + tmp2;
                tmp3.w = _BevelWidth + _OutlineWidth;
                tmp3.w = max(tmp3.w, 0.01);
                tmp2 = tmp2 - float4(0.5, 0.5, 0.5, 0.5);
                tmp2 = tmp2 / tmp3.wwww;
                tmp2 = saturate(tmp2 + float4(0.5, 0.5, 0.5, 0.5));
                tmp5 = tmp2 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp5 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp5);
                tmp2 = tmp4.xxxx ? tmp5 : tmp2;
                tmp4 = tmp2 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp2;
                tmp2 = _BevelRoundness.xxxx * tmp4 + tmp2;
                tmp4.x = 1.0 - _BevelClamp;
                tmp2 = min(tmp2, tmp4.xxxx);
                tmp3.w = tmp3.w * _Bevel;
                tmp3.w = tmp3.w * _GradientScale;
                tmp3.w = tmp3.w * -2.0;
                tmp2.xz = tmp2.xz * tmp3.ww;
                tmp2.yz = tmp2.wy * tmp3.ww + -tmp2.zx;
                tmp2.xw = float2(-1.0, 1.0);
                tmp2.w = dot(tmp2.zw, tmp2.zw);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.yz = tmp2.ww * float2(1.0, 0.0);
                tmp4.x = tmp2.w * tmp2.z;
                tmp2.w = dot(tmp2.xy, tmp2.xy);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.z = 0.0;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp5.xyz = tmp2.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.zxy * tmp2.yzx + -tmp5.xyz;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.w = dot(tmp4.xy, tmp4.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp4.z = sqrt(tmp2.w);
                tmp2.w = _BumpOutline - _BumpFace;
                tmp2.w = tmp1.w * tmp2.w + _BumpFace;
                tmp4.xyz = tmp4.xyz * tmp2.www + float3(-0.0, -0.0, -1.0);
                tmp4.xyz = tmp6.www * tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp1.w * tmp2.w + _FaceShininess;
                tmp4 = inp.texcoord4.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp4 = unity_WorldToLight._m00_m10_m20_m30 * inp.texcoord4.xxxx + tmp4;
                tmp4 = unity_WorldToLight._m02_m12_m22_m32 * inp.texcoord4.zzzz + tmp4;
                tmp4 = tmp4 + unity_WorldToLight._m03_m13_m23_m33;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord4.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord4.xxx + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.zzz + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp2.www ? tmp5.xyz : inp.texcoord4.xyz;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.w = tmp5.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp2.w, tmp3.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp2.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp3.w = tmp4.z > 0.0;
                tmp3.w = uint1(tmp3.w) & uint1(1);
                tmp5.xy = tmp4.xy / tmp4.ww;
                tmp5.xy = tmp5.xy + float2(0.5, 0.5);
                tmp5 = tex2D(_LightTexture0, tmp5.xy);
                tmp3.w = tmp3.w * tmp5.w;
                tmp4.x = dot(tmp4.xyz, tmp4.xyz);
                tmp4 = tex2D(_LightTextureB0, tmp4.xx);
                tmp3.w = tmp3.w * tmp4.x;
                tmp2.w = tmp2.w * tmp3.w;
                tmp4.x = dot(inp.texcoord1.xyz, -tmp2.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, -tmp2.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, -tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp4.xyz = tmp2.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = dot(tmp2.xyz, tmp1.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.z = tmp1.w * 128.0;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = pow(2.0, tmp0.y);
                tmp1.xyz = tmp3.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.xyz * _SpecColor.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.xxx + tmp0.yzw;
                o.sv_target.w = tmp6.w;
                return o;
            }

            #elif POINT_COOKIE // FORWARD:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _OutlineShininess; // 564 (starting at cb0[35].y)
            float _FaceShininess; // 560 (starting at cb0[35].x)
            float _FaceUVSpeedX; // 128 (starting at cb0[8].x)
            float _FaceUVSpeedY; // 132 (starting at cb0[8].y)
            float4 _FaceColor; // 144 (starting at cb0[9].x)
            float _OutlineSoftness; // 164 (starting at cb0[10].y)
            float _OutlineUVSpeedX; // 168 (starting at cb0[10].z)
            float _OutlineUVSpeedY; // 172 (starting at cb0[10].w)
            float4 _OutlineColor; // 176 (starting at cb0[11].x)
            float _OutlineWidth; // 192 (starting at cb0[12].x)
            float _Bevel; // 196 (starting at cb0[12].y)
            float _BevelOffset; // 200 (starting at cb0[12].z)
            float _BevelWidth; // 204 (starting at cb0[12].w)
            float _BevelClamp; // 208 (starting at cb0[13].x)
            float _BevelRoundness; // 212 (starting at cb0[13].y)
            float _BumpOutline; // 216 (starting at cb0[13].z)
            float _BumpFace; // 220 (starting at cb0[13].w)
            float _ShaderFlags; // 448 (starting at cb0[28].x)
            float _TextureWidth; // 536 (starting at cb0[33].z)
            float _TextureHeight; // 540 (starting at cb0[33].w)
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 3
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb3[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb3[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb3[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb3[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3
            sampler2D _LightTextureB0; // 4
            samplerCUBE _LightTexture0; // 5

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp2.z = 0.0;
                tmp3 = inp.texcoord.xyxy - tmp2.xzzy;
                tmp4 = tex2D(_MainTex, tmp3.xy);
                tmp2 = tmp2.xzzy + inp.texcoord.xyxy;
                tmp5 = tex2D(_MainTex, tmp2.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp6 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = 0.5 - tmp6.w;
                tmp1.w = tmp1.w - inp.texcoord5.x;
                tmp1.w = tmp1.w * inp.texcoord5.y + 0.5;
                tmp3.x = _OutlineWidth * _ScaleRatioA;
                tmp3.y = _OutlineSoftness * _ScaleRatioA;
                tmp3.xz = tmp3.xy * inp.texcoord5.yy;
                tmp6 = inp.color * _FaceColor;
                tmp4.x = inp.color.w * _OutlineColor.w;
                tmp4.yz = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_FaceTex, tmp4.yz);
                tmp6 = tmp6 * tmp7;
                tmp4.yz = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp7 = tex2D(_OutlineTex, tmp4.yz);
                tmp5.xyz = tmp7.xyz * _OutlineColor.xyz;
                tmp7.w = tmp4.x * tmp7.w;
                tmp4.x = -tmp3.x * 0.5 + tmp1.w;
                tmp3.z = tmp3.z * 0.5 + tmp4.x;
                tmp3.y = tmp3.y * inp.texcoord5.y + 1.0;
                tmp3.y = saturate(tmp3.z / tmp3.y);
                tmp3.y = 1.0 - tmp3.y;
                tmp1.w = saturate(tmp3.x * 0.5 + tmp1.w);
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.x = sqrt(tmp3.x);
                tmp3.x = tmp1.w * tmp3.x;
                tmp6.xyz = tmp6.www * tmp6.xyz;
                tmp7.xyz = tmp5.xyz * tmp7.www;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp3.xxxx * tmp7 + tmp6;
                tmp6 = tmp3.yyyy * tmp6;
                tmp3.x = max(tmp6.w, 0.0001);
                tmp3.xyz = tmp6.xyz / tmp3.xxx;
                tmp4.x = _ShaderFlags * 0.5;
                tmp4.y = tmp4.x >= -tmp4.x;
                tmp4.x = frac(abs(tmp4.x));
                tmp4.x = tmp4.y ? tmp4.x : -tmp4.x;
                tmp4.x = tmp4.x >= 0.5;
                tmp4.y = inp.texcoord5.x + _BevelOffset;
                tmp2.x = tmp4.w;
                tmp2.y = tmp5.w;
                tmp2.z = tmp3.w;
                tmp2 = tmp4.yyyy + tmp2;
                tmp3.w = _BevelWidth + _OutlineWidth;
                tmp3.w = max(tmp3.w, 0.01);
                tmp2 = tmp2 - float4(0.5, 0.5, 0.5, 0.5);
                tmp2 = tmp2 / tmp3.wwww;
                tmp2 = saturate(tmp2 + float4(0.5, 0.5, 0.5, 0.5));
                tmp5 = tmp2 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp5 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp5);
                tmp2 = tmp4.xxxx ? tmp5 : tmp2;
                tmp4 = tmp2 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp2;
                tmp2 = _BevelRoundness.xxxx * tmp4 + tmp2;
                tmp4.x = 1.0 - _BevelClamp;
                tmp2 = min(tmp2, tmp4.xxxx);
                tmp3.w = tmp3.w * _Bevel;
                tmp3.w = tmp3.w * _GradientScale;
                tmp3.w = tmp3.w * -2.0;
                tmp2.xz = tmp2.xz * tmp3.ww;
                tmp2.yz = tmp2.wy * tmp3.ww + -tmp2.zx;
                tmp2.xw = float2(-1.0, 1.0);
                tmp2.w = dot(tmp2.zw, tmp2.zw);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.yz = tmp2.ww * float2(1.0, 0.0);
                tmp4.x = tmp2.w * tmp2.z;
                tmp2.w = dot(tmp2.xy, tmp2.xy);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.z = 0.0;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp5.xyz = tmp2.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.zxy * tmp2.yzx + -tmp5.xyz;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.w = dot(tmp4.xy, tmp4.xy);
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp4.z = sqrt(tmp2.w);
                tmp2.w = _BumpOutline - _BumpFace;
                tmp2.w = tmp1.w * tmp2.w + _BumpFace;
                tmp4.xyz = tmp4.xyz * tmp2.www + float3(-0.0, -0.0, -1.0);
                tmp4.xyz = tmp6.www * tmp4.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp1.w * tmp2.w + _FaceShininess;
                tmp4.xyz = inp.texcoord4.yyy * unity_WorldToLight._m01_m11_m21;
                tmp4.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord4.xxx + tmp4.xyz;
                tmp4.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord4.zzz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz + unity_WorldToLight._m03_m13_m23;
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord4.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord4.xxx + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.zzz + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp2.www ? tmp5.xyz : inp.texcoord4.xyz;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.w = tmp5.y * 0.25 + 0.75;
                    tmp3.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp2.w, tmp3.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp2.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp3.w = dot(tmp4.xyz, tmp4.xyz);
                tmp5 = tex2D(_LightTextureB0, tmp3.ww);
                tmp4 = texCUBE(_LightTexture0, tmp4.xyz);
                tmp3.w = tmp4.w * tmp5.x;
                tmp2.w = tmp2.w * tmp3.w;
                tmp4.x = dot(inp.texcoord1.xyz, -tmp2.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, -tmp2.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, -tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp4.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * tmp4.xyz;
                tmp4.xyz = tmp2.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = dot(tmp2.xyz, tmp1.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.z = tmp1.w * 128.0;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = pow(2.0, tmp0.y);
                tmp1.xyz = tmp3.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.xyz * _SpecColor.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.xxx + tmp0.yzw;
                o.sv_target.w = tmp6.w;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _OutlineShininess; // 564 (starting at cb0[35].y)
            float _FaceShininess; // 560 (starting at cb0[35].x)
            float _FaceUVSpeedX; // 128 (starting at cb0[8].x)
            float _FaceUVSpeedY; // 132 (starting at cb0[8].y)
            float4 _FaceColor; // 144 (starting at cb0[9].x)
            float _OutlineSoftness; // 164 (starting at cb0[10].y)
            float _OutlineUVSpeedX; // 168 (starting at cb0[10].z)
            float _OutlineUVSpeedY; // 172 (starting at cb0[10].w)
            float4 _OutlineColor; // 176 (starting at cb0[11].x)
            float _OutlineWidth; // 192 (starting at cb0[12].x)
            float _Bevel; // 196 (starting at cb0[12].y)
            float _BevelOffset; // 200 (starting at cb0[12].z)
            float _BevelWidth; // 204 (starting at cb0[12].w)
            float _BevelClamp; // 208 (starting at cb0[13].x)
            float _BevelRoundness; // 212 (starting at cb0[13].y)
            float _BumpOutline; // 216 (starting at cb0[13].z)
            float _BumpFace; // 220 (starting at cb0[13].w)
            float _ShaderFlags; // 448 (starting at cb0[28].x)
            float _TextureWidth; // 536 (starting at cb0[33].z)
            float _TextureHeight; // 540 (starting at cb0[33].w)
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            float4 _SpecColor; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 3
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb3[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb3[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb3[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb3[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _FaceTex; // 1
            sampler2D _OutlineTex; // 2
            sampler2D _BumpMap; // 3
            sampler2D _LightTexture0; // 4

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xy = float2(1.0, 1.0) / float2(_TextureWidth.x, _TextureHeight.x);
                tmp1.z = 0.0;
                tmp2 = inp.texcoord.xyxy - tmp1.xzzy;
                tmp3 = tex2D(_MainTex, tmp2.xy);
                tmp1 = tmp1.xzzy + inp.texcoord.xyxy;
                tmp4 = tex2D(_MainTex, tmp1.xy);
                tmp2 = tex2D(_MainTex, tmp2.zw);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp5 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.x = 0.5 - tmp5.w;
                tmp2.x = tmp2.x - inp.texcoord5.x;
                tmp2.x = tmp2.x * inp.texcoord5.y + 0.5;
                tmp2.y = _OutlineWidth * _ScaleRatioA;
                tmp2.y = tmp2.y * inp.texcoord5.y;
                tmp2.z = _OutlineSoftness * _ScaleRatioA;
                tmp3.x = tmp2.z * inp.texcoord5.y;
                tmp5 = inp.color * _FaceColor;
                tmp3.y = inp.color.w * _OutlineColor.w;
                tmp4.xy = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp6 = tex2D(_FaceTex, tmp4.xy);
                tmp5 = tmp5 * tmp6;
                tmp4.xy = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord.zw;
                tmp6 = tex2D(_OutlineTex, tmp4.xy);
                tmp4.xyz = tmp6.xyz * _OutlineColor.xyz;
                tmp6.w = tmp3.y * tmp6.w;
                tmp3.y = -tmp2.y * 0.5 + tmp2.x;
                tmp3.x = tmp3.x * 0.5 + tmp3.y;
                tmp2.z = tmp2.z * inp.texcoord5.y + 1.0;
                tmp2.z = saturate(tmp3.x / tmp2.z);
                tmp2.z = 1.0 - tmp2.z;
                tmp2.x = saturate(tmp2.y * 0.5 + tmp2.x);
                tmp2.y = min(tmp2.y, 1.0);
                tmp2.y = sqrt(tmp2.y);
                tmp2.y = tmp2.y * tmp2.x;
                tmp5.xyz = tmp5.www * tmp5.xyz;
                tmp6.xyz = tmp4.xyz * tmp6.www;
                tmp6 = tmp6 - tmp5;
                tmp5 = tmp2.yyyy * tmp6 + tmp5;
                tmp5 = tmp2.zzzz * tmp5;
                tmp2.y = max(tmp5.w, 0.0001);
                tmp3.xyz = tmp5.xyz / tmp2.yyy;
                tmp2.y = _ShaderFlags * 0.5;
                tmp2.z = tmp2.y >= -tmp2.y;
                tmp2.y = frac(abs(tmp2.y));
                tmp2.y = tmp2.z ? tmp2.y : -tmp2.y;
                tmp2.y = tmp2.y >= 0.5;
                tmp2.z = inp.texcoord5.x + _BevelOffset;
                tmp1.x = tmp3.w;
                tmp1.y = tmp4.w;
                tmp1.z = tmp2.w;
                tmp1 = tmp2.zzzz + tmp1;
                tmp2.z = _BevelWidth + _OutlineWidth;
                tmp2.z = max(tmp2.z, 0.01);
                tmp1 = tmp1 - float4(0.5, 0.5, 0.5, 0.5);
                tmp1 = tmp1 / tmp2.zzzz;
                tmp1 = saturate(tmp1 + float4(0.5, 0.5, 0.5, 0.5));
                tmp4 = tmp1 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp4 = float4(1.0, 1.0, 1.0, 1.0) - abs(tmp4);
                tmp1 = tmp2.yyyy ? tmp4 : tmp1;
                tmp4 = tmp1 * float4(1.570796, 1.570796, 1.570796, 1.570796);
                tmp4 = sin(tmp4);
                tmp4 = tmp4 - tmp1;
                tmp1 = _BevelRoundness.xxxx * tmp4 + tmp1;
                tmp2.y = 1.0 - _BevelClamp;
                tmp1 = min(tmp1, tmp2.yyyy);
                tmp2.y = tmp2.z * _Bevel;
                tmp2.y = tmp2.y * _GradientScale;
                tmp2.y = tmp2.y * -2.0;
                tmp1.xz = tmp1.xz * tmp2.yy;
                tmp1.yz = tmp1.wy * tmp2.yy + -tmp1.zx;
                tmp1.xw = float2(-1.0, 1.0);
                tmp1.w = dot(tmp1.zw, tmp1.zw);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.yz = tmp1.ww * float2(1.0, 0.0);
                tmp4.x = tmp1.w * tmp1.z;
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.z = 0.0;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.yzw = tmp1.xyz * tmp4.xyz;
                tmp1.xyz = tmp4.zxy * tmp1.yzx + -tmp2.yzw;
                tmp4 = tex2D(_BumpMap, inp.texcoord.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp4.xy, tmp4.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp4.z = sqrt(tmp1.w);
                tmp1.w = _BumpOutline - _BumpFace;
                tmp1.w = tmp2.x * tmp1.w + _BumpFace;
                tmp2.yzw = tmp4.xyz * tmp1.www + float3(-0.0, -0.0, -1.0);
                tmp2.yzw = tmp5.www * tmp2.yzw + float3(0.0, 0.0, 1.0);
                tmp1.xyz = tmp1.xyz - tmp2.yzw;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.w = _OutlineShininess - _FaceShininess;
                tmp1.w = tmp2.x * tmp1.w + _FaceShininess;
                tmp2.xy = inp.texcoord4.yy * unity_WorldToLight._m01_m11;
                tmp2.xy = unity_WorldToLight._m00_m10 * inp.texcoord4.xx + tmp2.xy;
                tmp2.xy = unity_WorldToLight._m02_m12 * inp.texcoord4.zz + tmp2.xy;
                tmp2.xy = tmp2.xy + unity_WorldToLight._m03_m13;
                tmp2.z = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.z) {
                    tmp2.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp4.xyz = inp.texcoord4.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord4.xxx + tmp4.xyz;
                    tmp4.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.zzz + tmp4.xyz;
                    tmp4.xyz = tmp4.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp4.xyz = tmp2.zzz ? tmp4.xyz : inp.texcoord4.xyz;
                    tmp4.xyz = tmp4.xyz - unity_ProbeVolumeMin;
                    tmp4.yzw = tmp4.xyz * unity_ProbeVolumeSizeInv;
                    tmp2.z = tmp4.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp4.x = max(tmp2.w, tmp2.z);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xzw);
                } else {
                    tmp4 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp2.z = saturate(dot(tmp4, unity_OcclusionMaskSelector));
                tmp4 = tex2D(_LightTexture0, tmp2.xy);
                tmp2.x = tmp2.z * tmp4.w;
                tmp4.x = dot(inp.texcoord1.xyz, -tmp1.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, -tmp1.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, -tmp1.xyz);
                tmp1.x = dot(tmp4.xyz, tmp4.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * tmp4.xyz;
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp0.y = tmp1.w * 128.0;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = pow(2.0, tmp0.x);
                tmp1.xyz = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.xyz * _SpecColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                o.sv_target.w = tmp5.w;
                return o;
            }
            #endif
            ENDCG
            
        }
        Pass {
            Name "Caster"
            LOD 300
            ColorMask RGB
            ZClip On
            Cull Off
            Offset 1, 1
            Fog {
                Mode Off
            }
            Tags {
                "IGNOREPROJECTOR"="true"
                "LIGHTMODE"="SHADOWCASTER"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
                "SHADOWSUPPORT"="true"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile SHADOWS_DEPTH SHADOWS_CUBE
            

            #if SHADOWS_DEPTH // Caster:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _OutlineWidth; // 48 (starting at cb0[3].x)
            float _FaceDilate; // 52 (starting at cb0[3].y)
            float _ScaleRatioA; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityShadows) // 1
                // float4 unity_LightShadowBias; // 80 (starting at cb1[5].x)
            // CBUFFER_END
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
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp0.x = -_FaceDilate * _ScaleRatioA + tmp0.x;
                o.texcoord2.x = tmp0.x * 0.5;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _OutlineWidth; // 48 (starting at cb0[3].x)
            float _FaceDilate; // 52 (starting at cb0[3].y)
            float _ScaleRatioA; // 56 (starting at cb0[3].z)
            // CBUFFER_START(UnityShadows) // 1
                // float4 unity_LightShadowBias; // 80 (starting at cb1[5].x)
            // CBUFFER_END
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
                tmp1.x = min(tmp0.w, tmp0.z);
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.position.xyw = tmp0.xyw;
                tmp0.x = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp0.x = -_FaceDilate * _ScaleRatioA + tmp0.x;
                o.texcoord2.x = tmp0.x * 0.5;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }
            #endif


            #if SHADOWS_DEPTH // Caster:DX11PixelSM40
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
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp0.w - inp.texcoord2.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp0.w - inp.texcoord2.x;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
