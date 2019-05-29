using UnityEngine;
public class RatPlayer : MonoBehaviour {
    Tween modelTween;
   

    Animator player;
   

    bool isRunning;
    float finishTime = 0;
    void Start() {
        modelTween = this.GetComponent<Tween>();
		player = this.GetComponent<Animator>();
       
    }

    void Update() {
        if(isRunning) {
           return; 
        }
        
        if(finishTime ==0 || Time.realtimeSinceStartup - this.finishTime > 5) {
            modelTween.onFinished = onMoveFinished;
            modelTween.moveTo(new Vector3(Random.Range(0f, 8f),0f, Random.Range(0f, 8f)));
            player.Play("Walk");
            isRunning = true;
        }
        
    }

	void onMoveFinished() {
        this.finishTime = Time.realtimeSinceStartup;
		player.Play("sound");
        isRunning = false;
	}
}