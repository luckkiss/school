using UnityEngine;
public class Tween : MonoBehaviour {
    public float moveSpeed = 0.1f;

    private Transform target;
    private Vector3 targetPos;

    private bool isRunning;

    public System.Action onFinished = null;

    void Start() {
        target = this.gameObject.transform;
    }

    void Update() {
        if(!this.isRunning) {
            return;
        }
        if(target.position.Equals(targetPos)) {
            this.isRunning = false;
            if(null != onFinished) {
                onFinished();
                onFinished = null;
            }
            return;
        }
        Vector3 newPos = Vector3.MoveTowards(target.position, targetPos, moveSpeed);
        target.LookAt(newPos);
        target.position = newPos;
    }

    public void moveTo(Vector3 pos) {
        this.targetPos = pos;
        this.isRunning = true;
    }
}