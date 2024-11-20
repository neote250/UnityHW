using UnityEngine;

public class Rotator : MonoBehaviour
{
    [SerializeField, Range(-360, 360)] float angle;

    void Update()
    {
        transform.rotation *= Quaternion.AngleAxis(angle * Time.deltaTime, Vector3.up);
    }
}
