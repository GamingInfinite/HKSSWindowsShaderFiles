Shader "Custom/LavaBase" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Flow Rate", Float) = 1
        _OffsetZ ("Offset Z", Float) = 1
        [Toggle(FLOW_Y)] _EnableFlowY ("Flows along Y axis", Float) = 0
        [Toggle(FLIP_DIR_SCALE)] _FlipDirectionWithScale ("Flip Direction With Scale", Float) = 0
        [Toggle(USE_MASK)] _UseMask ("Use Mask", Float) = 0
        _MaskTex ("Mask Texture", 2D) = "white" {}
        [PerRendererData] _TintColor ("Tint Color", Color) = (1, 1, 1, 1)
        [PerRendererData] _OffsetFlow ("Offset Flow", Float) = 1
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
            Tags {
                "DisableBatching"="true"
                "IGNOREPROJECTOR"="true"
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature FLIP_DIR_SCALE
            #pragma shader_feature FLOW_Y
            #pragma shader_feature INSTANCING_ON
            #pragma shader_feature USE_MASK

            

            #if FLIP_DIR_SCALE && FLOW_Y && INSTANCING_ON && USE_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
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
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.w = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.yw = sqrt(tmp0.yw);
                tmp2.x = tmp0.w > 0.0;
                tmp0.w = tmp0.w * v.texcoord.y;
                tmp0.y = tmp0.w / tmp0.y;
                tmp0.w = floor(-tmp2.x);
                tmp2.x = tmp0.w * _Speed;
                tmp0.z = tmp2.x * _Time.y + tmp0.z;
                tmp0.z = PropsArray._OffsetFlow * tmp0.w + tmp0.z;
                o.color = v.color * PropsArray._TintColor;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = v.texcoord.x;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif FLIP_DIR_SCALE && FLOW_Y && USE_MASK
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
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1.x = unity_ObjectToWorld._m23 * v.vertex.w + tmp0.z;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.x = tmp1.x * _OffsetZ;
                tmp1.y = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp1.y = sqrt(tmp1.y);
                tmp1.z = tmp1.y > 0.0;
                tmp1.y = tmp1.y * v.texcoord.y;
                tmp1.z = floor(-tmp1.z);
                tmp1.w = tmp1.z * _Speed;
                tmp1.x = tmp1.w * _Time.y + tmp1.x;
                tmp1.x = _OffsetFlow * tmp1.z + tmp1.x;
                tmp1.z = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp1.z = sqrt(tmp1.z);
                tmp1.y = tmp1.y / tmp1.z;
                tmp1.y = tmp1.x + tmp1.y;
                tmp1.x = v.texcoord.x;
                o.texcoord.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif FLIP_DIR_SCALE && FLOW_Y && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
			float _OffsetFlow;
			float4 _TintColor;
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.w = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.yw = sqrt(tmp0.yw);
                tmp2.x = tmp0.w > 0.0;
                tmp0.w = tmp0.w * v.texcoord.y;
                tmp0.y = tmp0.w / tmp0.y;
                tmp0.w = floor(-tmp2.x);
                tmp2.x = tmp0.w * _Speed;
                tmp0.z = tmp2.x * _Time.y + tmp0.z;
                tmp0.z = _OffsetFlow * tmp0.w + tmp0.z;
                o.color = v.color * _TintColor;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = v.texcoord.x;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif FLOW_Y && INSTANCING_ON && USE_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
			float _OffsetFlow;
			float4 _TintColor;
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.z = _Speed * _Time.y + tmp0.z;
                tmp0.z = tmp0.z + _OffsetFlow;
                o.color = v.color * _TintColor;
                tmp0.x = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.xy = sqrt(tmp0.xy);
                tmp0.x = tmp0.x * v.texcoord.y;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.y = tmp0.z + tmp0.x;
                tmp0.x = v.texcoord.x;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif FLIP_DIR_SCALE && INSTANCING_ON && USE_MASK
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
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
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.w = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.y = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.yw = sqrt(tmp0.yw);
                tmp2.x = tmp0.w > 0.0;
                tmp0.w = tmp0.w * v.texcoord.x;
                tmp0.y = tmp0.w / tmp0.y;
                tmp0.w = floor(-tmp2.x);
                tmp2.x = tmp0.w * _Speed;
                tmp0.z = tmp2.x * _Time.y + tmp0.z;
                tmp0.z = PropsArray._OffsetFlow * tmp0.w + tmp0.z;
                o.color = v.color * PropsArray._TintColor;
                tmp0.x = tmp0.z + tmp0.y;
                tmp0.y = v.texcoord.y;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif FLIP_DIR_SCALE && FLOW_Y
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1.x = unity_ObjectToWorld._m23 * v.vertex.w + tmp0.z;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.x = tmp1.x * _OffsetZ;
                tmp1.y = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp1.y = sqrt(tmp1.y);
                tmp1.z = tmp1.y > 0.0;
                tmp1.y = tmp1.y * v.texcoord.y;
                tmp1.z = floor(-tmp1.z);
                tmp1.w = tmp1.z * _Speed;
                tmp1.x = tmp1.w * _Time.y + tmp1.x;
                tmp1.x = _OffsetFlow * tmp1.z + tmp1.x;
                tmp1.z = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp1.z = sqrt(tmp1.z);
                tmp1.y = tmp1.y / tmp1.z;
                tmp1.y = tmp1.x + tmp1.y;
                tmp1.x = v.texcoord.x;
                o.texcoord.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif FLOW_Y && USE_MASK
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
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * v.texcoord.y;
                tmp0.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.y = sqrt(tmp0.y);
                tmp0.x = tmp0.x / tmp0.y;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.y = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * _OffsetZ;
                tmp0.y = _Speed * _Time.y + tmp0.y;
                tmp0.y = tmp0.y + _OffsetFlow;
                tmp0.y = tmp0.y + tmp0.x;
                tmp0.x = v.texcoord.x;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif FLIP_DIR_SCALE && USE_MASK
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
            };

            // CBs for DX11VertexSM40
            float4 _MaskTex_ST; // 64 (starting at cb0[4].x)
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1.x = unity_ObjectToWorld._m23 * v.vertex.w + tmp0.z;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.x = tmp1.x * _OffsetZ;
                tmp1.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp1.y = sqrt(tmp1.y);
                tmp1.z = tmp1.y > 0.0;
                tmp1.y = tmp1.y * v.texcoord.x;
                tmp1.z = floor(-tmp1.z);
                tmp1.w = tmp1.z * _Speed;
                tmp1.x = tmp1.w * _Time.y + tmp1.x;
                tmp1.x = _OffsetFlow * tmp1.z + tmp1.x;
                tmp1.z = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp1.z = sqrt(tmp1.z);
                tmp1.y = tmp1.y / tmp1.z;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.y = v.texcoord.y;
                o.texcoord.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord1.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif FLOW_Y && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
			float _OffsetFlow;
			float4 _TintColor;
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.z = _Speed * _Time.y + tmp0.z;
                tmp0.z = tmp0.z + _OffsetFlow;
                o.color = v.color * _TintColor;
                tmp0.x = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.xy = sqrt(tmp0.xy);
                tmp0.x = tmp0.x * v.texcoord.y;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.y = tmp0.z + tmp0.x;
                tmp0.x = v.texcoord.x;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif FLIP_DIR_SCALE && INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
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
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.w = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.y = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.yw = sqrt(tmp0.yw);
                tmp2.x = tmp0.w > 0.0;
                tmp0.w = tmp0.w * v.texcoord.x;
                tmp0.y = tmp0.w / tmp0.y;
                tmp0.w = floor(-tmp2.x);
                tmp2.x = tmp0.w * _Speed;
                tmp0.z = tmp2.x * _Time.y + tmp0.z;
                tmp0.z = PropsArray._OffsetFlow * tmp0.w + tmp0.z;
                o.color = v.color * PropsArray._TintColor;
                tmp0.x = tmp0.z + tmp0.y;
                tmp0.y = v.texcoord.y;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                return o;
            }

            #elif FLOW_Y
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * v.texcoord.y;
                tmp0.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.y = sqrt(tmp0.y);
                tmp0.x = tmp0.x / tmp0.y;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.y = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * _OffsetZ;
                tmp0.y = _Speed * _Time.y + tmp0.y;
                tmp0.y = tmp0.y + _OffsetFlow;
                tmp0.y = tmp0.y + tmp0.x;
                tmp0.x = v.texcoord.x;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif FLIP_DIR_SCALE
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1.x = unity_ObjectToWorld._m23 * v.vertex.w + tmp0.z;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.x = tmp1.x * _OffsetZ;
                tmp1.y = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp1.y = sqrt(tmp1.y);
                tmp1.z = tmp1.y > 0.0;
                tmp1.y = tmp1.y * v.texcoord.x;
                tmp1.z = floor(-tmp1.z);
                tmp1.w = tmp1.z * _Speed;
                tmp1.x = tmp1.w * _Time.y + tmp1.x;
                tmp1.x = _OffsetFlow * tmp1.z + tmp1.x;
                tmp1.z = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp1.z = sqrt(tmp1.z);
                tmp1.y = tmp1.y / tmp1.z;
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.y = v.texcoord.y;
                o.texcoord.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _TintColor;
                return o;
            }

            #elif INSTANCING_ON
            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
                float4 color : COLOR;
                uint sv_instanceid : SV_InstanceID;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(UnityDrawCallInfo) // 3
                int unity_BaseInstanceID; // 0 (starting at cb3[0].x)
            // CBUFFER_END
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.sv_instanceid.x + unity_BaseInstanceID;
                tmp0.y = float1(int1(tmp0.x) << 3);
                tmp0.x = float1(int1(tmp0.x) << 1);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.z = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.z = tmp0.z * _OffsetZ;
                tmp0.z = _Speed * _Time.y + tmp0.z;
                tmp0.z = tmp0.z + PropsArray._OffsetFlow;
                o.color = v.color * PropsArray._TintColor;
                tmp0.x = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.y = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.xy = sqrt(tmp0.xy);
                tmp0.x = tmp0.x * v.texcoord.x;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.y = v.texcoord.y;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
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
                float4 color : COLOR;
            };
            struct v2f
            {
                float2 texcoord : TEXCOORD;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            // CBs for DX11VertexSM40
            float4 _MainTex_ST; // 32 (starting at cb0[2].x)
            float _Speed; // 48 (starting at cb0[3].x)
            float _OffsetZ; // 52 (starting at cb0[3].y)
            // CBUFFER_START(Props) // 4
                float4 _TintColor; // 0 (starting at cb4[0].x)
            // CBUFFER_END
            float _OffsetFlow; // 16 (starting at cb4[1].x)
            // Textures for DX11VertexSM40

            v2f vert(appdata v)
            {
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * v.texcoord.x;
                tmp0.y = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.y = sqrt(tmp0.y);
                tmp0.x = tmp0.x / tmp0.y;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp0.y = unity_ObjectToWorld._m23 * v.vertex.w + tmp1.z;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * _OffsetZ;
                tmp0.y = _Speed * _Time.y + tmp0.y;
                tmp0.y = tmp0.y + _OffsetFlow;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.y = v.texcoord.y;
                o.texcoord.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.color = v.color * _TintColor;
                return o;
            }
            #endif


            #if FLIP_DIR_SCALE && FLOW_Y && INSTANCING_ON && USE_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif FLIP_DIR_SCALE && FLOW_Y && USE_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif FLIP_DIR_SCALE && FLOW_Y && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #elif FLOW_Y && INSTANCING_ON && USE_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif FLIP_DIR_SCALE && INSTANCING_ON && USE_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif FLIP_DIR_SCALE && FLOW_Y
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #elif FLOW_Y && USE_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif FLIP_DIR_SCALE && USE_MASK
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MaskTex; // 1
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MaskTex, inp.texcoord1.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tmp1 * inp.color;
                o.sv_target.w = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp1.xyz;
                return o;
            }

            #elif FLOW_Y && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #elif FLIP_DIR_SCALE && INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #elif FLOW_Y
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #elif FLIP_DIR_SCALE
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #elif INSTANCING_ON
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }

            #else
            struct fout
            {
                float4 sv_target : SV_Target;
            };

            // CBs for DX11PixelSM40
            // Textures for DX11PixelSM40
            sampler2D _MainTex; // 0

            fout frag(v2f inp)
            {
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target = tmp0 * inp.color;
                return o;
            }
            #endif
            ENDCG
            
        }
    }
}
