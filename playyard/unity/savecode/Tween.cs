using UnityEngine;
public class Tween : MonoBehaviour {
    public float moveSpeed = 0.1f;

    private Transform target;
    private Vector3 targetPos;

    void Start() {
        target = this.gameObject.transform;
    }

    void Update() {
        if(target.position.Equals(targetPos)) {
            return;
        }
        Vector3 newPos = Vector3.MoveTowards(target.position, targetPos, moveSpeed);
        target.position = newPos;
    }

    public void moveTo(Vector3 pos) {
        this.targetPos = pos;
    }
}