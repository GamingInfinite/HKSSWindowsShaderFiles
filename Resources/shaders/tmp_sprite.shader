Shader "TextMeshPro/Sprite" {
    Properties {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
        _ClipRect ("Clip Rect", Vector) = (-10000, -10000, 10000, 10000)
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
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
            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ColorMask 0
            ZClip On
            ZWrite Off
            Cull Off
            Stencil {
                ReadMask 0
                WriteMask 0
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

            #pragma shader_feature UNITY_UI_ALPHACLIP
            

            #if UNITY_UI_ALPHACLIP // :DX11VertexSM40
            struct appdata
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
                o.texcoord1 = v.vertex;
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
                o.texcoord1 = v.vertex;
                return o;
            }
            #endif


            #if UNITY_UI_ALPHACLIP // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _TextureSampleAdd; // 48 (starting at cb0[3].x)
            float4 _ClipRect; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord1.xy >= _ClipRect.xy;
                tmp0.zw = _ClipRect.zw >= inp.texcoord1.xy;
                tmp0 = uint4(tmp0) & uint4(int4(1, 1, 1, 1));
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.x = tmp0.y * tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 + _TextureSampleAdd;
                tmp1 = tmp1 * inp.color;
                tmp0.y = tmp1.w * tmp0.x + -0.001;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                o.sv_target.w = tmp0.x;
                tmp0.x = tmp0.y < 0.0;
                if (tmp0.x) {
                    discard;
                }
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _TextureSampleAdd; // 48 (starting at cb0[3].x)
            float4 _ClipRect; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord1.xy >= _ClipRect.xy;
                tmp0.zw = _ClipRect.zw >= inp.texcoord1.xy;
                tmp0 = uint4(tmp0) & uint4(int4(1, 1, 1, 1));
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.x = tmp0.y * tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 + _TextureSampleAdd;
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
