Shader "Alpha Masked/Unlit Alpha Masked - World Coords" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle] _ClampHoriz ("Clamp Alpha Horizontally", Float) = 0
        [Toggle] _ClampVert ("Clamp Alpha Vertically", Float) = 0
        [Toggle] _UseAlphaChannel ("Use Mask Alpha Channel (not RGB)", Float) = 0
        _MaskRotation ("Mask Rotation in Radians", Float) = 0
        _AlphaTex ("Alpha Mask", 2D) = "white" {}
        _ClampBorder ("Clamping Border", Float) = 0.01
        [KeywordEnum(X, Y, Z)] _Axis ("Alpha Mapping Axis", Float) = 0
    }
    SubShader {
        Tags {
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name ""
            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Tags {
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile DUMMY _AXIS_Z
            #pragma shader_feature _AXIS_X
            #pragma shader_feature _AXIS_Y
            #pragma shader_feature _CLAMPHORIZ_ON
            #pragma shader_feature _CLAMPVERT_ON
            #pragma shader_feature _USEALPHACHANNEL_ON
            

            #if _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_Y && _AXIS_Z // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _AXIS_X && _AXIS_Z // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _USEALPHACHANNEL_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _USEALPHACHANNEL_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _CLAMPVERT_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif _CLAMPHORIZ_ON && DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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

            #elif DUMMY // :DX11VertexSM40
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = _AlphaTex_ST.zw;
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
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float _MaskRotation; // 36 (starting at cb0[2].y)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float4 _AlphaTex_ST; // 64 (starting at cb0[4].x)
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
            #endif


            #if _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Y && _AXIS_Z // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _CLAMPVERT_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z && _CLAMPHORIZ_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z && _CLAMPHORIZ_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _CLAMPHORIZ_ON && _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Y && _AXIS_Z // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_X && _AXIS_Z // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _USEALPHACHANNEL_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _USEALPHACHANNEL_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _CLAMPVERT_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _CLAMPVERT_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _CLAMPHORIZ_ON && DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif _AXIS_Z && _CLAMPHORIZ_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _ClampBorder; // 32 (starting at cb0[2].x)
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
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif DUMMY // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
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
            sampler2D _AlphaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Unlit/Texture"
}
