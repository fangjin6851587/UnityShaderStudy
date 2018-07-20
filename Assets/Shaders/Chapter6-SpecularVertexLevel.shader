Shader "Unity Shaders Book/Chapter6/SpecularVertexLevel" {
	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {
		Pass {

			Tags {"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCg.cginc"
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;	
			};

			struct v2f {
				float4 pos:SV_POSITION;
				fixed3 color:COLOR;
			};

			v2f vert(a2v v)
			{
				v2f o;

				//transfrom the vertex from object space to projection space
				o.pos = UnityObjectToClipPos(v.vertex);

				//get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				//transfrom the normal from object space to world space 
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);

				//get the light direction in world space
				//fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 worldLightDir = WorldSpaceLightDir(v.vertex);

				//compute diffuse term
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

				//get the reflect direction in world space
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

				//get the view direction in world space
				//fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				fixed3 viewDir = normalize(WorldSpaceViewDir(v.vertex));

				//compute specular term
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(viewDir, reflectDir)), _Gloss);

				o.color = ambient + diffuse + specular;

				return o;
			}

			fixed4 frag(v2f i):SV_TARGET
			{
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
