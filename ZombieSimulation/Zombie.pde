class Zombie extends Agent
{
  float turnRadius = 10;
  
  Zombie(PVector p)
  {
    super(p);  
  }
  
  
  void updateTarget()
  {
    if(attackMode)
    {
      smallestDistance = 2000;
      
      for(int i = 0; i < humans.size(); i++)
      {
        distanceToTarget = mag(myPosition.x - humans.get(i).myPosition.x, myPosition.y - humans.get(i).myPosition.y);
        
        if(distanceToTarget < turnRadius)
        {
          makeZombie(i);
        }
        
        if(turnRadius < distanceToTarget && distanceToTarget < smallestDistance)
        {
          smallestDistance = distanceToTarget;
          closestIndex = i;
        }
      }
      
      if(humans.size() > 0) targetPosition = humans.get(closestIndex).myPosition.copy();
    }
  } 
  
  void makeZombie(int index)
  {
    PVector humanPosition = humans.get(index).myPosition;
    humans.remove(index);
    zombies.add(new Zombie(humanPosition));
  }
  
  void spreadOut()
  {
    for(int i = zombies.size() - 1; i >= 0; i--)
    {
      PVector distance = PVector.sub(myPosition, zombies.get(i).myPosition);
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
    fill(0, 200, 0);
    noStroke();
    ellipse(myPosition.x, myPosition.y, myDiameter, myDiameter);
  }
}