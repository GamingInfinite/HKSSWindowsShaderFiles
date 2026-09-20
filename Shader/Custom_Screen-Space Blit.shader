Shader "Custom/Screen-Space Blit" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Geometry"
            "RenderType"="Opaque"
        }
        Pass {
            Name ""
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Geometry"
                "RenderType"="Opaque"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature BLUR_PLANE
            

            #if BLUR_PLANE // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
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
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp1.zz + tmp1.xw;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
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
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord.zw = tmp0.zw;
                o.texcoord.xy = tmp1.zz + tmp1.xw;
                return o;
            }
            #endif


            #if BLUR_PLANE // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _BlurPlaneVibranceOffset; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _BlurPlaneVibranceOffset + 1.0;
                tmp0.yz = inp.texcoord.xy / inp.texcoord.ww;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp1.w;
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
                float4 tmp0;
                tmp0.xy = inp.texcoord.xy / inp.texcoord.ww;
                o.sv_target = tex2D(_MainTex, tmp0.xy);
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
