Shader "Custom/Heat Effect" {
    Properties {
        _BumpAmt ("Distortion", Range(0, 128)) = 10
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _SpeedX ("Speed X", Float) = 1
        _SpeedY ("Speed Y", Float) = 1
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "QUEUE"="Transparent"
            "RenderType"="Opaque"
        }
        Pass {
            Name ""
            ZWrite Off
            Cull Off
            Stencil {
                ReadMask 0
                WriteMask 0
            }
        }
        Pass {
            Name "BASE"
            ZClip On
            ZWrite Off
            Tags {
                "LIGHTMODE"="ALWAYS"
                "QUEUE"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature ENABLE_HEATEFFECTMULT
            #pragma shader_feature RENDER_DBG
            

            #if ENABLE_HEATEFFECTMULT && RENDER_DBG
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _BumpMap_ST; // 48 (starting at cb0[3].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                o.texcoord1.xy = tmp0.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                o.texcoord2.xy = v.texcoord.xy;
                return o;
            }

            #elif ENABLE_HEATEFFECTMULT
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _BumpMap_ST; // 48 (starting at cb0[3].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                o.texcoord1.xy = tmp0.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                o.texcoord2.xy = v.texcoord.xy;
                return o;
            }

            #elif RENDER_DBG
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _BumpMap_ST; // 48 (starting at cb0[3].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                o.texcoord1.xy = tmp0.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                o.texcoord2.xy = v.texcoord.xy;
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _BumpMap_ST; // 48 (starting at cb0[3].x)
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
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                o.texcoord1.xy = tmp0.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp0.xy * float2(0.5, 0.5);
                o.texcoord2.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if ENABLE_HEATEFFECTMULT && RENDER_DBG
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeatEffectMult; // 128 (starting at cb0[8].x)
            float _BumpAmt; // 32 (starting at cb0[2].x)
            float _SpeedX; // 96 (starting at cb0[6].x)
            float _SpeedY; // 100 (starting at cb0[6].y)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _BumpMap; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = float2(1.0, 1.0) - inp.texcoord2.xy;
                tmp0 = tex2D(_Mask, tmp0.xy);
                tmp0.y = inp.texcoord.z * _BumpAmt;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * _HeatEffectMult;
                tmp0.x = tmp0.x * 0.00195313;
                tmp0.yz = float2(_SpeedX.x, _SpeedY.x) * _Time.yy + inp.texcoord1.xy;
                tmp1 = tex2D(_BumpMap, tmp0.yz);
                tmp1.x = tmp1.w * tmp1.x;
                tmp0.yz = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xx * tmp0.yz;
                tmp0.xy = tmp0.xy * float2(30.0, 30.0) + float2(1.0, 1.0);
                o.sv_target.xy = tmp0.xy * float2(0.5, 0.5);
                o.sv_target.zw = float2(1.0, 1.0);
                return o;
            }

            #elif ENABLE_HEATEFFECTMULT
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HeatEffectMult; // 128 (starting at cb0[8].x)
            float _BumpAmt; // 32 (starting at cb0[2].x)
            float _SpeedX; // 96 (starting at cb0[6].x)
            float _SpeedY; // 100 (starting at cb0[6].y)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _BumpMap; // 1
            sampler2D _GrabTexture; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = float2(1.0, 1.0) - inp.texcoord2.xy;
                tmp0 = tex2D(_Mask, tmp0.xy);
                tmp0.y = inp.texcoord.z * _BumpAmt;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * _HeatEffectMult;
                tmp0.x = tmp0.x * 0.00195313;
                tmp0.yz = float2(_SpeedX.x, _SpeedY.x) * _Time.yy + inp.texcoord1.xy;
                tmp1 = tex2D(_BumpMap, tmp0.yz);
                tmp1.x = tmp1.w * tmp1.x;
                tmp0.yz = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.yz * tmp0.xx + inp.texcoord.xy;
                tmp0.xy = tmp0.xy / inp.texcoord.ww;
                o.sv_target = tex2D(_GrabTexture, tmp0.xy);
                return o;
            }

            #elif RENDER_DBG
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BumpAmt; // 32 (starting at cb0[2].x)
            float _SpeedX; // 96 (starting at cb0[6].x)
            float _SpeedY; // 100 (starting at cb0[6].y)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _BumpMap; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = float2(1.0, 1.0) - inp.texcoord2.xy;
                tmp0 = tex2D(_Mask, tmp0.xy);
                tmp0.y = inp.texcoord.z * _BumpAmt;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.00195313;
                tmp0.yz = float2(_SpeedX.x, _SpeedY.x) * _Time.yy + inp.texcoord1.xy;
                tmp1 = tex2D(_BumpMap, tmp0.yz);
                tmp1.x = tmp1.w * tmp1.x;
                tmp0.yz = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xx * tmp0.yz;
                tmp0.xy = tmp0.xy * float2(30.0, 30.0) + float2(1.0, 1.0);
                o.sv_target.xy = tmp0.xy * float2(0.5, 0.5);
                o.sv_target.zw = float2(1.0, 1.0);
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BumpAmt; // 32 (starting at cb0[2].x)
            float _SpeedX; // 96 (starting at cb0[6].x)
            float _SpeedY; // 100 (starting at cb0[6].y)
            // Textures for DX11PixelSM40
            sampler2D _Mask; // 0
            sampler2D _BumpMap; // 1
            sampler2D _GrabTexture; // 2

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = float2(1.0, 1.0) - inp.texcoord2.xy;
                tmp0 = tex2D(_Mask, tmp0.xy);
                tmp0.y = inp.texcoord.z * _BumpAmt;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.00195313;
                tmp0.yz = float2(_SpeedX.x, _SpeedY.x) * _Time.yy + inp.texcoord1.xy;
                tmp1 = tex2D(_BumpMap, tmp0.yz);
                tmp1.x = tmp1.w * tmp1.x;
                tmp0.yz = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.yz * tmp0.xx + inp.texcoord.xy;
                tmp0.xy = tmp0.xy / inp.texcoord.ww;
                o.sv_target = tex2D(_GrabTexture, tmp0.xy);
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
