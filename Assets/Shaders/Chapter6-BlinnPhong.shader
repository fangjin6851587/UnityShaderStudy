Shader "Unity Shaders Book/Chapter6/BlinnPhong" {
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
				fixed3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f o;

				//transfrom the vertex from object space to projection space
				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				//transfrom the normal from object space to world space 
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			fixed4 frag(v2f i):SV_TARGET
			{
				//get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 worldNormal = i.worldNormal;

				float3 worldPos = i.worldPos;

					//get the light direction in world space
				fixed3 worldLightDir = UnityWorldSpaceLightDir(worldPos);

				//compute diffuse term
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
				//fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * (dot(worldNormal, worldLightDir) * 0.5 + 0.5);

				//get the view direction in world space
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				//get the half direction in world space
				fixed3 halfDir = normalize(worldLightDir + viewDir);

				//compute specular term
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0);
			}

			ENDCG
		}
	}

	Fallback "Specular"
}
