using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelPlayer : MonoBehaviour {
	private Animator anim;

	// Use this for initialization
	void Start () {
		anim = this.GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void startMove() {
		this.anim.Play("Walk");
	}

	public void endMove() {
		this.anim.Play("Idle");
	}
}
