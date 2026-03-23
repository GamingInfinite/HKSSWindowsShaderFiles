Shader "UI/Blur/UIBlur" {
    Properties {
        _TintColor ("Tint Color", Color) = (1, 1, 1, 0.2)
        _Size ("Spacing", Range(0, 200)) = 5
        _Vibrancy ("Vibrancy", Range(0, 2)) = 0.2
        [HideInInspector] _StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector] _Stencil ("Stencil ID", Float) = 0
        [HideInInspector] _StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector] _StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector] _StencilReadMask ("Stencil Read Mask", Float) = 255
        [Toggle(BLUR_PLANE)] _IsBlurPlane ("Is Scene Blur Plane", Float) = 0
        [Toggle(USE_MASK)] _UseMask ("Use Mask", Float) = 0
        _MaskLerp ("Mask Lerp", Range(0, 1)) = 1
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="true"
            "Queue"="Transparent"
            "RenderType"="Opaque"
        }
        // Pass {
        //     Name ""
        //     ZWrite Off
        //     Cull Off
        //     Stencil {
        //         ReadMask 0
        //         WriteMask 0
        //     }
        // }
        GrabPass { Tags { "LightMode"="Always" } }
        Pass {
            Name "VERTICAL"
            // ZClip On
            // ZWrite Off
            // Stencil {
            //     ReadMask 0
            //     WriteMask 0
            // }
            Tags {
                "IgnoreProjector"="true"
                "LightMode"="Always"
                "Queue"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_MASK
            

            #if USE_MASK // VERTICAL:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Mask_ST; // 32 (starting at cb0[2].x)
            float2 _HeroWorldPos; // 52 (starting at cb0[3].y)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                tmp3.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp3.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp3.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                tmp1.xy = tmp2.xy - tmp1.xy;
                o.texcoord.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
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
                float4 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
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
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }
            #endif


            #if USE_MASK // VERTICAL:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _MaskLerp; // 48 (starting at cb0[3].x)
            float4 _GrabTexture_TexelSize; // 64 (starting at cb0[4].x)
            float _Size; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _GrabTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_Mask, inp.texcoord.xy);
                tmp0.x = _Size * tmp0.x + -_Size;
                tmp0.x = _MaskLerp * tmp0.x + _Size;
                tmp0.x = tmp0.x * _GrabTexture_TexelSize.y;
                tmp1 = tmp0.xxxx * float4(-6.44, -3.22, -4.83, -1.61) + inp.texcoord1.yyyy;
                tmp0 = tmp0.xxxx * float4(1.61, 4.83, 3.22, 6.44) + inp.texcoord1.yyyy;
                tmp2.yw = tmp1.xz;
                tmp2.xz = inp.texcoord1.xx;
                tmp2 = tmp2 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.zw);
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp2 = tmp2 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp1.xz = inp.texcoord1.xx;
                tmp1 = tmp1 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp1.xy);
                tmp1 = tex2D(_GrabTexture, tmp1.zw);
                tmp2 = tmp3 * float4(0.12, 0.12, 0.12, 0.12) + tmp2;
                tmp1 = tmp1 * float4(0.15, 0.15, 0.15, 0.15) + tmp2;
                tmp2.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp1 = tmp2 * float4(0.18, 0.18, 0.18, 0.18) + tmp1;
                tmp2.yw = tmp0.xz;
                tmp2.xz = inp.texcoord1.xx;
                tmp2 = tmp2 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.xy);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp1 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp1;
                tmp1 = tmp2 * float4(0.12, 0.12, 0.12, 0.12) + tmp1;
                tmp0.xz = inp.texcoord1.xx;
                tmp0 = tmp0 / inp.texcoord1.wwww;
                tmp2 = tex2D(_GrabTexture, tmp0.xy);
                tmp0 = tex2D(_GrabTexture, tmp0.zw);
                tmp1 = tmp2 * float4(0.09, 0.09, 0.09, 0.09) + tmp1;
                o.sv_target = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp1;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _GrabTexture_TexelSize; // 32 (starting at cb0[2].x)
            float _Size; // 48 (starting at cb0[3].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xz = inp.texcoord.xx;
                tmp1.x = _GrabTexture_TexelSize.y * _Size;
                tmp2 = tmp1.xxxx * float4(-6.44, -3.22, -4.83, -1.61) + inp.texcoord.yyyy;
                tmp1 = tmp1.xxxx * float4(1.61, 4.83, 3.22, 6.44) + inp.texcoord.yyyy;
                tmp0.yw = tmp2.xz;
                tmp0 = tmp0 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp0.zw);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp0 = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp2.xz = inp.texcoord.xx;
                tmp2 = tmp2 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.xy);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp0 = tmp3 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp0 = tmp2 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp2.xy = inp.texcoord.xy / inp.texcoord.ww;
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp0 = tmp2 * float4(0.18, 0.18, 0.18, 0.18) + tmp0;
                tmp2.yw = tmp1.xz;
                tmp2.xz = inp.texcoord.xx;
                tmp2 = tmp2 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.xy);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp0 = tmp2 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp1.xz = inp.texcoord.xx;
                tmp1 = tmp1 / inp.texcoord.wwww;
                tmp2 = tex2D(_GrabTexture, tmp1.xy);
                tmp1 = tex2D(_GrabTexture, tmp1.zw);
                tmp0 = tmp2 * float4(0.09, 0.09, 0.09, 0.09) + tmp0;
                o.sv_target = tmp1 * float4(0.05, 0.05, 0.05, 0.05) + tmp0;
                return o;
            }
            #endif
            ENDCG
            
        }
        // Pass {
        //     Name ""
        //     ZWrite Off
        //     Cull Off
        //     Stencil {
        //         ReadMask 0
        //         WriteMask 0
        //     }
        // }
        GrabPass { Tags { "LightMode"="Always" } }
        Pass {
            Name "HORIZONTAL"
            // ZClip On
            // ZWrite Off
            // Stencil {
            //     ReadMask 0
            //     WriteMask 0
            // }
            Tags {
                "IgnoreProjector"="true"
                "LightMode"="Always"
                "Queue"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_MASK
            

            #if USE_MASK // HORIZONTAL:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Mask_ST; // 32 (starting at cb0[2].x)
            float2 _HeroWorldPos; // 52 (starting at cb0[3].y)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                tmp3.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp3.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp3.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                tmp1.xy = tmp2.xy - tmp1.xy;
                o.texcoord.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
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
                float4 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
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
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }
            #endif


            #if USE_MASK // HORIZONTAL:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _MaskLerp; // 48 (starting at cb0[3].x)
            float4 _GrabTexture_TexelSize; // 64 (starting at cb0[4].x)
            float _Size; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _GrabTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_Mask, inp.texcoord.xy);
                tmp0.x = _Size * tmp0.x + -_Size;
                tmp0.x = _MaskLerp * tmp0.x + _Size;
                tmp0.x = tmp0.x * _GrabTexture_TexelSize.x;
                tmp1 = tmp0.xxxx * float4(-3.22, -6.44, -1.61, -4.83) + inp.texcoord1.xxxx;
                tmp0 = tmp0.xxxx * float4(4.83, 1.61, 6.44, 3.22) + inp.texcoord1.xxxx;
                tmp2.xz = tmp1.yw;
                tmp2.yw = inp.texcoord1.yy;
                tmp2 = tmp2 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.zw);
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp2 = tmp2 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp1.yw = inp.texcoord1.yy;
                tmp1 = tmp1 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp1.xy);
                tmp1 = tex2D(_GrabTexture, tmp1.zw);
                tmp2 = tmp3 * float4(0.12, 0.12, 0.12, 0.12) + tmp2;
                tmp1 = tmp1 * float4(0.15, 0.15, 0.15, 0.15) + tmp2;
                tmp2.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp1 = tmp2 * float4(0.18, 0.18, 0.18, 0.18) + tmp1;
                tmp2.xz = tmp0.yw;
                tmp2.yw = inp.texcoord1.yy;
                tmp2 = tmp2 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.xy);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp1 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp1;
                tmp1 = tmp2 * float4(0.12, 0.12, 0.12, 0.12) + tmp1;
                tmp0.yw = inp.texcoord1.yy;
                tmp0 = tmp0 / inp.texcoord1.wwww;
                tmp2 = tex2D(_GrabTexture, tmp0.xy);
                tmp0 = tex2D(_GrabTexture, tmp0.zw);
                tmp1 = tmp2 * float4(0.09, 0.09, 0.09, 0.09) + tmp1;
                o.sv_target = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp1;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _GrabTexture_TexelSize; // 32 (starting at cb0[2].x)
            float _Size; // 48 (starting at cb0[3].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.yw = inp.texcoord.yy;
                tmp1.x = _GrabTexture_TexelSize.x * _Size;
                tmp2 = tmp1.xxxx * float4(-3.22, -6.44, -1.61, -4.83) + inp.texcoord.xxxx;
                tmp1 = tmp1.xxxx * float4(4.83, 1.61, 6.44, 3.22) + inp.texcoord.xxxx;
                tmp0.xz = tmp2.yw;
                tmp0 = tmp0 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp0.zw);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp0 = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp2.yw = inp.texcoord.yy;
                tmp2 = tmp2 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.xy);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp0 = tmp3 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp0 = tmp2 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp2.xy = inp.texcoord.xy / inp.texcoord.ww;
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp0 = tmp2 * float4(0.18, 0.18, 0.18, 0.18) + tmp0;
                tmp2.xz = tmp1.yw;
                tmp2.yw = inp.texcoord.yy;
                tmp2 = tmp2 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp2.xy);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp0 = tmp2 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp1.yw = inp.texcoord.yy;
                tmp1 = tmp1 / inp.texcoord.wwww;
                tmp2 = tex2D(_GrabTexture, tmp1.xy);
                tmp1 = tex2D(_GrabTexture, tmp1.zw);
                tmp0 = tmp2 * float4(0.09, 0.09, 0.09, 0.09) + tmp0;
                o.sv_target = tmp1 * float4(0.05, 0.05, 0.05, 0.05) + tmp0;
                return o;
            }
            #endif
            ENDCG
            
        }
        // Pass {
        //     Name ""
        //     ZWrite Off
        //     Cull Off
        //     Stencil {
        //         ReadMask 0
        //         WriteMask 0
        //     }
        // }
        GrabPass { Tags { "LightMode"="Always" } }
        Pass {
            Name "VERTICAL"
            // ZClip On
            // ZWrite Off
            // Stencil {
            //     ReadMask 0
            //     WriteMask 0
            // }
            Tags {
                "IgnoreProjector"="true"
                "LightMode"="Always"
                "Queue"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_MASK
            

            #if USE_MASK // VERTICAL:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Mask_ST; // 32 (starting at cb0[2].x)
            float2 _HeroWorldPos; // 52 (starting at cb0[3].y)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                tmp3.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp3.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp3.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                tmp1.xy = tmp2.xy - tmp1.xy;
                o.texcoord.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
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
                float4 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
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
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }
            #endif


            #if USE_MASK // VERTICAL:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _MaskLerp; // 48 (starting at cb0[3].x)
            float4 _GrabTexture_TexelSize; // 64 (starting at cb0[4].x)
            float _Size; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _GrabTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xz = inp.texcoord1.xx;
                tmp1 = tex2D(_Mask, inp.texcoord.xy);
                tmp1.x = _Size * tmp1.x + -_Size;
                tmp1.x = _MaskLerp * tmp1.x + _Size;
                tmp1.y = tmp1.x * _GrabTexture_TexelSize.y;
                tmp2 = tmp1.yyyy * float4(-4.0, 3.0, -3.0, -2.0) + inp.texcoord1.yyyy;
                tmp0.yw = tmp2.xz;
                tmp0 = tmp0 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp0.zw);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp0 = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp3.y = tmp2.w;
                tmp3.xz = inp.texcoord1.xx;
                tmp1.zw = tmp3.xy / inp.texcoord1.ww;
                tmp4 = tex2D(_GrabTexture, tmp1.zw);
                tmp0 = tmp4 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp3.w = -_GrabTexture_TexelSize.y * tmp1.x + inp.texcoord1.y;
                tmp4.y = _GrabTexture_TexelSize.y * tmp1.x + inp.texcoord1.y;
                tmp1.xz = tmp3.zw / inp.texcoord1.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.xz);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp1.xz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.xz);
                tmp0 = tmp3 * float4(0.18, 0.18, 0.18, 0.18) + tmp0;
                tmp4.xz = inp.texcoord1.xx;
                tmp1.xz = tmp4.xy / inp.texcoord1.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.xz);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp4.w = tmp1.y * 2.0 + inp.texcoord1.y;
                tmp2.w = tmp1.y * 4.0 + inp.texcoord1.y;
                tmp1.xy = tmp4.zw / inp.texcoord1.ww;
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp2.xz = inp.texcoord1.xx;
                tmp1 = tmp2 / inp.texcoord1.wwww;
                tmp2 = tex2D(_GrabTexture, tmp1.zw);
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.09, 0.09, 0.09, 0.09) + tmp0;
                o.sv_target = tmp2 * float4(0.05, 0.05, 0.05, 0.05) + tmp0;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _GrabTexture_TexelSize; // 32 (starting at cb0[2].x)
            float _Size; // 48 (starting at cb0[3].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xz = inp.texcoord.xx;
                tmp1.x = _GrabTexture_TexelSize.y * _Size;
                tmp2 = tmp1.xxxx * float4(-4.0, 3.0, -3.0, -2.0) + inp.texcoord.yyyy;
                tmp0.yw = tmp2.xz;
                tmp0 = tmp0 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp0.zw);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp0 = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp3.y = tmp2.w;
                tmp3.xz = inp.texcoord.xx;
                tmp1.yz = tmp3.xy / inp.texcoord.ww;
                tmp4 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp4 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp3.w = -_GrabTexture_TexelSize.y * _Size + inp.texcoord.y;
                tmp1.yz = tmp3.zw / inp.texcoord.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp1.yz = inp.texcoord.xy / inp.texcoord.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp3 * float4(0.18, 0.18, 0.18, 0.18) + tmp0;
                tmp3.y = _GrabTexture_TexelSize.y * _Size + inp.texcoord.y;
                tmp3.xz = inp.texcoord.xx;
                tmp1.yz = tmp3.xy / inp.texcoord.ww;
                tmp4 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp4 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp3.w = tmp1.x * 2.0 + inp.texcoord.y;
                tmp2.w = tmp1.x * 4.0 + inp.texcoord.y;
                tmp1.xy = tmp3.zw / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp2.xz = inp.texcoord.xx;
                tmp1 = tmp2 / inp.texcoord.wwww;
                tmp2 = tex2D(_GrabTexture, tmp1.zw);
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.09, 0.09, 0.09, 0.09) + tmp0;
                o.sv_target = tmp2 * float4(0.05, 0.05, 0.05, 0.05) + tmp0;
                return o;
            }
            #endif
            ENDCG
            
        }
        // Pass {
        //     Name ""
        //     ZWrite Off
        //     Cull Off
        //     Stencil {
        //         ReadMask 0
        //         WriteMask 0
        //     }
        // }
        GrabPass { Tags { "LightMode"="Always" } }
        Pass {
            Name "HORIZONTAL"
            // ZClip On
            // ZWrite Off
            // Stencil {
            //     ReadMask 0
            //     WriteMask 0
            // }
            Tags {
                "IgnoreProjector"="true"
                "LightMode"="Always"
                "Queue"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_MASK
            

            #if USE_MASK // HORIZONTAL:DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Mask_ST; // 32 (starting at cb0[2].x)
            float2 _HeroWorldPos; // 52 (starting at cb0[3].y)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                tmp3.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp3.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp3.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                tmp1.xy = tmp2.xy - tmp1.xy;
                o.texcoord.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
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
                float4 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
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
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }
            #endif


            #if USE_MASK // HORIZONTAL:DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _MaskLerp; // 48 (starting at cb0[3].x)
            float4 _GrabTexture_TexelSize; // 64 (starting at cb0[4].x)
            float _Size; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _GrabTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.yw = inp.texcoord1.yy;
                tmp1 = tex2D(_Mask, inp.texcoord.xy);
                tmp1.x = _Size * tmp1.x + -_Size;
                tmp1.x = _MaskLerp * tmp1.x + _Size;
                tmp1.y = tmp1.x * _GrabTexture_TexelSize.x;
                tmp2 = tmp1.yyyy * float4(3.0, -4.0, -3.0, -2.0) + inp.texcoord1.xxxx;
                tmp0.xz = tmp2.yz;
                tmp0 = tmp0 / inp.texcoord1.wwww;
                tmp3 = tex2D(_GrabTexture, tmp0.zw);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp0 = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp3.x = tmp2.w;
                tmp3.yw = inp.texcoord1.yy;
                tmp1.zw = tmp3.xy / inp.texcoord1.ww;
                tmp4 = tex2D(_GrabTexture, tmp1.zw);
                tmp0 = tmp4 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp3.z = -_GrabTexture_TexelSize.x * tmp1.x + inp.texcoord1.x;
                tmp4.x = _GrabTexture_TexelSize.x * tmp1.x + inp.texcoord1.x;
                tmp1.xz = tmp3.zw / inp.texcoord1.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.xz);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp1.xz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.xz);
                tmp0 = tmp3 * float4(0.18, 0.18, 0.18, 0.18) + tmp0;
                tmp4.yw = inp.texcoord1.yy;
                tmp1.xz = tmp4.xy / inp.texcoord1.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.xz);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp4.z = tmp1.y * 2.0 + inp.texcoord1.x;
                tmp2.z = tmp1.y * 4.0 + inp.texcoord1.x;
                tmp1.xy = tmp4.zw / inp.texcoord1.ww;
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp2.yw = inp.texcoord1.yy;
                tmp1 = tmp2 / inp.texcoord1.wwww;
                tmp2 = tex2D(_GrabTexture, tmp1.zw);
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.09, 0.09, 0.09, 0.09) + tmp0;
                o.sv_target = tmp2 * float4(0.05, 0.05, 0.05, 0.05) + tmp0;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _GrabTexture_TexelSize; // 32 (starting at cb0[2].x)
            float _Size; // 48 (starting at cb0[3].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.yw = inp.texcoord.yy;
                tmp1.x = _GrabTexture_TexelSize.x * _Size;
                tmp2 = tmp1.xxxx * float4(3.0, -4.0, -3.0, -2.0) + inp.texcoord.xxxx;
                tmp0.xz = tmp2.yz;
                tmp0 = tmp0 / inp.texcoord.wwww;
                tmp3 = tex2D(_GrabTexture, tmp0.zw);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp3 = tmp3 * float4(0.09, 0.09, 0.09, 0.09);
                tmp0 = tmp0 * float4(0.05, 0.05, 0.05, 0.05) + tmp3;
                tmp3.x = tmp2.w;
                tmp3.yw = inp.texcoord.yy;
                tmp1.yz = tmp3.xy / inp.texcoord.ww;
                tmp4 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp4 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp3.z = -_GrabTexture_TexelSize.x * _Size + inp.texcoord.x;
                tmp1.yz = tmp3.zw / inp.texcoord.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp3 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp1.yz = inp.texcoord.xy / inp.texcoord.ww;
                tmp3 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp3 * float4(0.18, 0.18, 0.18, 0.18) + tmp0;
                tmp3.x = _GrabTexture_TexelSize.x * _Size + inp.texcoord.x;
                tmp3.yw = inp.texcoord.yy;
                tmp1.yz = tmp3.xy / inp.texcoord.ww;
                tmp4 = tex2D(_GrabTexture, tmp1.yz);
                tmp0 = tmp4 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp3.z = tmp1.x * 2.0 + inp.texcoord.x;
                tmp2.z = tmp1.x * 4.0 + inp.texcoord.x;
                tmp1.xy = tmp3.zw / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.12, 0.12, 0.12, 0.12) + tmp0;
                tmp2.yw = inp.texcoord.yy;
                tmp1 = tmp2 / inp.texcoord.wwww;
                tmp2 = tex2D(_GrabTexture, tmp1.zw);
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp1 * float4(0.09, 0.09, 0.09, 0.09) + tmp0;
                o.sv_target = tmp2 * float4(0.05, 0.05, 0.05, 0.05) + tmp0;
                return o;
            }
            #endif
            ENDCG
            
        }
        // Pass {
        //     Name ""
        //     ZWrite Off
        //     Cull Off
        //     Stencil {
        //         ReadMask 0
        //         WriteMask 0
        //     }
        // }
        GrabPass { Tags { "LightMode"="Always" } }
        Pass {
            Name ""
            // ZClip On
            // ZWrite Off
            // Stencil {
            //     ReadMask 0
            //     WriteMask 0
            // }
            Tags {
                "IgnoreProjector"="true"
                "LightMode"="Always"
                "Queue"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature BLUR_PLANE
            #pragma shader_feature USE_MASK
            

            #if BLUR_PLANE && USE_MASK // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Mask_ST; // 32 (starting at cb0[2].x)
            float2 _HeroWorldPos; // 52 (starting at cb0[3].y)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                tmp3.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp3.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp3.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                tmp1.xy = tmp2.xy - tmp1.xy;
                o.texcoord.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }

            #elif BLUR_PLANE // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
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
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }

            #elif USE_MASK // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Mask_ST; // 32 (starting at cb0[2].x)
            float2 _HeroWorldPos; // 52 (starting at cb0[3].y)
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                tmp3.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp3.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp3.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                tmp1.xy = tmp2.xy - tmp1.xy;
                o.texcoord.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
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
                float4 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
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
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }
            #endif


            #if BLUR_PLANE && USE_MASK // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _MaskLerp; // 48 (starting at cb0[3].x)
            float4 _TintColor; // 64 (starting at cb0[4].x)
            float _Vibrancy; // 80 (starting at cb0[5].x)
            float _BlurPlaneVibranceOffset; // 112 (starting at cb0[7].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0
            sampler2D _Mask; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_Mask, inp.texcoord.xy);
                tmp0.x = _Vibrancy * tmp0.x + -_Vibrancy;
                tmp0.x = _MaskLerp * tmp0.x + _Vibrancy;
                tmp0.x = tmp0.x + _BlurPlaneVibranceOffset;
                tmp0.x = tmp0.x + 1.0;
                tmp0.yz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_GrabTexture, tmp0.yz);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0 = _TintColor - tmp1;
                o.sv_target = _TintColor * tmp0 + tmp1;
                return o;
            }

            #elif BLUR_PLANE // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _TintColor; // 32 (starting at cb0[2].x)
            float _Vibrancy; // 48 (starting at cb0[3].x)
            float _BlurPlaneVibranceOffset; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _Vibrancy + _BlurPlaneVibranceOffset;
                tmp0.x = tmp0.x + 1.0;
                tmp0.yz = inp.texcoord.xy / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp0.yz);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0 = _TintColor - tmp1;
                o.sv_target = _TintColor * tmp0 + tmp1;
                return o;
            }

            #elif USE_MASK // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _MaskLerp; // 48 (starting at cb0[3].x)
            float4 _TintColor; // 64 (starting at cb0[4].x)
            float _Vibrancy; // 80 (starting at cb0[5].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0
            sampler2D _Mask; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_Mask, inp.texcoord.xy);
                tmp0.x = _Vibrancy * tmp0.x + -_Vibrancy;
                tmp0.x = _MaskLerp * tmp0.x + _Vibrancy;
                tmp0.x = tmp0.x + 1.0;
                tmp0.yz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_GrabTexture, tmp0.yz);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0 = _TintColor - tmp1;
                o.sv_target = _TintColor * tmp0 + tmp1;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _TintColor; // 32 (starting at cb0[2].x)
            float _Vibrancy; // 48 (starting at cb0[3].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _Vibrancy + 1.0;
                tmp0.yz = inp.texcoord.xy / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp0.yz);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0 = _TintColor - tmp1;
                o.sv_target = _TintColor * tmp0 + tmp1;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
