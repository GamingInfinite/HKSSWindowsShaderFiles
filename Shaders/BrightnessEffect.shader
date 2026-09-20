Shader "Custom/Brightness Effect" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Brightness ("Brightness", Float) = 1
        _Contrast ("Contrast", Float) = 1
        [Toggle(ENABLE_ALPHA)] _EnableAlpha ("Enable Effect Alpha", Float) = 0
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

            #pragma shader_feature ENABLE_ALPHA
            #pragma shader_feature UNITY_UI_ALPHACLIP
            

            #if ENABLE_ALPHA && UNITY_UI_ALPHACLIP // :DX11VertexSM40
            struct appdata
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
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
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
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1 = v.vertex;
                return o;
            }

            #elif ENABLE_ALPHA // :DX11VertexSM40
            struct appdata
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
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
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
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1 = v.vertex;
                return o;
            }

            #elif UNITY_UI_ALPHACLIP // :DX11VertexSM40
            struct appdata
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
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
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
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
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
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1 = v.vertex;
                return o;
            }
            #endif


            #if ENABLE_ALPHA && UNITY_UI_ALPHACLIP // :DX11PixelSM40
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
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp0.w - 0.001;
                tmp1.x = tmp1.x < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                o.sv_target.xyz = tmp0.xyz * inp.color.www;
                return o;
            }

            #elif ENABLE_ALPHA // :DX11PixelSM40
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.w = tmp0.w;
                tmp0.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                o.sv_target.xyz = tmp0.xyz * inp.color.www;
                return o;
            }

            #elif UNITY_UI_ALPHACLIP // :DX11PixelSM40
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }

            #else
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = tmp0.xyz * _Brightness.xxx + float3(-0.5, -0.5, -0.5);
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz * _Contrast.xxx + float3(0.5, 0.5, 0.5);
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
