Shader "Custom/Tiled Scrolling Fog" {
    Properties {
        [PerRendererData] _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        [PerRendererData] _SpeedX ("Flow Rate X", Float) = 1
        [PerRendererData] _SpeedY ("Flow Rate Y", Float) = 1
        _WorldOffsetX ("World Offset X Amount", Float) = 0
        _WorldOffsetY ("World Offset Y Amount", Float) = 0
        _WorldOffsetZ ("World Offset Z Amount", Float) = 0
        [PerRendererData] _FogRotation ("Fog Rotation", Float) = 1
        [Toggle(USE_HERO_MASK)] _UseHeroMask ("Use Screen Space Hero Mask", Float) = 0
        _HeroMaskTex ("Mask Texture", 2D) = "white" {}
        [Toggle(USE_OBJ_MASK)] _UseObjMask ("Use Object UV Mask", Float) = 0
        _ObjMaskTex ("Mask Texture", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "DisableBatching"="true"
            "IGNOREPROJECTOR"="true"
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
        Pass {
            Name ""
            LOD 100
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
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature INSTANCING_ON
            #pragma shader_feature USE_HERO_MASK
            #pragma shader_feature USE_OBJ_MASK
            

            #if INSTANCING_ON && USE_HERO_MASK && USE_OBJ_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 136 (starting at cb0[8].z)
            float2 _HeroWorldPos; // 128 (starting at cb0[8].x)
            float4 _ObjMaskTex_ST; // 112 (starting at cb0[7].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
            int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.yz = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.yz = tmp0.yz + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.xy;
                tmp0.yz = floor(tmp0.yz);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2.xy = tmp0.yz * tmp2.xy;
                tmp0.yz = tmp0.yz > float2(0.0, 0.0);
                tmp3.x = sin(_FogRotation);
                tmp4.x = cos(_FogRotation);
                tmp5.z = tmp3.x;
                tmp5.y = tmp4.x;
                tmp5.x = -tmp3.x;
                tmp0.w = dot(tmp2.xy, tmp5.xy);
                tmp2.x = dot(tmp2.xy, tmp5.yz);
                tmp2.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.x = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp2.y;
                tmp0.x = tmp0.x + _Time.y;
                tmp2.x = _SpeedX * tmp0.x + tmp2.x;
                tmp2.y = _SpeedY * tmp0.x + tmp0.w;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp2.xz = float2(0.5, 0.5);
                tmp2.y = _ProjectionParams.x;
                tmp3.xyz = tmp1.xyw * tmp2.xyz;
                tmp3.w = tmp3.y * 0.5;
                tmp0.xw = tmp3.zz + tmp3.xw;
                tmp0.xw = tmp0.xw / tmp1.ww;
                o.position = tmp1;
                tmp1.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp1.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp1.xyz;
                tmp1.xyz = tmp1.xyz + unity_MatrixVP._m03_m13_m33;
                tmp2.xyz = tmp2.xyz * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp1.xy = tmp2.zz + tmp2.xw;
                tmp1.xy = tmp1.xy / tmp1.zz;
                tmp1.xy = tmp1.xy - float2(0.5, 0.5);
                o.texcoord1.xy = tmp0.xw - tmp1.xy;
                tmp0.xw = float2(1.0, 1.0) - v.texcoord.xy;
                tmp0.xy = tmp0.yz ? tmp0.xw : v.texcoord.xy;
                o.texcoord2.xy = tmp0.xy * _ObjMaskTex_ST.xy + _ObjMaskTex_ST.zw;
                return o;
            }

            #elif USE_HERO_MASK && USE_OBJ_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 136 (starting at cb0[8].z)
            float2 _HeroWorldPos; // 128 (starting at cb0[8].x)
            float4 _ObjMaskTex_ST; // 112 (starting at cb0[7].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp0.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp0.xy = tmp2.zz + tmp2.xw;
                tmp0.xy = tmp0.xy / tmp0.zz;
                tmp0.xy = tmp0.xy - float2(0.5, 0.5);
                tmp2 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp2;
                tmp3 = tmp2 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.zw = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp2.xy;
                tmp2 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp2;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp2;
                tmp1.xyz = tmp1.xyz * tmp2.xyw;
                tmp1.w = tmp1.y * 0.5;
                tmp1.xy = tmp1.zz + tmp1.xw;
                tmp1.xy = tmp1.xy / tmp2.ww;
                o.position = tmp2;
                o.texcoord1.xy = tmp1.xy - tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.xy = tmp0.xy + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.xy > float2(0.0, 0.0);
                tmp0.xy = tmp0.xy < float2(0.0, 0.0);
                tmp0.xy = tmp0.xy - tmp1.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.zw = tmp0.xy * tmp0.zw;
                tmp0.xy = tmp0.xy > float2(0.0, 0.0);
                tmp1.x = sin(_FogRotation);
                tmp2.x = cos(_FogRotation);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp1.x = dot(tmp0.zw, tmp3.xy);
                tmp0.z = dot(tmp0.zw, tmp3.yz);
                tmp0.w = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.w = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.w;
                tmp0.w = tmp0.w + _Time.y;
                tmp2.x = _SpeedX * tmp0.w + tmp0.z;
                tmp2.y = _SpeedY * tmp0.w + tmp1.x;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.zw = float2(1.0, 1.0) - v.texcoord.xy;
                tmp0.xy = tmp0.xy ? tmp0.zw : v.texcoord.xy;
                o.texcoord2.xy = tmp0.xy * _ObjMaskTex_ST.xy + _ObjMaskTex_ST.zw;
                return o;
            }

            #elif INSTANCING_ON && USE_HERO_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 120 (starting at cb0[7].z)
            float2 _HeroWorldPos; // 112 (starting at cb0[7].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                // int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.yz = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.yz = tmp0.yz + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.xy;
                tmp0.yz = floor(tmp0.yz);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.yz = tmp0.yz * tmp2.xy;
                tmp2.x = sin(_FogRotation);
                tmp3.x = cos(_FogRotation);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp0.w = dot(tmp0.yz, tmp4.xy);
                tmp0.y = dot(tmp0.yz, tmp4.yz);
                tmp0.z = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.x = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.x = tmp0.x + _Time.y;
                tmp2.x = _SpeedX * tmp0.x + tmp0.y;
                tmp2.y = _SpeedY * tmp0.x + tmp0.w;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                o.position = tmp0;
                tmp0.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp0.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp0.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp0.xy = tmp1.zz + tmp1.xw;
                tmp0.xy = tmp0.xy / tmp0.zz;
                tmp0.xy = tmp0.xy - float2(0.5, 0.5);
                o.texcoord1.xy = tmp2.xy - tmp0.xy;
                return o;
            }

            #elif INSTANCING_ON && USE_OBJ_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord2 : TEXCOORD2;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 120 (starting at cb0[7].z)
            float4 _ObjMaskTex_ST; // 96 (starting at cb0[6].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.yz = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.yz = tmp0.yz + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.xy;
                tmp0.yz = floor(tmp0.yz);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2.xy = tmp0.yz * tmp2.xy;
                tmp0.yz = tmp0.yz > float2(0.0, 0.0);
                tmp3.x = sin(_FogRotation);
                tmp4.x = cos(_FogRotation);
                tmp5.z = tmp3.x;
                tmp5.y = tmp4.x;
                tmp5.x = -tmp3.x;
                tmp0.w = dot(tmp2.xy, tmp5.xy);
                tmp2.x = dot(tmp2.xy, tmp5.yz);
                tmp2.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.x = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp2.y;
                tmp0.x = tmp0.x + _Time.y;
                tmp2.x = _SpeedX * tmp0.x + tmp2.x;
                tmp2.y = _SpeedY * tmp0.x + tmp0.w;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.xw = float2(1.0, 1.0) - v.texcoord.xy;
                tmp0.xy = tmp0.yz ? tmp0.xw : v.texcoord.xy;
                o.texcoord2.xy = tmp0.xy * _ObjMaskTex_ST.xy + _ObjMaskTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif USE_HERO_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 120 (starting at cb0[7].z)
            float2 _HeroWorldPos; // 112 (starting at cb0[7].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.xy = tmp0.xy + unity_ObjectToWorld._m02_m12;
                tmp0.zw = tmp0.xy > float2(0.0, 0.0);
                tmp0.xy = tmp0.xy < float2(0.0, 0.0);
                tmp0.xy = tmp0.xy - tmp0.zw;
                tmp0.xy = floor(tmp0.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.zw = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = tmp0.xy * tmp0.zw;
                tmp2.x = sin(_FogRotation);
                tmp3.x = cos(_FogRotation);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp0.z = dot(tmp0.xy, tmp4.xy);
                tmp0.x = dot(tmp0.xy, tmp4.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp2.x = _SpeedX * tmp0.y + tmp0.x;
                tmp2.y = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp2.xyz = tmp0.xyw * tmp1.xyz;
                tmp2.w = tmp2.y * 0.5;
                tmp2.xy = tmp2.zz + tmp2.xw;
                tmp2.xy = tmp2.xy / tmp0.ww;
                o.position = tmp0;
                tmp0.xyz = _HeroWorldPos.yyy * unity_MatrixVP._m01_m11_m31;
                tmp0.xyz = unity_MatrixVP._m00_m10_m30 * _HeroWorldPos.xxx + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + unity_MatrixVP._m03_m13_m33;
                tmp1.xyz = tmp1.xyz * tmp0.xyz;
                tmp1.w = tmp1.y * 0.5;
                tmp0.xy = tmp1.zz + tmp1.xw;
                tmp0.xy = tmp0.xy / tmp0.zz;
                tmp0.xy = tmp0.xy - float2(0.5, 0.5);
                o.texcoord1.xy = tmp2.xy - tmp0.xy;
                return o;
            }

            #elif USE_OBJ_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord2 : TEXCOORD2;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 120 (starting at cb0[7].z)
            float4 _ObjMaskTex_ST; // 96 (starting at cb0[6].x)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.xy = tmp0.xy + unity_ObjectToWorld._m02_m12;
                tmp0.zw = tmp0.xy > float2(0.0, 0.0);
                tmp0.xy = tmp0.xy < float2(0.0, 0.0);
                tmp0.xy = tmp0.xy - tmp0.zw;
                tmp0.xy = floor(tmp0.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.zw = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.zw = tmp0.xy * tmp0.zw;
                tmp0.xy = tmp0.xy > float2(0.0, 0.0);
                tmp2.x = sin(_FogRotation);
                tmp3.x = cos(_FogRotation);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp2.x = dot(tmp0.zw, tmp4.xy);
                tmp0.z = dot(tmp0.zw, tmp4.yz);
                tmp0.w = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.w = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.w;
                tmp0.w = tmp0.w + _Time.y;
                tmp3.x = _SpeedX * tmp0.w + tmp0.z;
                tmp3.y = _SpeedY * tmp0.w + tmp2.x;
                o.texcoord.xy = tmp3.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0.zw = float2(1.0, 1.0) - v.texcoord.xy;
                tmp0.xy = tmp0.xy ? tmp0.zw : v.texcoord.xy;
                o.texcoord2.xy = tmp0.xy * _ObjMaskTex_ST.xy + _ObjMaskTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
            };

            // CBs for DX11VertexSM40
            float _FogRotation; // 92 (starting at cb0[5].w)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.x = float1(int1(tmp0.x) << 3);
                tmp0.yz = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.yz = tmp0.yz + unity_ObjectToWorld._m02_m12;
                tmp1.xy = tmp0.yz > float2(0.0, 0.0);
                tmp0.yz = tmp0.yz < float2(0.0, 0.0);
                tmp0.yz = tmp0.yz - tmp1.xy;
                tmp0.yz = floor(tmp0.yz);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.yz = tmp0.yz * tmp2.xy;
                tmp2.x = sin(_FogRotation);
                tmp3.x = cos(_FogRotation);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp0.w = dot(tmp0.yz, tmp4.xy);
                tmp0.y = dot(tmp0.yz, tmp4.yz);
                tmp0.z = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.x = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.z;
                tmp0.x = tmp0.x + _Time.y;
                tmp2.x = _SpeedX * tmp0.x + tmp0.y;
                tmp2.y = _SpeedY * tmp0.x + tmp0.w;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #else
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
            float _FogRotation; // 92 (starting at cb0[5].w)
            float4 _MainTex_ST; // 48 (starting at cb0[3].x)
            float _SpeedX; // 64 (starting at cb0[4].x)
            float _SpeedY; // 68 (starting at cb0[4].y)
            float _WorldOffsetY; // 72 (starting at cb0[4].z)
            float _WorldOffsetX; // 76 (starting at cb0[4].w)
            float _WorldOffsetZ; // 80 (starting at cb0[5].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = unity_ObjectToWorld._m00_m10 + unity_ObjectToWorld._m01_m11;
                tmp0.xy = tmp0.xy + unity_ObjectToWorld._m02_m12;
                tmp0.zw = tmp0.xy > float2(0.0, 0.0);
                tmp0.xy = tmp0.xy < float2(0.0, 0.0);
                tmp0.xy = tmp0.xy - tmp0.zw;
                tmp0.xy = floor(tmp0.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.zw = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp1.xy;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xy = tmp0.xy * tmp0.zw;
                tmp2.x = sin(_FogRotation);
                tmp3.x = cos(_FogRotation);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp0.z = dot(tmp0.xy, tmp4.xy);
                tmp0.x = dot(tmp0.xy, tmp4.yz);
                tmp0.y = dot(unity_ObjectToWorld._m13_m03, float2(_WorldOffsetY.x, _WorldOffsetX.x));
                tmp0.y = unity_ObjectToWorld._m23 * _WorldOffsetZ + tmp0.y;
                tmp0.y = tmp0.y + _Time.y;
                tmp2.x = _SpeedX * tmp0.y + tmp0.x;
                tmp2.y = _SpeedY * tmp0.y + tmp0.z;
                o.texcoord.xy = tmp2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }
            #endif


            #if INSTANCING_ON && USE_HERO_MASK && USE_OBJ_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _ObjMaskTex; // 2
            sampler2D _HeroMaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_HeroMaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _Color;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                tmp1 = tex2D(_ObjMaskTex, inp.texcoord2.xy);
                o.sv_target.w = tmp0.x * tmp1.x;
                return o;
            }

            #elif USE_HERO_MASK && USE_OBJ_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _ObjMaskTex; // 2
            sampler2D _HeroMaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_HeroMaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _Color;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                tmp1 = tex2D(_ObjMaskTex, inp.texcoord2.xy);
                o.sv_target.w = tmp0.x * tmp1.x;
                return o;
            }

            #elif INSTANCING_ON && USE_HERO_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_HeroMaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _Color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif INSTANCING_ON && USE_OBJ_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _ObjMaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ObjMaskTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _Color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif USE_HERO_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _HeroMaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_HeroMaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _Color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif USE_OBJ_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _ObjMaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_ObjMaskTex, inp.texcoord2.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * _Color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * _Color;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            float4 _Color; // 32 (starting at cb0[2].x)
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * _Color;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
