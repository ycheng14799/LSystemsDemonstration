import java.lang.Math;
import java.lang.Math; 

// Global turtle object
turtle3D turtle; 

// Setup function 
void setup() { 
  // Initialize window 
  size(2560, 1440, P3D);
  // Generate expression using L-System object 
  LSystem lSystem = new LSystem(); 
  // Print axiom
  print("Axiom: " + lSystem.getAxiom() + "\n"); 
  int numProd = lSystem.getNumProd();
  // Print productions 
  for(int i = 0; i < numProd; i++) {
    Production currentProduction = lSystem.getProduction(i);
    print("Production " + i + ": " + currentProduction.a + "->" + currentProduction.x + "\n");
  }
  // Generate the tree expression 
  String treeExpression = lSystem.retNDevStep(3);
  
  // Initialize turtle 
  turtle = new turtle3D(treeExpression, 100, 10, (PI / 180.0f) * 25.7f);
}

void draw() {
  background(0);
  lights();
  noStroke(); 
  fill(255, 255, 255);
  // Placement of tree at (width/2, height, 0); 
  //centreTree();
  camera(3000*cos(millis() / 500), 3000.0f, 3000*sin(millis() / 500), 0.0f, 1500.0f, 0.0f, 0.0f, -1.0f, 0.0f);
  background(0);
  lights();
  noStroke(); 
  fill(255, 255, 255);
  turtle.drawExpression3D();
}

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
    setAxiom("F"); 
    V = new Production[10]; 
    numExpr = 0; 
    addProduction("F", "F[>F][^F]F[<F][&F]F");
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

void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
  // Initialize starting angle 
  float angle = 0;
  // Initialize increment for drawing cylinder 
  float angleIncrement = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  // Draw cylinder sides 
  for (int i = 0; i < sides + 1; ++i) {
    vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
    vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
    
    angle += angleIncrement;
  }
  endShape();
  
  // If it is not a cone, draw the circular top cap
  if (topRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);
    
    // Center point
    vertex(0, 0, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }
  // If it is not a cone, draw the circular bottom cap
  if (bottomRadius != 0) {
    angle = 0;
    beginShape(TRIANGLE_FAN);

    // Center point
    vertex(0, tall, 0);
    for (int i = 0; i < sides + 1; i++) {
      vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
      angle += angleIncrement;
    }
    endShape();
  }
}

// Centering function 
void centreTree() {
  fill(255, 255, 255);
  rotateZ(-PI);
  translate(-width, -height);
  translate(width/2, 100);
}

// 3D Turtle Class 
class turtle3D {
  // State variables 
  // Branch length 
  private float segLen; 
  // Branch radius 
  private float segRad;
  // Branch cylinder faces 
  private int segFaces;
  // Rotation angle 
  private float rotAng;
  // L-System generated expression 
  private String expression;
  
  //Constructor 
  turtle3D(String expression, float segLen, float segRad, float rotAng) {
    // Set state variables 
    this.segLen = segLen;
    this.segRad = segRad; 
    this.expression = expression;
    this.rotAng = rotAng; 
    this.segFaces = 64;
    
  }
  
  // Draw expression function 
  // F:Forward 
  // [: Push onto the stack 
  // ]: Pop from stack
  // +: Turn left about negative y-axis (right about y-axis)
  // -: Turn right about negative y-axis (left about y-axis)
  // &: Pitch down about negative x-axis (up about x-axis)
  // ^: Pitch up about negative x-axis (down about x-axis)
  // <: Roll left about z-axis 
  // >: Roll right about z-axis 
  public void drawExpression3D() {
    // Iterate through expression 
    for(int i = 0; i < expression.length(); i++) { 
      char currentCommand = expression.charAt(i);
      switch (currentCommand) {
        case 'F':
          // Draw Forward 
          drawCylinder(segRad, segRad, segLen, segFaces); 
          // Translate forward by segLen 
          translate(0, segLen, 0); 
          break;
        case '>':
          // Roll right about z-axis
          rotateZ(rotAng);
          break;
        case '<': 
          // Roll left about z-axis 
          rotateZ(-rotAng); 
          break;
        case '+':
          // Turn right about y-axis 
          rotateY(-rotAng);
          break;
        case '-': 
          // Turn left about y-axis 
          rotateY(rotAng); 
          break; 
        case '&': 
          // Pitch up about x-axis 
          rotateX(-rotAng); 
          break; 
        case '^': 
          // Pitch down about x-axis 
          rotateX(rotAng); 
          break; 
        case '[': 
          // Push matrix 
          pushMatrix(); 
          break;
        case ']': 
          // Pop matrix 
          popMatrix(); 
          break; 
      }
    }
  }
}
