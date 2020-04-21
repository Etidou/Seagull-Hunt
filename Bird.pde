class Bird 
{  
  
  boolean mort = false;
  int x,y,r=75;
  int index;
  int compt, comptTime = 0;
  int vit;
  int nbImg;
  PImage img;
  PImage[] tabImg;
  Bird(String nomImg,int nbImage, int vitAnim)
  {
    index=0;
    compt=0;
    vit=vitAnim;
    nbImg=nbImage;
    img=loadImage(nomImg);
    tabImg=new PImage[nbImage];
    for (int i=0;i<nbImg;i++)
    {
      tabImg[i]=img.get(300*i,0,300,300);
    }
  }
  
  void move(int posX, int posY)
  {
    x = posX;
    y = posY;
  }
  
  void anim()
  {
    if (compt==vit)
    {
      compt=0;
      index=index+1;
      if (index==nbImg)
      {
        index=0;
      }
    }
    compt=compt+1;
    image(tabImg[index],x,y);
  }
  
  void testScreen()
  {
    if(x>(width+150)|| x<-150)
    {
      vie = 0;
      
      comptTime = comptTime + 1;
      println(comptTime);
      if(comptTime == 200)
      {
         startMenu = true;
         comptTime = 0;
      }
    }
  }
  
  boolean dead()
  {
    return mort;
  }
}
