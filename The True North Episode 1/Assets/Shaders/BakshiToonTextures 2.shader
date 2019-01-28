// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sebula/BakshiToonEyes"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Lighteffect("Light effect", Color) = (0.5220588,0.5220588,0.5220588,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Lighteffect;
		uniform float _MaskClipValue = 0.5;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode11 = tex2D( _Albedo, uv_Albedo );
			o.Emission = lerp( tex2DNode11 , ( saturate( ( tex2DNode11 * _Lighteffect ) )) , 1.0 ).rgb;
			o.Alpha = 1;
			clip( tex2DNode11.a - _MaskClipValue );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=11001
1820;106;1906;1042;1610.598;940.7008;1.3;True;True
Node;AmplifyShaderEditor.ColorNode;155;-875.4978,-162.0004;Float;False;Property;_Lighteffect;Light effect;2;0;0.5220588,0.5220588,0.5220588,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;11;-651.6013,-609.1988;Float;True;Property;_Albedo;Albedo;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BlendOpsNode;154;-619.2979,-300.5007;Float;False;Multiply;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;158;-364.2976,-384.5009;Float;False;3;0;FLOAT4;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;80.39994,-578.0995;Float;False;True;6;Float;ASEMaterialInspector;0;Unlit;sebula/BakshiToonEyes;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;True;0;True;Transparent;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0.0001;0,0,0,0;VertexOffset;False;Spherical;Relative;0;;0;-1;-1;-1;0;14;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;154;0;11;0
WireConnection;154;1;155;0
WireConnection;158;0;11;0
WireConnection;158;1;154;0
WireConnection;0;2;158;0
WireConnection;0;10;11;4
ASEEND*/
//CHKSM=C7165F9BC8C7E31DEAFF0B0F7815653D5B5CB0A7