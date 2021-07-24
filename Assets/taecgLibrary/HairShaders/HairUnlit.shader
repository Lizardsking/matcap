//by taecg@qq.com
//created 2018/01/20	
//updated 2018/12/16
//头发，不受光照影响

Shader "taecg/Hair/Hair Unlit" 
{
	Properties 
	{
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 0
        _Color ("Color", Color) = (1,1,1,1)
        _Emiss ("Emiss", Range(0, 2)) = 1
        _MainTex ("MainTex ( RGB, A = Cutoff )", 2D) = "white" {}
        _Cutoff ("Cutoff", Range(0, 1)) = 0.5
    }

    SubShader 
	{
		Tags 
		{
            // "Queue"="AlphaTest"
            "Queue"="Transparent"
            "RenderType"="TransparentCutout"
        }
         
        //AlphaTest
        Pass 
        {
            Tags 
            {
                "LightMode"="ForwardBase"
            }
            Cull [_Cull]
                
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fog
            #pragma target 2.0

            uniform fixed4 _Color;
            uniform sampler2D _MainTex; uniform half4 _MainTex_ST;
            uniform fixed _Cutoff;
            uniform fixed _Emiss;

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };

            v2f vert (appdata_base v) 
            {
                v2f o = (v2f)0;
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                o.pos = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET 
            {
                float4 _MainTex_var = tex2D(_MainTex,i.uv);
                clip(_MainTex_var.a - _Cutoff);
                float3 mainColor = _MainTex_var.rgb * _Color.rgb;
                float3 emissColor = mainColor * _Emiss;
                // fixed4 col = fixed4(mainColor + emissColor,1);
                fixed4 col = fixed4(emissColor,1);

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }


        //Transparent
        Pass 
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull [_Cull]
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fog
            #pragma target 2.0

            fixed4 _Color;
            sampler2D _MainTex; float4 _MainTex_ST;
            fixed _Emiss;

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };

            v2f vert (appdata_base v) 
            {
                v2f o = (v2f)0;
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                v.vertex.xyz += (0.00001*v.normal);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_TARGET 
            {
                float4 _MainTex_var = tex2D(_MainTex,i.uv);
                float3 mainColor = _MainTex_var.rgb * _Color.rgb;
                float3 emissColor = mainColor * _Emiss;
                // fixed4 col = fixed4(mainColor + emissColor,_MainTex_var.a);
                fixed4 col = fixed4(emissColor,_MainTex_var.a);

                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }

        Pass 
        {
            Name "Caster"
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing // allow instanced shadow pass for most of the shaders
            #include "UnityCG.cginc"

            struct v2f 
            {
                V2F_SHADOW_CASTER;
                float2  uv : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            uniform float4 _MainTex_ST;

            v2f vert( appdata_base v )
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            sampler2D _MainTex;
            fixed _Cutoff;
            fixed4 _Color;

            float4 frag( v2f i ) : SV_Target
            {
                fixed4 texcol = tex2D( _MainTex, i.uv );
                clip( texcol.a * _Color.a - _Cutoff );

                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }

    FallBack "Legacy Shaders/Transparent/Cutout/Soft Edge Unlit"
}
