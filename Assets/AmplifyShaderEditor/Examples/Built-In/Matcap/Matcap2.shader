// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matcap2"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_skinHazardousarts("skinHazardousarts", 2D) = "white" {}
		_Char_1_normal("Char_1_normal", 2D) = "bump" {}
		_Matcap_add("Matcap_add", Float) = 0
		_Matcap_strength("Matcap_strength", Float) = 1
		_Matcap_desaturation("Matcap_desaturation", Float) = 0
		_FlatColor("FlatColor", Color) = (0,0,0,0)
		_UseFlatColor("UseFlatColor", Float) = 0
		_Normal_strength("Normal_strength", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
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
		uniform float4 _FlatColor;
		uniform float _UseFlatColor;
		uniform sampler2D _skinHazardousarts;
		uniform sampler2D _Char_1_normal;
		uniform float4 _Char_1_normal_ST;
		uniform float _Normal_strength;
		uniform float _Matcap_desaturation;
		uniform float _Matcap_add;
		uniform float _Matcap_strength;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 lerpResult25 = lerp( tex2D( _MainTex, uv_MainTex ) , _FlatColor , _UseFlatColor);
			float3 temp_cast_0 = (0.5).xxx;
			float2 uv_Char_1_normal = i.uv_texcoord * _Char_1_normal_ST.xy + _Char_1_normal_ST.zw;
			float3 NormalTexture41 = UnpackScaleNormal( tex2D( _Char_1_normal, uv_Char_1_normal ), _Normal_strength );
			float3 desaturateInitialColor21 = tex2D( _skinHazardousarts, ( ( mul( UNITY_MATRIX_V, float4( normalize( (WorldNormalVector( i , NormalTexture41 )) ) , 0.0 ) ).xyz * 0.5 ) + 0.5 ).xy ).rgb;
			float desaturateDot21 = dot( desaturateInitialColor21, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar21 = lerp( desaturateInitialColor21, desaturateDot21.xxx, _Matcap_desaturation );
			float3 lerpResult19 = lerp( temp_cast_0 , ( desaturateVar21 + _Matcap_add ) , _Matcap_strength);
			float4 blendOpSrc14 = lerpResult25;
			float4 blendOpDest14 = float4( lerpResult19 , 0.0 );
			float4 temp_output_14_0 = ( saturate( (( blendOpDest14 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest14 ) * ( 1.0 - blendOpSrc14 ) ) : ( 2.0 * blendOpDest14 * blendOpSrc14 ) ) ));
			c.rgb = temp_output_14_0.rgb;
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
71;368;1571;707;3043.257;164.0015;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-2585.265,109.7829;Inherit;False;Property;_Normal_strength;Normal_strength;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-2377.253,57.01651;Inherit;True;Property;_Char_1_normal;Char_1_normal;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1993.903,51.89124;Inherit;False;NormalTexture;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1882.342,338.1454;Inherit;False;41;NormalTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewMatrixNode;3;-1548.481,248.0632;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-1628.669,342.197;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1389.938,277.8491;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1400.755,406.2239;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1222.686,314.2949;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1047.376,364.3718;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-847.9846,334.5;Inherit;True;Property;_skinHazardousarts;skinHazardousarts;4;0;Create;True;0;0;0;False;0;False;-1;1ff29e9e61da34f41951b3d3b2bf7803;450fde32c77e9ab439210d11a813f8cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-498.5415,473.9872;Inherit;False;Property;_Matcap_desaturation;Matcap_desaturation;8;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-214.0349,475.1098;Inherit;False;Property;_Matcap_add;Matcap_add;6;0;Create;True;0;0;0;False;0;False;0;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;21;-469.5415,347.9872;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-80.03491,557.1097;Inherit;False;Property;_Matcap_strength;Matcap_strength;7;0;Create;True;0;0;0;False;0;False;1;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-214.0349,345.1098;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-477.5,-345.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;b40fedd32a06d4c479ea036f5e248fc8;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-50.86698,429.3525;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-392.3511,-130.5968;Inherit;False;Property;_FlatColor;FlatColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-377.3511,70.4032;Inherit;False;Property;_UseFlatColor;UseFlatColor;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;9.648926,-16.5968;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;19;116.9651,356.1098;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1316.972,-927.2028;Inherit;False;28;LightDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-594.257,-757.5073;Inherit;False;41;NormalTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;38;36.5352,-633.6834;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-388.1385,-767.0003;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;9;-185.5,708.5;Inherit;True;Property;_Matcap;Matcap;2;0;Create;True;0;0;0;False;0;False;-1;None;b23676ff9cac20a4c9c7b9333f055f1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1057.772,-904.2028;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;50;-1229.022,-791.2163;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-357.1385,-615.0003;Inherit;False;33;H;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-26.92273,-375.9636;Inherit;False;Constant;_Float3;Float 3;12;0;Create;True;0;0;0;False;0;False;128;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;479.343,-64.13901;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;393.3831,-440.9972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-724.9717,-910.7029;Inherit;False;H;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;48;-1440.737,-761.9611;Inherit;False;Constant;_ViewDir;ViewDir;12;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendOpsNode;14;244.4569,48.85318;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;49;-1201.022,-1110.216;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-103.0478,-562.0542;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;218.3831,-325.9972;Inherit;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-26.86114,-459.2528;Inherit;False;Property;_Shininess;Shininess;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;36;-128.1384,-702.0003;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;27;-1443.965,-1160.021;Inherit;False;Constant;_LightDir;LightDir;3;0;Create;True;0;0;0;False;0;False;-1,1,1;-1,1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;40;182.0904,-552.4842;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;30;-1333.072,-625.1028;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;32;-904.3717,-905.5028;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-959.3956,-1102.693;Inherit;False;LightDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;692.9717,-292.683;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Matcap2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.75;True;False;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;5;26;0
WireConnection;41;0;13;0
WireConnection;4;0;42;0
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
WireConnection;25;0;1;0
WireConnection;25;1;23;0
WireConnection;25;2;24;0
WireConnection;19;0;20;0
WireConnection;19;1;15;0
WireConnection;19;2;18;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;34;0;43;0
WireConnection;31;0;29;0
WireConnection;31;1;50;0
WireConnection;50;0;48;0
WireConnection;45;1;14;0
WireConnection;46;0;40;0
WireConnection;46;1;47;0
WireConnection;33;0;32;0
WireConnection;14;0;25;0
WireConnection;14;1;19;0
WireConnection;49;0;27;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;40;0;38;0
WireConnection;40;1;44;0
WireConnection;32;0;31;0
WireConnection;28;0;49;0
WireConnection;0;13;14;0
ASEEND*/
//CHKSM=F4B74598DF1EDE99C36ED21D0AD4C477D015B3C5