Shader "Sprites/CameraScrollingSpriteTexture" {
    Properties {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _ColorTex ("Color Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _ScrollSpeed ("Scroll Speed", Vector) = (0, 0, 0, 0)
        _Scale ("Scale", Vector) = (1, 1, 0, 0)
    }

    SubShader {
        Tags {
            "QUEUE"="Transparent"
            "RenderType"="Transparent"
        }

        LOD 100

        Pass {
            Name ""
            LOD 100

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off

            Tags {
                "QUEUE"="Transparent"
                "RenderType"="Transparent"
            }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            float4 _ScrollSpeed;
            float4 _Scale;

            sampler2D _MainTex;
            sampler2D _ColorTex;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 position : SV_POSITION;
                float4 color : COLOR;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float4 tmp0;
                float4 tmp1;

                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;

                tmp1.xy = unity_ObjectToWorld._m03_m13 * v.vertex.ww + tmp0.xy;

                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;

                tmp1.xy = tmp1.xy + _WorldSpaceCameraPos.xy;
                tmp1.xy = tmp1.xy * _ScrollSpeed.xy + v.texcoord.xy;

                o.texcoord1.xy = tmp1.xy / _Scale.xy;
                o.texcoord.xy = v.texcoord.xy;

                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;

                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;

                return o;
            }

            struct fout
            {
                float4 sv_target : SV_Target;
            };

            fout frag(v2f inp)
            {
                fout o;

                float4 tmp0;
                float4 tmp1;

                tmp0 = tex2D(_MainTex, inp.texcoord);
                tmp1 = tex2D(_ColorTex, inp.texcoord1);

                tmp0.w = tmp1.w;

                tmp1 = tmp0.xxxw * tmp1;
                tmp0 = tmp0.wwwx * tmp1;

                o.sv_target = tmp0 * inp.color;

                return o;
            }

            ENDCG
        }
    }
}