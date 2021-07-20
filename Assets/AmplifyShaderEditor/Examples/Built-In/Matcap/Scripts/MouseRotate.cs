using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseRotate : MonoBehaviour
{
    Vector3 lastMousePosition;
    Vector3 newMousePosition;
    public List<Transform> objectsToRotate = new List<Transform>();

    
    void Start()
    {
        
    }

    
    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            newMousePosition = Input.mousePosition;
            //Debug.Log(newMousePosition);
            if (lastMousePosition != new Vector3(-1000f, -1000f, 1000f))
			{
                float xDiff = lastMousePosition.x - newMousePosition.x;

                for (int i = 0; i < objectsToRotate.Count; i++)
                {
                    if (objectsToRotate[i] != null)
					{                    
                    objectsToRotate[i].Rotate(new Vector3(0f, 1f, 0f), xDiff);
                    //Debug.Log("rotating by " + xDiff);
					}

				}
                
			}

            lastMousePosition = newMousePosition;
		}
		else
		{
            lastMousePosition = new Vector3(-1000f, -1000f, 1000f);
		}
    }
}
