using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour {
	public Transform target;

	public float offsetY = 2;

	public Transform cameraTrans;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		Vector3 pos = target.position;
		pos.y += this.offsetY;
		cameraTrans.position = pos;
	}
}
