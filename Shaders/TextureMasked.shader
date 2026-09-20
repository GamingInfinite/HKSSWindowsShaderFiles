Shader "Custom/Texture Masked" {
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        [PerRendererData] _TintColor ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle(USE_CHANNEL_MULTIPLY)] _UseChannelMultiply ("Use Channel Multiply as Greyscale", Float) = 0
        [Toggle(USE_MASK)] _UseMask ("Use Mask", Float) = 0
        _MaskTex ("Mask Texture", 2D) = "white" {}
        [Toggle(USE_MASK_2)] _UseMask2 ("Use Mask 2", Float) = 0
        _MaskTex2 ("Mask Texture 2", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "DisableBatching"="true"
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        Pass {
            Name ""
            LOD 100
            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Tags {
                "DisableBatching"="true"
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            // #pragma shader_feature INSTANCING_ON  (removed: decompiled instancing buffers unity_Builtins0Array/PerDrawSpriteArray are never declared)
            #pragma shader_feature USE_MASK
            #pragma shader_feature USE_MASK_2
            #pragma shader_feature USE_CHANNEL_MULTIPLY
            

            #if INSTANCING_ON && USE_MASK && USE_MASK_2 // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex2_ST; // 80 (starting at cb0[5].x)
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = v.texcoord.xy * _MaskTex2_ST.xy + _MaskTex2_ST.zw;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                o.color = v.color * _TintColor;
                tmp1 = v.vertex.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
            }

            #elif INSTANCING_ON && USE_CHANNEL_MULTIPLY && USE_MASK // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                o.color = v.color * _TintColor;
                tmp1 = v.vertex.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
            }

            #elif USE_MASK && USE_MASK_2 // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex2_ST; // 80 (starting at cb0[5].x)
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(Props) // 3
                float4 _TintColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord2.xy = v.texcoord.xy * _MaskTex2_ST.xy + _MaskTex2_ST.zw;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif USE_CHANNEL_MULTIPLY && USE_MASK // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(Props) // 3
                float4 _TintColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif INSTANCING_ON && USE_MASK // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                o.color = v.color * _TintColor;
                tmp1 = v.vertex.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
            }

            #elif USE_MASK // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(Props) // 3
                float4 _TintColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif INSTANCING_ON // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(UnityDrawCallInfo) // 2
                int unity_BaseInstanceID; // 0 (starting at cb2[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                o.color = v.color * _TintColor;
                tmp1 = v.vertex.yyyy * unity_Builtins0Array.unity_ObjectToWorldArray._m01_m11_m21_m31;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_Builtins0Array.unity_ObjectToWorldArray._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0 = tmp1 + unity_Builtins0Array.unity_ObjectToWorldArray._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            // CBUFFER_START(Props) // 3
                float4 _TintColor; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }
            #endif


            #if INSTANCING_ON && USE_MASK && USE_MASK_2 // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MaskTex2; // 2
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.xyz;
                tmp1 = tex2D(_MaskTex2, inp.texcoord2.xy);
                o.sv_target.w = tmp0.w * tmp1.x;
                return o;
            }

            #elif INSTANCING_ON && USE_CHANNEL_MULTIPLY && USE_MASK // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xy = tmp0.xy * inp.color.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.z * inp.color.z + tmp0.x;
                tmp0.xyz = tmp0.www * inp.color.www + tmp0.xxx;
                tmp0.w = 1.0;
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_MaskTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.xyz;
                return o;
            }

            #elif USE_MASK && USE_MASK_2 // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MaskTex2; // 2
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp0.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.xyz;
                tmp1 = tex2D(_MaskTex2, inp.texcoord2.xy);
                o.sv_target.w = tmp0.w * tmp1.x;
                return o;
            }

            #elif USE_CHANNEL_MULTIPLY && USE_MASK // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xy = tmp0.xy * inp.color.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.z * inp.color.z + tmp0.x;
                tmp0.xyz = tmp0.www * inp.color.www + tmp0.xxx;
                tmp0.w = 1.0;
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_MaskTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.xyz;
                return o;
            }

            #elif INSTANCING_ON && USE_MASK // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_MaskTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.xyz;
                return o;
            }

            #elif USE_MASK // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_MaskTex, inp.texcoord1.xy);
                o.sv_target.w = tmp0.w * tmp1.x;
                o.sv_target.xyz = tmp0.xyz;
                return o;
            }

            #elif INSTANCING_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                o.sv_target = tmp0 * _Color;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                o.sv_target = tmp0 * _Color;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
