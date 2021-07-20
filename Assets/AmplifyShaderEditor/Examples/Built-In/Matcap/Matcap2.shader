// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matcap2"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_skinHazardousarts("skinHazardousarts", 2D) = "white" {}
		_Char_1_normal("Char_1_normal", 2D) = "bump" {}
		_Matcap_add("Matcap_add", Float) = 0
		_Matcap_strength("Matcap_strength", Float) = 1
		_Matcap_desaturation("Matcap_desaturation", Float) = 0
		_FlatColor("FlatColor", Color) = (0,0,0,0)
		_UseFlatColor("UseFlatColor", Float) = 1
		_Normal_strength("Normal_strength", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
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
		uniform float4 _FlatColor;
		uniform float _UseFlatColor;
		uniform sampler2D _skinHazardousarts;
		uniform sampler2D _Char_1_normal;
		uniform float4 _Char_1_normal_ST;
		uniform float _Normal_strength;
		uniform float _Matcap_desaturation;
		uniform float _Matcap_add;
		uniform float _Matcap_strength;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult25 = lerp( tex2DNode1 , _FlatColor , _UseFlatColor);
			float3 temp_cast_0 = (0.5).xxx;
			float2 uv_Char_1_normal = i.uv_texcoord * _Char_1_normal_ST.xy + _Char_1_normal_ST.zw;
			float3 desaturateInitialColor21 = tex2D( _skinHazardousarts, ( ( mul( UNITY_MATRIX_V, float4( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _Char_1_normal, uv_Char_1_normal ), _Normal_strength ) )) , 0.0 ) ).xyz * 0.5 ) + 0.5 ).xy ).rgb;
			float desaturateDot21 = dot( desaturateInitialColor21, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar21 = lerp( desaturateInitialColor21, desaturateDot21.xxx, _Matcap_desaturation );
			float3 lerpResult19 = lerp( temp_cast_0 , ( desaturateVar21 + _Matcap_add ) , _Matcap_strength);
			float4 blendOpSrc14 = lerpResult25;
			float4 blendOpDest14 = float4( lerpResult19 , 0.0 );
			c.rgb = ( saturate( (( blendOpDest14 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest14 ) * ( 1.0 - blendOpSrc14 ) ) : ( 2.0 * blendOpDest14 * blendOpSrc14 ) ) )).rgb;
			c.a = 1;
			clip( tex2DNode1.a - _Cutoff );
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
-1752;238;1585;822;1319.771;443.5216;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;26;-2199.351,442.4032;Inherit;False;Property;_Normal_strength;Normal_strength;10;0;Create;True;0;0;0;False;0;False;1;0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-2009.339,349.6368;Inherit;True;Property;_Char_1_normal;Char_1_normal;4;0;Create;True;0;0;0;False;0;False;-1;724196f682c6cdf4f82b9f0867eaa4b0;9a33ebf404afc5a47b93b658aaa68b32;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;4;-1628.669,342.197;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;3;-1548.481,248.0632;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1389.938,277.8491;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1400.755,406.2239;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1222.686,314.2949;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1047.376,364.3718;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-847.9846,334.5;Inherit;True;Property;_skinHazardousarts;skinHazardousarts;3;0;Create;True;0;0;0;False;0;False;-1;1ff29e9e61da34f41951b3d3b2bf7803;57d4e5a622de28e48aa2a351c8821197;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-498.5415,473.9872;Inherit;False;Property;_Matcap_desaturation;Matcap_desaturation;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-214.0349,475.1098;Inherit;False;Property;_Matcap_add;Matcap_add;5;0;Create;True;0;0;0;False;0;False;0;-0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;21;-469.5415,347.9872;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-477.5,-345.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;feb36bd1a213b2c419e5b3d73014c7ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-392.3511,-130.5968;Inherit;False;Property;_FlatColor;FlatColor;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5283019,0.5283019,0.5283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-56.03491,391.1098;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-80.03491,557.1097;Inherit;False;Property;_Matcap_strength;Matcap_strength;6;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-214.0349,345.1098;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-377.3511,70.4032;Inherit;False;Property;_UseFlatColor;UseFlatColor;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;116.9651,356.1098;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;25;9.648926,-16.5968;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-185.5,708.5;Inherit;True;Property;_Matcap;Matcap;1;0;Create;True;0;0;0;False;0;False;-1;None;b23676ff9cac20a4c9c7b9333f055f1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;14;182.8579,161.5261;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;447,-63;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Matcap2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;False;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;5;26;0
WireConnection;4;0;13;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;8;1;7;0
WireConnection;21;0;8;0
WireConnection;21;1;22;0
WireConnection;15;0;21;0
WireConnection;15;1;16;0
WireConnection;19;0;20;0
WireConnection;19;1;15;0
WireConnection;19;2;18;0
WireConnection;25;0;1;0
WireConnection;25;1;23;0
WireConnection;25;2;24;0
WireConnection;14;0;25;0
WireConnection;14;1;19;0
WireConnection;0;10;1;4
WireConnection;0;13;14;0
ASEEND*/
//CHKSM=F57A69ED9DC69C4BA394613FC512B2E46EE776B2