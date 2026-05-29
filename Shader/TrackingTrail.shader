Shader "Custom/Tracking Trail" {
    Properties {
        [PerRendererData] _TintColor ("Tint Color", Color) = (1, 1, 1, 1)
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _SpeedX ("Flow Rate X", Float) = 1
        _SpeedY ("Flow Rate Y", Float) = 1
        _SecondaryColor ("Secondary Color", Color) = (1, 1, 1, 1)
        _SecondaryTex ("Secondary Texture", 2D) = "white" {}
        _SecondarySpeedX ("Secondary Flow Rate X", Float) = 1
        _SecondarySpeedY ("Secondary Flow Rate Y", Float) = 1
        _PointMaskTex ("Point Mask Texture", 2D) = "white" {}
        _PointLightTex ("Point Light Texture", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "DisableBatching"="true"
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name ""
            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ZClip On
            ZWrite Off
            Cull Off
            Tags {
                "DisableBatching"="true"
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            
            // CBs for d3d11
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float4 _SecondaryTex_ST; // 96 (starting at cb0[6].x)
            float _SecondarySpeedX; // 112 (starting at cb0[7].x)
            float _SecondarySpeedY; // 116 (starting at cb0[7].y)
            float4 _PointMaskTex_ST; // 128 (starting at cb0[8].x)
            float4 _PointLightTex_ST; // 144 (starting at cb0[9].x)
            float2 _HeroWorldPos; // 160 (starting at cb0[10].x)
            float _CutoutsCount; // 168 (starting at cb0[10].z)
            float2 _Cutouts[10]; // 176 (starting at cb0[11].x)
            // CBUFFER_START(Props) // 4
                // float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            // Textures for d3d11
            // Keywords: 
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
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float2 texcoord7 : TEXCOORD7;
                float2 texcoord8 : TEXCOORD8;
                float2 texcoord9 : TEXCOORD9;
                float2 texcoord10 : TEXCOORD10;
                float2 texcoord11 : TEXCOORD11;
                float2 texcoord12 : TEXCOORD12;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.color = v.color * _TintColor;
                tmp0.zw = float2(_SpeedX.x, _SpeedY.x) * _Time.yy + v.texcoord.xy;
                o.texcoord.xy = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.zw = float2(_SecondarySpeedX.x, _SecondarySpeedY.x) * _Time.yy + v.texcoord.xy;
                o.texcoord1.xy = tmp0.zw * _SecondaryTex_ST.xy + _SecondaryTex_ST.zw;
                tmp0.zw = float2(0.5, 0.5) / _PointMaskTex_ST.xy;
                tmp0.zw = tmp0.zw - _PointMaskTex_ST.zw;
                tmp1.x = min(_CutoutsCount, 10);
                tmp0.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;
                tmp1.y = 0.0;
                for (int i = tmp1.y; i < tmp1.x; i += 1) {
                    tmp1.zw = tmp0.xy - _Cutouts[i];
                    tmp1.zw = tmp0.zw + tmp1.zw;
                    tmp1.zw = tmp1.zw * _PointMaskTex_ST.xy;
                    cb0[0].xy = tmp1.zw;
                }
                o.texcoord3.xy = cb0[0].xy;
                o.texcoord4.xy = cb0[1].xy;
                o.texcoord5.xy = cb0[2].xy;
                o.texcoord6.xy = _MainTex_ST.xy;
                o.texcoord7.xy = float2(_SpeedX.x, _SpeedY.x);
                o.texcoord8.xy = cb0[5].xy;
                o.texcoord9.xy = _SecondaryTex_ST.xy;
                o.texcoord10.xy = float2(_SecondarySpeedX.x, _SecondarySpeedY.x);
                o.texcoord11.xy = _PointMaskTex_ST.xy;
                o.texcoord12.xy = _PointLightTex_ST.xy;
                tmp0.xy = tmp0.xy - _HeroWorldPos;
                tmp0.zw = float2(0.5, 0.5) / _PointLightTex_ST.xy;
                tmp0.xy = tmp0.zw + tmp0.xy;
                tmp0.xy = tmp0.xy - _PointLightTex_ST.zw;
                o.texcoord2.xy = tmp0.xy * _PointLightTex_ST.xy;
                return o;
            }
            
            // CBs for d3d11
            float4 _Color; // 32 (starting at cb0[2].x)
            float4 _SecondaryColor; // 80 (starting at cb0[5].x)
            float _CutoutsCount; // 168 (starting at cb0[10].z)
            float _HeroPlayMode; // 328 (starting at cb0[20].z)
            // Textures for d3d11
            sampler2D _MainTex; // 0
            sampler2D _SecondaryTex; // 1
            sampler2D _PointMaskTex; // 2
            sampler2D _PointLightTex; // 3
            // Keywords: 
            struct fout
            {
                float4 sv_target : SV_Target;
            };
            
            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * _Color;
                tmp1 = tex2D(_SecondaryTex, inp.texcoord1.xy);
                tmp1 = tmp1 * _SecondaryColor;
                tmp1 = tmp1 * inp.color;
                tmp0 = tmp0.wxyz * inp.color.wxyz + tmp1.wxyz;
                tmp1.xy = float2(1.0, 0.0);
                for (int i = tmp1.y; i < _CutoutsCount; i += 1) {
                    tmp2 = tex2D(_PointMaskTex, inp.texcoord.xy);
                    tmp1.x = min(tmp1.x, tmp2.x);
                }
                tmp0.x = tmp0.x * tmp1.x;
                tmp1.x = _HeroPlayMode != 0.0;
                if (tmp1.x) {
                    tmp1 = tex2D(_PointLightTex, inp.texcoord2.xy);
                    tmp0.x = tmp0.x * tmp1.x;
                }
                o.sv_target = tmp0.yzwx;
                return o;
            }
            
        }
    }
}

Custom/Tracking Trail decompiled
