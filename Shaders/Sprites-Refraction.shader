Shader "Custom/Sprites-Refraction" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        _BumpAmt ("Distortion", Range(0, 500)) = 10
        _BumpMap ("Normalmap", 2D) = "bump" {}
        [Toggle(USE_SILHOUETTE)] _UseSilhouette ("Just Use Silhouette", Float) = 0
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

            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature USE_SILHOUETTE
            

            #if ETC1_EXTERNAL_ALPHA && USE_SILHOUETTE // :DX11VertexSM40
            struct appdata
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
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _BumpMap_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = v.vertex.yy * unity_ObjectToWorld._m01_m11;
                tmp1.xy = unity_ObjectToWorld._m00_m10 * v.vertex.xx + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m02_m12 * v.vertex.zz + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                o.texcoord2.xy = tmp1.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }

            #elif USE_SILHOUETTE // :DX11VertexSM40
            struct appdata
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
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _BumpMap_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = v.vertex.yy * unity_ObjectToWorld._m01_m11;
                tmp1.xy = unity_ObjectToWorld._m00_m10 * v.vertex.xx + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m02_m12 * v.vertex.zz + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                o.texcoord2.xy = tmp1.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA // :DX11VertexSM40
            struct appdata
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
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _BumpMap_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = v.vertex.yy * unity_ObjectToWorld._m01_m11;
                tmp1.xy = unity_ObjectToWorld._m00_m10 * v.vertex.xx + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m02_m12 * v.vertex.zz + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                o.texcoord2.xy = tmp1.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
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
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _BumpMap_ST; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 3
                float4 _RendererColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            float2 _Flip; // 16 (starting at cb3[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.xy * _Flip;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                tmp1 = v.color * _Color;
                o.color = tmp1 * _RendererColor;
                tmp1.xy = v.vertex.yy * unity_ObjectToWorld._m01_m11;
                tmp1.xy = unity_ObjectToWorld._m00_m10 * v.vertex.xx + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m02_m12 * v.vertex.zz + tmp1.xy;
                tmp1.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                o.texcoord2.xy = tmp1.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = tmp0.xy * float2(1.0, -1.0) + tmp0.ww;
                o.texcoord1.zw = tmp0.zw;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5);
                return o;
            }
            #endif


            #if ETC1_EXTERNAL_ALPHA && USE_SILHOUETTE // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BumpAmt; // 96 (starting at cb0[6].x)
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _SpriteRefractionGrab; // 3
            sampler2D _AlphaTex; // 1
            sampler2D _BumpMap; // 2
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = inp.texcoord1.z * _BumpAmt;
                tmp0.z = tmp0.z * 0.00195313;
                tmp0.xy = tmp0.xy * tmp0.zz + inp.texcoord1.xy;
                tmp0.xy = tmp0.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_SpriteRefractionGrab, tmp0.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = tmp1.x - tmp2.w;
                tmp0.w = _EnableExternalAlpha * tmp0.w + tmp2.w;
                tmp0.w = tmp0.w * inp.color.w;
                tmp1.x = tmp0.w > 0.1;
                tmp0.w = tmp1.x ? 1.0 : tmp0.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif USE_SILHOUETTE // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BumpAmt; // 96 (starting at cb0[6].x)
            // Textures for DX11PixelSM40
            sampler2D _SpriteRefractionGrab; // 2
            sampler2D _BumpMap; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = inp.texcoord1.z * _BumpAmt;
                tmp0.z = tmp0.z * 0.00195313;
                tmp0.xy = tmp0.xy * tmp0.zz + inp.texcoord1.xy;
                tmp0.xy = tmp0.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_SpriteRefractionGrab, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = tmp1.w * inp.color.w;
                tmp1.x = tmp0.w > 0.1;
                tmp0.w = tmp1.x ? 1.0 : tmp0.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BumpAmt; // 96 (starting at cb0[6].x)
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _SpriteRefractionGrab; // 3
            sampler2D _AlphaTex; // 1
            sampler2D _BumpMap; // 2
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = inp.texcoord1.z * _BumpAmt;
                tmp0.z = tmp0.z * 0.00195313;
                tmp0.xy = tmp0.xy * tmp0.zz + inp.texcoord1.xy;
                tmp0.xy = tmp0.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_SpriteRefractionGrab, tmp0.xy);
                tmp1 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - tmp2.w;
                tmp2.w = _EnableExternalAlpha * tmp1.x + tmp2.w;
                tmp1 = tmp2 * inp.color + -tmp0;
                tmp2.x = tmp2.w * inp.color.w;
                tmp2.y = tmp2.x > 0.1;
                tmp2.x = tmp2.y ? tmp2.x : 1.0;
                tmp0 = tmp2.xxxx * tmp1 + tmp0;
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
            float _BumpAmt; // 96 (starting at cb0[6].x)
            // Textures for DX11PixelSM40
            sampler2D _SpriteRefractionGrab; // 2
            sampler2D _BumpMap; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_BumpMap, inp.texcoord2.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = inp.texcoord1.z * _BumpAmt;
                tmp0.z = tmp0.z * 0.00195313;
                tmp0.xy = tmp0.xy * tmp0.zz + inp.texcoord1.xy;
                tmp0.xy = tmp0.xy / inp.texcoord1.ww;
                tmp0 = tex2D(_SpriteRefractionGrab, tmp0.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tmp1 * inp.color + -tmp0;
                tmp1.x = tmp1.w * inp.color.w;
                tmp1.y = tmp1.x > 0.1;
                tmp1.x = tmp1.y ? tmp1.x : 1.0;
                tmp0 = tmp1.xxxx * tmp2 + tmp0;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Sprites/Diffuse"
}
