#version 300 es
precision mediump float;

in vec4 vColor;
in vec4 vPos;
in vec2 vUV;

  uniform sampler2D uMainTex;
  uniform sampler2D uDropTex;      // 【自改】水珠里要显示的图（第二张图）
  uniform vec4 uBackgroundSize; // (x, y, 1/x, 1/y)
uniform sampler2D uRaindropTex;
uniform sampler2D uDropletTex;
uniform sampler2D uMistTex;
uniform vec4 uColor;
uniform vec2 uSmoothRaindrop;
uniform vec2 uRefractParams; // (refractBase, refractScale)
uniform vec4 uLightPos;
uniform vec4 uDiffuseColor; // (color.rgb, shadowOffset)
uniform vec4 uSpecularParams; // (color.rgb, exponent)
uniform float uBump;
uniform float uPremultiply;   // 【自改】1 = 输出预乘 alpha（透明底/桌面浮层用）
uniform vec2  uCanvasSize;    // 【自改】画布像素尺寸（算倒影要用的珠心位置）
uniform float uSizeRef;       // 【自改】珠子尺寸的归一化基准（= spawnSize[1]）
uniform float uDropInvert;    // 【自改】水珠倒影强度：0 = 原版不倒影，1 = 完全倒影

out vec4 fragColor;

void main()
{
    // vec3 lightPos = vec3(0.5, 1, 1);

    vec4 raindrop = texture(uRaindropTex, vUV.xy).rgba;
    vec4 droplet = texture(uDropletTex, vUV.xy).rgba;
    float mist = texture(uMistTex, vUV.xy).r;

    vec4 compose = vec4(raindrop.rgb + droplet.rgb - vec3(2.0) * raindrop.rgb * droplet.rgb, max(droplet.a, raindrop.a));

    float mask = smoothstep(uSmoothRaindrop.x, uSmoothRaindrop.y, compose.a);
    
    vec2 uv = vUV.xy + -(compose.xy - vec2(0.5)) * vec2(compose.b * uRefractParams.y + uRefractParams.x);
    vec3 normal = normalize(vec3((compose.xy - vec2(0.5)) * vec2(2), 1.0));

    // vec3 lightDir = lightPos - vec3(vUV, 0);
    vec3 lightDir = uLightPos.xyz - uLightPos.w * vec3(vUV.xy, 0.0);
    vec3 viewDir = vec3(0, 0, 1);
    vec3 halfDir = normalize(lightDir + viewDir);
    float lambertian = clamp(dot(normalize(lightDir), normal), 0.0, 1.0);
    float blinnPhon = pow(max(dot(normal, halfDir), 0.0), uSpecularParams.a);


    // offset = pow(offset, vec2(2));
      vec4 color = texture(uMainTex, uv.xy).rgba;
      // 【自改】球面透镜倒影：水珠相当于一颗凸透镜，透过去看到的像是倒的。
      // compose.xy 是这颗珠子方框内的局部 uv（0..1），compose.b 是归一化珠径，
      // 于是「当前像素相对珠心的 uv 偏移」= (compose.xy-0.5) * 方框uv尺寸；
      // 珠心 = vUV - 偏移；倒影 = 采样点关于珠心做 180° 反转。
      float qpx = clamp(compose.b, 0.0, 2.0) * uSizeRef;
      vec2 quadUV = vec2(qpx / max(uCanvasSize.x, 1.0), qpx / max(uCanvasSize.y, 1.0));
      vec2 toCenter = (compose.xy - vec2(0.5)) * quadUV;
      vec2 uvInv = mix(uv, 2.0 * (vUV - toCenter) - uv, clamp(uDropInvert, 0.0, 1.0));
      // 【自改】只有「雨珠」覆盖处改采样第二张图（用同一个折射/倒影 uv）；
      // 小的背景水珠层（dropletsPerSeconds 那层）保持原样，否则整幅会像铺了一层别人家的雾
      vec4 dropColor = texture(uDropTex, uvInv).rgba;
      float dropMask = smoothstep(uSmoothRaindrop.x, uSmoothRaindrop.y, raindrop.a);
      color.rgb = mix(color.rgb, dropColor.rgb, dropMask);
      vec3 diffuse = vec3((lambertian - uDiffuseColor.a) * uDiffuseColor.rgb);

    color.rgb += vec3((lambertian - uDiffuseColor.a) * uDiffuseColor.rgb);
    color.rgb += vec3(blinnPhon) * uSpecularParams.rgb;
    

    // fragColor = vec4(mask, mask, mask, 1);
    // color = color * vec3(uColor);

    // 【自改】mix(1, mask, uPremultiply)：正常模式原样输出；透明底模式把 rgb 乘上 alpha（预乘）
    fragColor = vec4(color.rgb * mix(1.0, mask, uPremultiply), mask);
}
