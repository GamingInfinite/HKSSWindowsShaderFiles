Shader "Custom/Water" {
    Properties {
        _MainTex ("Tint Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _BumpAmt ("Distortion", Range(0, 128)) = 10
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _SpeedX ("Speed X", Float) = 1
        _SpeedY ("Speed Y", Float) = 1
        _Reflection ("Reflection Intensity", Range(0, 1)) = 1
        [Toggle(ENABLE_REFLECTION)] _EnableReflection ("Enable Screen Reflection", Float) = 0
        _ReflectionOffset ("Reflection Offset", Float) = 0
        _MaskTex ("Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "QUEUE"="Transparent"
            "RenderType"="Opaque"
        }

        GrabPass {
            "_GrabTexture"
        }

        Pass {
            Name "MASK"
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
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

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
                float2 texcoord3 : TEXCOORD3;
            };

            // CBs for DX11VertexSM40
            float4 _BumpMap_ST; // 48 (starting at cb0[3].x)
            float4 _MainTex_ST; // 64 (starting at cb0[4].x)
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
                o.texcoord2.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord3.xy = v.texcoord.xy * float2(1.0, -1.0) + float2(0.0, 1.0);
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BumpAmt; // 32 (starting at cb0[2].x)
            float _SpeedX; // 80 (starting at cb0[5].x)
            float _SpeedY; // 84 (starting at cb0[5].y)
            float4 _GrabTexture_TexelSize; // 96 (starting at cb0[6].x)
            float4 _Color; // 112 (starting at cb0[7].x)
            float _Reflection; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _GrabTexture; // 0
            sampler2D _BumpMap; // 1
            sampler2D _MainTex; // 2
            sampler2D _MaskTex; // 3

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = float2(_SpeedX.x, _SpeedY.x) * _Time.yy + inp.texcoord1.xy;
                tmp0 = tex2D(_BumpMap, tmp0.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * _BumpAmt.xx;
                tmp0.xz = tmp0.xy * _GrabTexture_TexelSize.xy;
                tmp0.y = tmp0.y * _GrabTexture_TexelSize.y + inp.texcoord3.y;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = tmp0.y * _Reflection;
                tmp0.xz = tmp0.xz * inp.texcoord.zz + inp.texcoord.xy;
                tmp0.xz = tmp0.xz / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp0.xz);
                tmp2 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp1 = tmp1 * tmp2;
                tmp0 = tmp1 * _Color + tmp0.yyyy;
                tmp1.xy = inp.texcoord.xy / inp.texcoord.ww;
                tmp1 = tex2D(_GrabTexture, tmp1.xy);
                tmp0 = tmp0 - tmp1;
                tmp2 = tex2D(_MaskTex, inp.texcoord2.xy);
                o.sv_target = tmp2.xxxx * tmp0 + tmp1;
                return o;
            }
            ENDCG
        }
    }
    SubShader {
        Tags {
            "QUEUE"="Transparent"
            "RenderType"="Opaque"
        }
        Pass {
            Name "BASE"
            Blend DstColor Zero, DstColor Zero
            ZClip On
            ZWrite Off
            Fog {
                Mode Off
            }
            Tags {
                "QUEUE"="Transparent"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float3 vertex : POSITION;
                float3 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.color = float4(0.0, 0.0, 0.0, 1.0);
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
            }

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
                o.sv_target = tex2D(_MainTex, inp.texcoord.xy);
                return o;
            }
            ENDCG
        }
    }
}
