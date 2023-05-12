using Unity.VisualScripting;
using UnityEngine;

public class LightingTexture : MonoBehaviour
{
    public Texture2D MainTex;
    public float DiffuseFrontIntensity;
    public float DiffuseBackIntensity;
    public Color Specular;
    public int Gloss;
    public Color LightColor;
    public float FinalColorIntensity;
    public Vector3 LightDirection;
    public Texture2D OutTexture;
    public Vector3 ViewDirection;
    float mainTexWidth;
    float mainTexHeight;
    void Start()
    {
        mainTexWidth = MainTex.width;
        mainTexHeight = MainTex.height;
        CaculateColor();
    }
    void CaculateColor()
    {
        var filters = GetComponentsInChildren<MeshFilter>();
        foreach (var filter in filters)
        {
            var normals = filter.mesh.normals;
            var uvs = filter.mesh.uv;

            for (int i = 0; i < normals.Length; i++)
            {
                var albedo = MainTex.GetPixel((int)(mainTexWidth * uvs[i].x), (int)(mainTexHeight * uvs[i].y));

                var halfLambert = Vector3.Dot(normals[i].normalized, LightDirection) * 0.5f + 0.5f;
                var diffuse = V3MultiplyV3(new Vector3(LightColor.r, LightColor.g, LightColor.b), new Vector3(albedo.r, albedo.g, albedo.b)) * halfLambert * DiffuseFrontIntensity;

                float oneMinusHalfLambert = 1 - halfLambert;
                diffuse += V3MultiplyV3(new Vector3(LightColor.r, LightColor.g, LightColor.b), new Vector3(albedo.r, albedo.g, albedo.b)) * oneMinusHalfLambert * DiffuseBackIntensity;

                var halfDirection = (LightDirection + ViewDirection).normalized;
                var specular = V3MultiplyV3(new Vector3(LightColor.r, LightColor.g, LightColor.b), new Vector3(Specular.r, Specular.g, Specular.b)) * Mathf.Pow(Mathf.Max(0, Vector3.Dot(normals[i].normalized, halfDirection)), Gloss);

                var color = (diffuse + specular) * FinalColorIntensity;

                OutTexture.SetPixel((int)(mainTexWidth * uvs[i].x), (int)(mainTexHeight * uvs[i].y), new Color(color.x, color.y, color.z));
            }
        }
        OutTexture.Apply(false);
    }
    Vector3 V3MultiplyV3(Vector3 right, Vector3 left)
    {
        return new Vector3(right.x * left.x, right.y * left.y, right.z * left.z);
    }
}
