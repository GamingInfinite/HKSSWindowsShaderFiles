Shader "Sprites/Cherry-Default-HueShift" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        _HueShift ("Hue Shift", Range(-1, 1)) = 0
    }
    SubShader {
        Tags {
            "CanUseSpriteAtlas"="true"
            "IGNOREPROJECTOR"="true"
            "PreviewType"="Plane"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name ""
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "CanUseSpriteAtlas"="true"
                "IGNOREPROJECTOR"="true"
                "PreviewType"="Plane"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature PIXELSNAP_ON
            

            #if PIXELSNAP_ON
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
                tmp0.xy = tmp0.xy / tmp0.ww;
                tmp1.xy = _ScreenParams.xy * float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * tmp1.xy;
                tmp0.xy = round(tmp0.xy);
                tmp0.xy = tmp0.xy / tmp1.xy;
                o.position.xy = tmp0.ww * tmp0.xy;
                o.position.zw = tmp0.zw;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if PIXELSNAP_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HueShift; // 52 (starting at cb0[3].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _HueShift; // 52 (starting at cb0[3].y)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = tex2D(_MainTex, inp.texcoord.xy);
                tmp3.x = tmp2.y >= tmp2.z;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.xxxx * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.x = tmp2.x >= tmp0.x;
                tmp3.x = uint1(tmp3.x) & uint1(1);
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.xxxx * tmp1.yxzw + tmp0.yxzw;
                tmp1.x = min(tmp0.x, tmp0.w);
                tmp1.x = tmp0.y - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.x = tmp0.w - tmp0.x;
                tmp0.x = tmp0.x / tmp1.y;
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = abs(tmp0.x) + _HueShift;
                tmp0.xzw = tmp0.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp0.xzw = frac(tmp0.xzw);
                tmp0.xzw = tmp0.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) - float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.y + 0.0;
                tmp0.y = saturate(tmp0.y);
                tmp1.x = saturate(tmp1.x / tmp1.y);
                tmp0.xzw = tmp1.xxx * tmp0.xzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xzw * tmp0.yyy;
                tmp0 = tmp2 * inp.color;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
