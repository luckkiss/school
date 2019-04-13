using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class XunLu : MonoBehaviour {
	public Transform model;
	private Camera mainCamera;
	// Use this for initialization
	void Start () {
		mainCamera = Camera.main;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyUp(KeyCode.Mouse0))
        {
			RaycastHit hitInfo;
			if (Physics.Raycast(this.mainCamera.ScreenPointToRay(Input.mousePosition), out hitInfo,1<<10))
			{
				Vector3 pos = hitInfo.point;
				Tween modelTween = model.GetComponent<Tween>();
				modelTween.moveTo(pos);
			}
        }
	}
}
