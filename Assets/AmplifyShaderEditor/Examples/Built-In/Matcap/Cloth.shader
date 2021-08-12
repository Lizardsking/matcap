Shader "PlayFlock/Cloth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_BaseMatcap_Power("BaseMatcap_Power", Float) = 1
		_BaseMatcap("BaseMatcap", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Matcap_R_Power("Matcap_R_Power", Float) = 1
		_Matcap_R("Matcap_R", 2D) = "white" {}
		_Matcap_G_Power("Matcap_G_Power", Float) = 1
		_Matcap_G("Matcap_G", 2D) = "white" {}
		_Matcap_B_Power("Matcap_B_Power", Float) = 1
		_Matcap_B("Matcap_B", 2D) = "white" {}
		[Toggle(_USE_R_MASK_ON)] _Use_R_Mask("Use_R_Mask", Float) = 0
		[Toggle(_USE_G_MASK_ON)] _Use_G_Mask("Use_G_Mask", Float) = 0
		[Toggle(_USE_B_MASK_ON)] _Use_B_Mask("Use_B_Mask", Float) = 0
		_matcapRGBs_Mask("matcapRGBs_Mask", 2D) = "black" {}
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
			#pragma shader_feature_local _USE_B_MASK_ON
			#pragma shader_feature_local _USE_G_MASK_ON
			#pragma shader_feature_local _USE_R_MASK_ON


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
			uniform sampler2D _BaseMatcap;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			uniform float _BaseMatcap_Power;
			uniform sampler2D _Matcap_R;
			uniform float _Matcap_R_Power;
			uniform sampler2D _matcapRGBs_Mask;
			uniform float4 _matcapRGBs_Mask_ST;
			uniform sampler2D _Matcap_G;
			uniform float _Matcap_G_Power;
			uniform sampler2D _Matcap_B;
			uniform float _Matcap_B_Power;

			
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
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
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
				float4 blendOpSrc14 = tex2DNode1;
				float4 blendOpDest14 = lerpResult19;
				float4 temp_output_14_0 = ( saturate( (( blendOpDest14 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest14 ) * ( 1.0 - blendOpSrc14 ) ) : ( 2.0 * blendOpDest14 * blendOpSrc14 ) ) ));
				float4 temp_cast_4 = (0.5).xxxx;
				float4 lerpResult65 = lerp( temp_cast_4 , tex2D( _Matcap_R, matcapUV58.xy ) , _Matcap_R_Power);
				float4 blendOpSrc72 = tex2DNode1;
				float4 blendOpDest72 = lerpResult65;
				float2 uv_matcapRGBs_Mask = i.ase_texcoord1.xy * _matcapRGBs_Mask_ST.xy + _matcapRGBs_Mask_ST.zw;
				float4 tex2DNode78 = tex2D( _matcapRGBs_Mask, uv_matcapRGBs_Mask );
				float4 lerpResult75 = lerp( temp_output_14_0 , ( saturate( (( blendOpDest72 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest72 ) * ( 1.0 - blendOpSrc72 ) ) : ( 2.0 * blendOpDest72 * blendOpSrc72 ) ) )) , tex2DNode78.r);
				#ifdef _USE_R_MASK_ON
				float4 staticSwitch56 = lerpResult75;
				#else
				float4 staticSwitch56 = temp_output_14_0;
				#endif
				float4 temp_cast_6 = (0.5).xxxx;
				float4 lerpResult68 = lerp( temp_cast_6 , tex2D( _Matcap_G, matcapUV58.xy ) , _Matcap_G_Power);
				float4 blendOpSrc73 = tex2DNode1;
				float4 blendOpDest73 = lerpResult68;
				float4 lerpResult76 = lerp( staticSwitch56 , ( saturate( (( blendOpDest73 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest73 ) * ( 1.0 - blendOpSrc73 ) ) : ( 2.0 * blendOpDest73 * blendOpSrc73 ) ) )) , tex2DNode78.g);
				#ifdef _USE_G_MASK_ON
				float4 staticSwitch82 = lerpResult76;
				#else
				float4 staticSwitch82 = staticSwitch56;
				#endif
				float4 temp_cast_8 = (0.5).xxxx;
				float4 lerpResult71 = lerp( temp_cast_8 , tex2D( _Matcap_B, matcapUV58.xy ) , _Matcap_B_Power);
				float4 blendOpSrc74 = tex2DNode1;
				float4 blendOpDest74 = lerpResult71;
				float4 lerpResult77 = lerp( staticSwitch82 , ( saturate( (( blendOpDest74 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest74 ) * ( 1.0 - blendOpSrc74 ) ) : ( 2.0 * blendOpDest74 * blendOpSrc74 ) ) )) , tex2DNode78.b);
				#ifdef _USE_B_MASK_ON
				float4 staticSwitch83 = lerpResult77;
				#else
				float4 staticSwitch83 = staticSwitch82;
				#endif
				
				
				finalColor = staticSwitch83;
				return finalColor;
			}
			ENDCG
		}
	}
}