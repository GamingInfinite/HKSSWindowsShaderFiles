Shader "Sprites/ChainWind-Diffuse" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
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
            Name "FORWARD"
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "CanUseSpriteAtlas"="true"
                "IGNOREPROJECTOR"="true"
                "LIGHTMODE"="FORWARDBASE"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
                "SHADOWSUPPORT"="true"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile DIRECTIONAL
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature LIGHTPROBE_SH
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature SHADOWS_SCREEN
            #pragma shader_feature VERTEXLIGHT_ON
            

            #if DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord1.xyz = tmp2.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp3 = unity_4LightPosX0 - tmp0.xxxx;
                tmp4 = unity_4LightPosY0 - tmp0.yyyy;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp5 = tmp2.yyyy * tmp4;
                tmp4 = tmp4 * tmp4;
                tmp4 = tmp3 * tmp3 + tmp4;
                tmp3 = tmp3 * tmp2.xxxx + tmp5;
                tmp3 = tmp0 * tmp2.zzzz + tmp3;
                tmp0 = tmp0 * tmp0 + tmp4;
                tmp0 = max(tmp0, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp4 = rsqrt(tmp0);
                tmp0 = tmp0 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) / tmp0;
                tmp3 = tmp3 * tmp4;
                tmp3 = max(tmp3, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp0 * tmp3;
                tmp3.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp3.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp3.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp3.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                tmp3.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp3.xyz = tmp0.xyz * tmp3.xyz + float3(0.01252288, 0.01252288, 0.01252288);
                tmp0.w = tmp2.y * tmp2.y;
                tmp0.w = tmp2.x * tmp2.x + -tmp0.w;
                tmp2 = tmp2.yzzx * tmp2.xyzz;
                tmp4.x = dot(unity_SHBr, tmp2);
                tmp4.y = dot(unity_SHBg, tmp2);
                tmp4.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp4.xyz;
                o.texcoord4.xyz = tmp0.xyz * tmp3.xyz + tmp2.xyz;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord5.zw = tmp1.zw;
                o.texcoord5.xy = tmp0.zz + tmp0.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord1.xyz = tmp2.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp3 = unity_4LightPosX0 - tmp0.xxxx;
                tmp4 = unity_4LightPosY0 - tmp0.yyyy;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp5 = tmp2.yyyy * tmp4;
                tmp4 = tmp4 * tmp4;
                tmp4 = tmp3 * tmp3 + tmp4;
                tmp3 = tmp3 * tmp2.xxxx + tmp5;
                tmp3 = tmp0 * tmp2.zzzz + tmp3;
                tmp0 = tmp0 * tmp0 + tmp4;
                tmp0 = max(tmp0, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp4 = rsqrt(tmp0);
                tmp0 = tmp0 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) / tmp0;
                tmp3 = tmp3 * tmp4;
                tmp3 = max(tmp3, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp0 * tmp3;
                tmp3.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp3.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp3.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp3.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                tmp3.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp3.xyz = tmp0.xyz * tmp3.xyz + float3(0.01252288, 0.01252288, 0.01252288);
                tmp0.w = tmp2.y * tmp2.y;
                tmp0.w = tmp2.x * tmp2.x + -tmp0.w;
                tmp2 = tmp2.yzzx * tmp2.xyzz;
                tmp4.x = dot(unity_SHBr, tmp2);
                tmp4.y = dot(unity_SHBg, tmp2);
                tmp4.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp4.xyz;
                o.texcoord4.xyz = tmp0.xyz * tmp3.xyz + tmp2.xyz;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord5.zw = tmp1.zw;
                o.texcoord5.xy = tmp0.zz + tmp0.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && PIXELSNAP_ON && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord1.xyz = tmp2.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp3 = unity_4LightPosX0 - tmp0.xxxx;
                tmp4 = unity_4LightPosY0 - tmp0.yyyy;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp5 = tmp2.yyyy * tmp4;
                tmp4 = tmp4 * tmp4;
                tmp4 = tmp3 * tmp3 + tmp4;
                tmp3 = tmp3 * tmp2.xxxx + tmp5;
                tmp3 = tmp0 * tmp2.zzzz + tmp3;
                tmp0 = tmp0 * tmp0 + tmp4;
                tmp0 = max(tmp0, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp4 = rsqrt(tmp0);
                tmp0 = tmp0 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) / tmp0;
                tmp3 = tmp3 * tmp4;
                tmp3 = max(tmp3, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp0 * tmp3;
                tmp3.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp3.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp3.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp3.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                tmp3.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp3.xyz = tmp0.xyz * tmp3.xyz + float3(0.01252288, 0.01252288, 0.01252288);
                tmp0.w = tmp2.y * tmp2.y;
                tmp0.w = tmp2.x * tmp2.x + -tmp0.w;
                tmp2 = tmp2.yzzx * tmp2.xyzz;
                tmp4.x = dot(unity_SHBr, tmp2);
                tmp4.y = dot(unity_SHBg, tmp2);
                tmp4.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp4.xyz;
                o.texcoord4.xyz = tmp0.xyz * tmp3.xyz + tmp2.xyz;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord5.zw = tmp1.zw;
                o.texcoord5.xy = tmp0.zz + tmp0.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // CBUFFER_END
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.w = tmp1.y * tmp1.y;
                tmp1.w = tmp1.x * tmp1.x + -tmp1.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp1.x = dot(unity_SHBr, tmp2);
                tmp1.y = dot(unity_SHBg, tmp2);
                tmp1.z = dot(unity_SHBb, tmp2);
                o.texcoord4.xyz = unity_SHC.xyz * tmp1.www + tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_4LightPosX0; // 48 (starting at cb2[3].x)
            // CBUFFER_END
            // float4 unity_4LightPosY0; // 64 (starting at cb2[4].x)
            // float4 unity_4LightPosZ0; // 80 (starting at cb2[5].x)
            // float4 unity_4LightAtten0; // 96 (starting at cb2[6].x)
            // float4 unity_LightColor[8]; // 112 (starting at cb2[7].x)
            // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
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
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.w = tmp1.y * tmp1.y;
                tmp0.w = tmp1.x * tmp1.x + -tmp0.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp3.xyz;
                tmp1.w = 1.0;
                tmp3.x = dot(unity_SHAr, tmp1);
                tmp3.y = dot(unity_SHAg, tmp1);
                tmp3.z = dot(unity_SHAb, tmp1);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp3 = unity_4LightPosY0 - tmp0.yyyy;
                tmp4 = tmp1.yyyy * tmp3;
                tmp3 = tmp3 * tmp3;
                tmp5 = unity_4LightPosX0 - tmp0.xxxx;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp4 = tmp5 * tmp1.xxxx + tmp4;
                tmp3 = tmp5 * tmp5 + tmp3;
                tmp3 = tmp0 * tmp0 + tmp3;
                tmp0 = tmp0 * tmp1.zzzz + tmp4;
                tmp1 = max(tmp3, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp3 = rsqrt(tmp1);
                tmp1 = tmp1 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp1 = float4(1.0, 1.0, 1.0, 1.0) / tmp1;
                tmp0 = tmp0 * tmp3;
                tmp0 = max(tmp0, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp1 * tmp0;
                tmp1.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp1.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp1.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                o.texcoord4.xyz = tmp2.xyz + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord1.xyz = tmp2.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp3 = unity_4LightPosX0 - tmp0.xxxx;
                tmp4 = unity_4LightPosY0 - tmp0.yyyy;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp5 = tmp2.yyyy * tmp4;
                tmp4 = tmp4 * tmp4;
                tmp4 = tmp3 * tmp3 + tmp4;
                tmp3 = tmp3 * tmp2.xxxx + tmp5;
                tmp3 = tmp0 * tmp2.zzzz + tmp3;
                tmp0 = tmp0 * tmp0 + tmp4;
                tmp0 = max(tmp0, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp4 = rsqrt(tmp0);
                tmp0 = tmp0 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) / tmp0;
                tmp3 = tmp3 * tmp4;
                tmp3 = max(tmp3, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp0 * tmp3;
                tmp3.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp3.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp3.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp3.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                tmp3.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp3.xyz = tmp0.xyz * tmp3.xyz + float3(0.01252288, 0.01252288, 0.01252288);
                tmp0.w = tmp2.y * tmp2.y;
                tmp0.w = tmp2.x * tmp2.x + -tmp0.w;
                tmp2 = tmp2.yzzx * tmp2.xyzz;
                tmp4.x = dot(unity_SHBr, tmp2);
                tmp4.y = dot(unity_SHBg, tmp2);
                tmp4.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp4.xyz;
                o.texcoord4.xyz = tmp0.xyz * tmp3.xyz + tmp2.xyz;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord5.zw = tmp1.zw;
                o.texcoord5.xy = tmp0.zz + tmp0.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // CBUFFER_END
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.w = tmp1.y * tmp1.y;
                tmp1.w = tmp1.x * tmp1.x + -tmp1.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp1.x = dot(unity_SHBr, tmp2);
                tmp1.y = dot(unity_SHBg, tmp2);
                tmp1.z = dot(unity_SHBb, tmp2);
                o.texcoord4.xyz = unity_SHC.xyz * tmp1.www + tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_4LightPosX0; // 48 (starting at cb1[3].x)
            // CBUFFER_END
            // float4 unity_4LightPosY0; // 64 (starting at cb1[4].x)
            // float4 unity_4LightPosZ0; // 80 (starting at cb1[5].x)
            // float4 unity_4LightAtten0; // 96 (starting at cb1[6].x)
            // float4 unity_LightColor[8]; // 112 (starting at cb1[7].x)
            // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.w = tmp1.y * tmp1.y;
                tmp0.w = tmp1.x * tmp1.x + -tmp0.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp3.xyz;
                tmp1.w = 1.0;
                tmp3.x = dot(unity_SHAr, tmp1);
                tmp3.y = dot(unity_SHAg, tmp1);
                tmp3.z = dot(unity_SHAb, tmp1);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp3 = unity_4LightPosY0 - tmp0.yyyy;
                tmp4 = tmp1.yyyy * tmp3;
                tmp3 = tmp3 * tmp3;
                tmp5 = unity_4LightPosX0 - tmp0.xxxx;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp4 = tmp5 * tmp1.xxxx + tmp4;
                tmp1 = tmp0 * tmp1.zzzz + tmp4;
                tmp3 = tmp5 * tmp5 + tmp3;
                tmp0 = tmp0 * tmp0 + tmp3;
                tmp0 = max(tmp0, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp3 = rsqrt(tmp0);
                tmp0 = tmp0 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) / tmp0;
                tmp1 = tmp1 * tmp3;
                tmp1 = max(tmp1, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp0 * tmp1;
                tmp1.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp1.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp1.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                o.texcoord4.xyz = tmp2.xyz + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && PIXELSNAP_ON && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // CBUFFER_END
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.w = tmp1.y * tmp1.y;
                tmp1.w = tmp1.x * tmp1.x + -tmp1.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp1.x = dot(unity_SHBr, tmp2);
                tmp1.y = dot(unity_SHBg, tmp2);
                tmp1.z = dot(unity_SHBb, tmp2);
                o.texcoord4.xyz = unity_SHC.xyz * tmp1.www + tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && PIXELSNAP_ON && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_4LightPosX0; // 48 (starting at cb2[3].x)
            // CBUFFER_END
            // float4 unity_4LightPosY0; // 64 (starting at cb2[4].x)
            // float4 unity_4LightPosZ0; // 80 (starting at cb2[5].x)
            // float4 unity_4LightAtten0; // 96 (starting at cb2[6].x)
            // float4 unity_LightColor[8]; // 112 (starting at cb2[7].x)
            // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
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
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.w = tmp1.y * tmp1.y;
                tmp0.w = tmp1.x * tmp1.x + -tmp0.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp3.xyz;
                tmp1.w = 1.0;
                tmp3.x = dot(unity_SHAr, tmp1);
                tmp3.y = dot(unity_SHAg, tmp1);
                tmp3.z = dot(unity_SHAb, tmp1);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp3 = unity_4LightPosY0 - tmp0.yyyy;
                tmp4 = tmp1.yyyy * tmp3;
                tmp3 = tmp3 * tmp3;
                tmp5 = unity_4LightPosX0 - tmp0.xxxx;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp4 = tmp5 * tmp1.xxxx + tmp4;
                tmp3 = tmp5 * tmp5 + tmp3;
                tmp3 = tmp0 * tmp0 + tmp3;
                tmp0 = tmp0 * tmp1.zzzz + tmp4;
                tmp1 = max(tmp3, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp3 = rsqrt(tmp1);
                tmp1 = tmp1 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp1 = float4(1.0, 1.0, 1.0, 1.0) / tmp1;
                tmp0 = tmp0 * tmp3;
                tmp0 = max(tmp0, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp1 * tmp0;
                tmp1.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp1.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp1.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                o.texcoord4.xyz = tmp2.xyz + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord4.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // CBUFFER_END
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.w = tmp1.y * tmp1.y;
                tmp1.w = tmp1.x * tmp1.x + -tmp1.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp1.x = dot(unity_SHBr, tmp2);
                tmp1.y = dot(unity_SHBg, tmp2);
                tmp1.z = dot(unity_SHBb, tmp2);
                o.texcoord4.xyz = unity_SHC.xyz * tmp1.www + tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_4LightPosX0; // 48 (starting at cb1[3].x)
            // CBUFFER_END
            // float4 unity_4LightPosY0; // 64 (starting at cb1[4].x)
            // float4 unity_4LightPosZ0; // 80 (starting at cb1[5].x)
            // float4 unity_4LightAtten0; // 96 (starting at cb1[6].x)
            // float4 unity_LightColor[8]; // 112 (starting at cb1[7].x)
            // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.w = tmp1.y * tmp1.y;
                tmp0.w = tmp1.x * tmp1.x + -tmp0.w;
                tmp2 = tmp1.yzzx * tmp1.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp2.xyz = unity_SHC.xyz * tmp0.www + tmp3.xyz;
                tmp1.w = 1.0;
                tmp3.x = dot(unity_SHAr, tmp1);
                tmp3.y = dot(unity_SHAg, tmp1);
                tmp3.z = dot(unity_SHAb, tmp1);
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp3 = unity_4LightPosY0 - tmp0.yyyy;
                tmp4 = tmp1.yyyy * tmp3;
                tmp3 = tmp3 * tmp3;
                tmp5 = unity_4LightPosX0 - tmp0.xxxx;
                tmp0 = unity_4LightPosZ0 - tmp0.zzzz;
                tmp4 = tmp5 * tmp1.xxxx + tmp4;
                tmp1 = tmp0 * tmp1.zzzz + tmp4;
                tmp3 = tmp5 * tmp5 + tmp3;
                tmp0 = tmp0 * tmp0 + tmp3;
                tmp0 = max(tmp0, float4(0.000001, 0.000001, 0.000001, 0.000001));
                tmp3 = rsqrt(tmp0);
                tmp0 = tmp0 * unity_4LightAtten0 + float4(1.0, 1.0, 1.0, 1.0);
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) / tmp0;
                tmp1 = tmp1 * tmp3;
                tmp1 = max(tmp1, float4(0.0, 0.0, 0.0, 0.0));
                tmp0 = tmp0 * tmp1;
                tmp1.xyz = tmp0.yyy * unity_LightColor[1].xyz;
                tmp1.xyz = unity_LightColor[0].xyz * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_LightColor[2].xyz * tmp0.zzz + tmp1.xyz;
                tmp0.xyz = unity_LightColor[3].xyz * tmp0.www + tmp0.xyz;
                o.texcoord4.xyz = tmp2.xyz + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && SHADOWS_SCREEN && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord4.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord4.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord4.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && SHADOWS_SCREEN
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3 = v.color * _Color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.zw = tmp0.zw;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && VERTEXLIGHT_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }
            #endif


            #if DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // CBUFFER_END
            // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _ShadowMapTexture; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.z = tmp1.z - tmp2.x;
                tmp1.x = tmp1.x * tmp1.z + tmp2.x;
                tmp1.xzw = tmp1.xxx * _LightColor0.xyz;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25;
                    tmp2.y = unity_ProbeVolumeParams.z * 0.5;
                    tmp3.x = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp1.y = max(tmp1.y, tmp2.y);
                    tmp2.x = min(tmp3.x, tmp1.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                    tmp4.xyz = tmp2.xzw + float3(0.25, 0.0, 0.0);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xyz);
                    tmp2.xyz = tmp2.xzw + float3(0.5, 0.0, 0.0);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xyz);
                    tmp5.xyz = inp.texcoord1.xyz;
                    tmp5.w = 1.0;
                    tmp3.x = dot(tmp3, tmp5);
                    tmp3.y = dot(tmp4, tmp5);
                    tmp3.z = dot(tmp2, tmp5);
                } else {
                    tmp2.xyz = inp.texcoord1.xyz;
                    tmp2.w = 1.0;
                    tmp3.x = dot(unity_SHAr, tmp2);
                    tmp3.y = dot(unity_SHAg, tmp2);
                    tmp3.z = dot(unity_SHAb, tmp2);
                }
                tmp2.xyz = tmp3.xyz + inp.texcoord4.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp1.y = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.xzw = tmp0.xyz * tmp1.xzw;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp1.xzw * tmp1.yyy + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // CBUFFER_END
            // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _ShadowMapTexture; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.z = tmp1.z - tmp2.x;
                tmp1.x = tmp1.x * tmp1.z + tmp2.x;
                tmp1.xzw = tmp1.xxx * _LightColor0.xyz;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25;
                    tmp2.y = unity_ProbeVolumeParams.z * 0.5;
                    tmp3.x = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp1.y = max(tmp1.y, tmp2.y);
                    tmp2.x = min(tmp3.x, tmp1.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                    tmp4.xyz = tmp2.xzw + float3(0.25, 0.0, 0.0);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xyz);
                    tmp2.xyz = tmp2.xzw + float3(0.5, 0.0, 0.0);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xyz);
                    tmp5.xyz = inp.texcoord1.xyz;
                    tmp5.w = 1.0;
                    tmp3.x = dot(tmp3, tmp5);
                    tmp3.y = dot(tmp4, tmp5);
                    tmp3.z = dot(tmp2, tmp5);
                } else {
                    tmp2.xyz = inp.texcoord1.xyz;
                    tmp2.w = 1.0;
                    tmp3.x = dot(unity_SHAr, tmp2);
                    tmp3.y = dot(unity_SHAg, tmp2);
                    tmp3.z = dot(unity_SHAb, tmp2);
                }
                tmp2.xyz = tmp3.xyz + inp.texcoord4.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp1.y = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.xzw = tmp0.xyz * tmp1.xzw;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp1.xzw * tmp1.yyy + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && PIXELSNAP_ON && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // CBUFFER_END
            // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ShadowMapTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.z = tmp1.z - tmp2.x;
                tmp1.x = tmp1.x * tmp1.z + tmp2.x;
                tmp1.xzw = tmp1.xxx * _LightColor0.xyz;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25;
                    tmp2.y = unity_ProbeVolumeParams.z * 0.5;
                    tmp3.x = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp1.y = max(tmp1.y, tmp2.y);
                    tmp2.x = min(tmp3.x, tmp1.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                    tmp4.xyz = tmp2.xzw + float3(0.25, 0.0, 0.0);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xyz);
                    tmp2.xyz = tmp2.xzw + float3(0.5, 0.0, 0.0);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xyz);
                    tmp5.xyz = inp.texcoord1.xyz;
                    tmp5.w = 1.0;
                    tmp3.x = dot(tmp3, tmp5);
                    tmp3.y = dot(tmp4, tmp5);
                    tmp3.z = dot(tmp2, tmp5);
                } else {
                    tmp2.xyz = inp.texcoord1.xyz;
                    tmp2.w = 1.0;
                    tmp3.x = dot(unity_SHAr, tmp2);
                    tmp3.y = dot(unity_SHAg, tmp2);
                    tmp3.z = dot(unity_SHAb, tmp2);
                }
                tmp2.xyz = tmp3.xyz + inp.texcoord4.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp1.y = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.xzw = tmp0.xyz * tmp1.xzw;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp1.xzw * tmp1.yyy + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord4.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _ShadowMapTexture; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.yzw = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp1.yzw = tmp1.yzw - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp1.yzw * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25 + 0.75;
                    tmp1.z = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.z, tmp1.y);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.y = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp1.zw = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp1.zw);
                tmp1.y = tmp1.y - tmp2.x;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // CBUFFER_END
            // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ShadowMapTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp2.xy);
                tmp1.z = tmp1.z - tmp2.x;
                tmp1.x = tmp1.x * tmp1.z + tmp2.x;
                tmp1.xzw = tmp1.xxx * _LightColor0.xyz;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25;
                    tmp2.y = unity_ProbeVolumeParams.z * 0.5;
                    tmp3.x = -unity_ProbeVolumeParams.z * 0.5 + 0.25;
                    tmp1.y = max(tmp1.y, tmp2.y);
                    tmp2.x = min(tmp3.x, tmp1.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                    tmp4.xyz = tmp2.xzw + float3(0.25, 0.0, 0.0);
                    tmp4 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp4.xyz);
                    tmp2.xyz = tmp2.xzw + float3(0.5, 0.0, 0.0);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xyz);
                    tmp5.xyz = inp.texcoord1.xyz;
                    tmp5.w = 1.0;
                    tmp3.x = dot(tmp3, tmp5);
                    tmp3.y = dot(tmp4, tmp5);
                    tmp3.z = dot(tmp2, tmp5);
                } else {
                    tmp2.xyz = inp.texcoord1.xyz;
                    tmp2.w = 1.0;
                    tmp3.x = dot(unity_SHAr, tmp2);
                    tmp3.y = dot(unity_SHAg, tmp2);
                    tmp3.z = dot(unity_SHAb, tmp2);
                }
                tmp2.xyz = tmp3.xyz + inp.texcoord4.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = log(tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp2.xyz = pow(2.0, tmp2.xyz);
                tmp2.xyz = tmp2.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp1.y = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.xzw = tmp0.xyz * tmp1.xzw;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp1.xzw * tmp1.yyy + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord4.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _ShadowMapTexture; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.yzw = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp1.yzw = tmp1.yzw - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp1.yzw * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25 + 0.75;
                    tmp1.z = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.z, tmp1.y);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.y = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp1.zw = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp1.zw);
                tmp1.y = tmp1.y - tmp2.x;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord4.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ShadowMapTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.yzw = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp1.yzw = tmp1.yzw - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp1.yzw * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25 + 0.75;
                    tmp1.z = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.z, tmp1.y);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.y = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp1.zw = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp1.zw);
                tmp1.y = tmp1.y - tmp2.x;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && LIGHTPROBE_SH
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord4.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && SHADOWS_SCREEN
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb2[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityShadows) // 3
                // float4 _LightShadowData; // 384 (starting at cb3[24].x)
            // CBUFFER_END
            // float4 unity_ShadowFadeCenterAndType; // 400 (starting at cb3[25].x)
            // CBUFFER_START(UnityProbeVolume) // 5
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb5[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb5[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb5[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb5[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ShadowMapTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp2.x = unity_MatrixV._m20;
                tmp2.y = unity_MatrixV._m21;
                tmp2.z = unity_MatrixV._m22;
                tmp1.x = dot(tmp1.xyz, tmp2.xyz);
                tmp1.yzw = inp.texcoord2.xyz - unity_ShadowFadeCenterAndType.xyz;
                tmp1.y = dot(tmp1.yzw, tmp1.yzw);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = unity_ShadowFadeCenterAndType.w * tmp1.y + tmp1.x;
                tmp1.x = saturate(tmp1.x * _LightShadowData.z + _LightShadowData.w);
                tmp1.y = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.y) {
                    tmp1.y = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.yzw = tmp1.yyy ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp1.yzw = tmp1.yzw - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp1.yzw * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp2.y * 0.25 + 0.75;
                    tmp1.z = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.z, tmp1.y);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.y = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp1.zw = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp2 = tex2D(_ShadowMapTexture, tmp1.zw);
                tmp1.y = tmp1.y - tmp2.x;
                tmp1.x = tmp1.x * tmp1.y + tmp2.x;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
        Pass {
            Name "FORWARD"
            Blend One One, One One
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "CanUseSpriteAtlas"="true"
                "IGNOREPROJECTOR"="true"
                "LIGHTMODE"="FORWARDADD"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile POINT DIRECTIONAL SPOT POINT_COOKIE DIRECTIONAL_COOKIE
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature PIXELSNAP_ON
            

            #if ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && POINT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SPOT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1 = tmp0.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp1 = unity_WorldToLight._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_WorldToLight._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.texcoord4 = unity_WorldToLight._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && POINT_COOKIE
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL_COOKIE && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xy = tmp1.yy * unity_WorldToLight._m01_m11;
                tmp0.xy = unity_WorldToLight._m00_m10 * tmp1.xx + tmp0.xy;
                tmp0.xy = unity_WorldToLight._m02_m12 * tmp1.zz + tmp0.xy;
                o.texcoord4.xy = unity_WorldToLight._m03_m13 * tmp1.ww + tmp0.xy;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && POINT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && SPOT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1 = tmp0.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp1 = unity_WorldToLight._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_WorldToLight._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.texcoord4 = unity_WorldToLight._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && POINT_COOKIE
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL_COOKIE && ETC1_EXTERNAL_ALPHA
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
                float2 texcoord : TEXCOORD;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xy = tmp1.yy * unity_WorldToLight._m01_m11;
                tmp0.xy = unity_WorldToLight._m00_m10 * tmp1.xx + tmp0.xy;
                tmp0.xy = unity_WorldToLight._m02_m12 * tmp1.zz + tmp0.xy;
                o.texcoord4.xy = unity_WorldToLight._m03_m13 * tmp1.ww + tmp0.xy;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif PIXELSNAP_ON && POINT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif PIXELSNAP_ON && SPOT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1 = tmp0.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp1 = unity_WorldToLight._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_WorldToLight._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.texcoord4 = unity_WorldToLight._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif PIXELSNAP_ON && POINT_COOKIE
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL_COOKIE && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xy = tmp1.yy * unity_WorldToLight._m01_m11;
                tmp0.xy = unity_WorldToLight._m00_m10 * tmp1.xx + tmp0.xy;
                tmp0.xy = unity_WorldToLight._m02_m12 * tmp1.zz + tmp0.xy;
                o.texcoord4.xy = unity_WorldToLight._m03_m13 * tmp1.ww + tmp0.xy;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif POINT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif DIRECTIONAL
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif SPOT
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1 = tmp0.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp1 = unity_WorldToLight._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_WorldToLight._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.texcoord4 = unity_WorldToLight._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif POINT_COOKIE
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord3 = v.color * _Color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
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
                float2 texcoord : TEXCOORD;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 128 (starting at cb0[8].x)
            float4 _MainTex_ST; // 144 (starting at cb0[9].x)
            float4x4 unity_WorldToLight; // 64 (starting at cb0[4].x)
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xy = tmp1.yy * unity_WorldToLight._m01_m11;
                tmp0.xy = unity_WorldToLight._m00_m10 * tmp1.xx + tmp0.xy;
                tmp0.xy = unity_WorldToLight._m02_m12 * tmp1.zz + tmp0.xy;
                o.texcoord4.xy = unity_WorldToLight._m03_m13 * tmp1.ww + tmp0.xy;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }
            #endif


            #if ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && POINT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTexture0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.xyz;
                tmp1 = tmp2 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2 = tex2D(_LightTexture0, tmp2.xx);
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && SPOT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTexture0; // 2
            sampler2D _LightTextureB0; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.xyz;
                tmp1 = tmp2 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2 = inp.texcoord2.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp2 = unity_WorldToLight._m00_m10_m20_m30 * inp.texcoord2.xxxx + tmp2;
                tmp2 = unity_WorldToLight._m02_m12_m22_m32 * inp.texcoord2.zzzz + tmp2;
                tmp2 = tmp2 + unity_WorldToLight._m03_m13_m23_m33;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp3.y = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp3.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp3.x = tmp2.z > 0.0;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp3.yz = tmp2.xy / tmp2.ww;
                tmp3.yz = tmp3.yz + float2(0.5, 0.5);
                tmp4 = tex2D(_LightTexture0, tmp3.yz);
                tmp2.w = tmp3.x * tmp4.w;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.xx);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && POINT_COOKIE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTextureB0; // 2
            samplerCUBE _LightTexture0; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.xyz;
                tmp1 = tmp2 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.ww);
                tmp2 = texCUBE(_LightTexture0, tmp2.xyz);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL_COOKIE && ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTexture0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xy = inp.texcoord2.yy * unity_WorldToLight._m01_m11;
                tmp1.xy = unity_WorldToLight._m00_m10 * inp.texcoord2.xx + tmp1.xy;
                tmp1.xy = unity_WorldToLight._m02_m12 * inp.texcoord2.zz + tmp1.xy;
                tmp1.xy = tmp1.xy + unity_WorldToLight._m03_m13;
                tmp1.z = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.z) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2 = tex2D(_LightTexture0, tmp1.xy);
                tmp1.x = tmp1.z * tmp2.w;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && POINT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTexture0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.xyz;
                tmp1 = tmp2 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2 = tex2D(_LightTexture0, tmp2.xx);
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && SPOT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTexture0; // 2
            sampler2D _LightTextureB0; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.xyz;
                tmp1 = tmp2 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2 = inp.texcoord2.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp2 = unity_WorldToLight._m00_m10_m20_m30 * inp.texcoord2.xxxx + tmp2;
                tmp2 = unity_WorldToLight._m02_m12_m22_m32 * inp.texcoord2.zzzz + tmp2;
                tmp2 = tmp2 + unity_WorldToLight._m03_m13_m23_m33;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp3.y = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp3.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp3.x = tmp2.z > 0.0;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp3.yz = tmp2.xy / tmp2.ww;
                tmp3.yz = tmp3.yz + float2(0.5, 0.5);
                tmp4 = tex2D(_LightTexture0, tmp3.yz);
                tmp2.w = tmp3.x * tmp4.w;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.xx);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && POINT_COOKIE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTextureB0; // 2
            samplerCUBE _LightTexture0; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2.xyz = tmp1.xyz;
                tmp1 = tmp2 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.ww);
                tmp2 = texCUBE(_LightTexture0, tmp2.xyz);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL_COOKIE && ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1
            sampler2D _LightTexture0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1.xyz = tmp0.xyz;
                tmp0 = tmp1 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xy = inp.texcoord2.yy * unity_WorldToLight._m01_m11;
                tmp1.xy = unity_WorldToLight._m00_m10 * inp.texcoord2.xx + tmp1.xy;
                tmp1.xy = unity_WorldToLight._m02_m12 * inp.texcoord2.zz + tmp1.xy;
                tmp1.xy = tmp1.xy + unity_WorldToLight._m03_m13;
                tmp1.z = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.z) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2 = tex2D(_LightTexture0, tmp1.xy);
                tmp1.x = tmp1.z * tmp2.w;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif PIXELSNAP_ON && POINT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTexture0; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2 = tex2D(_LightTexture0, tmp2.xx);
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif PIXELSNAP_ON && SPOT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTexture0; // 1
            sampler2D _LightTextureB0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2 = inp.texcoord2.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp2 = unity_WorldToLight._m00_m10_m20_m30 * inp.texcoord2.xxxx + tmp2;
                tmp2 = unity_WorldToLight._m02_m12_m22_m32 * inp.texcoord2.zzzz + tmp2;
                tmp2 = tmp2 + unity_WorldToLight._m03_m13_m23_m33;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp3.y = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp3.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp3.x = tmp2.z > 0.0;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp3.yz = tmp2.xy / tmp2.ww;
                tmp3.yz = tmp3.yz + float2(0.5, 0.5);
                tmp4 = tex2D(_LightTexture0, tmp3.yz);
                tmp2.w = tmp3.x * tmp4.w;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.xx);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif PIXELSNAP_ON && POINT_COOKIE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTextureB0; // 1
            samplerCUBE _LightTexture0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.ww);
                tmp2 = texCUBE(_LightTexture0, tmp2.xyz);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL_COOKIE && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTexture0; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xy = inp.texcoord2.yy * unity_WorldToLight._m01_m11;
                tmp1.xy = unity_WorldToLight._m00_m10 * inp.texcoord2.xx + tmp1.xy;
                tmp1.xy = unity_WorldToLight._m02_m12 * inp.texcoord2.zz + tmp1.xy;
                tmp1.xy = tmp1.xy + unity_WorldToLight._m03_m13;
                tmp1.z = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.z) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2 = tex2D(_LightTexture0, tmp1.xy);
                tmp1.x = tmp1.z * tmp2.w;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif POINT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTexture0; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2 = tex2D(_LightTexture0, tmp2.xx);
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif DIRECTIONAL
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.x) {
                    tmp1.x = unity_ProbeVolumeParams.y == 1.0;
                    tmp1.yzw = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp1.yzw;
                    tmp1.yzw = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp1.yzw;
                    tmp1.yzw = tmp1.yzw + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp1.xyz = tmp1.xxx ? tmp1.yzw : inp.texcoord2.xyz;
                    tmp1.xyz = tmp1.xyz - unity_ProbeVolumeMin;
                    tmp1.yzw = tmp1.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.y = tmp1.y * 0.25 + 0.75;
                    tmp2.x = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp1.x = max(tmp1.y, tmp2.x);
                    tmp1 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp1.xzw);
                } else {
                    tmp1 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.x = saturate(dot(tmp1, unity_OcclusionMaskSelector));
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif SPOT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTexture0; // 1
            sampler2D _LightTextureB0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2 = inp.texcoord2.yyyy * unity_WorldToLight._m01_m11_m21_m31;
                tmp2 = unity_WorldToLight._m00_m10_m20_m30 * inp.texcoord2.xxxx + tmp2;
                tmp2 = unity_WorldToLight._m02_m12_m22_m32 * inp.texcoord2.zzzz + tmp2;
                tmp2 = tmp2 + unity_WorldToLight._m03_m13_m23_m33;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp3.y = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp3.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp3.x = tmp2.z > 0.0;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp3.yz = tmp2.xy / tmp2.ww;
                tmp3.yz = tmp3.yz + float2(0.5, 0.5);
                tmp4 = tex2D(_LightTexture0, tmp3.yz);
                tmp2.w = tmp3.x * tmp4.w;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.xx);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif POINT_COOKIE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTextureB0; // 1
            samplerCUBE _LightTexture0; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.texcoord3;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.texcoord2.yyy * unity_WorldToLight._m01_m11_m21;
                tmp2.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + unity_WorldToLight._m03_m13_m23;
                tmp0.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp0.w) {
                    tmp0.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp3.xyz = tmp0.www ? tmp3.xyz : inp.texcoord2.xyz;
                    tmp3.xyz = tmp3.xyz - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp3.xyz * unity_ProbeVolumeSizeInv;
                    tmp0.w = tmp3.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.w, tmp2.w);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.w = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp3 = tex2D(_LightTextureB0, tmp2.ww);
                tmp2 = texCUBE(_LightTexture0, tmp2.xyz);
                tmp2.x = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yzw = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp1.w;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _LightColor0; // 32 (starting at cb0[2].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_OcclusionMaskSelector; // 736 (starting at cb1[46].x)
            // CBUFFER_END
            // CBUFFER_START(UnityProbeVolume) // 2
                // float4x4 unity_ProbeVolumeWorldToObject; // 16 (starting at cb2[1].x)
            // CBUFFER_END
            // float4 unity_ProbeVolumeParams; // 0 (starting at cb2[0].x)
            // float3 unity_ProbeVolumeSizeInv; // 80 (starting at cb2[5].x)
            // float3 unity_ProbeVolumeMin; // 96 (starting at cb2[6].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _LightTexture0; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xy = inp.texcoord2.yy * unity_WorldToLight._m01_m11;
                tmp1.xy = unity_WorldToLight._m00_m10 * inp.texcoord2.xx + tmp1.xy;
                tmp1.xy = unity_WorldToLight._m02_m12 * inp.texcoord2.zz + tmp1.xy;
                tmp1.xy = tmp1.xy + unity_WorldToLight._m03_m13;
                tmp1.z = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.z) {
                    tmp1.z = unity_ProbeVolumeParams.y == 1.0;
                    tmp2.xyz = inp.texcoord2.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord2.xxx + tmp2.xyz;
                    tmp2.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord2.zzz + tmp2.xyz;
                    tmp2.xyz = tmp2.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp2.xyz = tmp1.zzz ? tmp2.xyz : inp.texcoord2.xyz;
                    tmp2.xyz = tmp2.xyz - unity_ProbeVolumeMin;
                    tmp2.yzw = tmp2.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.z = tmp2.y * 0.25 + 0.75;
                    tmp1.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp2.x = max(tmp1.w, tmp1.z);
                    tmp2 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp2.xzw);
                } else {
                    tmp2 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.z = saturate(dot(tmp2, unity_OcclusionMaskSelector));
                tmp2 = tex2D(_LightTexture0, tmp1.xy);
                tmp1.x = tmp1.z * tmp2.w;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.w = dot(inp.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
        Pass {
            Name "DEFERRED"
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "CanUseSpriteAtlas"="true"
                "IGNOREPROJECTOR"="true"
                "LIGHTMODE"="DEFERRED"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature LIGHTPROBE_SH
            #pragma shader_feature PIXELSNAP_ON
            #pragma shader_feature UNITY_HDR_ON
            

            #if ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif LIGHTPROBE_SH && PIXELSNAP_ON && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif LIGHTPROBE_SH && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif LIGHTPROBE_SH && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 2
                // float4 unity_SHAr; // 624 (starting at cb2[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb2[40].x)
            // float4 unity_SHAb; // 656 (starting at cb2[41].x)
            // float4 unity_SHBr; // 672 (starting at cb2[42].x)
            // float4 unity_SHBg; // 688 (starting at cb2[43].x)
            // float4 unity_SHBb; // 704 (starting at cb2[44].x)
            // float4 unity_SHC; // 720 (starting at cb2[45].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif PIXELSNAP_ON && UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif LIGHTPROBE_SH
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityLighting) // 1
                // float4 unity_SHAr; // 624 (starting at cb1[39].x)
            // CBUFFER_END
            // float4 unity_SHAg; // 640 (starting at cb1[40].x)
            // float4 unity_SHAb; // 656 (starting at cb1[41].x)
            // float4 unity_SHBr; // 672 (starting at cb1[42].x)
            // float4 unity_SHBg; // 688 (starting at cb1[43].x)
            // float4 unity_SHBb; // 704 (starting at cb1[44].x)
            // float4 unity_SHC; // 720 (starting at cb1[45].x)
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                tmp1.x = tmp0.y * tmp0.y;
                tmp1.x = tmp0.x * tmp0.x + -tmp1.x;
                tmp2 = tmp0.yzzx * tmp0.xyzz;
                tmp3.x = dot(unity_SHBr, tmp2);
                tmp3.y = dot(unity_SHBg, tmp2);
                tmp3.z = dot(unity_SHBb, tmp2);
                tmp1.xyz = unity_SHC.xyz * tmp1.xxx + tmp3.xyz;
                tmp0.w = 1.0;
                tmp2.x = dot(unity_SHAr, tmp0);
                tmp2.y = dot(unity_SHAg, tmp0);
                tmp2.z = dot(unity_SHAb, tmp0);
                tmp0.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = pow(2.0, tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord5.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                return o;
            }

            #elif UNITY_HDR_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }

            #elif PIXELSNAP_ON
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy / v.vertex.ww;
                tmp0.zw = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp0.zw;
                tmp0.xy = tmp0.xy * v.vertex.ww;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
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
                float2 texcoord : TEXCOORD;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3 = v.color * _Color;
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
            }
            #endif


            #if ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target3.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target3.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif LIGHTPROBE_SH && PIXELSNAP_ON && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target3.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target3.xyz = pow(2.0, -tmp0.xyz);
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(0.0, 0.0, 0.0, 1.0);
                return o;
            }

            #elif LIGHTPROBE_SH && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target3.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && LIGHTPROBE_SH
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target3.xyz = pow(2.0, -tmp0.xyz);
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(0.0, 0.0, 0.0, 1.0);
                return o;
            }

            #elif LIGHTPROBE_SH && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target3.xyz = pow(2.0, -tmp0.xyz);
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif PIXELSNAP_ON && UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(0.0, 0.0, 0.0, 1.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA && PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(1.0, 1.0, 1.0, 1.0);
                return o;
            }

            #elif LIGHTPROBE_SH
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz;
                tmp0.xyz = tmp0.xyz * inp.texcoord5.xyz;
                o.sv_target3.xyz = pow(2.0, -tmp0.xyz);
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3.w = 1.0;
                return o;
            }

            #elif UNITY_HDR_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(0.0, 0.0, 0.0, 1.0);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp0.w = tmp1.x;
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(1.0, 1.0, 1.0, 1.0);
                return o;
            }

            #elif PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(1.0, 1.0, 1.0, 1.0);
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
                float4 sv_target1 : SV_Target1;
                float4 sv_target2 : SV_Target2;
                float4 sv_target3 : SV_Target3;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.texcoord3;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                o.sv_target1 = float4(0.0, 0.0, 0.0, 0.0);
                o.sv_target2.xyz = inp.texcoord1.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                o.sv_target2.w = 1.0;
                o.sv_target3 = float4(1.0, 1.0, 1.0, 1.0);
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Transparent/VertexLit"
}
