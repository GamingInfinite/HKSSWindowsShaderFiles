Shader "Sprites/Darkness Sprite" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [Toggle(IS_VIGNETTE)] _ReadRToggle ("Is Vignette", Float) = 0
        [Toggle(IS_MASK_BLACKOUT)] _ReadBToggle ("Is Mask Blackout", Float) = 0
        [Toggle(IS_SCENE_BORDER)] _ReadAToggle ("Is Scene Border", Float) = 0
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

            #pragma multi_compile PIXELSNAP_ON DITHERING_NOISE
            #pragma shader_feature IS_VIGNETTE
            #pragma shader_feature IS_MASK_BLACKOUT
            #pragma shader_feature IS_SCENE_BORDER
            

            #if IS_VIGNETTE && PIXELSNAP_ON // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #elif IS_MASK_BLACKOUT && PIXELSNAP_ON // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #elif IS_SCENE_BORDER && PIXELSNAP_ON // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #elif DITHERING_NOISE && IS_VIGNETTE // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #elif DITHERING_NOISE && IS_MASK_BLACKOUT // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #elif DITHERING_NOISE && IS_SCENE_BORDER // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #elif PIXELSNAP_ON // :DX11VertexSM40
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
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
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4x4 _DarknessCameraVP; // 48 (starting at cb0[3].x)
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
                tmp0 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m11_m11_m11_m11;
                tmp0 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m01_m01_m01_m01 + tmp0;
                tmp0 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m21_m21_m21_m21 + tmp0;
                tmp0 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m31_m31_m31_m31 + tmp0;
                tmp0 = tmp0 * v.vertex.yyyy;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m10_m10_m10_m10;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m00_m00_m00_m00 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m20_m20_m20_m20 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m30_m30_m30_m30 + tmp1;
                tmp0 = tmp1 * v.vertex.xxxx + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m12_m12_m12_m12;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m02_m02_m02_m02 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m22_m22_m22_m22 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m32_m32_m32_m32 + tmp1;
                tmp0 = tmp1 * v.vertex.zzzz + tmp0;
                tmp1 = _DarknessCameraVP._m01_m11_m21_m31 * unity_ObjectToWorld._m13_m13_m13_m13;
                tmp1 = _DarknessCameraVP._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = _DarknessCameraVP._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = _DarknessCameraVP._m03_m13_m23_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1;
                tmp0 = tmp0 + tmp1;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                return o;
            }
            #endif


            #if IS_VIGNETTE && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _DarknessCutout; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_DarknessCutout, tmp0.xy);
                tmp0.x = -tmp0.x * 0.8 + 1.0;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif IS_MASK_BLACKOUT && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _DarknessCutout; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = inp.color.w * -2.0 + 1.0;
                tmp0.yz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_DarknessCutout, tmp0.yz);
                tmp0.x = tmp1.z * tmp0.x + inp.color.w;
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(tmp2.w * tmp0.x + tmp1.y);
                tmp0.yzw = tmp2.xyz * inp.color.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif IS_SCENE_BORDER && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _DarknessCutout; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_DarknessCutout, tmp0.xy);
                tmp0.x = 1.0 - tmp0.w;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif DITHERING_NOISE && IS_VIGNETTE // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _DarknessCutout; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.06711056, 0.00583715));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 0.00392157 + -0.00196078;
                tmp0.yz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_DarknessCutout, tmp0.yz);
                tmp0.y = -tmp1.x * 0.8 + 1.0;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp2.w = tmp0.y * tmp1.w;
                tmp2.xyz = tmp1.xyz * tmp2.www;
                o.sv_target = tmp0.xxxx + tmp2;
                return o;
            }

            #elif DITHERING_NOISE && IS_MASK_BLACKOUT // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _DarknessCutout; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.06711056, 0.00583715));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 0.00392157 + -0.00196078;
                tmp0.y = inp.color.w * -2.0 + 1.0;
                tmp0.zw = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_DarknessCutout, tmp0.zw);
                tmp0.y = tmp1.z * tmp0.y + inp.color.w;
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = saturate(tmp2.w * tmp0.y + tmp1.y);
                tmp0.yzw = tmp2.xyz * inp.color.xyz;
                tmp1.xyz = tmp1.www * tmp0.yzw;
                o.sv_target = tmp0.xxxx + tmp1;
                return o;
            }

            #elif DITHERING_NOISE && IS_SCENE_BORDER // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _DarknessCutout; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = dot(inp.position.xy, float2(0.06711056, 0.00583715));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 0.00392157 + -0.00196078;
                tmp0.yz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_DarknessCutout, tmp0.yz);
                tmp0.y = 1.0 - tmp1.w;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp2.w = tmp0.y * tmp1.w;
                tmp2.xyz = tmp1.xyz * tmp2.www;
                o.sv_target = tmp0.xxxx + tmp2;
                return o;
            }

            #elif PIXELSNAP_ON // :DX11PixelSM40
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
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
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(inp.position.xy, float2(0.06711056, 0.00583715));
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 52.98292;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 0.00392157 + -0.00196078;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.sv_target = tmp0.xxxx + tmp1;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
