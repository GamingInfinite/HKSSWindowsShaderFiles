Shader "Hidden/NoiseAndGrain" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise (RGB)", 2D) = "white" {}
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

            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _NoiseTex_TexelSize; // 32 (starting at cb0[2].x)
            float4 _MainTex_TexelSize; // 48 (starting at cb0[3].x)
            float3 _NoiseTilingPerChannel; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float3 _NoisePerChannel; // 64 (starting at cb0[4].x)
            float3 _NoiseAmount; // 96 (starting at cb0[6].x)
            float3 _MidGrey; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_NoiseTex, inp.texcoord1.zw);
                tmp0.xyz = tmp0.xyz * float3(0.0, 1.0, 0.0);
                tmp1 = tex2D(_NoiseTex, inp.texcoord1.xy);
                tmp0.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp0.xyz;
                tmp1 = tex2D(_NoiseTex, inp.texcoord2.xy);
                tmp0.xyz = tmp1.xyz * float3(0.0, 0.0, 1.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0));
                tmp0.w = tmp0.w - _MidGrey.x;
                tmp2.xy = saturate(tmp0.ww * _MidGrey.yz);
                tmp0.w = dot(_NoiseAmount.zy, tmp2.xy);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w + _NoiseAmount.x;
                tmp2.xyz = tmp0.www * _NoisePerChannel;
                tmp0.xyz = saturate(tmp2.xyz * tmp0.xyz + float3(0.5, 0.5, 0.5));
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp1.xyz = saturate(tmp1.xyz);
                o.sv_target.w = tmp1.w;
                tmp3.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp3.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xyz = tmp1.xyz >= float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp1.xyz ? float3(0.0, 0.0, 0.0) : tmp0.xyz;
                tmp1.xyz = uint3(tmp1.xyz) & uint3(int3(1, 1, 1));
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp2.xyz + tmp0.xyz;
                return o;
            }
            ENDCG
            
        }
        Pass {
            Name ""
            ZClip On
            ZTest Always
            ZWrite Off
            Cull Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _NoiseTex_TexelSize; // 32 (starting at cb0[2].x)
            float4 _MainTex_TexelSize; // 48 (starting at cb0[3].x)
            float3 _NoiseTilingPerChannel; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_NoiseTex, inp.texcoord.xy);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp2.xyz = saturate(tmp2.xyz);
                o.sv_target.w = tmp2.w;
                tmp3.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.xyz >= float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp3.xyz ? float3(0.0, 0.0, 0.0) : tmp2.xyz;
                tmp3.xyz = uint3(tmp3.xyz) & uint3(int3(1, 1, 1));
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp3.xyz * tmp1.xyz + tmp0.xyz;
                return o;
            }
            ENDCG
            
        }
        Pass {
            Name ""
            ZClip On
            ZTest Always
            ZWrite Off
            Cull Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _NoiseTex_TexelSize; // 32 (starting at cb0[2].x)
            float4 _MainTex_TexelSize; // 48 (starting at cb0[3].x)
            float3 _NoiseTilingPerChannel; // 80 (starting at cb0[5].x)
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.vertex.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.vertex.y;
                tmp0.xy = v.texcoord1.xy * _NoiseTilingPerChannel.zz;
                o.texcoord2.xy = tmp0.xy * _NoiseTex_TexelSize.xy + v.texcoord.xy;
                o.texcoord.x = v.vertex.x;
                tmp0 = v.texcoord1.xyxy * _NoiseTilingPerChannel.xxyy;
                o.texcoord1 = tmp0 * _NoiseTex_TexelSize + v.texcoord.xyxy;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float3 _NoisePerChannel; // 64 (starting at cb0[4].x)
            float3 _NoiseAmount; // 96 (starting at cb0[6].x)
            float3 _MidGrey; // 128 (starting at cb0[8].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_NoiseTex, inp.texcoord1.zw);
                tmp0.xyz = tmp0.xyz * float3(0.0, 1.0, 0.0);
                tmp1 = tex2D(_NoiseTex, inp.texcoord1.xy);
                tmp0.xyz = tmp1.xyz * float3(1.0, 0.0, 0.0) + tmp0.xyz;
                tmp1 = tex2D(_NoiseTex, inp.texcoord2.xy);
                tmp0.xyz = tmp1.xyz * float3(0.0, 0.0, 1.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.w = dot(tmp1.xyz, float4(0.22, 0.707, 0.071, 0.0));
                o.sv_target.w = tmp1.w;
                tmp0.w = tmp0.w - _MidGrey.x;
                tmp1.xy = saturate(tmp0.ww * _MidGrey.yz);
                tmp0.w = dot(_NoiseAmount.zy, tmp1.xy);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w + _NoiseAmount.x;
                tmp1.xyz = tmp0.www * _NoisePerChannel;
                o.sv_target.xyz = saturate(tmp1.xyz * tmp0.xyz + float3(0.5, 0.5, 0.5));
                return o;
            }
            ENDCG
            
        }
    }
}
