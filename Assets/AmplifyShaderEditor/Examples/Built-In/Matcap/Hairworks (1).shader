// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hairworks"
{
	Properties
	{
		_LIghtDirection("LIghtDirection", Vector) = (1,-0.5,0,0)
		_ShiftTexture("ShiftTexture", 2D) = "white" {}
		_Highlight_1_Shift("Highlight_1_Shift", Float) = 0.1
		_Highlight_2_Shift("Highlight_2_Shift", Float) = 0.05
		_Highlight_1_Power("Highlight_1_Power", Float) = 1000
		_GeneralShift("GeneralShift", Float) = 0.8
		_Highlight_2_Power("Highlight_2_Power", Float) = 1000
		_Highlight_1_Strength("Highlight_1_Strength", Float) = 1
		_Highlight_2_Strength("Highlight_2_Strength", Float) = 1
		_Highlight_1_Color("Highlight_1_Color", Color) = (1,1,1,1)
		_Highlight_2_Color("Highlight_2_Color", Color) = (1,1,1,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Hair_Color("Hair_Color", Color) = (1,1,1,0)
		_Hair_normal("Hair_normal", 2D) = "bump" {}
		_JitterStrength("JitterStrength", Float) = 0
		_Jitter_Balance("Jitter_Balance", Float) = 0.5
		_Desaturate_TextureColor("Desaturate_TextureColor", Float) = 0
		_Texture_Strength("Texture_Strength", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		 _Cutoff ("Cutoff", Range(0, 1)) = 0.5

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="TransparentCutout" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 2.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
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

			uniform sampler2D _Hair_normal;
			uniform float4 _Hair_normal_ST;
			uniform float _Highlight_1_Shift;
			uniform sampler2D _ShiftTexture;
			uniform float4 _ShiftTexture_ST;
			uniform float _Jitter_Balance;
			uniform float _JitterStrength;
			uniform float _GeneralShift;
			uniform float3 _LIghtDirection;
			uniform float _Highlight_1_Power;
			uniform float _Highlight_1_Strength;
			uniform float4 _Highlight_1_Color;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float _Desaturate_TextureColor;
			uniform float _Texture_Strength;
			uniform float4 _Hair_Color;
			uniform float _Highlight_2_Shift;
			uniform float _Highlight_2_Power;
			uniform float _Highlight_2_Strength;
			uniform float4 _Highlight_2_Color;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.zw = 0;
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
				float3 ase_worldTangent = i.ase_texcoord1.xyz;
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 ase_worldBitangent = i.ase_texcoord3.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float2 uv_Hair_normal = i.ase_texcoord4.xy * _Hair_normal_ST.xy + _Hair_normal_ST.zw;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal92 = UnpackNormal( tex2D( _Hair_normal, uv_Hair_normal ) );
				float3 worldNormal92 = float3(dot(tanToWorld0,tanNormal92), dot(tanToWorld1,tanNormal92), dot(tanToWorld2,tanNormal92));
				float3 normalizeResult13 = normalize( mul( ase_worldToTangent, worldNormal92 ) );
				float3 normalizeResult17 = normalize( cross( normalizeResult13 , float3(1,0,0) ) );
				float2 uv_ShiftTexture = i.ase_texcoord4.xy * _ShiftTexture_ST.xy + _ShiftTexture_ST.zw;
				float4 tex2DNode32 = tex2D( _ShiftTexture, uv_ShiftTexture );
				float temp_output_35_0 = ( ( ( tex2DNode32.b - _Jitter_Balance ) * _JitterStrength ) - _GeneralShift );
				float3 normalizeResult6_g16 = normalize( ( normalizeResult17 + ( ( _Highlight_1_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
				float3 temp_output_1_0_g28 = normalizeResult6_g16;
				float3 normalizeResult5 = normalize( ( _LIghtDirection * -1.0 ) );
				float3 LightDirection47 = normalizeResult5;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 worldSpaceViewDir81 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
				float3 ViewVector49 = mul( ase_worldToTangent, ( ase_worldViewDir - ( worldSpaceViewDir81 * -1.0 ) ) );
				float3 normalizeResult11_g28 = normalize( ( LightDirection47 + ViewVector49 ) );
				float dotResult13_g28 = dot( temp_output_1_0_g28 , normalizeResult11_g28 );
				float smoothstepResult7_g28 = smoothstep( -1.0 , 0.0 , dotResult13_g28);
				float dotResult18_g28 = dot( temp_output_1_0_g28 , normalizeResult11_g28 );
				float3 temp_cast_0 = (1.0).xxx;
				float2 uv_TextureSample0 = i.ase_texcoord4.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode68 = tex2D( _TextureSample0, uv_TextureSample0 );
				float3 desaturateInitialColor141 = tex2DNode68.rgb;
				float desaturateDot141 = dot( desaturateInitialColor141, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar141 = lerp( desaturateInitialColor141, desaturateDot141.xxx, _Desaturate_TextureColor );
				float3 lerpResult147 = lerp( temp_cast_0 , desaturateVar141 , _Texture_Strength);
				float4 temp_output_76_0 = ( float4( lerpResult147 , 0.0 ) * _Hair_Color );
				float3 normalizeResult6_g29 = normalize( ( normalizeResult17 + ( ( _Highlight_2_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
				float3 temp_output_1_0_g30 = normalizeResult6_g29;
				float3 normalizeResult11_g30 = normalize( ( LightDirection47 + ViewVector49 ) );
				float dotResult13_g30 = dot( temp_output_1_0_g30 , normalizeResult11_g30 );
				float smoothstepResult7_g30 = smoothstep( -1.0 , 0.0 , dotResult13_g30);
				float dotResult18_g30 = dot( temp_output_1_0_g30 , normalizeResult11_g30 );
				float temp_output_151_0 = ( smoothstepResult7_g30 * ( pow( sqrt( ( 1.0 - ( dotResult18_g30 * dotResult18_g30 ) ) ) , _Highlight_2_Power ) * _Highlight_2_Strength ) );
				float4 appendResult168 = (float4(( ( ( ( smoothstepResult7_g28 * ( pow( sqrt( ( 1.0 - ( dotResult18_g28 * dotResult18_g28 ) ) ) , _Highlight_1_Power ) * _Highlight_1_Strength ) ) * _Highlight_1_Color ) + temp_output_76_0 ) + ( temp_output_151_0 * _Highlight_2_Color ) ).rgb , tex2DNode68.a));
				
				
				finalColor = appendResult168;
				return finalColor;
			}
			ENDCG
		}
		
		//AlphaTest
        Pass 
        {
            Tags 
            {
                "LightMode"="ForwardBase"
            }
            Cull Off
                
            CGPROGRAM
         
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
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

			uniform sampler2D _Hair_normal;
			uniform float4 _Hair_normal_ST;
			uniform float _Highlight_1_Shift;
			uniform sampler2D _ShiftTexture;
			uniform float4 _ShiftTexture_ST;
			uniform float _Jitter_Balance;
			uniform float _JitterStrength;
			uniform float _GeneralShift;
			uniform float3 _LIghtDirection;
			uniform float _Highlight_1_Power;
			uniform float _Highlight_1_Strength;
			uniform float4 _Highlight_1_Color;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float _Desaturate_TextureColor;
			uniform float _Texture_Strength;
			uniform float4 _Hair_Color;
			uniform float _Highlight_2_Shift;
			uniform float _Highlight_2_Power;
			uniform float _Highlight_2_Strength;
			uniform float4 _Highlight_2_Color;
            fixed _Cutoff;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.zw = 0;
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
				float3 ase_worldTangent = i.ase_texcoord1.xyz;
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 ase_worldBitangent = i.ase_texcoord3.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float2 uv_Hair_normal = i.ase_texcoord4.xy * _Hair_normal_ST.xy + _Hair_normal_ST.zw;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal92 = UnpackNormal( tex2D( _Hair_normal, uv_Hair_normal ) );
				float3 worldNormal92 = float3(dot(tanToWorld0,tanNormal92), dot(tanToWorld1,tanNormal92), dot(tanToWorld2,tanNormal92));
				float3 normalizeResult13 = normalize( mul( ase_worldToTangent, worldNormal92 ) );
				float3 normalizeResult17 = normalize( cross( normalizeResult13 , float3(1,0,0) ) );
				float2 uv_ShiftTexture = i.ase_texcoord4.xy * _ShiftTexture_ST.xy + _ShiftTexture_ST.zw;
				float4 tex2DNode32 = tex2D( _ShiftTexture, uv_ShiftTexture );
				float temp_output_35_0 = ( ( ( tex2DNode32.b - _Jitter_Balance ) * _JitterStrength ) - _GeneralShift );
				float3 normalizeResult6_g16 = normalize( ( normalizeResult17 + ( ( _Highlight_1_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
				float3 temp_output_1_0_g28 = normalizeResult6_g16;
				float3 normalizeResult5 = normalize( ( _LIghtDirection * -1.0 ) );
				float3 LightDirection47 = normalizeResult5;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 worldSpaceViewDir81 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
				float3 ViewVector49 = mul( ase_worldToTangent, ( ase_worldViewDir - ( worldSpaceViewDir81 * -1.0 ) ) );
				float3 normalizeResult11_g28 = normalize( ( LightDirection47 + ViewVector49 ) );
				float dotResult13_g28 = dot( temp_output_1_0_g28 , normalizeResult11_g28 );
				float smoothstepResult7_g28 = smoothstep( -1.0 , 0.0 , dotResult13_g28);
				float dotResult18_g28 = dot( temp_output_1_0_g28 , normalizeResult11_g28 );
				float3 temp_cast_0 = (1.0).xxx;
				float2 uv_TextureSample0 = i.ase_texcoord4.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode68 = tex2D( _TextureSample0, uv_TextureSample0 );
				float3 desaturateInitialColor141 = tex2DNode68.rgb;
				float desaturateDot141 = dot( desaturateInitialColor141, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar141 = lerp( desaturateInitialColor141, desaturateDot141.xxx, _Desaturate_TextureColor );
				float3 lerpResult147 = lerp( temp_cast_0 , desaturateVar141 , _Texture_Strength);
				float4 temp_output_76_0 = ( float4( lerpResult147 , 0.0 ) * _Hair_Color );
				float3 normalizeResult6_g29 = normalize( ( normalizeResult17 + ( ( _Highlight_2_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
				float3 temp_output_1_0_g30 = normalizeResult6_g29;
				float3 normalizeResult11_g30 = normalize( ( LightDirection47 + ViewVector49 ) );
				float dotResult13_g30 = dot( temp_output_1_0_g30 , normalizeResult11_g30 );
				float smoothstepResult7_g30 = smoothstep( -1.0 , 0.0 , dotResult13_g30);
				float dotResult18_g30 = dot( temp_output_1_0_g30 , normalizeResult11_g30 );
				float temp_output_151_0 = ( smoothstepResult7_g30 * ( pow( sqrt( ( 1.0 - ( dotResult18_g30 * dotResult18_g30 ) ) ) , _Highlight_2_Power ) * _Highlight_2_Strength ) );
				float4 appendResult168 = (float4(( ( ( ( smoothstepResult7_g28 * ( pow( sqrt( ( 1.0 - ( dotResult18_g28 * dotResult18_g28 ) ) ) , _Highlight_1_Power ) * _Highlight_1_Strength ) ) * _Highlight_1_Color ) + temp_output_76_0 ) + ( temp_output_151_0 * _Highlight_2_Color ) ).rgb , tex2DNode68.a));
				
				
				finalColor = appendResult168;
				clip( finalColor.a  - _Cutoff );
				return finalColor;
			}
            ENDCG
        }
	}
	
	
}