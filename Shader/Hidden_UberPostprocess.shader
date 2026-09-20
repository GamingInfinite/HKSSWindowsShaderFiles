Shader "Hidden/UberPostprocess" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Pass {
            Name ""
            ZClip On
            ZTest Always
            ZWrite Off
            Cull Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature BLOOM_ENABLED
            #pragma shader_feature BRIGHTNESS_EFFECT_ENABLED
            #pragma shader_feature COLOR_CURVES_ENABLED
            #pragma shader_feature NOISE_ENABLED
            

            #if BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED && COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED && NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED && COLOR_CURVES_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif NOISE_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif COLOR_CURVES_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #elif BLOOM_ENABLED // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_TexelSize; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.x = v.texcoord.x;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord1 = float2(v.texcoord.x, o.texcoord.y);
                return o;
            }
            #endif


            #if BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            float _Saturation; // 40 (starting at cb0[2].z)
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1
            sampler2D _NoiseTex; // 2
            sampler2D _RgbTex; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp2 = tex2D(_Bloom, inp.texcoord.xy);
                tmp1 = tmp1 + tmp2;
                tmp0.xyz = saturate(tmp0.yxz * tmp1.yxz);
                o.sv_target.w = tmp1.w;
                tmp0.w = 0.125;
                tmp1 = tex2D(_RgbTex, tmp0.yw);
                tmp0.yw = float2(0.375, 0.625);
                tmp2 = tex2D(_RgbTex, tmp0.xy);
                tmp0 = tex2D(_RgbTex, tmp0.zw);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0, 0.0, 1.0) + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                tmp0.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            float _Saturation; // 40 (starting at cb0[2].z)
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1
            sampler2D _RgbTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp0.xyz = saturate(tmp0.yxz * tmp1.yxz);
                o.sv_target.w = tmp1.w;
                tmp0.w = 0.125;
                tmp1 = tex2D(_RgbTex, tmp0.yw);
                tmp0.yw = float2(0.375, 0.625);
                tmp2 = tex2D(_RgbTex, tmp0.xy);
                tmp0 = tex2D(_RgbTex, tmp0.zw);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0, 0.0, 1.0) + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                tmp0.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif BLOOM_ENABLED && COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Saturation; // 40 (starting at cb0[2].z)
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1
            sampler2D _NoiseTex; // 2
            sampler2D _RgbTex; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp2 = tex2D(_Bloom, inp.texcoord.xy);
                tmp1 = tmp1 + tmp2;
                tmp0.xyz = saturate(tmp0.yxz * tmp1.yxz);
                o.sv_target.w = tmp1.w;
                tmp0.w = 0.125;
                tmp1 = tex2D(_RgbTex, tmp0.yw);
                tmp0.yw = float2(0.375, 0.625);
                tmp2 = tex2D(_RgbTex, tmp0.xy);
                tmp0 = tex2D(_RgbTex, tmp0.zw);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0, 0.0, 1.0) + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                o.sv_target.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                return o;
            }

            #elif BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1
            sampler2D _NoiseTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp2 = tex2D(_Bloom, inp.texcoord.xy);
                tmp1 = tmp1 + tmp2;
                tmp0.xyz = saturate(tmp0.xyz * tmp1.xyz);
                o.sv_target.w = tmp1.w;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            float _Saturation; // 40 (starting at cb0[2].z)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1
            sampler2D _RgbTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp1 = tex2D(_Bloom, inp.texcoord.xy);
                tmp0 = tmp0.zxyw + tmp1.zxyw;
                tmp1.xz = tmp0.yz;
                tmp1.yw = float2(0.125, 0.375);
                tmp2 = tex2D(_RgbTex, tmp1.zw);
                tmp1 = tex2D(_RgbTex, tmp1.xy);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.y = 0.625;
                tmp0 = tex2D(_RgbTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * float3(0.0, 0.0, 1.0) + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                tmp0.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif COLOR_CURVES_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Saturation; // 40 (starting at cb0[2].z)
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1
            sampler2D _RgbTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp0.xyz = saturate(tmp0.yxz * tmp1.yxz);
                o.sv_target.w = tmp1.w;
                tmp0.w = 0.125;
                tmp1 = tex2D(_RgbTex, tmp0.yw);
                tmp0.yw = float2(0.375, 0.625);
                tmp2 = tex2D(_RgbTex, tmp0.xy);
                tmp0 = tex2D(_RgbTex, tmp0.zw);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0, 0.0, 1.0) + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                o.sv_target.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp0.xyz = saturate(tmp0.xyz * tmp1.xyz);
                o.sv_target.w = tmp1.w;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED && COLOR_CURVES_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            float _Saturation; // 40 (starting at cb0[2].z)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _RgbTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.yw = float2(0.125, 0.375);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp0.xz = tmp1.yz;
                tmp2 = tex2D(_RgbTex, tmp0.xw);
                tmp0 = tex2D(_RgbTex, float2(tmp1.x, tmp0.y));
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp0.xyz = tmp0.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                o.sv_target.w = tmp1.w;
                tmp1.y = 0.625;
                tmp1 = tex2D(_RgbTex, tmp1.zy);
                tmp0.xyz = tmp1.xyz * float3(0.0, 0.0, 1.0) + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                tmp0.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif BLOOM_ENABLED && NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1
            sampler2D _NoiseTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp2 = tex2D(_Bloom, inp.texcoord.xy);
                tmp1 = tmp1 + tmp2;
                o.sv_target.xyz = saturate(tmp0.xyz * tmp1.xyz);
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif BLOOM_ENABLED && COLOR_CURVES_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Saturation; // 40 (starting at cb0[2].z)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1
            sampler2D _RgbTex; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp1 = tex2D(_Bloom, inp.texcoord.xy);
                tmp0 = tmp0.zxyw + tmp1.zxyw;
                tmp1.xz = tmp0.yz;
                tmp1.yw = float2(0.125, 0.375);
                tmp2 = tex2D(_RgbTex, tmp1.zw);
                tmp1 = tex2D(_RgbTex, tmp1.xy);
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                o.sv_target.w = tmp0.w;
                tmp0.y = 0.625;
                tmp0 = tex2D(_RgbTex, tmp0.xy);
                tmp0.xyz = tmp0.xyz * float3(0.0, 0.0, 1.0) + tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                o.sv_target.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                return o;
            }

            #elif BLOOM_ENABLED && BRIGHTNESS_EFFECT_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp1 = tex2D(_Bloom, inp.texcoord.xy);
                tmp0 = tmp0 + tmp1;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif NOISE_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _NoiseColor; // 48 (starting at cb0[3].x)
            float _NoiseStrength; // 64 (starting at cb0[4].x)
            float _TimeSnap; // 68 (starting at cb0[4].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                o.sv_target.xyz = saturate(tmp0.xyz * tmp1.xyz);
                o.sv_target.w = tmp1.w;
                return o;
            }

            #elif COLOR_CURVES_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Saturation; // 40 (starting at cb0[2].z)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _RgbTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.yw = float2(0.125, 0.375);
                tmp1 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp0.xz = tmp1.yz;
                tmp2 = tex2D(_RgbTex, tmp0.xw);
                tmp0 = tex2D(_RgbTex, float2(tmp1.x, tmp0.y));
                tmp2.xyz = tmp2.xyz * float3(0.0, 1.0, 0.0);
                tmp0.xyz = tmp0.xyz * float3(1.0, 0.0, 0.0) + tmp2.xyz;
                o.sv_target.w = tmp1.w;
                tmp1.y = 0.625;
                tmp1 = tex2D(_RgbTex, tmp1.zy);
                tmp0.xyz = tmp1.xyz * float3(0.0, 0.0, 1.0) + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.xyz = tmp0.xyz - tmp0.www;
                o.sv_target.xyz = _Saturation.xxx * tmp0.xyz + tmp0.www;
                return o;
            }

            #elif BRIGHTNESS_EFFECT_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Brightness; // 32 (starting at cb0[2].x)
            float _Contrast; // 36 (starting at cb0[2].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #elif BLOOM_ENABLED // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _Bloom; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                tmp1 = tex2D(_Bloom, inp.texcoord.xy);
                o.sv_target = tmp0 + tmp1;
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
                o.sv_target = tex2Dlod(_MainTex, float4(inp.texcoord1.xy, 0, 0.0));
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
