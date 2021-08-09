// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matcap4_forHead"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_matcap_default("matcap_default", 2D) = "white" {}
		_Matcap_default_strength("Matcap_default_strength", Float) = 1
		_NormalTex("NormalTex", 2D) = "bump" {}
		_LEye_texture("LEye_texture", 2D) = "black" {}
		_REye_texture("REye_texture", 2D) = "black" {}
		_LCheek_texture("LCheek_texture", 2D) = "black" {}
		_RCheek_texture("RCheek_texture", 2D) = "black" {}
		_Lips("Lips", 2D) = "black" {}
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
		uniform sampler2D _LEye_texture;
		uniform float4 _LEye_texture_ST;
		uniform sampler2D _REye_texture;
		uniform float4 _REye_texture_ST;
		uniform sampler2D _LCheek_texture;
		uniform float4 _LCheek_texture_ST;
		uniform sampler2D _RCheek_texture;
		uniform float4 _RCheek_texture_ST;
		uniform sampler2D _Lips;
		uniform float4 _Lips_ST;
		uniform sampler2D _matcap_default;
		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _Matcap_default_strength;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_LEye_texture = i.uv_texcoord * _LEye_texture_ST.xy + _LEye_texture_ST.zw;
			float4 tex2DNode84 = tex2D( _LEye_texture, uv_LEye_texture );
			float4 lerpResult88 = lerp( tex2D( _MainTex, uv_MainTex ) , tex2DNode84 , tex2DNode84.a);
			float2 uv_REye_texture = i.uv_texcoord * _REye_texture_ST.xy + _REye_texture_ST.zw;
			float4 tex2DNode85 = tex2D( _REye_texture, uv_REye_texture );
			float4 lerpResult89 = lerp( lerpResult88 , tex2DNode85 , tex2DNode85.a);
			float2 uv_LCheek_texture = i.uv_texcoord * _LCheek_texture_ST.xy + _LCheek_texture_ST.zw;
			float4 tex2DNode86 = tex2D( _LCheek_texture, uv_LCheek_texture );
			float4 lerpResult90 = lerp( lerpResult89 , tex2DNode86 , tex2DNode86.a);
			float2 uv_RCheek_texture = i.uv_texcoord * _RCheek_texture_ST.xy + _RCheek_texture_ST.zw;
			float4 tex2DNode87 = tex2D( _RCheek_texture, uv_RCheek_texture );
			float4 lerpResult91 = lerp( lerpResult90 , tex2DNode87 , tex2DNode87.a);
			float2 uv_Lips = i.uv_texcoord * _Lips_ST.xy + _Lips_ST.zw;
			float4 tex2DNode92 = tex2D( _Lips, uv_Lips );
			float4 lerpResult93 = lerp( lerpResult91 , tex2DNode92 , tex2DNode92.a);
			float4 temp_cast_0 = (0.5).xxxx;
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float3 NormalTexture41 = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
			float3 matcapUV58 = ( ( mul( UNITY_MATRIX_V, float4( normalize( (WorldNormalVector( i , NormalTexture41 )) ) , 0.0 ) ).xyz * 0.5 ) + 0.5 );
			float4 lerpResult19 = lerp( temp_cast_0 , tex2D( _matcap_default, matcapUV58.xy ) , _Matcap_default_strength);
			float4 blendOpSrc14 = lerpResult93;
			float4 blendOpDest14 = lerpResult19;
			c.rgb = ( saturate( (( blendOpDest14 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest14 ) * ( 1.0 - blendOpSrc14 ) ) : ( 2.0 * blendOpDest14 * blendOpSrc14 ) ) )).rgb;
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
-1890;108;1857;969;1274.468;-397.8759;1;True;False
Node;AmplifyShaderEditor.SamplerNode;13;-2666.24,1042.3;Inherit;True;Property;_NormalTex;NormalTex;5;0;Create;True;0;0;0;False;0;False;-1;None;f4d420f84591c104a881199cb4cfc7f5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2282.89,1037.175;Inherit;False;NormalTexture;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2050.287,1043.741;Inherit;False;41;NormalTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewMatrixNode;3;-1716.424,953.6584;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-1796.612,1047.792;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1557.88,983.4443;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1568.697,1111.819;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1378.37,-384.9091;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;5018c4a2fe5296246b882398a542fef1;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;84;-1286.75,-137.0229;Inherit;True;Property;_LEye_texture;LEye_texture;6;0;Create;True;0;0;0;False;0;False;-1;None;08dda17445cb37e49888e1434e1d2408;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1390.628,1019.89;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1226.318,1060.967;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;88;-856.0789,-200.9645;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;85;-1202.057,94.39897;Inherit;True;Property;_REye_texture;REye_texture;7;0;Create;True;0;0;0;False;0;False;-1;None;3e42fd90c83d3e548bdf5a4eba0f1852;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;86;-1089.827,330.1948;Inherit;True;Property;_LCheek_texture;LCheek_texture;8;0;Create;True;0;0;0;False;0;False;-1;None;cb391253c02fca3408656323fa301794;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;89;-678.0789,-2.964478;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1001.521,1037.965;Inherit;False;matcapUV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;87;-847.6517,553.4033;Inherit;True;Property;_RCheek_texture;RCheek_texture;9;0;Create;True;0;0;0;False;0;False;-1;None;5f0ed3848c01db64fb310bd794618cb8;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;90;-524.0789,194.0355;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-768.6343,1039.861;Inherit;False;58;matcapUV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-535.7365,1015.495;Inherit;True;Property;_matcap_default;matcap_default;3;0;Create;True;0;0;0;False;0;False;-1;7a06754892719da4fadf5997db2fba27;7a06754892719da4fadf5997db2fba27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-146.8778,1146.287;Inherit;False;Property;_Matcap_default_strength;Matcap_default_strength;4;0;Create;True;0;0;0;False;0;False;1;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-116.7998,975.3675;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;92;-604.649,766.6864;Inherit;True;Property;_Lips;Lips;10;0;Create;True;0;0;0;False;0;False;-1;None;b8c8511d6695e6945912ddce4ecf9b53;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;91;-372.0789,365.0355;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;93;-142.4094,550.2947;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1435.566,-1511.361;Inherit;False;2221.714;803.7272;Blinn Phong Lightning;21;39;37;40;46;43;38;34;35;36;47;44;29;30;28;33;27;49;50;31;32;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;19;74.03219,995.1248;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-666.5727,-1212.042;Inherit;False;H;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;49;-1142.623,-1411.556;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-363.4919,-1255.144;Inherit;False;41;NormalTexture;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;38;267.3003,-1131.32;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-126.3734,-1112.637;Inherit;False;33;H;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;50;-1170.623,-1092.556;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;40;412.8555,-1050.12;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;127.7174,-1059.69;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;30;-1274.673,-926.4424;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;624.1482,-938.6335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;32;-845.9727,-1206.842;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;36;102.6267,-1199.637;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;14;192.0575,545.5253;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-999.373,-1205.542;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-900.9966,-1404.033;Inherit;False;LightDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;39;203.904,-956.8892;Inherit;False;Property;_Shininess;Shininess;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;203.8424,-873.6;Inherit;False;Constant;_Float3;Float 3;12;0;Create;True;0;0;0;False;0;False;128;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1258.573,-1228.542;Inherit;False;28;LightDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-157.3734,-1264.637;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;27;-1385.566,-1461.361;Inherit;False;Constant;_LightDir;LightDir;3;0;Create;True;0;0;0;False;0;False;-1,1,1;-1,1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;48;-1382.338,-1063.301;Inherit;False;Constant;_ViewDir;ViewDir;12;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;47;449.1482,-823.6335;Inherit;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;940.0558,-173.0014;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Matcap4_forHead;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.75;True;False;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;13;0
WireConnection;4;0;42;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;88;0;1;0
WireConnection;88;1;84;0
WireConnection;88;2;84;4
WireConnection;89;0;88;0
WireConnection;89;1;85;0
WireConnection;89;2;85;4
WireConnection;58;0;7;0
WireConnection;90;0;89;0
WireConnection;90;1;86;0
WireConnection;90;2;86;4
WireConnection;8;1;59;0
WireConnection;91;0;90;0
WireConnection;91;1;87;0
WireConnection;91;2;87;4
WireConnection;93;0;91;0
WireConnection;93;1;92;0
WireConnection;93;2;92;4
WireConnection;19;0;20;0
WireConnection;19;1;8;0
WireConnection;19;2;18;0
WireConnection;33;0;32;0
WireConnection;49;0;27;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;50;0;48;0
WireConnection;40;0;38;0
WireConnection;40;1;44;0
WireConnection;46;0;40;0
WireConnection;46;1;47;0
WireConnection;32;0;31;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;14;0;93;0
WireConnection;14;1;19;0
WireConnection;31;0;29;0
WireConnection;31;1;50;0
WireConnection;28;0;49;0
WireConnection;34;0;43;0
WireConnection;0;13;14;0
ASEEND*/
//CHKSM=FE35A03ADC9143947C2C3AD6E3B09CDA2FC29476