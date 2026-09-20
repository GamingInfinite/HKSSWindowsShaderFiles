Shader "Switch/Video" {
    Properties {
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Luminance Texture", 2D) = "black" {}
        _ChromaTex ("Chroma Texture", 2D) = "green" {}
    }
    SubShader {
        Pass {
            Name ""
            ZClip On
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float4 _ChromaTex_ST; // 48 (starting at cb0[3].x)
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
                o.texcoord.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _ChromaTex_ST.xy + _ChromaTex_ST.zw;
                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _ChromaTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy < float2(0.0, 0.0);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                tmp0.yz = inp.texcoord.xy > float2(1.0, 1.0);
                tmp0.x = uint1(tmp0.y) | uint1(tmp0.x);
                tmp0.x = uint1(tmp0.z) | uint1(tmp0.x);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = tmp1.x - 0.0625;
                tmp2 = tex2D(_ChromaTex, inp.texcoord1.xy);
                tmp1.yz = tmp2.xy - float2(0.5, 0.5);
                tmp2.x = dot(float2(1.1644, 1.7927), tmp1.xz);
                tmp2.y = dot(float4(1.1644, -0.2133, -0.5329, 0.0), tmp1.xyz);
                tmp2.z = dot(float2(1.1644, 2.1124), tmp1.xy);
                tmp0.xyz = tmp0.xxx ? float3(0.0, 0.0, 0.0) : tmp2.xyz;
                tmp1.xyz = _Color.xyz - tmp0.xyz;
                o.sv_target.xyz = _Color.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
            }
            ENDCG
            
        }
    }
}
