using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour {
	public Transform target;
	public Transform target02;
	public Transform target01;

	public float offsetY = 2;

	public Transform cameraTrans;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		Vector3 pos = target.position;
		Vector3 pos02 = target02.position;
		Vector3 pos01 = target01.position;
		pos02.y += this.offsetY;
		pos.y += this.offsetY;
		pos01.y += this.offsetY;
		cameraTrans.position = pos;
		// cameraTrans.position = pos02;
		// cameraTrans.position = pos01;
	}
}
