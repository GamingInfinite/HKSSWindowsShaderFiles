Shader "Custom/RadialFill" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _Angle ("Angle", Range(0, 360)) = 0
        _Arc1 ("Arc Point 1", Range(0, 360)) = 15
        _Arc2 ("Arc Point 2", Range(0, 360)) = 15
        _EdgeFade ("Edge Fade", Float) = 0
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
            

            #if PIXELSNAP_ON // :DX11VertexSM40
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


            #if PIXELSNAP_ON // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Angle; // 52 (starting at cb0[3].y)
            float _Arc1; // 56 (starting at cb0[3].z)
            float _Arc2; // 60 (starting at cb0[3].w)
            float _EdgeFade; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Angle - _Arc1;
                tmp0.y = _Arc2 + _Angle;
                tmp0.zw = inp.texcoord.yx * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = min(abs(tmp0.w), abs(tmp0.z));
                tmp1.y = max(abs(tmp0.w), abs(tmp0.z));
                tmp1.y = 1.0 / tmp1.y;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.z = tmp1.y * 0.0208351 + -0.085133;
                tmp1.z = tmp1.y * tmp1.z + 0.180141;
                tmp1.z = tmp1.y * tmp1.z + -0.3302995;
                tmp1.y = tmp1.y * tmp1.z + 0.999866;
                tmp1.z = tmp1.y * tmp1.x;
                tmp1.w = abs(tmp0.w) < abs(tmp0.z);
                tmp1.z = tmp1.z * -2.0 + 1.570796;
                tmp1.z = uint1(tmp1.w) & uint1(tmp1.z);
                tmp1.x = tmp1.x * tmp1.y + tmp1.z;
                tmp1.y = tmp0.w < -tmp0.w;
                tmp1.y = uint1(tmp1.y) & uint1(-3);
                tmp1.x = tmp1.y + tmp1.x;
                tmp1.y = min(tmp0.w, tmp0.z);
                tmp0.z = max(tmp0.w, tmp0.z);
                tmp0.w = tmp1.y < -tmp1.y;
                tmp0.z = tmp0.z >= -tmp0.z;
                tmp0.z = uint1(tmp0.z) & uint1(tmp0.w);
                tmp0.z = tmp0.z ? -tmp1.x : tmp1.x;
                tmp0.w = tmp0.z * 57.3;
                tmp1.x = tmp0.z < 0.0;
                tmp1.y = tmp0.z * 57.3 + 360.0;
                tmp1.x = tmp1.x ? tmp1.y : tmp0.w;
                tmp1.y = tmp1.x >= tmp0.x;
                tmp1.z = tmp0.y >= tmp1.x;
                tmp1.y = uint1(tmp1.z) & uint1(tmp1.y);
                if (tmp1.y) {
                    discard;
                }
                tmp1.y = tmp0.y - 360.0;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = min(tmp1.y, 360.0);
                tmp1.y = tmp1.y >= tmp1.x;
                if (tmp1.y) {
                    discard;
                }
                tmp1.y = tmp0.x + 360.0;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = min(tmp1.y, 360.0);
                tmp1.x = tmp1.x >= tmp1.y;
                if (tmp1.x) {
                    discard;
                }
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp2.x = tmp0.x - _EdgeFade;
                tmp2.y = tmp0.y + _EdgeFade;
                tmp2.z = tmp0.x >= tmp0.w;
                tmp2.x = tmp0.w >= tmp2.x;
                tmp2.x = uint1(tmp2.x) & uint1(tmp2.z);
                tmp0.x = tmp0.z * 57.3 + -tmp0.x;
                tmp0.x = tmp0.x / -_EdgeFade;
                tmp2.z = tmp0.w >= tmp0.y;
                tmp0.w = tmp2.y >= tmp0.w;
                tmp0.w = uint1(tmp0.w) & uint1(tmp2.z);
                tmp0.y = tmp0.z * 57.3 + -tmp0.y;
                tmp0.y = tmp0.y / _EdgeFade;
                tmp0.xy = tmp1.ww * tmp0.xy;
                tmp0.y = tmp0.w ? tmp0.y : tmp1.w;
                tmp0.x = tmp2.x ? tmp0.x : tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float _Angle; // 52 (starting at cb0[3].y)
            float _Arc1; // 56 (starting at cb0[3].z)
            float _Arc2; // 60 (starting at cb0[3].w)
            float _EdgeFade; // 64 (starting at cb0[4].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Angle - _Arc1;
                tmp0.y = _Arc2 + _Angle;
                tmp0.zw = inp.texcoord.yx * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = min(abs(tmp0.w), abs(tmp0.z));
                tmp1.y = max(abs(tmp0.w), abs(tmp0.z));
                tmp1.y = 1.0 / tmp1.y;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.z = tmp1.y * 0.0208351 + -0.085133;
                tmp1.z = tmp1.y * tmp1.z + 0.180141;
                tmp1.z = tmp1.y * tmp1.z + -0.3302995;
                tmp1.y = tmp1.y * tmp1.z + 0.999866;
                tmp1.z = tmp1.y * tmp1.x;
                tmp1.w = abs(tmp0.w) < abs(tmp0.z);
                tmp1.z = tmp1.z * -2.0 + 1.570796;
                tmp1.z = uint1(tmp1.w) & uint1(tmp1.z);
                tmp1.x = tmp1.x * tmp1.y + tmp1.z;
                tmp1.y = tmp0.w < -tmp0.w;
                tmp1.y = uint1(tmp1.y) & uint1(-3);
                tmp1.x = tmp1.y + tmp1.x;
                tmp1.y = min(tmp0.w, tmp0.z);
                tmp0.z = max(tmp0.w, tmp0.z);
                tmp0.w = tmp1.y < -tmp1.y;
                tmp0.z = tmp0.z >= -tmp0.z;
                tmp0.z = uint1(tmp0.z) & uint1(tmp0.w);
                tmp0.z = tmp0.z ? -tmp1.x : tmp1.x;
                tmp0.w = tmp0.z * 57.3;
                tmp1.x = tmp0.z < 0.0;
                tmp1.y = tmp0.z * 57.3 + 360.0;
                tmp1.x = tmp1.x ? tmp1.y : tmp0.w;
                tmp1.y = tmp1.x >= tmp0.x;
                tmp1.z = tmp0.y >= tmp1.x;
                tmp1.y = uint1(tmp1.z) & uint1(tmp1.y);
                if (tmp1.y) {
                    discard;
                }
                tmp1.y = tmp0.y - 360.0;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = min(tmp1.y, 360.0);
                tmp1.y = tmp1.y >= tmp1.x;
                if (tmp1.y) {
                    discard;
                }
                tmp1.y = tmp0.x + 360.0;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = min(tmp1.y, 360.0);
                tmp1.x = tmp1.x >= tmp1.y;
                if (tmp1.x) {
                    discard;
                }
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                tmp2.x = tmp0.x - _EdgeFade;
                tmp2.y = tmp0.y + _EdgeFade;
                tmp2.z = tmp0.x >= tmp0.w;
                tmp2.x = tmp0.w >= tmp2.x;
                tmp2.x = uint1(tmp2.x) & uint1(tmp2.z);
                tmp0.x = tmp0.z * 57.3 + -tmp0.x;
                tmp0.x = tmp0.x / -_EdgeFade;
                tmp2.z = tmp0.w >= tmp0.y;
                tmp0.w = tmp2.y >= tmp0.w;
                tmp0.w = uint1(tmp0.w) & uint1(tmp2.z);
                tmp0.y = tmp0.z * 57.3 + -tmp0.y;
                tmp0.y = tmp0.y / _EdgeFade;
                tmp0.xy = tmp1.ww * tmp0.xy;
                tmp0.y = tmp0.w ? tmp0.y : tmp1.w;
                tmp0.x = tmp2.x ? tmp0.x : tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = tmp0.x;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
