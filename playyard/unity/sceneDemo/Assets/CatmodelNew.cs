using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CatmodelNew : MonoBehaviour {
	Tween modelTween;
	Animator ani;
	bool isRunning;
	float time = 0;

	// Use this for initialization
	void Start () {
		modelTween = this.GetComponent<Tween>();
		ani = this.GetComponent<Animator>();
		
	}
	
	// Update is called once per frame
	void Update () {	
		if(isRunning){
			return;
		}
		this.time++;
		if(this.time%90 ==1 ){
			// if(Random.Range(0f,10f) > 8.8f){
			modelTween.onFinished = onMoveFinished;
			modelTween.moveTo(new Vector3(Random.Range(0f, 8f),0f, Random.Range(0f, 8f)));
			ani.Play("Walk");
			// }
		}
		
	}
	void onMoveFinished(){
		ani.Play("Jump");
		isRunning = false;
	}
}
