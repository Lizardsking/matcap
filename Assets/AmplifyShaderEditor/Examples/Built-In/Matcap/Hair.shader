// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hair"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
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
		_Normal_Strength("Normal_Strength", Float) = 0
		_Desaturate_TextureColor("Desaturate_TextureColor", Float) = 0
		_Texture_Strength("Texture_Strength", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
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
		uniform float _Normal_Strength;
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
		uniform float _Desaturate_TextureColor;
		uniform float _Texture_Strength;
		uniform float4 _Hair_Color;
		uniform float _Highlight_2_Shift;
		uniform float _Highlight_2_Power;
		uniform float _Highlight_2_Strength;
		uniform float4 _Highlight_2_Color;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode68 = tex2D( _TextureSample0, uv_TextureSample0 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float2 uv_Hair_normal = i.uv_texcoord * _Hair_normal_ST.xy + _Hair_normal_ST.zw;
			float3 normalizeResult13 = normalize( mul( ase_worldToTangent, (WorldNormalVector( i , UnpackScaleNormal( tex2D( _Hair_normal, uv_Hair_normal ), _Normal_Strength ) )) ) );
			float3 normalizeResult17 = normalize( cross( normalizeResult13 , float3(1,0,0) ) );
			float2 uv_ShiftTexture = i.uv_texcoord * _ShiftTexture_ST.xy + _ShiftTexture_ST.zw;
			float4 tex2DNode32 = tex2D( _ShiftTexture, uv_ShiftTexture );
			float temp_output_35_0 = ( ( ( tex2DNode32.b - _Jitter_Balance ) * _JitterStrength ) - _GeneralShift );
			float3 normalizeResult6_g16 = normalize( ( normalizeResult17 + ( ( _Highlight_1_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
			float3 temp_output_1_0_g21 = normalizeResult6_g16;
			float3 normalizeResult5 = normalize( ( _LIghtDirection * -1.0 ) );
			float3 LightDirection47 = normalizeResult5;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 worldSpaceViewDir81 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
			float3 ViewVector49 = mul( ase_worldToTangent, ( ase_worldViewDir - ( worldSpaceViewDir81 * -1.0 ) ) );
			float3 normalizeResult11_g21 = normalize( ( LightDirection47 + ViewVector49 ) );
			float dotResult13_g21 = dot( temp_output_1_0_g21 , normalizeResult11_g21 );
			float smoothstepResult7_g21 = smoothstep( -1.0 , 0.0 , dotResult13_g21);
			float dotResult18_g21 = dot( temp_output_1_0_g21 , normalizeResult11_g21 );
			float temp_output_46_0 = ( smoothstepResult7_g21 * ( pow( sqrt( ( 1.0 - ( dotResult18_g21 * dotResult18_g21 ) ) ) , _Highlight_1_Power ) * _Highlight_1_Strength ) );
			float3 temp_cast_0 = (1.0).xxx;
			float3 desaturateInitialColor141 = tex2DNode68.rgb;
			float desaturateDot141 = dot( desaturateInitialColor141, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar141 = lerp( desaturateInitialColor141, desaturateDot141.xxx, _Desaturate_TextureColor );
			float3 lerpResult147 = lerp( temp_cast_0 , desaturateVar141 , _Texture_Strength);
			float4 temp_output_76_0 = ( float4( lerpResult147 , 0.0 ) * _Hair_Color );
			float4 temp_output_143_0 = ( ( temp_output_46_0 * _Highlight_1_Color ) + temp_output_76_0 );
			float3 normalizeResult6_g20 = normalize( ( normalizeResult17 + ( ( _Highlight_2_Shift + temp_output_35_0 ) * normalizeResult13 ) ) );
			float3 temp_output_1_0_g22 = normalizeResult6_g20;
			float3 normalizeResult11_g22 = normalize( ( LightDirection47 + ViewVector49 ) );
			float dotResult13_g22 = dot( temp_output_1_0_g22 , normalizeResult11_g22 );
			float smoothstepResult7_g22 = smoothstep( -1.0 , 0.0 , dotResult13_g22);
			float dotResult18_g22 = dot( temp_output_1_0_g22 , normalizeResult11_g22 );
			float temp_output_53_0 = ( smoothstepResult7_g22 * ( pow( sqrt( ( 1.0 - ( dotResult18_g22 * dotResult18_g22 ) ) ) , _Highlight_2_Power ) * _Highlight_2_Strength ) );
			c.rgb = ( temp_output_143_0 + ( temp_output_53_0 * _Highlight_2_Color ) ).rgb;
			c.a = 1;
			clip( tex2DNode68.a - _Cutoff );
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
110;372;1585;757;-2013.653;-669.652;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;14;-3028.22,76.84465;Inherit;False;1000.292;493.4901;Normal;5;13;115;114;92;130;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-3252.583,223.9791;Inherit;False;Property;_Normal_Strength;Normal_Strength;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;9;-2870.983,-541.8011;Inherit;False;1438.405;575.2569;Camera view;8;81;49;78;89;88;85;127;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2781.951,1417.414;Inherit;False;1311.857;596.1176;Anisotropic Control Texture;5;32;135;134;133;132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;130;-2997.396,238.6789;Inherit;True;Property;_Hair_normal;Hair_normal;15;0;Create;True;0;0;0;False;0;False;-1;b5b2ed88ee9b5c04f96fb8005220b17a;b5b2ed88ee9b5c04f96fb8005220b17a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-2597.545,1557.414;Inherit;True;Property;_ShiftTexture;ShiftTexture;3;0;Create;True;0;0;0;False;0;False;-1;1af753fb792298c47809dc7f0cbc6849;1af753fb792298c47809dc7f0cbc6849;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;92;-2687.848,249.7752;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToTangentMatrix;114;-2681.582,176.5213;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-2615.074,-61.17636;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-2352.729,1747.904;Inherit;False;Property;_Jitter_Balance;Jitter_Balance;17;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;81;-2837.566,-201.9445;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;6;-2835.611,-962.173;Inherit;False;1220.146;401.735;LightVector;5;2;47;5;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2837.085,-471.8375;Inherit;False;241;238;ViewDir = Camera Vector;1;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;2;-2768.344,-872.1984;Inherit;False;Property;_LIghtDirection;LIghtDirection;1;0;Create;True;0;0;0;False;0;False;1,-0.5,0;-1,-1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-2787.085,-421.8375;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2547.459,-232.6547;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2516.634,-754.5776;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-2147.93,1765.504;Inherit;False;Property;_JitterStrength;JitterStrength;16;0;Create;True;0;0;0;False;0;False;0;3.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;132;-2151.13,1626.304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-2398.445,237.8925;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1731.83,1018.94;Inherit;False;415;318;ShiftHeightControl;3;35;36;131;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1978.429,539.4915;Inherit;False;606.3762;350.2667;Tangent;3;16;15;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;88;-2447.934,-466.3733;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.NormalizeNode;13;-2197.848,248.2713;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-2359.634,-864.5778;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;-2431.881,-376.2903;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;16;-1928.429,701.7581;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;-1681.83,1220.94;Inherit;False;Property;_GeneralShift;GeneralShift;7;0;Create;True;0;0;0;False;0;False;0.8;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-1917.53,1602.304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1269.83,1045.94;Inherit;False;Property;_Highlight_1_Shift;Highlight_1_Shift;4;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-2195.145,-394.5987;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;5;-2155.634,-863.5778;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;15;-1748.473,592.7936;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-1492.83,1082.94;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;776.2709,633.6908;Inherit;False;370;280;BaseTexture (Gray);1;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1941.593,-862.7657;Inherit;False;LightDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1011.83,1057.94;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;17;-1547.053,594.6915;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1259.83,1222.94;Inherit;False;Property;_Highlight_2_Shift;Highlight_2_Shift;5;0;Create;True;0;0;0;False;0;False;0.05;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;823.1448,668.0603;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;0;False;0;False;-1;ff68836c59202944380e84509e80d8e5;065cea1018970c649bd1389466cecb6c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-1951.949,-397.4789;Inherit;False;ViewVector;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;142;970.377,896.0994;Inherit;False;Property;_Desaturate_TextureColor;Desaturate_TextureColor;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;66;-355.765,59.38558;Inherit;False;996.1727;488.5634;Primary Highlight;5;50;48;46;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-737.043,210.469;Inherit;False;291;209;Shift Tangent 1;1;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;149;1250.493,1014.536;Inherit;False;Constant;_Float2;Float 2;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;1260.379,1138.808;Inherit;False;Property;_Texture_Strength;Texture_Strength;20;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-995.8301,1229.94;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-260.5923,362.949;Inherit;False;Property;_Highlight_1_Strength;Highlight_1_Strength;9;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-305.765,109.3856;Inherit;False;47;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-295.5923,195.949;Inherit;False;49;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-257.5923,279.949;Inherit;False;Property;_Highlight_1_Power;Highlight_1_Power;6;0;Create;True;0;0;0;False;0;False;1000;400;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;43;-687.043,260.469;Inherit;False;ASEF_ShiftTangent;-1;;16;39d09a43ecc973744b8339a00c34f086;0;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DesaturateOpNode;141;1206.377,741.0994;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;45;-732.8954,530.0141;Inherit;False;291;209;Shift Tangent 2;1;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-339.1427,567.5775;Inherit;False;1037.55;478.3715;Secondary Highlight;5;56;54;55;57;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-278.97,704.141;Inherit;False;49;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;147;1455.178,965.9475;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;42;-682.8954,580.0141;Inherit;False;ASEF_ShiftTangent;-1;;20;39d09a43ecc973744b8339a00c34f086;0;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;77;1366.044,1272.005;Inherit;False;Property;_Hair_Color;Hair_Color;14;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;46;93.46875,110.5522;Inherit;False;ASEF_StrandSpec;-1;;21;bbb8858f7ec589241a0890523416146f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-289.1427,617.5775;Inherit;False;47;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-243.97,871.141;Inherit;False;Property;_Highlight_2_Strength;Highlight_2_Strength;10;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-240.97,788.141;Inherit;False;Property;_Highlight_2_Power;Highlight_2_Power;8;0;Create;True;0;0;0;False;0;False;1000;21.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;1838.188,575.0096;Inherit;False;Property;_Highlight_1_Color;Highlight_1_Color;11;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.9215125,0.8632076,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;2114.176,555.5693;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1667.136,957.1997;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;62;2189.026,1199.196;Inherit;False;Property;_Highlight_2_Color;Highlight_2_Color;12;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.648978,0.3349057,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;53;110.0911,618.7441;Inherit;False;ASEF_StrandSpec;-1;;22;bbb8858f7ec589241a0890523416146f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;2493.698,1131.217;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;34;-2908.958,910.3703;Inherit;False;1127.223;482.0001;Jitter Control;7;19;20;24;25;22;23;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;2354.132,714.3843;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexBinormalNode;110;-3925.218,457.1764;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;111;-3919.074,604.2227;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.MatrixFromVectors;113;-3697.731,428.4516;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.LerpOp;25;-1968.535,1057.371;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2180.573,1127.179;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;139;2685.148,911.1437;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;138;2358.633,917.9476;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;2693.653,745.6212;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;104;-3275.54,-958.2679;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-2191.573,989.8316;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-1690.218,1084.329;Inherit;False;Constant;_Float4;Float 4;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2647.435,1245.87;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;108;-3434.66,381.3476;Inherit;False;return TransformWorldToTangent(Input, tangentTransform_World);1;False;4;True;Input;FLOAT;0;In;;Inherit;False;True;tangentTransform_World;FLOAT3x3;1,0,0,1,1,1,1,0,1;In;;Inherit;False;True;In1;FLOAT3;0,0,0;In;;Inherit;False;True;In2;FLOAT3;0,0,0;In;;Inherit;False;WorldToTangent;True;False;0;4;0;FLOAT;0;False;1;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexTangentNode;109;-3926.443,313.7569;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;20;-2677.948,1037.546;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;9999;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2458.535,1041.371;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2872.858,1032.084;Inherit;False;Property;_Jitter;Jitter;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;137;3141.096,806.3047;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Hair;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;False;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;130;5;140;0
WireConnection;92;0;130;0
WireConnection;126;0;81;0
WireConnection;126;1;127;0
WireConnection;132;0;32;3
WireConnection;132;1;133;0
WireConnection;115;0;114;0
WireConnection;115;1;92;0
WireConnection;13;0;115;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;78;0;8;0
WireConnection;78;1;126;0
WireConnection;134;0;132;0
WireConnection;134;1;135;0
WireConnection;89;0;88;0
WireConnection;89;1;78;0
WireConnection;5;0;3;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;35;0;134;0
WireConnection;35;1;36;0
WireConnection;47;0;5;0
WireConnection;38;0;40;0
WireConnection;38;1;35;0
WireConnection;17;0;15;0
WireConnection;49;0;89;0
WireConnection;39;0;41;0
WireConnection;39;1;35;0
WireConnection;43;3;13;0
WireConnection;43;1;17;0
WireConnection;43;2;38;0
WireConnection;141;0;68;0
WireConnection;141;1;142;0
WireConnection;147;0;149;0
WireConnection;147;1;141;0
WireConnection;147;2;148;0
WireConnection;42;3;13;0
WireConnection;42;1;17;0
WireConnection;42;2;39;0
WireConnection;46;1;43;0
WireConnection;46;2;48;0
WireConnection;46;3;50;0
WireConnection;46;4;51;0
WireConnection;46;5;52;0
WireConnection;144;0;46;0
WireConnection;144;1;60;0
WireConnection;76;0;147;0
WireConnection;76;1;77;0
WireConnection;53;1;42;0
WireConnection;53;2;54;0
WireConnection;53;3;55;0
WireConnection;53;4;56;0
WireConnection;53;5;57;0
WireConnection;146;0;53;0
WireConnection;146;1;62;0
WireConnection;143;0;144;0
WireConnection;143;1;76;0
WireConnection;113;0;109;0
WireConnection;113;1;110;0
WireConnection;113;2;111;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;25;2;32;3
WireConnection;24;0;21;0
WireConnection;24;1;22;0
WireConnection;139;0;143;0
WireConnection;139;1;60;0
WireConnection;139;2;46;0
WireConnection;138;0;76;0
WireConnection;138;1;62;0
WireConnection;138;2;53;0
WireConnection;145;0;143;0
WireConnection;145;1;146;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;108;1;113;0
WireConnection;20;0;19;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;137;10;68;4
WireConnection;137;13;145;0
ASEEND*/
//CHKSM=C072D365E1855C4BA3074E63FF44DE4E75ED1C43