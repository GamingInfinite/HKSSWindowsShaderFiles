Shader "TextMeshPro/Mobile/Bitmap" {
    Properties {
        _MainTex ("Font Atlas", 2D) = "white" {}
        _Color ("Text Color", Color) = (1, 1, 1, 1)
        _DiffusePower ("Diffuse Power", Range(1, 4)) = 1
        _VertexOffsetX ("Vertex OffsetX", Float) = 0
        _VertexOffsetY ("Vertex OffsetY", Float) = 0
        _MaskSoftnessX ("Mask SoftnessX", Float) = 0
        _MaskSoftnessY ("Mask SoftnessY", Float) = 0
        _ClipRect ("Clip Rect", Vector) = (-10000, -10000, 10000, 10000)
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
            Fog {
                Mode Off
            }
            Tags {
                "IGNOREPROJECTOR"="true"
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
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 sv_position : SV_Position;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float4 texcoord2 : TEXCOORD2;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _DiffusePower; // 48 (starting at cb0[3].x)
            float _VertexOffsetX; // 52 (starting at cb0[3].y)
            float _VertexOffsetY; // 56 (starting at cb0[3].z)
            float4 _ClipRect; // 64 (starting at cb0[4].x)
            float _MaskSoftnessX; // 80 (starting at cb0[5].x)
            float _MaskSoftnessY; // 84 (starting at cb0[5].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.zw = tmp1.xy / tmp1.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.zw * tmp1.xy;
                tmp0.zw = round(tmp0.zw);
                tmp0.zw = tmp0.zw / tmp1.xy;
                o.sv_position.xy = tmp1.ww * tmp0.zw;
                o.sv_position.zw = tmp1.zw;
                tmp0.zw = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp1.ww;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp0.zw;
                tmp1 = v.color * _Color;
                o.color.xyz = tmp1.xyz * _DiffusePower.xxx;
                o.color.w = tmp1.w;
                o.texcoord.xy = v.texcoord.xy;
                tmp1 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp1 = min(tmp1, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp1.xy;
                o.texcoord2.xy = tmp0.xy - tmp1.zw;
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
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _ClipRect.zw - _ClipRect.xy;
                tmp0.xy = tmp0.xy - abs(inp.texcoord2.xy);
                tmp0.xy = saturate(tmp0.xy * inp.texcoord2.zw);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.w = tmp1.w * inp.color.w;
                tmp1.xyz = inp.color.xyz;
                o.sv_target = tmp0.xxxx * tmp1;
                return o;
            }
            ENDCG
            
        }
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
            ZTest Always
            ZWrite Off
            Cull Off
            Fog {
                Mode Off
            }
            Tags {
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            

            struct appdata
            {
                float3 vertex : POSITION;
                float4 color : COLOR;
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
                o.color = saturate(v.color);
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
            float4 _Color; // 48 (starting at cb0[3].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target.w = tmp0.w * _Color.w;
                o.sv_target.xyz = inp.color.xyz * _Color.xyz;
                return o;
            }
            ENDCG
            
        }
    }
}
