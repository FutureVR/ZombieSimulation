import controlP5.*;

ArrayList<Zombie> zombies = new ArrayList<Zombie>();
ArrayList<Human> humans = new ArrayList<Human>();

int zombieCount;
int humanCount;

PVector startingPos = new PVector(width / 2, height / 2);
Agent agent = new Agent(startingPos);


ControlP5 cp5;

Button pauseButton;
Button restartButton;
Slider numberOfHumansSlider;
Slider numberOfZombiesSlider;
Slider zombieSpeedSlider;
Slider humanSpeedSlider;

int buttonWidth = 200;
int buttonHeight = 50;
int buttonVerticalOffset = 56;

int sliderWidth = 200;
int sliderHeight = 32;
int sliderVerticalOffset = 40;

boolean paused;

void setup()
{
  size(1600, 900);
  background(255);
  
  paused = false;
  cp5 = new ControlP5(this);
  
  //Create the UI
  restartButton = createButton("RESTART", width - buttonWidth - 10, 10, buttonWidth, buttonHeight);
  pauseButton = createButton("PAUSE", width - buttonWidth - 10, 10 + buttonVerticalOffset, buttonWidth, buttonHeight);
  numberOfHumansSlider = createSlider("NUM_OF_HUMANS", 10, 10, sliderWidth, sliderHeight, 1, 1000, 700);
  numberOfZombiesSlider = createSlider("NUM_OF_ZOMBIES", 10, 10 + sliderVerticalOffset, sliderWidth, sliderHeight, 1, 10, 4);
  humanSpeedSlider = createSlider("HUMAN_SPEED", 10, 10 + sliderVerticalOffset * 2, sliderWidth, sliderHeight , .1, 5, 1.7);
  zombieSpeedSlider = createSlider("ZOMBIE_SPEED", 10, 10 + sliderVerticalOffset * 3, sliderWidth, sliderHeight , .1, 4, 1);

  zombieCount = (int)numberOfZombiesSlider.getValue();
  humanCount = (int)numberOfHumansSlider.getValue();
  
  createHumans();
  createZombies();
}


void draw()
{
  if (!paused)
  {
    background(255);
    
    for(int i = 0; i < humans.size(); i++)
    {
      Human h = humans.get(i);
      
      h.updateTarget();
      h.spreadOut();
      h.updateSteering(true);
      h.updateMovement();
      h.display();
    }
    
    for(int i = 0; i < zombies.size(); i++)
    {
      Zombie z = zombies.get(i);
      
      z.updateTarget();
      z.spreadOut();
      z.updateSteering(false);
      z.updateMovement();
      z.display();
    }
  }
}


void createHumans()
{
  for(int i = 0; i < humanCount; i++)
  {
    humans.add(new Human(new PVector(random(0, width), random(0, height))));  
  }
}

void createZombies()
{
  for(int i = 0; i < zombieCount; i++)
  {
    zombies.add(new Zombie(new PVector(random(0, width), random(0, height))));  
  }
}

void destroyAllHumans()
{
  humans.clear();
}

void destroyAllZombies()
{
  zombies.clear();
}


public void controlEvent(ControlEvent theEvent) 
{
  Controller object = theEvent.getController();
  
  if (object == pauseButton)
  {
    paused = !paused;
  }
  else if (object == restartButton)
  {
    zombieCount = (int)numberOfZombiesSlider.getValue();
    humanCount = (int)numberOfHumansSlider.getValue();
    
    destroyAllHumans();
    destroyAllZombies();
    createHumans();
    createZombies();
  }

}

Button createButton(String name, int x, int y, int myWidth, int myHeight)
{
  Button button = cp5.addButton(name);
  button.setValue(0).setPosition(x, y).setSize(myWidth, myHeight);
  button.getCaptionLabel().setSize(myWidth / 10);
  return button;
}

Slider createSlider(String name, int x, int y, 
    int myWidth, int myHeight, float min, float max, float value)
{

  Slider slider = cp5.addSlider(name)
    .setCaptionLabel(name)
    .setPosition(x, y)
    .setColorCaptionLabel(color(0,0,0))
    .setSize(myWidth, myHeight)
    .setRange(min, max)
    .setValue(value)
    .setDecimalPrecision(2);
    
  slider.getCaptionLabel().setSize(20);
    
  return slider;
}