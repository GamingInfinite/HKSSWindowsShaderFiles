Shader "UI/BlendModes/Font/Difference" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }
    SubShader {
        Tags {
            "IGNOREPROJECTOR"="true"
            "PreviewType"="Plane"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
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
            Fog {
                Mode Off
            }
            Tags {
                "IGNOREPROJECTOR"="true"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            

            struct appdata
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                o.texcoord1 = tmp0;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _GrabTexture; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = inp.color.w * tmp0.w + -0.01;
                tmp0.y = tmp0.w * inp.color.w;
                o.sv_target.w = tmp0.y;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp0.xy = tmp0.xy + float2(1.0, 1.0);
                tmp0.x = tmp0.x * 0.5;
                tmp0.z = -tmp0.y * 0.5 + 1.0;
                tmp0 = tex2D(_GrabTexture, tmp0.xz);
                tmp0.xyz = tmp0.xyz - inp.color.xyz;
                o.sv_target.xyz = abs(tmp0.xyz);
                return o;
            }
            ENDCG
            
        }
    }
    Fallback "UI/Default Font"
}
