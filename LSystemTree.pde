// Import stacks data-structure
import java.util.Stack;
import java.lang.Math;
import java.lang.Math; 

// Production class 
class Production {
  // Alphabet 
  public String a;
  // Production Expression
  public String x; 
  Production(String newA, String newX) {
    a = newA;
    x = newX; 
  }
}

// L-System class
class LSystem {
  // omega: Initial expression (Axiom)
  private String omega; 
  // V: productions 
  private Production V[]; 
  // numExpr: Integer to logical size of V and Vexpr 
  private int numExpr; 
  
  // Constructor 
  LSystem() {
    // Initialize variables 
    // Default axiom: "F" 
    setAxiom("X"); 
    V = new Production[10]; 
    numExpr = 0; 
    // Figure 1.24A 
    // Axiom: F 
    // Iterations: 5
    //addProduction("F","F[+F]F[-F]F");
    // Figure 1.24B
    // Axiom: F
    // Iterations: 5
    //addProduction("F","F[+F]F[-F][F]");
    // Figure 1.24C
    // Axiom: F 
    // Iterations: 4
    //addProduction("F", "FF-[-F+F+F]+[+F-F-F]");
    // Figure 1.24D 
    // Axiom: X
    // Iterations: 7 
    //addProduction("X", "F[+X]F[-X]+X"); 
    //addProduction("F", "FF");
    // Figure 1.24E 
    // Axiom: X 
    // Iterations: 7
    //addProduction("X", "F[+X][-X]FX");
    //addProduction("F", "FF");
    // Figure 1.24F
    // Axiom: X 
    // Iterations: 5 
    addProduction("X", "F-[[X]+X]+F[+FX]-X");
    addProduction("F","FF");
  }
  
  // Method for setting the axiom 
  public void setAxiom(String axiom) { 
    omega = axiom; 
  }
  
  // Method to access axiom 
  public String getAxiom() {
    return omega; 
  }
  
  // Method for adding a production 
  public void addProduction(String a, String x) {
    // Add into class arrays 
    Production newProduction = new Production(a, x); 
    V[numExpr] = newProduction; 
    // Increment expressions count 
    numExpr++; 
  }
  
  // Method for getting a production 
  // Get production at index i
  public Production getProduction(int i) {
    return V[i]; 
  }
  
  // Method for getting the number of productions 
  public int getNumProd() {
    return numExpr;
  }  
  
  // Recursive helper function for getting the nth developmental step 
  private String retNDevStepRecurse(String expression, int step) {
    print("step: " + step + "\n");
    print(expression + "\n");
    // Base case: Return the expression 
    if(step <= 0) {
      return expression; 
    }
    // Variable for new expression
    String newExpression = ""; 
    
    for(int i = 0; i < expression.length(); i++) {
      // Replace accordingly 
      boolean productionFound = false; 
      for(int j = 0; j < numExpr; j++) {
        // Check if index of production is at 0
        if((expression.indexOf(V[j].a, i) - i) == 0) {
          // Concat to end of newExpression 
          newExpression = newExpression + V[j].x; 
          // Set productionFound boolean and break out of the loop 
          productionFound = true; 
          break; 
        }
      }
      // If not replacements found, just concatenate the original alphabet
      if(!productionFound) { 
        newExpression = newExpression + expression.charAt(i);
      }
    }
    
    return retNDevStepRecurse(newExpression, step - 1);
  }
  
  // Function for getting the nth development step 
  public String retNDevStep(int steps) {
    return retNDevStepRecurse(omega, steps); 
  }
}

// Point class 
class pointObj {
  // Stores x, y, z values of points 
  public float x; 
  public float y; 
  public float z; 
  // Constructor 
  pointObj(float newX, float newY, float newZ) {
    x = newX; 
    y = newY; 
    z = newZ; 
  }
}
    
// Turtle state class: Records turtle position and angle 
class turtleState {
  // State variables 
  public pointObj position;
  public float angle; 
  // Constructor 
  turtleState(pointObj position, float angle) {
    this.position = position;
    this.angle = angle; 
  }
}

// Turtle Class 
class turtle {
  // State variables 
  private float angle; 
  private float lineLen; 
  private String expression; 
  // Stack for drawing 
  Stack<turtleState> drawStack;
  // Constructor 
  // Accepts string generated from L-System, angle, and lineLen 
  turtle(String exp, float setAng, float linl) {
    angle = setAng;
    lineLen = linl; 
    expression = exp; 
    // Initialize stack 
    drawStack = new Stack<turtleState>();
  }
  
  // Draw forward function: F 
  private pointObj drawForward2D(float currAngle, pointObj currPosition) {
    stroke(0);
    float destX, destY; 
    // Get destination coordinates 
    destX = (float)(currPosition.x + lineLen*Math.cos(Math.toRadians(currAngle)));
    destY = (float)(currPosition.y + lineLen*Math.sin(Math.toRadians(currAngle)));
    pointObj dest = new pointObj(destX, destY, 0.0f); 
    line(currPosition.x, currPosition.y, destX, destY); 
    return dest; 
  }
  // Draw expression function 
  // F: Forward
  // [: Push onto stack 
  // ]: Pop from stack 
  // +: Rotate left 
  // -: Rotate right 
  public void drawExpression2D(float initAngle, pointObj initPoint) {
    // Set initial position and angle 
    pointObj curPosition = initPoint; 
    float curAngle = initAngle; 
    // Clear the stack 
    while(!drawStack.empty()) {
      drawStack.pop();
    }
    // Iterate through expression 
    for(int i = 0; i < expression.length(); i++) { 
      char currentCommand = expression.charAt(i); 
      switch (currentCommand) {
        case 'F':
          // Draw forward 
          curPosition = drawForward2D(curAngle, curPosition); 
          break;
        case '+':
          // Turn left by setAngle 
          curAngle -= angle;
          break;
        case '-': 
          // Turn right by setAngle 
          curAngle += angle;
          break;
        case '[': 
          // Push current state onto stack
          turtleState currentState = new turtleState(curPosition, curAngle);
          drawStack.push(currentState);
          break; 
        case ']':
          // Pop state from stack and store as current 
          turtleState poppedState = drawStack.pop(); 
          curPosition = poppedState.position;
          curAngle = poppedState.angle;
          break; 
      }
    }
  }
}

// Initialization function
void setup() {
  // Define size of display window
  size(1000, 1000);
  // Define background color 
  background(255, 255, 255, 255);
  // Intantiate an L-System object 
  LSystem lSystem = new LSystem(); 
  print("Axiom: " + lSystem.getAxiom() + "\n");
  int num = lSystem.getNumProd();
  for(int i = 0; i < num; i++) {
    Production currentProduction = lSystem.getProduction(i);
    print("Production " + i + ": " + currentProduction.a + "->" + currentProduction.x + "\n");
  }
  String treeExpression = lSystem.retNDevStep(7);
  // Intantiate turtle object with L-System generated expression
  turtle treeTurtle = new turtle(treeExpression, 25.7f, 3.0f); 
  treeTurtle.drawExpression2D(-90, new pointObj(500.0, 1000.0, 0.0));
}

// Update function 
void draw() {
}
