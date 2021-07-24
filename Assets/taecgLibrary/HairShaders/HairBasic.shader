//by taecg@qq.com
//created 2018/01/20	
//updated 2019/05/16
//头发Basic V2版本

Shader "taecg/Hair/Hair Basic"
{
	Properties
	{
		[Header(Base)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 0
		_Color ("Color",Color) = (1,1,1,1)
		_Emiss("Emiss", Range(0, 2)) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_Cutoff("Cutoff (MainTex A)", Range(0, 1)) = 0.35

		[Header(Normal)]
		_NormalTex("NormalTex", 2D) = "normalTex" {}
		_NormalIntensity("_NormalIntensity", Range(0 , 200000)) = 0

		[Header(Specular)]
		_AnisoDir("SpecShift (G),Spec Mask (B)", 2D) = "white" {}
		_SpecularIntenstiy("Specular Intensity", Range(0, 5)) = 1.0
		_PrimarySpecularColor("Primary Specular Color", Color) = (1,1,1,1)
		_PrimarySpecularMultiplier("Primary Specular Multiplier", float) = 100.0
		_PrimaryShift("Primary Specular Shift", float) = 0.0
		_SecondarySpecularColor("Secondary Specular Color", Color) = (0.5,0.5,0.5,1)
		_SecondarySpecularMultiplier("Secondary Specular Multiplier", float) = 100.0
		_SecondaryShift("Secondary Specular Shift", float) = 0.7
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent" }
		Cull [_Cull]

		//不透明Pass,目的在于渲染基本纹理及基本光照，同时做AlphaTest
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			#pragma skip_variants DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN SHADOWS_SHADOWMASK  
			//#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			sampler2D _NormalTex;float4 _NormalTex_ST;
			half _NormalIntensity;
			sampler2D _MainTex;float4 _MainTex_ST;
			fixed _Cutoff;
			fixed4 _Color;
			half _Emiss;

			struct appdata 
			{
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				UNITY_POSITION(pos);
				half4 uv : TEXCOORD0;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;

#if UNITY_SHOULD_SAMPLE_SH
				half3 sh : TEXCOORD4;
#endif

				UNITY_SHADOW_COORDS(5)
				UNITY_FOG_COORDS(6)
			};

			v2f vert(appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord.zw, _NormalTex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
				o.sh = 0;
				// Approximated illumination from non-important point lights
#ifdef VERTEXLIGHT_ON
				o.sh += Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
					unity_4LightAtten0, worldPos, worldNormal);
#endif
				o.sh = ShadeSHPerVertex(worldNormal, o.sh);
#endif

				UNITY_TRANSFER_SHADOW(o,v.texcoord1.xy); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			fixed4 frag(v2f i) : SV_Target 
			{
				float3 worldPos = float3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT(SurfaceOutput, o);
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Specular = 0.0;
				o.Alpha = 0.0;
				o.Gloss = 0.0;
				o.Normal = fixed3(0,0,1);

				o.Normal = UnpackScaleNormal(tex2D(_NormalTex, i.uv.zw), _NormalIntensity);
				fixed4 mainTex = tex2D(_MainTex,i.uv.xy);
				o.Albedo = mainTex.rgb * _Color * _Emiss;
				o.Alpha = 1;
				clip(mainTex.a - _Cutoff);

				UNITY_LIGHT_ATTENUATION(atten, i, worldPos)

				fixed4 c = 0;
				fixed3 worldN;
				worldN.x = dot(i.tSpace0.xyz, o.Normal);
				worldN.y = dot(i.tSpace1.xyz, o.Normal);
				worldN.z = dot(i.tSpace2.xyz, o.Normal);
				worldN = normalize(worldN);
				o.Normal = worldN;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;

				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = worldPos;
				giInput.atten = atten;
				#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
					giInput.ambient = i.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
				LightingLambert_GI(o, giInput, gi);

				c += LightingLambert(o, gi);

				UNITY_APPLY_FOG(i.fogCoord, c);
				return c;
			}
			ENDCG
		}

		//头发主要效果Pass，包括头发高光的实现
		Pass
		{
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			ZWrite Off
			Cull[_Cull]
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			#pragma skip_variants DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON LIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SCREEN SHADOWS_SHADOWMASK  
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			sampler2D _MainTex, _AnisoDir,_NormalTex;
			float4 _MainTex_ST, _AnisoDir_ST,_NormalTex_ST;
			fixed4 _Color;
			half _Emiss;
			half _PrimarySpecularMultiplier, _PrimaryShift,_SpecularIntenstiy,_SecondaryShift,_SecondarySpecularMultiplier;
			half4 _PrimarySpecularColor,_SecondarySpecularColor;
			half _Cutoff;
			half _NormalIntensity;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				UNITY_POSITION(pos);
				half4 uv : TEXCOORD0;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;

				#if UNITY_SHOULD_SAMPLE_SH
				half3 sh : TEXCOORD4;
				#endif

				UNITY_SHADOW_COORDS(5)
				UNITY_FOG_COORDS(6)
			};

			v2f vert(appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord.zw, _NormalTex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

		#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
				o.sh = 0;
				// Approximated illumination from non-important point lights
		#ifdef VERTEXLIGHT_ON
				o.sh += Shade4PointLights(
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, worldPos, worldNormal);
		#endif
				o.sh = ShadeSHPerVertex(worldNormal, o.sh);
		#endif

				UNITY_TRANSFER_SHADOW(o,v.texcoord1.xy); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			//发丝高光
			fixed StrandSpecular(fixed3 T, fixed3 V, fixed3 L, fixed exponent)
			{
				fixed3 H = normalize(L + V);
				fixed dotTH = dot(T, H);
				fixed sinTH = sqrt(1 - dotTH * dotTH);
				fixed dirAtten = smoothstep(-1, 0, dotTH);
				//return dirAtten * pow(sinTH, exponent);
				return pow(sinTH, exponent);
			}

			//切线扰动
			fixed3 ShiftTangent(fixed3 T, fixed3 N, fixed shift)
			{
				return normalize(T + shift * N);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 worldPos = float3(i.tSpace0.w, i.tSpace1.w, i.tSpace2.w);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT(SurfaceOutput, o);
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Specular = 0.0;
				o.Alpha = 0.0;
				o.Gloss = 0.0;
				o.Normal = fixed3(0,0,1);

				o.Normal = UnpackScaleNormal(tex2D(_NormalTex, i.uv.zw), _NormalIntensity);
				//基础纹理
				fixed4 mainTex = tex2D(_MainTex, i.uv.xy);
				o.Albedo = mainTex.rgb;
				o.Alpha = 1;

				// compute lighting & shadowing factor
				UNITY_LIGHT_ATTENUATION(atten, i, worldPos)

				fixed3 worldN;
				worldN.x = dot(i.tSpace0.xyz, o.Normal);
				worldN.y = dot(i.tSpace1.xyz, o.Normal);
				worldN.z = dot(i.tSpace2.xyz, o.Normal);
				worldN = normalize(worldN);
				o.Normal = worldN;

				// Setup lighting environment
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;

				// Call GI (lightmaps/SH/reflections) lighting function
				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = worldPos;
				giInput.atten = atten;
				//#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				//	giInput.lightmapUV = i.lmap;
				//#else
				//	giInput.lightmapUV = 0.0;
				//#endif
				#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
					giInput.ambient = i.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
					LightingLambert_GI(o, giInput, gi);

				fixed4 diffuse = LightingLambert(o, gi);
				diffuse *= _Color * _Emiss;
				diffuse.a = mainTex.a;

				//采样法线纹理
				fixed3 normalTex = UnpackScaleNormal(tex2D(_NormalTex, i.uv.zw),_NormalIntensity);
				//最终法线的计算，将TBN与法线纹理点乘
				fixed3 worldNormal = normalize(float3(dot(i.tSpace0.xyz, normalTex), dot(i.tSpace1.xyz, normalTex), dot(i.tSpace2.xyz, normalTex)));

				//重新通过TBN获取世界位置、切线、副切线
				fixed3 worldTangent = normalize(float3(i.tSpace0.x, i.tSpace1.x, i.tSpace2.x));
				fixed3 worldBinormal = normalize(float3(i.tSpace0.y, i.tSpace1.y, i.tSpace2.y));

				//获取视角方向、灯光方向在世界空间下的坐标
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));

				//采样高光纹理
				fixed3 spec = tex2D(_AnisoDir, i.uv).rgb;

				half shiftTex = spec.r;
				//half shiftTex = 0.5;
				//切线扰动
				half3 t1 = ShiftTangent(worldBinormal, worldNormal, _PrimaryShift + shiftTex);
				half3 t2 = ShiftTangent(worldBinormal, worldNormal, _SecondaryShift + shiftTex);

				//高光计算
				half3 spec1 = StrandSpecular(t1, worldViewDir, worldLightDir, _PrimarySpecularMultiplier) * _PrimarySpecularColor;
				half3 spec2 = StrandSpecular(t2, worldViewDir, worldLightDir, _SecondarySpecularMultiplier) * _SecondarySpecularColor;
				//return fixed4(diffuseColor,1);

				//最终混合
				fixed4 finalColor = 0;
				finalColor += diffuse;
				finalColor.rgb += spec1 * _SpecularIntenstiy;
				finalColor.rgb += spec2 * _SpecularIntenstiy;
				finalColor.rgb *= _LightColor0.rgb;

				UNITY_APPLY_FOG(i.fogCoord, finalColor);
				return finalColor;
			}
			ENDCG
		}

		//ForwardAdd Pass
		Pass
		{
			Name "FORWARD"
			Tags { "LightMode" = "ForwardAdd" }
			ZWrite Off
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_fog
			#pragma multi_compile_fwdadd_fullshadows novertexlight noshadowmask nodynlightmap nodirlightmap nolightmap
			#define UNITY_PASS_FORWARDADD
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			sampler2D _NormalTex; float4 _NormalTex_ST;
			half _NormalIntensity;
			sampler2D _MainTex; float4 _MainTex_ST;
			fixed _Cutoff;
			fixed4 _Color;
			half _Emiss;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				UNITY_POSITION(pos);
				half4 uv : TEXCOORD0;
				fixed3 tSpace0 : TEXCOORD1;
				fixed3 tSpace1 : TEXCOORD2;
				fixed3 tSpace2 : TEXCOORD3;
				float3 worldPos : TEXCOORD4;
				UNITY_SHADOW_COORDS(5)
				UNITY_FOG_COORDS(6)
			};

			v2f vert(appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord.zw, _NormalTex);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = fixed3(worldTangent.x, worldBinormal.x, worldNormal.x);
				o.tSpace1 = fixed3(worldTangent.y, worldBinormal.y, worldNormal.y);
				o.tSpace2 = fixed3(worldTangent.z, worldBinormal.z, worldNormal.z);
				o.worldPos = worldPos;

				UNITY_TRANSFER_SHADOW(o,v.texcoord1.xy);
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 worldPos = i.worldPos;
				#ifndef USING_DIRECTIONAL_LIGHT
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
				fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif
				#ifdef UNITY_COMPILER_HLSL
				SurfaceOutput o = (SurfaceOutput)0;
				#else
				SurfaceOutput o;
				#endif
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Specular = 0.0;
				o.Alpha = 0.0;
				o.Gloss = 0.0;
				fixed3 normalWorldVertex = fixed3(0,0,1);
				o.Normal = fixed3(0,0,1);

				o.Normal = UnpackScaleNormal(tex2D(_NormalTex, i.uv.zw), _NormalIntensity);
				fixed4 mainTex = tex2D(_MainTex, i.uv.xy);
				o.Albedo = mainTex.rgb * _Color * _Emiss;
				o.Alpha = 1;
				clip(mainTex.a - _Cutoff);

				UNITY_LIGHT_ATTENUATION(atten, i, worldPos)
				fixed4 c = 0;
				fixed3 worldN;
				worldN.x = dot(i.tSpace0.xyz, o.Normal);
				worldN.y = dot(i.tSpace1.xyz, o.Normal);
				worldN.z = dot(i.tSpace2.xyz, o.Normal);
				worldN = normalize(worldN);
				o.Normal = worldN;

				// Setup lighting environment
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;
				gi.light.color *= atten;
				c += LightingLambert(o, gi);
				UNITY_APPLY_FOG(i.fogCoord, c);
				return c;
			}
			ENDCG
		}

		//阴影Pass
		Pass
		{
			Name "Caster"
			Tags { "LightMode" = "ShadowCaster" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2  uv : TEXCOORD1;
			};

			sampler2D _MainTex; float4 _MainTex_ST;
			fixed _Cutoff;

			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				fixed4 mainTex = tex2D(_MainTex, i.uv);
				clip(mainTex.a - _Cutoff);

				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}

	}

	FallBack "Legacy Shaders/Transparent/Cutout/Soft Edge Unlit"
}