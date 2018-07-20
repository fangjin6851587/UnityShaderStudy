﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/Chapter6/Diffuse HalfLabmert" {
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass {
			
			Tags 
			{
				"LightMode"="ForwardBase"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Diffuse; 

			struct a2v {
				float4 vertex:POSITION; 
				float3 normal:NORMAL; 
			}; 

			struct v2f {
				float4 pos:SV_POSITION; 
				fixed3 worldNormal:TEXCOORD0; 
			}; 

			
			v2f vert (a2v v) {
				v2f o; 
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				return o; 
			}
			
			fixed4 frag (v2f i):SV_Target {

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed halfLambert = dot(i.worldNormal, worldLightDir) * 0.5 + 0.5;
				fixed3 diffuse = _LightColor0.rgb * _Diffuse * halfLambert;
				fixed3 color = diffuse + ambient;
				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}
