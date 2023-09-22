Shader "labthe3rd/PZ Video Shader Lite"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EmissiveGamma("Emissive Gamma", Float) = 1.0
        [Toggle(APPLY_GAMMA)] _ApplyGamma("Apply Gamma", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile APPLY_GAMMA_OFF APPLY_GAMMA

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _EmissiveGamma;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
#if APPLY_GAMMA
                fixed emissiveGamma = _EmissiveGamma;
                col = pow(col,emissiveGamma);
#endif
                return col;
            }
            ENDCG
        }
    }
}
