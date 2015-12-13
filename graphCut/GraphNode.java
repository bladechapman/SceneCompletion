// compile this using javac GraphNode.java

public class GraphNode implements Comparable<GraphNode> {
    public int x;
    public int y;
    public int weight;
    public GraphNode prev;
    
    public GraphNode() {
        this.x = 0;
        this.y = 0;
        this.weight = 10000;
        this.prev = null;
    }
    
    public GraphNode(int x, int y, int weight) {
        this.x = x;
        this.y = y;
        this.weight = weight;
        this.prev = null;
    }
    
    public int compareTo(GraphNode compareNode) {
        if (compareNode.weight < this.weight) {
            return 1;
        } else if (compareNode.weight > this.weight) {
            return -1;
        } else {
            return 0;
        }
    }
}