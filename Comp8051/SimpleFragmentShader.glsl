uniform sampler2D u_Texture;

varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
    highp float SpecularIntensity;
    highp float Shininess;
};
uniform Light u_Light;

struct PointLight {
    lowp vec3 Color;
    lowp vec3 Position;
    lowp float Constant;
    lowp float Linear;
    lowp float Quadratic;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    highp float SpecularIntensity;
    highp float Shininess;
};

uniform PointLight u_PointLight;

void main(void) {
    
    // Directional Light
    // Ambient
    lowp vec3 AmbientColor = u_Light.Color * u_Light.AmbientIntensity;
    
    // Diffuse
    lowp vec3 Normal = normalize(frag_Normal);
    lowp float DiffuseFactor = max(-dot(Normal, u_Light.Direction), 0.0);
    lowp vec3 DiffuseColor = u_Light.Color * u_Light.DiffuseIntensity * DiffuseFactor;
    
    // Specular
    lowp vec3 Eye = normalize(frag_Position);
    lowp vec3 Reflection = reflect(u_Light.Direction, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection, Eye)), u_Light.Shininess);
    lowp vec3 SpecularColor = u_Light.Color * u_Light.SpecularIntensity * SpecularFactor;
    
    // Point light
    vec3 lightDir = normalize(u_PointLight.position - frag_Position);
    
    // attenuation
    float distance    = length(u_PointLight.position - fragPos);
    float attenuation = 1.0 / (u_PointLight.constant + light.linear * distance +
                               u_PointLight.quadratic * (distance * distance));
    
    // Ambient
    lowp vec3 AmbientColorLava = u_PointLight.Color * u_PointLight.AmbientIntensity;
    
    // Diffuse
    lowp float DiffuseFactorLava = max(-dot(Normal, lightDir), 0.0);
    lowp vec3 DiffuseColorLava = u_PointLight.Color * u_PointLight.DiffuseIntensity * DiffuseFactor;
    
    // Specular
    lowp vec3 ReflectionLava = reflect(lightDir, Normal);
    lowp float SpecularFactorLava = pow(max(0.0, -dot(Reflection, Eye)), u_PointLight.Shininess);
    lowp vec3 SpecularColorLava = u_PointLight.Color * u_PointLight.SpecularIntensity * SpecularFactor;
    
    gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0) * vec4((AmbientColorLava + DiffuseColorLava + SpecularColorLava), 1.0);
}
