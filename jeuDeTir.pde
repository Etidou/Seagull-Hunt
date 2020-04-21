import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer backgroundMusic, shootMusic;

Serial port;

PImage background, sight, start_screen;
int db=100, xvalue = 0, yvalue = 0, sightMooveSpeed = 3, compt = 0, compt2 =3, score, nbrBird = 1, testNbrBird = 0, vie = 1, yrandom = 50;
boolean startMenu = true, isShooting = false;
Bird[] tableauBird = new Bird[500];



Sight mySight = new Sight(800, 800);
Bird myBird;
Start startButton = new Start();

void setup() 
{
  //constructeur
  size(1920, 1080);
  background = loadImage("paysage.png");
  background.resize(1920, 1080);
  start_screen = loadImage("start_screen.png");
  start_screen.resize(1920, 1080);
  sight = loadImage("sight.png");
  sight.resize(db, db);

  //birds
  //myBird = new Bird("bird_right_to_left.png",8,5);
  createBird();

  //musics
  minim = new Minim(this);
  shootMusic = minim.loadFile("shoot.mp3");
  backgroundMusic = minim.loadFile("music_loop.wav");

  //port
  port = new Serial(this, "COM6", 9600);
  port.bufferUntil('\n');
}

void draw()
{

  if (startMenu == false)
  {
    //background and background music
    image(background, 0, 0);
    if (!backgroundMusic.isPlaying())
    {
      backgroundMusic.rewind();
      backgroundMusic.play();
    }

    //text
    PFont police;
    police = createFont("txtFont.otf", 80);
    textFont(police);
    fill(255);
    text("Score: "+ score, 80, 1000);//appeler tableau
    text("Vie : "+vie, 1740, 1000);
    
    //ecran de fin
    gameOver();

    //disparition de l'oiseau quand mort
    shootBird();
    compt = compt+7+compt2;
    for (int i=0; i<nbrBird; i++)
    {

      if (!tableauBird[i].dead())
      {
        tableauBird[i].move(1920-compt-compt2, yrandom);
        tableauBird[i].anim();//postion du bird
        tableauBird[i].testScreen();
      } else if (testNbrBird == nbrBird & tableauBird[i].dead())
      {
        compt = 0;
        compt2 = int(random(6,15));
        testNbrBird = 0;
        createBird();
        tableauBird[i].mort = false;
        yrandom = int(random(25,800));
        //nbrBird = nbrBird + 1;//augmente le nombre d'oiseau mais probleme : ils sont au meme endroit car x et y sont mis en meme temps pour tous (peut etre le definir dans le tableau de creation)
      }
    }

    //viseur
    mySight.move();
    mySight.display();
    delay(5);
    mySight.testScreen();
  } else
  {
    //start background
    image(start_screen, 0, 0);

    //fond button
    startButton.display();

    //text button
    PFont police;
    police = loadFont("SegoeUI-48.vlw");
    textFont(police);
    fill(0);
    text("START", 835, 520);

    //viseur
    mySight.move();
    mySight.display();
    delay(5);
    mySight.testScreen();
  }
}


void serialEvent(Serial port) 
{
  String serialStr = port.readStringUntil('\n');
  serialStr = trim(serialStr);
  int values[] = int(split(serialStr, ','));
  int button = values[3];
  if ( values.length == 4 ) 
  {
    println(values);
    yvalue = calculate( values[0], 338 );
    xvalue = calculate( values[1], 341 );
    if (button == 1)
    {
      shootMusic.rewind();
      shootMusic.play();
      isShooting = true;
    } else
    {
      isShooting = false;
    }

    if (startMenu == true & mySight.intersectMenu(startButton) & button == 1 & vie == 1)
    {
      startMenu = false;
    }
    
    else if(startMenu == true & mySight.intersectMenu(startButton) & button == 1 & vie == 0)
    {
      vie = 1;
      startMenu = false;
      compt = 0;
      score = 0;
    }
  }
}



int calculate( int returnValue, int baseValue ) 
{
  int diff = returnValue - baseValue;
  return round(diff/sightMooveSpeed);
}

void createBird()
{

  for (int i = 0; i<nbrBird; i++)
  {
    tableauBird[i] = new Bird("bird_right_to_left.png", 8, 5);
  }
}

void shootBird()
{
  for (int i=0; i<nbrBird; i++)
  {
    if (mySight.intersect(tableauBird[i]) & isShooting == true)
    {
      score = score+100;
      testNbrBird = testNbrBird + 1;
      tableauBird[i].mort = true;
    }
  }
}

void gameOver()
{
  if(vie == 0)
  {
      fill(255);
      text("T'as perdu...",825,200);
      text("Faut croire que ce jeu est trop difficile pour un mickey comme toi", 250, 300);//appeler tableau
      text("Vous allez être redirigé vers l'écran de titre dans quelques secondes", 240, 570); 
  }
}
