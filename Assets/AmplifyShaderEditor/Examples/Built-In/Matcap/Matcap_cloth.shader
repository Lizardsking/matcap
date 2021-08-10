// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matcap_cloth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_matcap_default("matcap_default", 2D) = "white" {}
		_Matcap_default_strength("Matcap_default_strength", Float) = 1
		_NormalTex("NormalTex", 2D) = "bump" {}
		[Toggle(_USE_R_MASK_ON)] _Use_R_Mask("Use_R_Mask", Float) = 0
		[Toggle(_USE_G_MASK_ON)] _Use_G_Mask("Use_G_Mask", Float) = 0
		[Toggle(_USE_B_MASK_ON)] _Use_B_Mask("Use_B_Mask", Float) = 0
		_matcap_R_Strength("matcap_R_Strength", Float) = 1
		_matcap_G_Strength("matcap_G_Strength", Float) = 1
		_matcap_B_Strength("matcap_B_Strength", Float) = 1
		_matcap_R("matcap_R", 2D) = "white" {}
		_matcap_G("matcap_G", 2D) = "white" {}
		_matcap_B("matcap_B", 2D) = "white" {}
		_matcapMasks("matcapMasks", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature_local _USE_B_MASK_ON
		#pragma shader_feature_local _USE_G_MASK_ON
		#pragma shader_feature_local _USE_R_MASK_ON
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _matcap_default;
		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _Matcap_default_strength;
		uniform sampler2D _matcap_R;
		uniform float _matcap_R_Strength;
		uniform sampler2D _matcapMasks;
		uniform float4 _matcapMasks_ST;
		uniform sampler2D _matcap_G;
		uniform float _matcap_G_Strength;
		uniform sampler2D _matcap_B;
		uniform float _matcap_B_Strength;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 temp_cast_0 = (0.5).xxxx;
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float3 NormalTexture41 = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
			float3 matcapUV58 = ( ( mul( UNITY_MATRIX_V, float4( normalize( (WorldNormalVector( i , NormalTexture41 )) ) , 0.0 ) ).xyz * 0.5 ) + 0.5 );
			float4 lerpResult19 = lerp( temp_cast_0 , tex2D( _matcap_default, matcapUV58.xy ) , _Matcap_default_strength);
			float4 blendOpSrc14 = tex2DNode1;
			float4 blendOpDest14 = lerpResult19;
			float4 temp_output_14_0 = ( saturate( (( blendOpDest14 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest14 ) * ( 1.0 - blendOpSrc14 ) ) : ( 2.0 * blendOpDest14 * blendOpSrc14 ) ) ));
			float4 temp_cast_4 = (0.5).xxxx;
			float4 lerpResult65 = lerp( temp_cast_4 , tex2D( _matcap_R, matcapUV58.xy ) , _matcap_R_Strength);
			float4 blendOpSrc72 = tex2DNode1;
			float4 blendOpDest72 = lerpResult65;
			float2 uv_matcapMasks = i.uv_texcoord * _matcapMasks_ST.xy + _matcapMasks_ST.zw;
			float4 tex2DNode78 = tex2D( _matcapMasks, uv_matcapMasks );
			float4 lerpResult75 = lerp( temp_output_14_0 , ( saturate( (( blendOpDest72 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest72 ) * ( 1.0 - blendOpSrc72 ) ) : ( 2.0 * blendOpDest72 * blendOpSrc72 ) ) )) , tex2DNode78.r);
			#ifdef _USE_R_MASK_ON
				float4 staticSwitch56 = lerpResult75;
			#else
				float4 staticSwitch56 = temp_output_14_0;
			#endif
			float4 temp_cast_6 = (0.5).xxxx;
			float4 lerpResult68 = lerp( temp_cast_6 , tex2D( _matcap_G, matcapUV58.xy ) , _matcap_G_Strength);
			float4 blendOpSrc73 = tex2DNode1;
			float4 blendOpDest73 = lerpResult68;
			float4 lerpResult76 = lerp( staticSwitch56 , ( saturate( (( blendOpDest73 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest73 ) * ( 1.0 - blendOpSrc73 ) ) : ( 2.0 * blendOpDest73 * blendOpSrc73 ) ) )) , tex2DNode78.g);
			#ifdef _USE_G_MASK_ON
				float4 staticSwitch82 = lerpResult76;
			#else
				float4 staticSwitch82 = staticSwitch56;
			#endif
			float4 temp_cast_8 = (0.5).xxxx;
			float4 lerpResult71 = lerp( temp_cast_8 , tex2D( _matcap_B, matcapUV58.xy ) , _matcap_B_Strength);
			float4 blendOpSrc74 = tex2DNode1;
			float4 blendOpDest74 = lerpResult71;
			float4 lerpResult77 = lerp( staticSwitch82 , ( saturate( (( blendOpDest74 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest74 ) * ( 1.0 - blendOpSrc74 ) ) : ( 2.0 * blendOpDest74 * blendOpSrc74 ) ) )) , tex2DNode78.b);
			#ifdef _USE_B_MASK_ON
				float4 staticSwitch83 = lerpResult77;
			#else
				float4 staticSwitch83 = staticSwitch82;
			#endif
			c.rgb = staticSwitch83.rgb;
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
	}
	Fallback "Mobile/Unlit (Supports Lightmap)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
