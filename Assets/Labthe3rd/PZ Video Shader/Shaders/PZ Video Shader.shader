// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "labthe3rd/PZ Video Shader"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		[Toggle(_APPLYGAMMA_ON)] _ApplyGamma("ApplyGamma", Float) = 0
		_EmissiveGammaExponential("Emissive Gamma Exponential", Range( 0 , 5)) = 2.2
		[Toggle(_PIXELATE_ON)] _Pixelate("Pixelate", Float) = 0
		_PixelsX("X Pixels", Float) = 250
		_pixelsY("Y Pixels", Float) = 0
		[Toggle(_POSTERIZE_ON)] _Posterize("Posterize", Float) = 0
		_PosterizeAmount("PosterizeAmount", Range( 0 , 100)) = 5
		[Toggle(_GRAYSCALE_ON)] _Grayscale("Grayscale", Float) = 0
		[Toggle(_GAMEBOYFX_ON)] _GameboyFX("GameboyFX", Float) = 0
		_GameboyColor_LightestGreen("GameboyColor_LightestGreen", Color) = (0.6078432,0.7372549,0.05882353,1)
		_GameboyColor_LightGreen("GameboyColor_LightGreen", Color) = (0.5450981,0.6745098,0.05882353,1)
		_GameboyColor_DarkGreen("GameboyColor_DarkGreen", Color) = (0.1882353,0.3843137,0.1882353,1)
		_GameboyColor_DarkestGreen("GameboyColor_DarkestGreen", Color) = (0.05882353,0.2196078,0.05882353,1)
		_GBPIxelateX("GB PIxelate X", Float) = 160
		_GBPIxelateY("GB PIxelate Y", Float) = 144
		[Toggle(_INVERTCOLORS_ON)] _InvertColors("InvertColors", Float) = 0
		_InvertMultiplier("InvertMultiplier", Range( 0 , 1)) = 1
		[Toggle(_TWOCHANNEL_ON)] _TwoChannel("TwoChannel", Float) = 0
		_TwoChannelThreshhold("Two Channel Threshhold", Range( 0 , 1)) = 0.1
		_TwoChannleLighterColor("Two Channle Lighter Color", Color) = (1,1,1,1)
		_TwoChannelDarkerColor("Two Channel Darker Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _TWOCHANNEL_ON
		#pragma shader_feature_local _INVERTCOLORS_ON
		#pragma shader_feature_local _GAMEBOYFX_ON
		#pragma shader_feature_local _GRAYSCALE_ON
		#pragma shader_feature_local _POSTERIZE_ON
		#pragma shader_feature_local _PIXELATE_ON
		#pragma shader_feature_local _APPLYGAMMA_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _EmissiveGammaExponential;
		uniform float _PixelsX;
		uniform float _pixelsY;
		uniform float _PosterizeAmount;
		uniform float _GBPIxelateX;
		uniform float _GBPIxelateY;
		uniform float4 _GameboyColor_LightestGreen;
		uniform float4 _GameboyColor_LightGreen;
		uniform float4 _GameboyColor_DarkGreen;
		uniform float4 _GameboyColor_DarkestGreen;
		uniform float _InvertMultiplier;
		uniform float _TwoChannelThreshhold;
		uniform float4 _TwoChannleLighterColor;
		uniform float4 _TwoChannelDarkerColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float4 temp_cast_0 = (_EmissiveGammaExponential).xxxx;
			#ifdef _APPLYGAMMA_ON
				float4 staticSwitch15 = pow( tex2DNode2 , temp_cast_0 );
			#else
				float4 staticSwitch15 = tex2DNode2;
			#endif
			float pixelWidth18 =  1.0f / _PixelsX;
			float pixelHeight18 = 1.0f / _pixelsY;
			half2 pixelateduv18 = half2((int)(uv_MainTex.x / pixelWidth18) * pixelWidth18, (int)(uv_MainTex.y / pixelHeight18) * pixelHeight18);
			#ifdef _PIXELATE_ON
				float4 staticSwitch19 = tex2D( _MainTex, pixelateduv18 );
			#else
				float4 staticSwitch19 = staticSwitch15;
			#endif
			float div29=256.0/float((int)_PosterizeAmount);
			float4 posterize29 = ( floor( staticSwitch19 * div29 ) / div29 );
			#ifdef _POSTERIZE_ON
				float4 staticSwitch30 = posterize29;
			#else
				float4 staticSwitch30 = staticSwitch19;
			#endif
			float grayscale34 = Luminance(staticSwitch30.rgb);
			float4 temp_cast_3 = (grayscale34).xxxx;
			#ifdef _GRAYSCALE_ON
				float4 staticSwitch35 = temp_cast_3;
			#else
				float4 staticSwitch35 = staticSwitch30;
			#endif
			float pixelWidth46 =  1.0f / _GBPIxelateX;
			float pixelHeight46 = 1.0f / _GBPIxelateY;
			half2 pixelateduv46 = half2((int)(uv_MainTex.x / pixelWidth46) * pixelWidth46, (int)(uv_MainTex.y / pixelHeight46) * pixelHeight46);
			float grayscale42 = dot(tex2D( _MainTex, pixelateduv46 ).rgb, float3(0.299,0.587,0.114));
			#ifdef _GAMEBOYFX_ON
				float4 staticSwitch38 = ( grayscale42 > 0.75 ? _GameboyColor_LightestGreen : ( grayscale42 > 0.5 ? _GameboyColor_LightGreen : ( grayscale42 > 0.25 ? _GameboyColor_DarkGreen : _GameboyColor_DarkestGreen ) ) );
			#else
				float4 staticSwitch38 = staticSwitch35;
			#endif
			#ifdef _INVERTCOLORS_ON
				float4 staticSwitch61 = ( float4( ( float3(1,1,1) * _InvertMultiplier ) , 0.0 ) - staticSwitch38 );
			#else
				float4 staticSwitch61 = staticSwitch38;
			#endif
			float grayscale67 = (staticSwitch61.rgb.r + staticSwitch61.rgb.g + staticSwitch61.rgb.b) / 3;
			#ifdef _TWOCHANNEL_ON
				float4 staticSwitch66 = ( grayscale67 > _TwoChannelThreshhold ? _TwoChannleLighterColor : _TwoChannelDarkerColor );
			#else
				float4 staticSwitch66 = staticSwitch61;
			#endif
			o.Emission = staticSwitch66.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;439;1369;552;2580.854;-1280.729;1.936311;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2772.859,-600.601;Inherit;True;Property;_MainTex;Main Texture;0;0;Create;False;0;0;0;False;0;False;None;47752654f186b443d87898ef19bcccf9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-2416.452,-602.3883;Inherit;True;videoTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2347.721,294.395;Inherit;True;25;videoTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2409.963,-226.0713;Inherit;True;25;videoTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1957.124,80.97542;Inherit;False;Property;_EmissiveGammaExponential;Emissive Gamma Exponential;2;0;Create;True;0;0;0;False;0;False;2.2;2.2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1986.5,525.1516;Inherit;False;Property;_pixelsY;Y Pixels;5;0;Create;False;0;0;0;False;0;False;0;250;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1993.307,424.1823;Inherit;False;Property;_PixelsX;X Pixels;4;0;Create;False;0;0;0;False;0;False;250;250;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1989.26,-218.081;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1938.867,279.5478;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1786.109,1315.937;Inherit;True;25;videoTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1428.853,1595.847;Inherit;False;Property;_GBPIxelateX;GB PIxelate X;14;0;Create;True;0;0;0;False;0;False;160;160;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1531.346,1401.149;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-1406.553,1720.162;Inherit;False;Property;_GBPIxelateY;GB PIxelate Y;15;0;Create;True;0;0;0;False;0;False;144;144;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;18;-1585.613,313.1447;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1600.088,137.1741;Inherit;False;25;videoTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PowerNode;16;-1593.814,-67.45227;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2.2;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCPixelate;46;-1279.226,1371.387;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;15;-1304.657,-209.6386;Inherit;True;Property;_ApplyGamma;ApplyGamma;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;-1294.192,210.2417;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;19;-901.2533,15.87274;Inherit;False;Property;_Pixelate;Pixelate;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1011.464,505.5817;Inherit;False;Property;_PosterizeAmount;PosterizeAmount;7;0;Create;True;0;0;0;False;0;False;5;5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-1022.239,1185.15;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosterizeNode;29;-661.3387,356.7805;Inherit;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-384.3272,1312.511;Inherit;False;Constant;_GameboyColorLimit1;Gameboy Color Limit 1;16;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;42;-402.5304,1075.655;Inherit;True;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;54;-506.2197,1812.98;Inherit;False;Property;_GameboyColor_DarkestGreen;GameboyColor_DarkestGreen;13;0;Create;True;0;0;0;False;0;False;0.05882353,0.2196078,0.05882353,1;0.05882339,0.2196076,0.05882339,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;-668.2059,1593.001;Inherit;False;Property;_GameboyColor_DarkGreen;GameboyColor_DarkGreen;12;0;Create;True;0;0;0;False;0;False;0.1882353,0.3843137,0.1882353,1;0.1882351,0.3843135,0.1882351,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;52;-74.85055,1482.011;Inherit;False;Property;_GameboyColor_LightGreen;GameboyColor_LightGreen;11;0;Create;True;0;0;0;False;0;False;0.5450981,0.6745098,0.05882353,1;0.5450979,0.6745098,0.05882339,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;51;-140.2035,1278.495;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;63;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;30;-591.95,23.28351;Inherit;False;Property;_Posterize;Posterize;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-37.61991,1226.854;Inherit;False;Constant;_GameboyColorLimit2;Gameboy Color Limit 2;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;34;-351.8029,112.1492;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;318.6005,1497.411;Inherit;False;Property;_GameboyColor_LightestGreen;GameboyColor_LightestGreen;10;0;Create;True;0;0;0;False;0;False;0.6078432,0.7372549,0.05882353,1;0.6078432,0.737255,0.05882339,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;55;255.3028,1186.665;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;127.5;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;39.57126,992.3956;Inherit;False;Constant;_GameboyColorLimit3;Gameboy Color Limit 3;16;0;Create;True;0;0;0;False;0;False;0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;853.8287,494.3091;Inherit;False;Property;_InvertMultiplier;InvertMultiplier;17;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;56;481.0503,1051.119;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;62;927.4294,295.9091;Inherit;False;Constant;_Vector0;Vector 0;17;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;35;-125.4376,17.25894;Inherit;False;Property;_Grayscale;Grayscale;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;38;875.0632,47.88379;Inherit;True;Property;_GameboyFX;GameboyFX;9;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1149.828,395.1088;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;63;1268.229,235.1087;Inherit;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;61;1439.427,46.30887;Inherit;True;Property;_InvertColors;InvertColors;16;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;69;1476.015,677.2298;Inherit;False;Property;_TwoChannleLighterColor;Two Channle Lighter Color;20;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;67;1615.409,421.2969;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;1462.667,902.5498;Inherit;False;Property;_TwoChannelDarkerColor;Two Channel Darker Color;21;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;1432.072,539.8819;Inherit;False;Property;_TwoChannelThreshhold;Two Channel Threshhold;19;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;68;1918.892,387.3884;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0.1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;66;1986.97,60.24847;Inherit;False;Property;_TwoChannel;TwoChannel;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1695.012,-333.923;Inherit;False;VideoTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2411.747,0.5992603;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;labthe3rd/PZ Video Shader;False;False;False;False;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;1;0
WireConnection;2;0;26;0
WireConnection;21;2;27;0
WireConnection;45;2;44;0
WireConnection;18;0;21;0
WireConnection;18;1;22;0
WireConnection;18;2;23;0
WireConnection;16;0;2;0
WireConnection;16;1;17;0
WireConnection;46;0;45;0
WireConnection;46;1;48;0
WireConnection;46;2;49;0
WireConnection;15;1;2;0
WireConnection;15;0;16;0
WireConnection;24;0;28;0
WireConnection;24;1;18;0
WireConnection;19;1;15;0
WireConnection;19;0;24;0
WireConnection;47;0;44;0
WireConnection;47;1;46;0
WireConnection;29;1;19;0
WireConnection;29;0;33;0
WireConnection;42;0;47;0
WireConnection;51;0;42;0
WireConnection;51;1;57;0
WireConnection;51;2;53;0
WireConnection;51;3;54;0
WireConnection;30;1;19;0
WireConnection;30;0;29;0
WireConnection;34;0;30;0
WireConnection;55;0;42;0
WireConnection;55;1;58;0
WireConnection;55;2;52;0
WireConnection;55;3;51;0
WireConnection;56;0;42;0
WireConnection;56;1;59;0
WireConnection;56;2;43;0
WireConnection;56;3;55;0
WireConnection;35;1;30;0
WireConnection;35;0;34;0
WireConnection;38;1;35;0
WireConnection;38;0;56;0
WireConnection;64;0;62;0
WireConnection;64;1;65;0
WireConnection;63;0;64;0
WireConnection;63;1;38;0
WireConnection;61;1;38;0
WireConnection;61;0;63;0
WireConnection;67;0;61;0
WireConnection;68;0;67;0
WireConnection;68;1;71;0
WireConnection;68;2;69;0
WireConnection;68;3;70;0
WireConnection;66;1;61;0
WireConnection;66;0;68;0
WireConnection;31;0;2;0
WireConnection;0;2;66;0
ASEEND*/
//CHKSM=046BFDD322402D7754EC6769A147C18BFAB8F1C8