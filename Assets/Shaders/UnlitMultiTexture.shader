Shader "GAT350/UnlitMultiTexture"
{
    Properties
    {
        _MainTex1 ("Texture 1", 2D) = "white" {}
        _Scroll1("Scroll 1", Vector) = (0,0,0,0)

        _MainTex2 ("Texture 2", 2D) = "white" {}
        _Scroll2("Scroll 2", Vector) = (0,0,0,0)
        
        _Tint ("Tint", Color) = (1,1,1,1)
        _Intensity ("Intensity", Range(0,1)) = 1

        _Blend("Blend", Range(0,1)) = 0.5

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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };


            //point to pixel
            struct v2f
            {
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //texture 1
            sampler2D _MainTex1;
            float4 _MainTex1_ST;
            float4 _Scroll1;

            //texture 2
            sampler2D _MainTex2;
            float4 _MainTex2_ST;
            float4 _Scroll2;

            fixed4 _Tint;
            float _Intensity;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.uv1 = TRANSFORM_TEX(v.uv, _MainTex1);
                o.uv1.x = o.uv1.x + (_Time.y * _Scroll1.x);
                o.uv1.y = o.uv1.y + (_Time.y * _Scroll1.y);

                o.uv2 = TRANSFORM_TEX(v.uv, _MainTex2);
                o.uv2.x = o.uv2.x + (_Time.y * _Scroll2.x);
                o.uv2.y = o.uv2.y + (_Time.y * _Scroll2.y);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col1 = tex2D(_MainTex1, i.uv1);
                fixed4 col2 = tex2D(_MainTex2, i.uv2);

                fixed4 col = lerp(col1, col2, _Blend);

                //col = col * _Tint /* * _Intensity */;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
