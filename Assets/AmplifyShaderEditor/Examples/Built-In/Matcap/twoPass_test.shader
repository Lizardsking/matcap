// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "twoPass_test"
{
	Properties
	{
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color2("Color2", Color) = (1,0,0,0)

	}
	
	SubShader
	{
		LOD 0

		Tags { "RenderType"="Transparent" }
		
		Pass
		{
			
			Name "First"
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend Off
			AlphaToMask Off
			Cull Back
			ColorMask RGBA
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform float4 _Color2;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				
				
				finalColor = _Color2;
				return finalColor;
			}
			ENDCG
		}

		
		Pass
		{
			Name "Second"
			
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend Off
			AlphaToMask Off
			Cull Back
			ColorMask RGBA
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform float4 _Color0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				
				
				finalColor = _Color0;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-1920;108;1920;1029;984.6544;630.6061;1.001542;True;True
Node;AmplifyShaderEditor.CommentaryNode;9;-5864.567,-1416.364;Inherit;False;1438.405;575.2569;Camera view;8;47;37;32;29;22;19;17;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;41;-2217.313,-240.872;Inherit;False;370;280;BaseTexture (Gray);2;48;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-5775.535,542.8512;Inherit;False;1311.857;596.1176;Anisotropic Control Texture;5;35;25;24;16;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-4972.015,-335.0713;Inherit;False;606.3762;350.2667;Tangent;3;44;39;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-5830.669,-1346.4;Inherit;False;241;238;ViewDir = Camera Vector;1;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-3332.727,-306.9853;Inherit;False;1037.55;478.3715;Secondary Highlight;5;74;69;68;67;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;60;-3726.48,-344.5487;Inherit;False;291;209;Shift Tangent 2;1;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-5829.195,-1836.736;Inherit;False;1220.146;401.735;LightVector;5;42;38;31;23;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-5902.542,35.80742;Inherit;False;1127.223;482.0001;Jitter Control;7;94;93;92;89;87;82;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-3730.627,-664.0938;Inherit;False;291;209;Shift Tangent 1;1;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;-3349.349,-815.1772;Inherit;False;996.1727;488.5634;Primary Highlight;5;66;57;56;55;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;7;-6021.804,-797.7181;Inherit;False;1000.292;493.4901;Normal;5;30;26;14;13;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-4725.416,144.3772;Inherit;False;415;318;ShiftHeightControl;3;88;40;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;65;-1627.54,397.4422;Inherit;False;Property;_Hair_Color1;Hair_Color;13;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-5990.98,-635.8839;Inherit;True;Property;_Hair_normal1;Hair_normal;14;0;Create;True;0;0;0;False;0;False;-1;b5b2ed88ee9b5c04f96fb8005220b17a;b5b2ed88ee9b5c04f96fb8005220b17a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-6246.167,-650.5837;Inherit;False;Property;_Normal_Strength1;Normal_Strength;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-5608.658,-935.7391;Inherit;False;Constant;_Float4;Float 3;15;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;17;-5831.15,-1076.507;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-5346.314,873.3414;Inherit;False;Property;_Jitter_Balance1;Jitter_Balance;16;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;14;-5675.167,-698.0415;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SamplerNode;12;-5591.129,682.8513;Inherit;True;Property;_ShiftTexture1;ShiftTexture;2;0;Create;True;0;0;0;False;0;False;-1;1af753fb792298c47809dc7f0cbc6849;1af753fb792298c47809dc7f0cbc6849;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;30;-5191.433,-626.2914;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-5141.516,890.9412;Inherit;False;Property;_JitterStrength1;JitterStrength;15;0;Create;True;0;0;0;False;0;False;0;3.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-5541.043,-1107.218;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;13;-5681.432,-624.7875;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-5392.03,-636.6702;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-5425.466,-1250.853;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;20;-5761.928,-1746.761;Inherit;False;Property;_LIghtDirection1;LIghtDirection;0;0;Create;True;0;0;0;False;0;False;1,-0.5,0;-1,-1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-5174.158,252.6161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-5144.716,751.7413;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-4486.416,208.3771;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1743.091,139.9732;Inherit;False;Constant;_Float3;Float 2;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;58;-3680.627,-614.0938;Inherit;False;ASEF_ShiftTangent;-1;;16;39d09a43ecc973744b8339a00c34f086;0;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2023.207,21.53653;Inherit;False;Property;_Desaturate_TextureColor1;Desaturate_TextureColor;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;97;1.864441,-418.2792;Inherit;False;Property;_Color2;Color2;21;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;44;-4540.639,-279.8713;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-4945.534,-1272.042;Inherit;False;ViewVector;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-4005.414,183.3771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-5188.73,-1269.162;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4263.416,171.3771;Inherit;False;Property;_Highlight_1_Shift1;Highlight_1_Shift;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3254.176,-511.6138;Inherit;False;Property;_Highlight_1_Strength1;Highlight_1_Strength;8;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;39;-4742.059,-281.7692;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;46;-2170.439,-206.5025;Inherit;True;Property;_TextureSample1;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;ff68836c59202944380e84509e80d8e5;065cea1018970c649bd1389466cecb6c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;55;-3299.349,-765.1771;Inherit;False;47;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-4911.115,727.7413;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;29;-5441.519,-1340.936;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.ColorNode;96;18.89076,-97.78553;Inherit;False;Property;_Color0;Color 0;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;33;-4922.015,-172.8047;Inherit;False;Constant;_Vector1;Vector 0;1;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-3989.414,355.3771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-4253.416,348.3771;Inherit;False;Property;_Highlight_2_Shift1;Highlight_2_Shift;4;0;Create;True;0;0;0;False;0;False;0.05;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-3289.176,-678.6138;Inherit;False;47;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3251.176,-594.6137;Inherit;False;Property;_Highlight_1_Power1;Highlight_1_Power;5;0;Create;True;0;0;0;False;0;False;1000;400;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-5523.776,-1608.285;Inherit;False;Constant;_Float1;Float 0;1;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-5353.219,-1739.141;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-3282.727,-256.9853;Inherit;False;47;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-499.8858,256.6542;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexBinormalNode;78;-6918.802,-417.3864;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-639.4517,-160.1785;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3234.554,-86.42186;Inherit;False;Property;_Highlight_2_Power1;Highlight_2_Power;7;0;Create;True;0;0;0;False;0;False;1000;21.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;59;-1787.207,-133.4634;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-4935.179,-1737.328;Inherit;False;LightDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1733.205,264.2451;Inherit;False;Property;_Texture_Strength1;Texture_Strength;19;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-879.4077,-318.9935;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;63;-1538.406,91.38463;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;79;-6912.658,-270.3401;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;64;-3676.48,-294.5487;Inherit;False;ASEF_ShiftTangent;-1;;20;39d09a43ecc973744b8339a00c34f086;0;3;3;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-3272.554,-170.4218;Inherit;False;47;ViewVector;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;73;-804.558,324.6332;Inherit;False;Property;_Highlight_2_Color1;Highlight_2_Color;11;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.648978,0.3349057,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1326.448,82.63683;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;74;-2883.493,-255.8187;Inherit;False;ASEF_StrandSpec;-1;;22;bbb8858f7ec589241a0890523416146f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-4675.416,346.3771;Inherit;False;Property;_GeneralShift1;GeneralShift;6;0;Create;True;0;0;0;False;0;False;0.8;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;66;-2900.115,-764.0106;Inherit;False;ASEF_StrandSpec;-1;;21;bbb8858f7ec589241a0890523416146f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-5866.442,157.5211;Inherit;False;Property;_Jitter1;Jitter;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-5641.02,371.3072;Inherit;False;Constant;_Float2;Float 1;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;-308.4358,36.5808;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-3237.554,-3.421895;Inherit;False;Property;_Highlight_2_Strength1;Highlight_2_Strength;9;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-299.9305,-128.9416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;38;-5149.22,-1738.141;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;90;-6428.244,-493.2152;Inherit;False;return TransformWorldToTangent(Input, tangentTransform_World);1;False;4;True;Input;FLOAT;0;In;;Inherit;False;True;tangentTransform_World;FLOAT3x3;1,0,0,1,1,1,1,0,1;In;;Inherit;False;True;In1;FLOAT3;0,0,0;In;;Inherit;False;True;In2;FLOAT3;0,0,0;In;;Inherit;False;WorldToTangent;True;False;0;4;0;FLOAT;0;False;1;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;-1155.396,-299.5532;Inherit;False;Property;_Highlight_1_Color1;Highlight_1_Color;10;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.9215125,0.8632076,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;21;-5780.669,-1296.4;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;84;-634.9507,43.38469;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.MatrixFromVectors;80;-6691.315,-446.1112;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;-5185.158,115.2687;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-5452.12,166.8081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;92;-5671.532,162.9831;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;9999;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexTangentNode;91;-6920.027,-560.8058;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;88;-4683.804,209.7662;Inherit;False;Constant;_Float5;Float 4;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;86;-6269.125,-1832.831;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;81;-4962.121,182.8081;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;353.5429,-406.3932;Float;False;True;-1;2;ASEMaterialInspector;0;9;twoPass_test;003dfa9c16768d048b74f75c088119d8;True;First;0;0;First;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Transparent=RenderType;False;0;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;True;2;0;;0;0;Standard;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;364.7658,-101.8505;Float;False;False;-1;2;ASEMaterialInspector;0;9;New Amplify Shader;003dfa9c16768d048b74f75c088119d8;True;Second;0;1;Second;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;0;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;True;2;0;;0;0;Standard;0;False;0
WireConnection;11;5;8;0
WireConnection;30;0;26;0
WireConnection;22;0;17;0
WireConnection;22;1;15;0
WireConnection;13;0;11;0
WireConnection;26;0;14;0
WireConnection;26;1;13;0
WireConnection;32;0;21;0
WireConnection;32;1;22;0
WireConnection;82;0;93;0
WireConnection;82;1;89;0
WireConnection;25;0;12;3
WireConnection;25;1;16;0
WireConnection;40;0;35;0
WireConnection;40;1;34;0
WireConnection;58;3;30;0
WireConnection;58;1;44;0
WireConnection;58;2;43;0
WireConnection;44;0;39;0
WireConnection;47;0;37;0
WireConnection;43;0;36;0
WireConnection;43;1;40;0
WireConnection;37;0;29;0
WireConnection;37;1;32;0
WireConnection;39;0;30;0
WireConnection;39;1;33;0
WireConnection;35;0;25;0
WireConnection;35;1;24;0
WireConnection;53;0;45;0
WireConnection;53;1;40;0
WireConnection;31;0;20;0
WireConnection;31;1;23;0
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;77;0;71;0
WireConnection;77;1;72;0
WireConnection;59;0;46;0
WireConnection;59;1;48;0
WireConnection;42;0;38;0
WireConnection;71;0;66;0
WireConnection;71;1;70;0
WireConnection;63;0;51;0
WireConnection;63;1;59;0
WireConnection;63;2;52;0
WireConnection;64;3;30;0
WireConnection;64;1;44;0
WireConnection;64;2;53;0
WireConnection;72;0;63;0
WireConnection;72;1;65;0
WireConnection;74;1;64;0
WireConnection;74;2;67;0
WireConnection;74;3;62;0
WireConnection;74;4;69;0
WireConnection;74;5;68;0
WireConnection;66;1;58;0
WireConnection;66;2;55;0
WireConnection;66;3;56;0
WireConnection;66;4;57;0
WireConnection;66;5;54;0
WireConnection;83;0;77;0
WireConnection;83;1;70;0
WireConnection;83;2;66;0
WireConnection;85;0;77;0
WireConnection;85;1;75;0
WireConnection;38;0;31;0
WireConnection;90;1;80;0
WireConnection;84;0;72;0
WireConnection;84;1;73;0
WireConnection;84;2;74;0
WireConnection;80;0;91;0
WireConnection;80;1;78;0
WireConnection;80;2;79;0
WireConnection;87;0;93;0
WireConnection;87;1;89;0
WireConnection;93;0;92;0
WireConnection;93;1;89;0
WireConnection;92;0;94;0
WireConnection;81;0;87;0
WireConnection;81;1;82;0
WireConnection;81;2;12;3
WireConnection;5;0;97;0
WireConnection;6;0;96;0
ASEEND*/
//CHKSM=42EDCC771E103D6D4929A5211894A67CC98F7FC1