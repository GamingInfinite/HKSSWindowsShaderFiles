Shader "Alpha Masked/Sprites Alpha Masked - World Coords" {
    Properties {
        [PerRendererData] _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [Toggle] _ClampHoriz ("Clamp Alpha Horizontally", Float) = 0
        [Toggle] _ClampVert ("Clamp Alpha Vertically", Float) = 0
        [Toggle] _UseAlphaChannel ("Use Mask Alpha Channel (not RGB)", Float) = 0
        _MaskRotation ("Mask Rotation in Radians", Float) = 0
        _AlphaTex ("Alpha Mask", 2D) = "white" {}
        _ClampBorder ("Clamping Border", Float) = 0.01
        [KeywordEnum(X, Y, Z)] _Axis ("Alpha Mapping Axis", Float) = 0
        _IsThisText ("Is This Text?", Float) = 0
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

            #pragma multi_compile DUMMY _SCREEN_SPACE_UI
            #pragma shader_feature _AXIS_X
            #pragma shader_feature _AXIS_Y
            #pragma shader_feature _AXIS_Z
            #pragma shader_feature _CLAMPHORIZ_ON
            #pragma shader_feature _CLAMPVERT_ON
            #pragma shader_feature _USEALPHACHANNEL_ON
            #pragma shader_feature PIXELSNAP_ON
            

            #if _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xy, tmp2.xy);
                tmp0.z = dot(v.vertex.xy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m23 * v.vertex.ww + tmp0.xz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.xz, tmp2.xy);
                tmp0.z = dot(v.vertex.xz, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0.xy = unity_ObjectToWorld._m23_m13 * v.vertex.ww + tmp0.zy;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _Color;
                tmp1.x = sin(_MaskRotation);
                tmp2.x = cos(_MaskRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.z = dot(tmp0.xy, tmp3.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                tmp0.x = sin(_MaskRotation);
                tmp1.x = cos(_MaskRotation);
                tmp2.z = tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.x = -tmp0.x;
                tmp0.w = dot(v.vertex.zy, tmp2.xy);
                tmp0.z = dot(v.vertex.zy, tmp2.yz);
                o.texcoord2.xy = tmp0.zw * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            #elif _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif DUMMY && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif DUMMY // :DX11VertexSM40
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
            float4 _AlphaTex_ST; // 80 (starting at cb0[5].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }
            #endif


            #if _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.x = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.w * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.yz = max(inp.texcoord2.xy, _ClampBorder.xx);
                tmp0.xy = min(tmp0.xx, tmp0.yz);
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _USEALPHACHANNEL_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _CLAMPVERT_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _AXIS_Z && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Z && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_Y && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _AXIS_X && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _SCREEN_SPACE_UI && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPVERT_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.y, _ClampBorder);
                tmp0.y = min(tmp0.x, tmp0.y);
                tmp0.x = inp.texcoord2.x;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _SCREEN_SPACE_UI // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = 1.0 - _ClampBorder;
                tmp0.y = max(inp.texcoord2.x, _ClampBorder);
                tmp0.x = min(tmp0.x, tmp0.y);
                tmp0.y = inp.texcoord2.y;
                tmp0 = tex2D(_AlphaTex, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.y = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz + _IsThisText.xxx);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #elif DUMMY && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif _SCREEN_SPACE_UI && PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
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
            float _IsThisText; // 44 (starting at cb0[2].w)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0.xyz = saturate(tmp0.xyz + _IsThisText.xxx);
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp1 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Unlit/Texture"
}
