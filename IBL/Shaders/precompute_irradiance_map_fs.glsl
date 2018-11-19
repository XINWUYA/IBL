#version 430 core

out vec4 FragColor;

in vec3 o_WorldPos;

uniform samplerCube u_EnvironmentMap;

const float PI = 3.14159265359;

void main()
{
	vec3 Normal = normalize(o_WorldPos);

	vec3 Irradiance = vec3(0.0f);
	vec3 Up = vec3(0.0f, 1.0f, 0.0f);
	vec3 Right = cross(Up, Normal);
	Up = cross(Normal, Right);

	float SampleDelta = 0.025f;
	float SampleCnt = 0.0f;
	for (float Phi = 0.0f; Phi < 2.0f * PI; Phi += SampleDelta)
	{
		for (float Theta = 0.0f; Theta < 0.5f * PI; Theta += SampleDelta)
		{
			//�����߿ռ��У�����������ת�����ѿ���������
			vec3 TangentSample = vec3(sin(Theta) * cos(Phi), sin(Theta) * sin(Phi), cos(Theta));
			//�����������߿ռ�ת��������ռ���
			vec3 SampleVec = TangentSample.x * Right + TangentSample.y * Up + TangentSample.z * Normal;
			Irradiance += texture(u_EnvironmentMap, SampleVec).rgb * cos(Theta) * sin(Theta);
			SampleCnt++;
		}
	}
	Irradiance = PI * Irradiance * (1.0f / SampleCnt);
	FragColor = vec4(Irradiance, 1.0f);
}