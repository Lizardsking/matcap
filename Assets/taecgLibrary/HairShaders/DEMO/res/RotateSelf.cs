using System.Collections;
using UnityEngine;

namespace taecg.tool.hairShader
{
    public class RotateSelf : MonoBehaviour
    {
        [Header ("旋转速度")]
        public float Speed;

        public enum RotateDirection
        {
            沿X轴正方向,
            沿X轴负方向,
            沿Y轴正方向,
            沿Y轴负方向,
            沿Z轴正方向,
            沿Z轴负方向,
        }

        [Header ("旋转方向")]
        public RotateDirection theRotateDirection = RotateDirection.沿Y轴正方向;
        private Vector3 directionVec3 = Vector3.down;

        private Transform trans;

        // Use this for initialization
        void Start ()
        {
            trans = transform;

            switch (theRotateDirection)
            {
                case RotateDirection.沿X轴正方向:
                    directionVec3 = Vector3.left;
                    break;
                case RotateDirection.沿X轴负方向:
                    directionVec3 = Vector3.right;
                    break;
                case RotateDirection.沿Y轴正方向:
                    directionVec3 = Vector3.down;
                    break;
                case RotateDirection.沿Y轴负方向:
                    directionVec3 = Vector3.up;
                    break;
                case RotateDirection.沿Z轴正方向:
                    directionVec3 = Vector3.back;
                    break;
                case RotateDirection.沿Z轴负方向:
                    directionVec3 = Vector3.forward;
                    break;
                default:
                    break;
            }
        }

        // Update is called once per frame
        void Update ()
        {
            trans.RotateAround (trans.position, directionVec3, Speed * Time.deltaTime);
        }
    }
}