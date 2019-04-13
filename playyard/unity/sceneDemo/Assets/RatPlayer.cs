using UnityEngine;
public class RatPlayer : MonoBehaviour {
    Tween modelTween;

    ModelPlayer player;

    bool isRunning;
    void Start() {
        modelTween = this.GetComponent<Tween>();
		player = this.GetComponent<ModelPlayer>();
    }

    void Update() {
        if(isRunning) {
           return; 
        }
        if(Random.Range(0, 10) > 6) {
            modelTween.onFinished = onMoveFinished;
            modelTween.moveTo(new Vector3(Random.Range(0f, 20f), Random.Range(0f, 20f), 0));
            player.startMove();
        }
    }

	void onMoveFinished() {
		player.endMove();
        isRunning = false;
	}
}