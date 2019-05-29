using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
public class XunLu : MonoBehaviour {
	public Transform model;
	public Transform model02;

	public Transform model01;

	private Animator player;
	private Animator player02;
	private Animator player01;
	private float time = 0;

	private Camera mainCamera;
	// Use this for initialization
	void Start () {
		mainCamera = Camera.main;
		player = model.GetComponent<Animator>();
		player02 = model02.GetComponent<Animator>();
		player01 = model01.GetComponent<Animator>();

	}
	
	// Update is called once per frame
	void Update () {
		if(EventSystem.current.IsPointerOverGameObject()){
			return;
		}
		if (Input.GetKeyUp(KeyCode.Mouse0))
        {
			RaycastHit hitInfo;
			if (Physics.Raycast(this.mainCamera.ScreenPointToRay(Input.mousePosition), out hitInfo,1<<10))
			{

				Vector3 pos = hitInfo.point;
				Tween modelTween = model.GetComponent<Tween>();
				modelTween.onFinished = onMoveFinished;
				modelTween.moveTo(pos);
				
				player.Play("Walk");
				
			}

        }
		this.time++;
		if(Random.Range(0,10) > 9)
		{
			// RaycastHit hitInfo;
			float xx = Random.Range(0f,10f);
			float zz = Random.Range(0f,10f);
			float yy = 0.3f;
			Vector3 pos = new Vector3(xx,yy,zz);
			// if (Physics.Raycast(this.mainCamera.ScreenPointToRay(pos), out hitInfo,1<<10))
			// {
			//     Vector3 position = hitInfo.point;
				Tween modelTween02 = model02.GetComponent<Tween>();
				// modelTween02.onFinished = player02.endMove;
				modelTween02.moveTo(pos);
				player02.Play("Walk");
			// }
		}
		if (time%100 == 1)
		{
			float xx = Random.Range(-5f,10f);
			float zz = Random.Range(-5f,10f);
			float yy = 0.5f;
			Vector3 pos = new Vector3(xx,yy,zz);
			Tween modelTween01 = model01.GetComponent<Tween>();
			// modelTween01.onFinished = player01.endMove;
			modelTween01.moveTo(pos);
			player01.Play("Walk");

		}
		
		
	}

	void onMoveFinished() {
		player.Play("Idle");
		
	}
}
