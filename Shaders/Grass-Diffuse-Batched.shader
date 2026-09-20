Shader "Hollow Knight/Grass-Diffuse-Batchable" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        _SwaySpeed ("SwaySpeed", Float) = 1
        _SwayAmount ("Sway Amount", Float) = 1
        _WorldOffset ("World Offset", Float) = 1
        _HeightOffset ("Height Offset", Float) = 0
        _ClampZ ("Clamp Z Position", Float) = 1
        [PerRendererData] _PushAmount ("Push Amount (Player)", Float) = 0
        [PerRendererData] _SwayMultiplier ("Sway Multiplier (Extra)", Float) = 1
        [Toggle(FRAMERATE_SNAPPING)] _EnableFramerateSnapping ("Enable Framerate Snapping", Float) = 0
        _SnappedFramerate ("Snapped Framerate", Float) = 12
        [Toggle(SWAP_XY)] _SwapXY ("Sway X & Y", Float) = 0
        [HideInInspector] _MagnitudeMultA ("", Float) = 1
        [HideInInspector] _TimeMultA ("", Float) = 1
        [HideInInspector] _MagnitudeMultB ("", Float) = 1
        [HideInInspector] _TimeMultB ("", Float) = 1
        [HideInInspector] _MagnitudeMultC ("", Float) = 1
        [HideInInspector] _TimeMultC ("", Float) = 1
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

            #pragma shader_feature CUSTOM_FUNC
            #pragma shader_feature ETC1_EXTERNAL_ALPHA
            #pragma shader_feature FRAMERATE_SNAPPING
            

            #if CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float4 texcoord3 : TEXCOORD3;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float _TimeMultC; // 92 (starting at cb0[5].w)
            float _MagnitudeMultC; // 88 (starting at cb0[5].z)
            float _TimeMultB; // 84 (starting at cb0[5].y)
            float _MagnitudeMultB; // 80 (starting at cb0[5].x)
            float _TimeMultA; // 76 (starting at cb0[4].w)
            float _MagnitudeMultA; // 72 (starting at cb0[4].z)
            float _SnappedFramerate; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.texcoord3.y + v.texcoord3.x;
                tmp0.x = tmp0.x + v.texcoord3.z;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = v.texcoord3.w + _HeightOffset;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(v.texcoord3.z, -_ClampZ);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif CUSTOM_FUNC && FRAMERATE_SNAPPING // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float4 texcoord3 : TEXCOORD3;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float _TimeMultC; // 92 (starting at cb0[5].w)
            float _MagnitudeMultC; // 88 (starting at cb0[5].z)
            float _TimeMultB; // 84 (starting at cb0[5].y)
            float _MagnitudeMultB; // 80 (starting at cb0[5].x)
            float _TimeMultA; // 76 (starting at cb0[4].w)
            float _MagnitudeMultA; // 72 (starting at cb0[4].z)
            float _SnappedFramerate; // 68 (starting at cb0[4].y)
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.texcoord3.y + v.texcoord3.x;
                tmp0.x = tmp0.x + v.texcoord3.z;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.y = _Time.y * _SnappedFramerate + 0.5;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y / _SnappedFramerate;
                tmp0.x = tmp0.y * _SwaySpeed + tmp0.x;
                tmp0.y = tmp0.x * _TimeMultA;
                tmp0.xz = tmp0.xx * float2(_TimeMultC.x, _TimeMultB.x);
                tmp0.xyz = sin(tmp0.xyz);
                tmp0.x = tmp0.x * _MagnitudeMultB;
                tmp0.x = _MagnitudeMultA * tmp0.y + tmp0.x;
                tmp0.x = _MagnitudeMultC * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier + _PushAmount;
                tmp0.y = v.texcoord3.w + _HeightOffset;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(v.texcoord3.z, -_ClampZ);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA // :DX11VertexSM40
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float4 texcoord3 : TEXCOORD3;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.texcoord3.y + v.texcoord3.x;
                tmp0.x = tmp0.x + v.texcoord3.z;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = v.texcoord3.w + _HeightOffset;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(v.texcoord3.z, -_ClampZ);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }

            #else
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
                float4 texcoord3 : TEXCOORD3;
            };
            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD;
            };

            // CBs for DX11VertexSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            float _SwaySpeed; // 48 (starting at cb0[3].x)
            float _SwayAmount; // 52 (starting at cb0[3].y)
            float _WorldOffset; // 56 (starting at cb0[3].z)
            float _HeightOffset; // 60 (starting at cb0[3].w)
            float _ClampZ; // 64 (starting at cb0[4].x)
            // CBUFFER_START(UnityPerDrawSprite) // 4
                float4 _RendererColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // CBUFFER_START(Props) // 5
                float _PushAmount; // 0 (starting at cb5[0].x)
            // CBUFFER_END
            float _SwayMultiplier; // 4 (starting at cb5[0].y)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.texcoord3.y + v.texcoord3.x;
                tmp0.x = tmp0.x + v.texcoord3.z;
                tmp0.x = tmp0.x * _WorldOffset;
                tmp0.x = _Time.y * _SwaySpeed + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * _SwayAmount;
                tmp0.x = tmp0.x * _SwayMultiplier;
                tmp0.x = tmp0.x * 1.25 + _PushAmount;
                tmp0.y = v.texcoord3.w + _HeightOffset;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = max(v.texcoord3.z, -_ClampZ);
                tmp0.y = min(tmp0.y, _ClampZ);
                tmp0.y = abs(tmp0.y) + 1.0;
                tmp0.x = tmp0.x * tmp0.y + v.vertex.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp0 = v.color * _Color;
                o.color = tmp0 * _RendererColor;
                o.texcoord.xy = v.texcoord.xy;
                return o;
            }
            #endif


            #if CUSTOM_FUNC && ETC1_EXTERNAL_ALPHA && FRAMERATE_SNAPPING // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif CUSTOM_FUNC && FRAMERATE_SNAPPING // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #elif ETC1_EXTERNAL_ALPHA // :DX11PixelSM40
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // CBUFFER_START(UnityPerDrawSprite) // 1
                float _EnableExternalAlpha; // 24 (starting at cb1[1].z)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _AlphaTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_AlphaTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.x - tmp1.w;
                tmp1.w = _EnableExternalAlpha * tmp0.x + tmp1.w;
                tmp0 = tmp1 * inp.color;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // CBUFFER_START(UnityPerFrame) // 0
                // float4 glstate_lightmodel_ambient; // 0 (starting at cb0[0].x)
            // CBUFFER_END
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * inp.color;
                tmp0.xyz = tmp0.xyz * glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                o.sv_target.w = tmp0.w;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
    Fallback "Sprites/Diffuse"
}
