// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sebula/ToonRaster"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0.004
		_Diffuse("Diffuse", 2D) = "white" {}
		_TextureSample8("Texture Sample 8", 2D) = "white" {}
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_raster("raster", Range( 0.6 , 8)) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:outlineVertexDataFunc
		uniform fixed4 _ASEOutlineColor;
		uniform fixed _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline fixed4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return fixed4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o ) { o.Emission = _ASEOutlineColor.rgb; o.Alpha = 1; }
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform sampler2D _TextureSample3;
		uniform float _raster;
		uniform sampler2D _TextureSample6;
		uniform sampler2D _TextureSample8;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#if DIRECTIONAL
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_lightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			float dotResult3 = dot( i.worldNormal , ase_lightDir );
			float temp_output_88_0 = round( dotResult3 );
			float4 temp_cast_0 = (temp_output_88_0).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPos93 = ase_screenPos;
			float2 componentMask95 = ase_screenPos93.xy;
			float2 temp_output_100_0 = ( ( componentMask95 / max( ase_screenPos93.w , 0.01 ) ) * ( float2( 80,60 ) * _raster ) );
			float4 temp_cast_4 = (temp_output_88_0).xxxx;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_indirectDiffuse = ShadeSH9( float4( ase_worldNormal, 1 ) );
			c.rgb = ( ( tex2D( _Diffuse, uv_Diffuse ) * ( saturate( ( 1.0 - ( 1.0 - (( dotResult3 > -0.2 ) ? (( dotResult3 > 0.2 ) ? (( dotResult3 > 0.6 ) ? temp_cast_0 :  tex2D( _TextureSample3, temp_output_100_0 ) ) :  tex2D( _TextureSample6, temp_output_100_0 ) ) :  tex2D( _TextureSample8, temp_output_100_0 ) ) ) * ( 1.0 - temp_cast_4 ) ) )) ) * ( _LightColor0 * float4( ( ase_indirectDiffuse + ase_lightAtten ) , 0.0 ) ) ).xyz;
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
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD6;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				float4 texcoords01 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord.xy = IN.texcoords01.xy;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
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
Version=11001
1927;173;1841;898;2466.38;1049.902;1.6;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;93;-1596.535,-853.5917;Float;False;1;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;95;-1324.935,-832.3916;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.Vector2Node;96;-1420.518,-529.326;Float;False;Constant;_Vector1;Vector 1;5;0;80,60;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMaxOp;97;-1396.337,-688.7926;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.01;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;48;-1484,-85.80003;Float;False;540.401;320.6003;Comment;3;1;3;2;N . L;0;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-1460.118,-345.226;Float;False;Property;_raster;raster;4;0;0.2;0.6;8;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;98;-1186.837,-712.7926;Float;False;2;0;FLOAT2;0.0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1190.418,-484.326;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-1420,122.2;Float;False;1;0;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.WorldNormalVector;1;-1372,-37.80003;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-1059.135,-575.7918;Float;False;2;2;0;FLOAT2;0.0,0;False;1;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.DotProductOpNode;3;-1084,26.19998;Float;False;2;0;FLOAT3;0.0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RoundOpNode;88;-587.2782,96.09795;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;101;-936.5182,-306.0258;Float;True;Property;_TextureSample3;Texture Sample 3;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TFHCCompareGreater;106;-439.1792,-534.2017;Float;False;4;0;FLOAT;0.0;False;1;FLOAT;0.6;False;2;FLOAT;0.0;False;3;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;102;-837.3172,-532.5259;Float;True;Property;_TextureSample6;Texture Sample 6;2;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;52;-880,320;Float;False;812;304;Comment;5;7;8;11;10;12;Attenuation and Ambient;0;0
Node;AmplifyShaderEditor.TFHCCompareGreater;105;-423.5791,-361.3017;Float;False;4;0;FLOAT;0.0;False;1;FLOAT;0.2;False;2;FLOAT4;0,0,0,0;False;3;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;103;-740.5168,-764.5258;Float;True;Property;_TextureSample8;Texture Sample 8;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.IndirectDiffuseLighting;11;-624,448;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.TFHCCompareGreater;104;-463.88,-192.6016;Float;False;4;0;FLOAT;0.0;False;1;FLOAT;-0.2;False;2;FLOAT4;0.0,0,0,0;False;3;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.LightAttenuation;7;-809.6001,504;Float;False;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;43;-224,-304;Float;True;Property;_Diffuse;Diffuse;0;0;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BlendOpsNode;90;-231.6797,-44.6014;Float;False;Screen;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LightColorNode;8;-768,368;Float;False;0;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-384,480;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-224,368;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;220.7999,-38.40003;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;443.1002,248.2;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1077.3,350.7;Float;False;True;2;Float;ASEMaterialInspector;0;CustomLighting;sebula/ToonRaster;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;True;0.004;0,0,0,0;VertexOffset;False;Cylindrical;Relative;0;;-1;-1;-1;-1;0;14;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;95;0;93;0
WireConnection;97;0;93;4
WireConnection;98;0;95;0
WireConnection;98;1;97;0
WireConnection;99;0;96;0
WireConnection;99;1;94;0
WireConnection;100;0;98;0
WireConnection;100;1;99;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;88;0;3;0
WireConnection;101;1;100;0
WireConnection;106;0;3;0
WireConnection;106;2;88;0
WireConnection;106;3;101;0
WireConnection;102;1;100;0
WireConnection;105;0;3;0
WireConnection;105;2;106;0
WireConnection;105;3;102;0
WireConnection;103;1;100;0
WireConnection;104;0;3;0
WireConnection;104;2;105;0
WireConnection;104;3;103;0
WireConnection;90;0;104;0
WireConnection;90;1;88;0
WireConnection;12;0;11;0
WireConnection;12;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;12;0
WireConnection;42;0;43;0
WireConnection;42;1;90;0
WireConnection;23;0;42;0
WireConnection;23;1;10;0
WireConnection;0;2;23;0
ASEEND*/
//CHKSM=35128280696D6FB591AD65F5947554A3E80AAF88