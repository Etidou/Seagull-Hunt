class Sight 
{
  int x,y;

  Sight (int posX, int posY)
  {
    x = posX;
    y = posY;
  }

  void move()
  {
    x = x+xvalue;
    y = y+yvalue;
  }

  void display()
  {
    image(sight,x,y);
  }
  
  void testScreen()
  {
    if(x>(width - 110)|| x<0)
    {
      x = x-xvalue;
    }
    
    if(y>(height - 130)|| y<0)
    {
      y = y-yvalue;
    }
  }
  
  boolean intersect(Bird b) 
  {
      int rSight=1;
      float distance = dist(x, y, b.x, b.y);
  
      if (distance < rSight + b.r) 
      {
        return true;
      }
      else 
      {
        return false;
      }
  }
  
  boolean intersectMenu(Start button) 
  {
      int rSight=1;
      float distance = dist(x, y, button.x, button.y);
  
      if (distance < rSight + button.r) 
      {
        return true;
      }
      else 
      {
        return false;
      }
  }
  
}
