class Agent
{
  //Editable Values
  public float myDiameter = 10;
  float myRadius = myDiameter / 2f;
  float health = 10;
  float maxHumanVelocity = 1.7;
  float baseHumanVelocity = 1;
  float maxHumanForce = .05;
  float maxZombieVelocity = 1.3;
  float maxZombieForce = .5;
  float speedRadius = 70;
  
  // Non-editable Values
  PVector myPosition = new PVector();
  PVector myVelocity = new PVector(0, 0);
  PVector myAcceleration = new PVector();
  PVector targetPosition = new PVector(400, 400);
  boolean isDead = false;
  PVector desiredVelocity = new PVector();
  PVector steering = new PVector();
  float m = 10;
  float distanceToTarget;
  float smallestDistance = 1000;
  int closestIndex;
  
  
  public boolean attackMode = true;
  
  Agent(PVector p)
  {
    myPosition.x = p.x;
    myPosition.y = p.y;
  }
  
  void updateMovement()
  {
    baseHumanVelocity = humanSpeedSlider.getValue();
    maxZombieVelocity = zombieSpeedSlider.getValue();
    
    myVelocity.add(myAcceleration);
    myPosition.add(myVelocity);
    myAcceleration = new PVector(0, 0);
    
    if(myPosition.x + myRadius > width) myPosition.x = -myRadius;
    if(myPosition.x - myRadius < 0) myPosition.x = width + myRadius;
    if(myPosition.y - myRadius < 0) myPosition.y = height + myRadius;
    if(myPosition.y + myRadius > height) myPosition.y = -myRadius;
    
    //if(myPosition.x + myRadius > width) myPosition.x = width - myRadius;
    //if(myPosition.x - myRadius < 0) myPosition.x = myRadius;
    //if(myPosition.y - myRadius < 0) myPosition.y = myRadius;
    //if(myPosition.y + myRadius > height) myPosition.y = height - myRadius;
  }
  
  void updateSteering(boolean human)
  {
    desiredVelocity = PVector.sub(targetPosition, myPosition);
    
    if(desiredVelocity.mag() < speedRadius)
    {
      float m;
      if(human) m = map(desiredVelocity.mag(), 0, speedRadius, maxHumanVelocity, baseHumanVelocity);
      else m = map(desiredVelocity.mag(), 0, speedRadius, 0, maxZombieVelocity);
      desiredVelocity.setMag(m);
    }
    else
    {
      if(human) desiredVelocity.setMag(baseHumanVelocity);
      else  desiredVelocity.setMag(maxZombieVelocity);
    }
    
    if(human) desiredVelocity.mult(-1);
    steering = PVector.sub(desiredVelocity, myVelocity);
    
    if(human) steering.limit(maxHumanForce);
    else steering.limit(maxZombieForce);
    
    addForce(steering);
  }
  
  void takeDamage(float damage)
  {
    health -= damage;
    if(health <= 0)
    {
      isDead = true;
    }
  }
  
  void addForce(PVector force)
  {
    myAcceleration.add(force);
  }
  
  boolean isDead()
  {
    if(isDead) return true;
    else return false;
  }
  
  void setPosition(PVector p)
  {
    myPosition = p.copy();    
  }
  
  void display()
  {
    ellipse(myPosition.x, myPosition.y, myDiameter, myDiameter);  
  }
}