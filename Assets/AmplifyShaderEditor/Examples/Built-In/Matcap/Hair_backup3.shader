// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hair_backup3"
{
	Properties
	{
		_LIghtDirection("LIghtDirection", Vector) = (1,-0.5,0,0)
		_Jitter("Jitter", Float) = 1
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
		_Highlight_Mask("Highlight_Mask", 2D) = "white" {}
		_Hair_Color("Hair_Color", Color) = (1,1,1,0)
		_Hair_normal("Hair_normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _Hair_normal;
		uniform float4 _Hair_normal_ST;
		uniform float _Highlight_2_Shift;
		uniform float _Jitter;
		uniform sampler2D _ShiftTexture;
		uniform float4 _ShiftTexture_ST;
		uniform float _GeneralShift;
		uniform float3 _LIghtDirection;
		uniform float _Highlight_2_Power;
		uniform float _Highlight_2_Strength;
		uniform float4 _Highlight_2_Color;
		uniform float _Highlight_1_Shift;
		uniform float _Highlight_1_Power;
		uniform float _Highlight_1_Strength;
		uniform float4 _Highlight_1_Color;
		uniform sampler2D _Highlight_Mask;
		uniform float4 _Highlight_Mask_ST;
		uniform float4 _Hair_Color;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float2 uv_Hair_normal = i.uv_texcoord * _Hair_normal_ST.xy + _Hair_normal_ST.zw;
			float3 normalizeResult13 = normalize( mul( ase_worldToTangent, (WorldNormalVector( i , UnpackNormal( tex2D( _Hair_normal, uv_Hair_normal ) ) )) ) );
			float3 normalizeResult17 = normalize( cross( normalizeResult13 , float3(1,0,0) ) );
			float clampResult20 = clamp( _Jitter , 0.0 , 9999.0 );
			float temp_output_21_0 = ( clampResult20 * 0.5 );
			float2 uv_ShiftTexture = i.uv_texcoord * _ShiftTexture_ST.xy + _ShiftTexture_ST.zw;
			float lerpResult25 = lerp( ( temp_output_21_0 - 0.5 ) , ( temp_output_21_0 + 0.5 ) , tex2D( _ShiftTexture, uv_ShiftTexture ).b);
			float temp_output_35_0 = ( lerpResult25 - _GeneralShift );
			float3 normalizeResult6_g5 = normalize( ( normalizeResult17 + ( ( _Highlight_2_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
			float3 temp_output_1_0_g9 = normalizeResult6_g5;
			float3 normalizeResult5 = normalize( ( _LIghtDirection * -1.0 ) );
			float3 LightDirection47 = normalizeResult5;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 worldSpaceViewDir81 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
			float3 ViewVector49 = mul( ase_worldToTangent, ( ase_worldViewDir - ( worldSpaceViewDir81 * -1.0 ) ) );
			float3 normalizeResult11_g9 = normalize( ( LightDirection47 + ViewVector49 ) );
			float dotResult13_g9 = dot( temp_output_1_0_g9 , normalizeResult11_g9 );
			float smoothstepResult7_g9 = smoothstep( -1.0 , 0.0 , dotResult13_g9);
			float dotResult18_g9 = dot( temp_output_1_0_g9 , normalizeResult11_g9 );
			float3 normalizeResult6_g6 = normalize( ( normalizeResult17 + ( ( _Highlight_1_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
			float3 temp_output_1_0_g8 = normalizeResult6_g6;
			float3 normalizeResult11_g8 = normalize( ( LightDirection47 + ViewVector49 ) );
			float dotResult13_g8 = dot( temp_output_1_0_g8 , normalizeResult11_g8 );
			float smoothstepResult7_g8 = smoothstep( -1.0 , 0.0 , dotResult13_g8);
			float dotResult18_g8 = dot( temp_output_1_0_g8 , normalizeResult11_g8 );
			float2 uv_Highlight_Mask = i.uv_texcoord * _Highlight_Mask_ST.xy + _Highlight_Mask_ST.zw;
			c.rgb = ( ( ( tex2D( _TextureSample0, uv_TextureSample0 ) + ( ( smoothstepResult7_g9 * ( pow( sqrt( ( 1.0 - ( dotResult18_g9 * dotResult18_g9 ) ) ) , _Highlight_2_Power ) * _Highlight_2_Strength ) ) * _Highlight_2_Color ) ) + ( ( ( smoothstepResult7_g8 * ( pow( sqrt( ( 1.0 - ( dotResult18_g8 * dotResult18_g8 ) ) ) , _Highlight_1_Power ) * _Highlight_1_Strength ) ) * _Highlight_1_Color ) * tex2D( _Highlight_Mask, uv_Highlight_Mask ) ) ) * _Hair_Color ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
225;437;1559;712;3554.546;-42.16587;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;34;-2908.958,910.3703;Inherit;False;1127.223;482.0001;Jitter Control;7;19;20;24;25;22;23;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2858.958,1062.584;Inherit;False;Property;_Jitter;Jitter;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-3028.22,76.84465;Inherit;False;1000.292;493.4901;Normal;4;13;115;114;92;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;9;-2870.983,-541.8011;Inherit;False;1438.405;575.2569;Camera view;8;81;49;78;89;88;85;127;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;130;-3063.546,204.1659;Inherit;True;Property;_Hair_normal;Hair_normal;15;0;Create;True;0;0;0;False;0;False;-1;b5b2ed88ee9b5c04f96fb8005220b17a;b5b2ed88ee9b5c04f96fb8005220b17a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-2586.735,1276.37;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;20;-2673.148,1061.545;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;9999;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-2835.611,-962.173;Inherit;False;1220.146;401.735;LightVector;5;2;47;5;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;81;-2837.566,-201.9445;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;33;-2457.151,1439.814;Inherit;False;643.0576;418.5177;Anisotropic Control Texture;1;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;114;-2747.732,142.0083;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-2615.074,-61.17636;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2837.085,-471.8375;Inherit;False;241;238;ViewDir = Camera Vector;1;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;92;-2753.998,215.2622;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2453.735,1065.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1731.83,1018.94;Inherit;False;415;318;ShiftHeightControl;2;35;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2516.634,-754.5776;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2187.773,1130.178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-2464.595,203.3795;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-2787.085,-421.8375;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;2;-2768.344,-872.1984;Inherit;False;Property;_LIghtDirection;LIghtDirection;0;0;Create;True;0;0;0;False;0;False;1,-0.5,0;-1,-1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;18;-1978.429,539.4915;Inherit;False;606.3762;350.2667;Tangent;3;16;15;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;32;-2335.545,1561.814;Inherit;True;Property;_ShiftTexture;ShiftTexture;2;0;Create;True;0;0;0;False;0;False;-1;1af753fb792298c47809dc7f0cbc6849;1af753fb792298c47809dc7f0cbc6849;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-2192.773,1037.831;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2547.459,-232.6547;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;88;-2447.934,-466.3733;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.LerpOp;25;-1963.735,1081.37;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-2359.634,-864.5778;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;16;-1928.429,701.7581;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;-1681.83,1220.94;Inherit;False;Property;_GeneralShift;GeneralShift;6;0;Create;True;0;0;0;False;0;False;0.8;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;-2431.881,-376.2903;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;13;-2263.998,213.7583;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;5;-2155.634,-863.5778;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1269.83,1045.94;Inherit;False;Property;_Highlight_1_Shift;Highlight_1_Shift;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1259.83,1222.94;Inherit;False;Property;_Highlight_2_Shift;Highlight_2_Shift;4;0;Create;True;0;0;0;False;0;False;0.05;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-2195.145,-394.5987;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;15;-1748.473,592.7936;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-1492.83,1082.94;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-1951.949,-437.744;Inherit;False;ViewVector;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;45;-732.8954,530.0141;Inherit;False;291;209;Shift Tangent 2;1;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-737.043,210.469;Inherit;False;291;209;Shift Tangent 1;1;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1930.089,-877.1462;Inherit;False;LightDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1011.83,1057.94;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;17;-1547.053,594.6915;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;66;-355.765,59.38558;Inherit;False;996.1727;488.5634;Primary Highlight;7;50;48;46;51;52;58;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-339.1427,567.5775;Inherit;False;1037.55;478.3715;Secondary Highlight;7;56;54;55;57;61;62;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-995.8301,1229.94;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;43;-687.043,260.469;Inherit;False;ASEF_ShiftTangent;-1;;6;39d09a43ecc973744b8339a00c34f086;0;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-240.97,788.141;Inherit;False;Property;_Highlight_2_Power;Highlight_2_Power;7;0;Create;True;0;0;0;False;0;False;1000;21.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-260.5923,362.949;Inherit;False;Property;_Highlight_1_Strength;Highlight_1_Strength;8;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-257.5923,279.949;Inherit;False;Property;_Highlight_1_Power;Highlight_1_Power;5;0;Create;True;0;0;0;False;0;False;1000;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-278.97,704.141;Inherit;False;49;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-243.97,871.141;Inherit;False;Property;_Highlight_2_Strength;Highlight_2_Strength;9;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-305.765,109.3856;Inherit;False;47;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-289.1427,617.5775;Inherit;False;47;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-295.5923,195.949;Inherit;False;49;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;42;-682.8954,580.0141;Inherit;False;ASEF_ShiftTangent;-1;;5;39d09a43ecc973744b8339a00c34f086;0;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;73;749.4254,-26.8322;Inherit;False;582.7774;406.4505;Highlight Mask;2;71;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;844.2629,615.1475;Inherit;False;370;280;BaseTexture (Gray);1;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;60;109.4077,335.949;Inherit;False;Property;_Highlight_1_Color;Highlight_1_Color;10;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.9215125,0.8632076,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;62;139.4077,833.949;Inherit;False;Property;_Highlight_2_Color;Highlight_2_Color;11;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.7264151,0.4779658,0.4077519,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;53;110.0911,618.7441;Inherit;False;ASEF_StrandSpec;-1;;9;bbb8858f7ec589241a0890523416146f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;46;93.46875,110.5522;Inherit;False;ASEF_StrandSpec;-1;;8;bbb8858f7ec589241a0890523416146f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;817.6636,169.0723;Inherit;True;Property;_Highlight_Mask;Highlight_Mask;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;536.4077,728.949;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;68;894.2629,665.1475;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;ff68836c59202944380e84509e80d8e5;e333446f43ca2034d8af6dc2220b5645;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;478.4077,244.949;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1141.085,51.1328;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;1360.96,676.7866;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;1649.839,676.7183;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;77;1674.952,873.4686;Inherit;False;Property;_Hair_Color;Hair_Color;14;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;111;-3919.074,604.2227;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToTangentMatrix;124;2140.355,1038.69;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;2373.02,1102.415;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1947.71,688.7527;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;108;-3434.66,381.3476;Inherit;False;return TransformWorldToTangent(Input, tangentTransform_World);1;False;4;True;Input;FLOAT;0;In;;Inherit;False;True;tangentTransform_World;FLOAT3x3;1,0,0,1,1,1,1,0,1;In;;Inherit;False;True;In1;FLOAT3;0,0,0;In;;Inherit;False;True;In2;FLOAT3;0,0,0;In;;Inherit;False;WorldToTangent;True;False;0;4;0;FLOAT;0;False;1;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexBinormalNode;110;-3925.218,457.1764;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;63;300.6879,1294.804;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;2222.926,820.2344;Inherit;False;49;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;123;2136.284,1120.723;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexTangentNode;109;-3926.443,313.7569;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;121;1773.531,1308.398;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;104;-3275.54,-958.2679;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;64;126.6879,1454.804;Inherit;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.MatrixFromVectors;113;-3697.731,428.4516;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;122;1791.08,1080.176;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2555.962,523.2533;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Hair_backup3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;19;0
WireConnection;92;0;130;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;24;0;21;0
WireConnection;24;1;22;0
WireConnection;115;0;114;0
WireConnection;115;1;92;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;126;0;81;0
WireConnection;126;1;127;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;25;2;32;3
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;78;0;8;0
WireConnection;78;1;126;0
WireConnection;13;0;115;0
WireConnection;5;0;3;0
WireConnection;89;0;88;0
WireConnection;89;1;78;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;35;0;25;0
WireConnection;35;1;36;0
WireConnection;49;0;89;0
WireConnection;47;0;5;0
WireConnection;38;0;40;0
WireConnection;38;1;35;0
WireConnection;17;0;15;0
WireConnection;39;0;41;0
WireConnection;39;1;35;0
WireConnection;43;3;13;0
WireConnection;43;1;17;0
WireConnection;43;2;38;0
WireConnection;42;3;13;0
WireConnection;42;1;17;0
WireConnection;42;2;39;0
WireConnection;53;1;42;0
WireConnection;53;2;54;0
WireConnection;53;3;55;0
WireConnection;53;4;56;0
WireConnection;53;5;57;0
WireConnection;46;1;43;0
WireConnection;46;2;48;0
WireConnection;46;3;50;0
WireConnection;46;4;51;0
WireConnection;46;5;52;0
WireConnection;61;0;53;0
WireConnection;61;1;62;0
WireConnection;58;0;46;0
WireConnection;58;1;60;0
WireConnection;72;0;58;0
WireConnection;72;1;71;0
WireConnection;74;0;68;0
WireConnection;74;1;61;0
WireConnection;75;0;74;0
WireConnection;75;1;72;0
WireConnection;125;0;124;0
WireConnection;125;1;123;0
WireConnection;76;0;75;0
WireConnection;76;1;77;0
WireConnection;108;1;113;0
WireConnection;63;3;64;0
WireConnection;123;0;122;0
WireConnection;123;1;121;0
WireConnection;113;0;109;0
WireConnection;113;1;110;0
WireConnection;113;2;111;0
WireConnection;0;13;76;0
ASEEND*/
//CHKSM=B8DE6E63FC6616ED9AE663B7B3537065BFCE713C