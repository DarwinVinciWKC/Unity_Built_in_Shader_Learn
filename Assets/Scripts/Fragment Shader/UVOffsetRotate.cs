using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UVOffsetRotate : MonoBehaviour
{
    public float speed = 200;
    public float pauseTime = 2;
    void Start()
    {
        StartCoroutine("Rotate");
    }
    IEnumerator Rotate()
    {
        float angleCount = 0;
        float currentAngle = 0;
        while (true)
        {
            transform.Rotate(Vector3.up * Time.deltaTime * speed);
            angleCount += Time.deltaTime * speed;
            yield return null;
            if (angleCount >= 90)
            {
                currentAngle += 90;
                transform.localEulerAngles = Vector3.up * currentAngle;
                yield return new WaitForSeconds(pauseTime);
                angleCount = 0;
            }
        }
    }
}
