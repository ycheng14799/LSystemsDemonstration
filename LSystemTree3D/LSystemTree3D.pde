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
    setAxiom("A"); 
    V = new Production[10]; 
    numExpr = 0; 
    addProduction("A", "[&FL!A]/////'[&FL!A]///////'[&FL!A]");
    addProduction("F", "S/////F");
    addProduction("S","FL");
    addProduction("L","['''^^{-f+f+f-|-f+f+f}]"); 
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
