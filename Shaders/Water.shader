// Custom/Water It... might be less accurate now but it looks right?

Shader "Custom/Water"
{
    Properties
    {
        _MainTex ("Tint Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _BumpAmt ("Distortion", Range(0, 128)) = 10
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _SpeedX ("Speed X", Float) = 1
        _SpeedY ("Speed Y", Float) = 1
        _Reflection ("Reflection Intensity", Range(0, 1)) = 1
        [Toggle(ENABLE_REFLECTION)] _EnableReflection ("Enable Screen Reflection", Float) = 0
        _ReflectionOffset ("Reflection Offset", Float) = 0
        _MaskTex ("Mask", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

        GrabPass { "_WaterGrab" }

        Pass
        {
            Name "BASE"
            Tags { "LightMode" = "Always" }

            Blend Off
            ColorMask RGB
            ZWrite Off
            ZTest LEqual
            Fog { Mode Off }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature_local ENABLE_REFLECTION
            #include "UnityCG.cginc"

            sampler2D _WaterGrab;
            float4 _WaterGrab_TexelSize;

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            sampler2D _MaskTex;

            fixed4 _Color;
            float _BumpAmt;
            float _SpeedX;
            float _SpeedY;
            float _Reflection;
            float _ReflectionOffset;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 grabPos : TEXCOORD0;
                float2 mainUV : TEXCOORD1;
                float2 bumpUV : TEXCOORD2;
                float2 uv : TEXCOORD3;
                float mirrorY : TEXCOORD4;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos);

                float3 worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0)).xyz;
                o.bumpUV = worldPos.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                o.mainUV = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;

                float3 pivot = float3(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13, unity_ObjectToWorld._m23);
                float4 mirrorGrab = ComputeGrabScreenPos(UnityWorldToClipPos(pivot + float3(0, _ReflectionOffset, 0)));
                o.mirrorY = mirrorGrab.y / mirrorGrab.w;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 scroll = float2(_SpeedX, _SpeedY) * _Time.y;
                fixed4 n = tex2D(_BumpMap, i.bumpUV + scroll);
                float2 nxy = float2(n.a * n.r, n.g) * 2.0 - 1.0;

                float2 offset = nxy * _BumpAmt * _WaterGrab_TexelSize.xy;
                float2 screenUV = i.grabPos.xy / i.grabPos.w;
                float2 distUV = saturate((i.grabPos.xy + offset * i.grabPos.z) / i.grabPos.w);

                fixed4 scene = tex2D(_WaterGrab, saturate(screenUV));
                fixed4 water = tex2D(_WaterGrab, distUV) * tex2D(_MainTex, i.mainUV) * _Color;

                #if defined(ENABLE_REFLECTION)
                    float2 reflUV = float2(distUV.x, 2.0 * i.mirrorY - distUV.y);
                    fixed4 refl = tex2D(_WaterGrab, saturate(reflUV)) * _Color;
                    water.rgb = lerp(water.rgb, refl.rgb, _Reflection * 0.5);
                #else
                    float grad = (i.uv.y - offset.y) * _Reflection;
                    water.rgb += grad;
                #endif

                float mask = tex2D(_MaskTex, i.mainUV).r;
                fixed4 col;
                col.rgb = max(0, lerp(scene.rgb, water.rgb, mask));
                col.a = 1;
                return col;
            }
            ENDCG
        }
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }

        Pass
        {
            Name "BASE"
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Fog { Mode Off }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _MaskTex;
            fixed4 _Color;

            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv) * _Color;
                c.a *= tex2D(_MaskTex, i.uv).r;
                return c;
            }
            ENDCG
        }
    }
}
