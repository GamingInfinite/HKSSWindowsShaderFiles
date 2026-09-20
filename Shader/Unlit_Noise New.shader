Shader "Unlit/Noise New" {
    Properties {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _NoiseColor ("Noise Color", Vector) = (1, 1, 1, 1)
        _NoiseStrength ("Noise Strength", Float) = 0.5
        _TimeSnap ("Time Snap", Float) = 0.5
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
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                o.texcoord.xy = v.texcoord.xy;
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
            float4 _NoiseColor; // 32 (starting at cb0[2].x)
            float _NoiseStrength; // 48 (starting at cb0[3].x)
            float _TimeSnap; // 52 (starting at cb0[3].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0
            sampler2D _NoiseTex; // 1

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _Time.zx / _TimeSnap.xx;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy * _TimeSnap.xx;
                tmp0.z = dot(tmp0.xy, float2(127.1, 311.7));
                tmp0.x = dot(tmp0.xy, float2(269.5, 183.3));
                tmp0.y = sin(tmp0.x);
                tmp0.x = sin(tmp0.z);
                tmp0.xy = tmp0.xy * float2(43758.55, 43758.55);
                tmp0.xy = frac(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * float2(162.185, 162.185) + inp.texcoord.xy;
                tmp0 = tex2D(_NoiseTex, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x * _NoiseStrength;
                tmp0.xyz = _NoiseColor.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target.xyz = saturate(tmp0.xyz * tmp1.xyz);
                o.sv_target.w = tmp1.w;
                return o;
            }
            ENDCG
            
        }
    }
}
