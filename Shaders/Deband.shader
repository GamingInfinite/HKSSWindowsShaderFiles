Shader "ImageEffects/Deband" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Threshold ("Threshold", Float) = 64
        _Range ("Range", Float) = 8
        _Iterations ("Iterations", Float) = 4
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 100
        Pass {
            Name ""
            LOD 100
            ZClip On
            ZTest Always
            ZWrite Off
            Cull Off
            Tags {
                "RenderType"="Opaque"
            }
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
            float4 _MainTex_TexelSize; // 32 (starting at cb0[2].x)
            float _Threshold; // 48 (starting at cb0[3].x)
            float _Range; // 52 (starting at cb0[3].y)
            float _Iterations; // 56 (starting at cb0[3].z)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xy = inp.texcoord.xy + float2(1.0, 1.0);
                tmp0.z = _Time.y + 1.0;
                tmp0.w = tmp0.x * 34.0 + 1.0;
                tmp0.x = tmp0.x * tmp0.w;
                tmp0.w = tmp0.x * 0.00346021;
                tmp0.w = floor(tmp0.w);
                tmp0.x = -tmp0.w * 289.0 + tmp0.x;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.y = tmp0.x * 34.0 + 1.0;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * 0.00346021;
                tmp0.y = floor(tmp0.y);
                tmp0.x = -tmp0.y * 289.0 + tmp0.x;
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.y = tmp0.x * 34.0 + 1.0;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * 0.00346021;
                tmp0.y = floor(tmp0.y);
                tmp0.x = -tmp0.y * 289.0 + tmp0.x;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2 = tmp1;
                tmp0.y = tmp0.x;
                tmp0.z = 1.0;
                while (true) {
                    tmp0.w = _Iterations < tmp0.z;
                    if (tmp0.w) {
                        break;
                    }
                    tmp0.w = floor(tmp0.z);
                    tmp3.x = tmp0.w * _Range;
                    tmp3.y = tmp0.y * 0.02439024;
                    tmp3.y = frac(tmp3.y);
                    tmp3.x = tmp3.x * tmp3.y;
                    tmp3.y = tmp0.y * 34.0 + 1.0;
                    tmp3.y = tmp0.y * tmp3.y;
                    tmp3.z = tmp3.y * 0.00346021;
                    tmp3.z = floor(tmp3.z);
                    tmp3.y = -tmp3.z * 289.0 + tmp3.y;
                    tmp3.z = tmp3.y * 0.02439024;
                    tmp3.z = frac(tmp3.z);
                    tmp3.w = tmp3.y * 34.0 + 1.0;
                    tmp3.y = tmp3.y * tmp3.w;
                    tmp3.zw = tmp3.zy * float2(6.283185, 0.00346021);
                    tmp3.w = floor(tmp3.w);
                    tmp0.y = -tmp3.w * 289.0 + tmp3.y;
                    tmp3.xy = tmp3.xx * _MainTex_TexelSize.xy;
                    tmp4.x = sin(tmp3.z);
                    tmp5.x = cos(tmp3.z);
                    tmp6.z = tmp5.x;
                    tmp6.w = tmp4.x;
                    tmp3.zw = tmp3.xy * tmp6.zw + inp.texcoord.xy;
                    tmp7 = tex2D(_MainTex, tmp3.zw);
                    tmp6.y = -tmp4.x;
                    tmp3.zw = tmp3.xy * tmp6.yz + inp.texcoord.xy;
                    tmp4 = tex2D(_MainTex, tmp3.zw);
                    tmp6.x = -tmp5.x;
                    tmp3 = tmp3.xyxy * tmp6.xywx + inp.texcoord.xyxy;
                    tmp5 = tex2D(_MainTex, tmp3.xy);
                    tmp3 = tex2D(_MainTex, tmp3.zw);
                    tmp4 = tmp4 + tmp7;
                    tmp4 = tmp5 + tmp4;
                    tmp3 = tmp3 + tmp4;
                    tmp4 = tmp3 * float4(0.25, 0.25, 0.25, 0.25);
                    tmp3 = -tmp3 * float4(0.25, 0.25, 0.25, 0.25) + tmp2;
                    tmp0.w = tmp0.w * 16384.0;
                    tmp0.w = _Threshold / tmp0.w;
                    tmp5 = abs(tmp3) >= tmp0.wwww;
                    tmp5 = uint4(tmp5) & uint4(int4(1, 1, 1, 1));
                    tmp2 = tmp5 * tmp3 + tmp4;
                    tmp0.z = tmp0.z + 1;
                }
                o.sv_target = tmp2;
                return o;
            }
            ENDCG
            
        }
    }
}