110;193;1571;678;2037.411;140.5658;2.075576;True;False
Node;AmplifyShaderEditor.SamplerNode;13;-3409.42,25.18132;Inherit;True;Property;_NormalTex;NormalTex;4;0;Create;True;0;0;0;False;0;False;-1;None;95371d9241a13b14982f221c50806bd3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-3026.07,20.05605;Inherit;False;NormalTexture;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2793.467,26.62185;Inherit;False;41;NormalTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-2539.792,30.67358;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;3;-2459.604,-63.46027;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-2301.061,-33.67435;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2311.878,94.70049;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-2133.809,2.771464;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1969.499,43.84834;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1744.702,20.84637;Inherit;False;matcapUV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-812.1817,615.9988;Inherit;False;58;matcapUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1032.613,322.0046;Inherit;False;58;matcapUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-441.7784,282.5107;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;-588.6133,598.0046;Inherit;True;Property;_matcap_R;matcap_R;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-799.7151,297.6385;Inherit;True;Property;_matcap_default;matcap_default;2;0;Create;True;0;0;0;False;0;False;-1;7a06754892719da4fadf5997db2fba27;7a06754892719da4fadf5997db2fba27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-175.352,689.0336;Inherit;False;Property;_matcap_R_Strength;matcap_R_Strength;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-471.8564,453.4306;Inherit;False;Property;_Matcap_default_strength;Matcap_default_strength;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;65;44.26929,537.871;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-387.7639,35.24473;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;12195164c523d3545b85ca2c58e437b3;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;80;-719.1817,837.9989;Inherit;False;58;matcapUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;19;-250.9464,302.268;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;14;250.4569,48.85318;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;78;557.9563,1071.311;Inherit;True;Property;_matcapMasks;matcapMasks;14;0;Create;True;0;0;0;False;0;False;-1;None;046495d55f6d7174babcc60056a16782;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;8.35918,939.0336;Inherit;False;Property;_matcap_G_Strength;matcap_G_Strength;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;72;284.2462,328.2343;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;61;-458.6133,837.0046;Inherit;True;Property;_matcap_G;matcap_G;12;0;Create;True;0;0;0;False;0;False;-1;None;6f8e41f4a4b09614b90b3e1065d83058;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;81;-525.1817,1082.999;Inherit;False;58;matcapUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;68;229.2693,787.871;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;75;560.8029,238.3104;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;73;448.7582,567.2219;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;56;813.5269,215.3964;Inherit;False;Property;_Use_R_Mask;Use_R_Mask;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;79.35918,1204.033;Inherit;False;Property;_matcap_B_Strength;matcap_B_Strength;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-310.6133,1061.005;Inherit;True;Property;_matcap_B;matcap_B;13;0;Create;True;0;0;0;False;0;False;-1;None;b2351295a76eec24a95c913fb1806c62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;71;300.2693,1052.871;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;76;1034.152,445.615;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;82;1260.05,423.521;Inherit;False;Property;_Use_G_Mask;Use_G_Mask;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;74;568.6181,877.8268;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1435.566,-1511.361;Inherit;False;2221.714;803.7272;Blinn Phong Lightning;21;39;37;40;46;43;38;34;35;36;47;44;29;30;28;33;27;49;50;31;32;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;77;1505.618,734.2407;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;203.8424,-873.6;Inherit;False;Constant;_Float3;Float 3;12;0;Create;True;0;0;0;False;0;False;128;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;84;-954.0942,482.2901;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-157.3734,-1264.637;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-900.9966,-1404.033;Inherit;False;LightDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;37;127.7174,-1059.69;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;38;267.3003,-1131.32;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-126.3734,-1112.637;Inherit;False;33;H;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;48;-1382.338,-1063.301;Inherit;False;Constant;_ViewDir;ViewDir;12;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;39;203.904,-956.8892;Inherit;False;Property;_Shininess;Shininess;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-999.373,-1205.542;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;36;102.6267,-1199.637;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-666.5727,-1212.042;Inherit;False;H;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;49;-1142.623,-1411.556;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-363.4919,-1255.144;Inherit;False;41;NormalTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;50;-1170.623,-1092.556;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;30;-1274.673,-926.4424;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;32;-845.9727,-1206.842;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;27;-1385.566,-1461.361;Inherit;False;Constant;_LightDir;LightDir;3;0;Create;True;0;0;0;False;0;False;-1,1,1;-1,1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;624.1482,-938.6335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;83;1771.581,712.9233;Inherit;False;Property;_Use_B_Mask;Use_B_Mask;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1258.573,-1228.542;Inherit;False;28;LightDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;40;412.8555,-1050.12;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;449.1482,-823.6335;Inherit;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;88;2138.78,477.742;Float;False;True;-1;0;ASEMaterialInspector;0;0;CustomLighting;Matcap_cloth;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Mobile/Unlit (Supports Lightmap);-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;13;0
WireConnection;4;0;42;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;58;0;7;0
WireConnection;60;1;79;0
WireConnection;8;1;59;0
WireConnection;65;0;20;0
WireConnection;65;1;60;0
WireConnection;65;2;63;0
WireConnection;19;0;20;0
WireConnection;19;1;8;0
WireConnection;19;2;18;0
WireConnection;14;0;1;0
WireConnection;14;1;19;0
WireConnection;72;0;1;0
WireConnection;72;1;65;0
WireConnection;61;1;80;0
WireConnection;68;0;20;0
WireConnection;68;1;61;0
WireConnection;68;2;66;0
WireConnection;75;0;14;0
WireConnection;75;1;72;0
WireConnection;75;2;78;1
WireConnection;73;0;1;0
WireConnection;73;1;68;0
WireConnection;56;1;14;0
WireConnection;56;0;75;0
WireConnection;62;1;81;0
WireConnection;71;0;20;0
WireConnection;71;1;62;0
WireConnection;71;2;69;0
WireConnection;76;0;56;0
WireConnection;76;1;73;0
WireConnection;76;2;78;2
WireConnection;82;1;56;0
WireConnection;82;0;76;0
WireConnection;74;0;1;0
WireConnection;74;1;71;0
WireConnection;77;0;82;0
WireConnection;77;1;74;0
WireConnection;77;2;78;3
WireConnection;34;0;43;0
WireConnection;28;0;49;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;31;0;29;0
WireConnection;31;1;50;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;33;0;32;0
WireConnection;49;0;27;0
WireConnection;50;0;48;0
WireConnection;32;0;31;0
WireConnection;46;0;40;0
WireConnection;46;1;47;0
WireConnection;83;1;82;0
WireConnection;83;0;77;0
WireConnection;40;0;38;0
WireConnection;40;1;44;0
WireConnection;88;13;83;0
ASEEND*/
//CHKSM=E19A8A1A9B38163AAA2F898126CB5FA20954FEF6