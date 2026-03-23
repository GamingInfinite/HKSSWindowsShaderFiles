Shader "Hollow Knight/Light Blur" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _BlurInfo ("Blur Info", Vector) = (0.00052083336, 0.0009259259, 0, 0)
    }
    SubShader {
        Pass {
            Name ""
            ZClip On
            ZWrite Off
            Cull Off
            CGPROGRAM
            
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
                float2 texcoord : TEXCOORD;
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float2 _BlurInfo; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = _BlurInfo.xxxx * float4(3.230769, 1.384615, -2.769231, -0.615385) + inp.texcoord.xxxx;
                tmp1.xz = tmp0.yw;
                tmp1.yw = inp.texcoord.yy;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.316261, 0.316261, 0.316261);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = tmp2.xyz * float3(0.227027, 0.227027, 0.227027) + tmp1.xyz;
                tmp0.yw = inp.texcoord.yy;
                tmp2 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz * float3(0.07027, 0.07027, 0.07027) + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
            }
            ENDCG
            
        }
        Pass {
            Name ""
            ZClip On
            ZWrite Off
            Cull Off
            CGPROGRAM
            
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
                float2 texcoord : TEXCOORD;
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float2 _BlurInfo; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xz = inp.texcoord.xx;
                tmp1 = _BlurInfo.yyyy * float4(1.384615, 3.230769, -0.615385, -2.769231) + inp.texcoord.yyyy;
                tmp0.yw = tmp1.xz;
                tmp2 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.316261, 0.316261, 0.316261);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.xyz = tmp2.xyz * float3(0.227027, 0.227027, 0.227027) + tmp0.xyz;
                tmp1.xz = inp.texcoord.xx;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * float3(0.07027, 0.07027, 0.07027) + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
            }
            ENDCG
            
        }
    }
}
