class Human extends Agent
{
  float actionRadius = 100;
  boolean fleeing = false;
  PVector fixedPosition = new PVector(random(0, width), random(0, height));
  
  Human(PVector p)
  {
    super(p);  
  }
  
  
  void updateSteering(boolean human)
  {
    //if( dist(targetPosition.x, targetPosition.y, myPosition.x, myPosition.y) < actionRadius)
    {
      desiredVelocity = PVector.sub(targetPosition, myPosition);
      
      if(desiredVelocity.mag() < speedRadius)
      {
        float m;
        m = map(desiredVelocity.mag(), 0, speedRadius, maxHumanVelocity, baseHumanVelocity);
        desiredVelocity.setMag(m);
      }
      else
      {
        desiredVelocity.setMag(baseHumanVelocity);
      }
      
      if(fleeing) desiredVelocity.mult(-1);
      steering = PVector.sub(desiredVelocity, myVelocity);
      
      steering.limit(maxHumanForce);
      addForce(steering);
    }
  }
  
  
  void updateTarget()
  {
    smallestDistance = 2000;
    
    for(int i = 0; i < zombies.size(); i++)
    {
      distanceToTarget = mag(myPosition.x - zombies.get(i).myPosition.x, myPosition.y - zombies.get(i).myPosition.y);
      if(distanceToTarget < smallestDistance)
      {
        smallestDistance = distanceToTarget;
        closestIndex = i;
      }
    }
    
    if(zombies.size() > 0 && smallestDistance < actionRadius) 
    {
      fleeing = true;
      targetPosition = zombies.get(closestIndex).myPosition.copy();
    }
    else 
    {
      fleeing = false;
      targetPosition = makeWalkingPosition();
    }
  } 
  
  
  PVector makeWalkingPosition()
  {
    if((int)random(0, 400) == 0) fixedPosition = new PVector(random(0, width), random(0, height));
    return fixedPosition;
  }
  
  
  void spreadOut()
  {
    for(int i = humans.size() - 1; i >= 0; i--)
    {
      PVector distance = PVector.sub(myPosition, humans.get(i).myPosition);
      if(distance.mag() < 20)
      {
        distance.normalize();
        distance.mult(.4);
        super.addForce(distance);
      }    
    }  
  }
  
  
  void display()
  {
    fill(0, 0, 200);
    noStroke();
    ellipse(myPosition.x, myPosition.y, myDiameter, myDiameter);
  }
}