Shader "PlayFlock/Skin"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_BaseMatcap_Power("BaseMatcap_Power", Float) = 1
		_BaseMatcap("BaseMatcap", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_LEyeTex("LEyeTex", 2D) = "black" {}
		_REyeTex("REyeTex", 2D) = "black" {}
		_LCheekTex("LCheekTex", 2D) = "black" {}
		_RCheekTex("RCheekTex", 2D) = "black" {}
		_LipsTex("LipsTex", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 2.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _LEyeTex;
			uniform float4 _LEyeTex_ST;
			uniform sampler2D _REyeTex;
			uniform float4 _REyeTex_ST;
			uniform sampler2D _LCheekTex;
			uniform float4 _LCheekTex_ST;
			uniform sampler2D _RCheekTex;
			uniform float4 _RCheekTex_ST;
			uniform sampler2D _LipsTex;
			uniform float4 _LipsTex_ST;
			uniform sampler2D _BaseMatcap;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			uniform float _BaseMatcap_Power;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv_LEyeTex = i.ase_texcoord1.xy * _LEyeTex_ST.xy + _LEyeTex_ST.zw;
				float4 tex2DNode84 = tex2D( _LEyeTex, uv_LEyeTex );
				float4 lerpResult88 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2DNode84 , tex2DNode84.a);
				float2 uv_REyeTex = i.ase_texcoord1.xy * _REyeTex_ST.xy + _REyeTex_ST.zw;
				float4 tex2DNode85 = tex2D( _REyeTex, uv_REyeTex );
				float4 lerpResult89 = lerp( lerpResult88 , tex2DNode85 , tex2DNode85.a);
				float2 uv_LCheekTex = i.ase_texcoord1.xy * _LCheekTex_ST.xy + _LCheekTex_ST.zw;
				float4 tex2DNode86 = tex2D( _LCheekTex, uv_LCheekTex );
				float4 lerpResult90 = lerp( lerpResult89 , tex2DNode86 , tex2DNode86.a);
				float2 uv_RCheekTex = i.ase_texcoord1.xy * _RCheekTex_ST.xy + _RCheekTex_ST.zw;
				float4 tex2DNode87 = tex2D( _RCheekTex, uv_RCheekTex );
				float4 lerpResult91 = lerp( lerpResult90 , tex2DNode87 , tex2DNode87.a);
				float2 uv_LipsTex = i.ase_texcoord1.xy * _LipsTex_ST.xy + _LipsTex_ST.zw;
				float4 tex2DNode92 = tex2D( _LipsTex, uv_LipsTex );
				float4 lerpResult93 = lerp( lerpResult91 , tex2DNode92 , tex2DNode92.a);
				float4 temp_cast_0 = (0.5).xxxx;
				float2 uv_NormalMap = i.ase_texcoord1.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				float3 NormalTexture41 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal4 = NormalTexture41;
				float3 worldNormal4 = normalize( float3(dot(tanToWorld0,tanNormal4), dot(tanToWorld1,tanNormal4), dot(tanToWorld2,tanNormal4)) );
				float3 matcapUV58 = ( ( mul( UNITY_MATRIX_V, float4( worldNormal4 , 0.0 ) ).xyz * 0.5 ) + 0.5 );
				float4 lerpResult19 = lerp( temp_cast_0 , tex2D( _BaseMatcap, matcapUV58.xy ) , _BaseMatcap_Power);
				float4 blendOpSrc14 = lerpResult93;
				float4 blendOpDest14 = lerpResult19;
				
				
				finalColor = ( saturate( (( blendOpDest14 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest14 ) * ( 1.0 - blendOpSrc14 ) ) : ( 2.0 * blendOpDest14 * blendOpSrc14 ) ) ));
				return finalColor;
			}
			ENDCG
		}
	}
}