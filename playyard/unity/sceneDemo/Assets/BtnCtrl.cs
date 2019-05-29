using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class BtnCtrl : MonoBehaviour {
	public Button btnJump;
	public Button btnEat;
	public Button btnSound;
	private Animator anim;
	public Transform model;
	// Use this for initialization
	void Start () {
		btnJump.onClick.AddListener(onClickBtnJump);
		btnEat.onClick.AddListener(onClickBtnEat);
		btnSound.onClick.AddListener(onClickBtnSound);
		anim = model.GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	void onClickBtnJump(){

		anim.Play("Jump");
		Debug.Log("aaa");
	}
	void onClickBtnEat(){
		anim.Play("Eat");
	}
	void onClickBtnSound(){
		anim.Play("sound");
	}
}
