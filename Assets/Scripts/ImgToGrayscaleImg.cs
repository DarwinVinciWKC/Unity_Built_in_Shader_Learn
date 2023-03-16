using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImgToGrayscaleImg : MonoBehaviour
{
    public Texture2D texture1;//需要开启Advanced中的Read/Write权限
    public Texture2D texture2;//需要开启Advanced中的Read/Write权限，将Format改成RGB格式中的一种
    void Start()
    {
        for (int i = 1; i < texture1.width - 1; i++)
        {
            for (int j = 1; j < texture1.height - 1; j++)
            {
                float wl = texture1.GetPixel(i - 1, j).r;
                float wr = texture1.GetPixel(i + 1, j).r;
                float wp = wr - wl;

                float hu = texture1.GetPixel(i, j - 1).r;
                float hd = texture1.GetPixel(i, j + 1).r;
                float hp = hd - hu;

                Vector3 xd = new Vector3(1, 0, wp);
                Vector3 yd = new Vector3(0, 1, hp);

                Vector3 c = Vector3.Cross(xd, yd).normalized;

                float x = c.x * 0.5f + 0.5f;
                float y = c.y * 0.5f + 0.5f;
                float z = c.z * 0.5f + 0.5f;

                texture2.SetPixel(i, j, new Color(x, y, z));
            }
        }
        texture2.Apply(false);
    }

}
