/* @pjs preload="./assets/mapTextures/swamp_2.jpg","./assets/mapTextures/grass_2.jpg","./assets/mapTextures/river_2.jpg","./assets/mapTextures/road_2.jpg","./assets/otherTextures/loot.png","./assets/otherTextures/car.png","./assets/playerTextures/player1.png","./assets/playerTextures/player2.png","./assets/playerTextures/player3.png","./assets/playerTextures/player4.png","./assets/monsterTextures/monster1.png","./assets/monsterTextures/monster2.png","./assets/monsterTextures/monster3.png","./assets/monsterTextures/monster4.png","./assets/otherTextures/granade.png"; */

PImage imgSwamp, imgGrass, imgRiver, imgRoad, imgLoot, imgCar, imgPlayer1, imgPlayer2, imgPlayer3, imgPlayer4, imgEnemy1, imgEnemy2, imgEnemy3, imgEnemy4, imgGranade; //<>//
String[] map = {
"..........~.........",
".......%%.~.........",
".......%%.~.........",
"@.....@.@.~...@.....",
"...@......~.........",
"..........~.........",
"..........~....%%...",
"..........~....%%...",
"..........~.........",
"........%%~..@......",
".....@..%%~...%%....",
"..........~...%%....",
"====================",
"..........~.........",
"..........~.....%%..",
"..........~.....%%..",
"..........~.........",
"..........~.........",
"..........~.........",
"..........~........."
}; //<Don`t forget that we have debug ;)>//
boolean pressedW, pressedA, pressedS, pressedD;
boolean gameWin = false;
boolean gameOver = false;
boolean debugMode = false;
boolean GoD = false;
boolean gameStopped = true;
boolean gameStart = false;
boolean bombPlanted = false;
String[] reset;
int x = 0;
int y = 0;
int px;
int py;
int lpx;
int lpy;
int lmx;
int lmy;
int cx;
int cy;
int sx;
int sy;
int mx = 1;
int my = 1;
int scoreLoot = 0;
int need = 5;
int lenX;
int lenY;
int DIM = 20;
int di;
int score = 0;
int level = 1;
int cooldownBomb = 3;
int readyBomb = 0;
int MCD = 7;
int monsterCooldown = MCD;
int az = 1;
int paz = 1;
int FAZE_MAX = 4;
int faze = 0;
int mFaze = 0;
int Gx;
int Gy;
int cooldown;
int lastKeyCode;
button buttonStart;
button buttonRusume;
button buttonRestart;
button Up;
button Left;
button Right;
button Down;
boolean pUp;
boolean pLeft;
boolean pRight;
boolean pDown;


void setup()
{
  size(600, 625);
  frameRate(25);

  try
  {
    //font = loadFont("tahoma.ttf");
    //textFont(font);
  }
  catch (Exception e)
  {
    //println(e);
  }
  textSize(12);

  background(255);
  noStroke();
  mapGenerator();



  imgSwamp = loadImage("assets/mapTextures/swamp_2.jpg");
  imgGrass = loadImage("assets/mapTextures/grass_2.jpg");
  imgRiver = loadImage("assets/mapTextures/river_2.jpg");
  imgRoad = loadImage("assets/mapTextures/road_2.jpg");
  imgLoot = loadImage("assets/otherTextures/loot.png");
  imgCar = loadImage("assets/otherTextures/car.png");
  imgPlayer1 = loadImage("assets/playerTextures/player1.png");
  imgPlayer2 = loadImage("assets/playerTextures/player2.png");
  imgPlayer3 = loadImage("assets/playerTextures/player3.png");
  imgPlayer4 = loadImage("assets/playerTextures/player4.png");
  imgEnemy1 = loadImage("assets/monsterTextures/monster1.png");
  imgEnemy2 = loadImage("assets/monsterTextures/monster2.png");
  imgEnemy3 = loadImage("assets/monsterTextures/monster3.png");
  imgEnemy4 = loadImage("assets/monsterTextures/monster4.png");
  imgGranade = loadImage("assets/otherTextures/granade.png");
  //saveStrings("map.txt", map);

  buttonStart = new button(120, 140, 200, 100, "START");
  buttonRestart = new button(120, 140, 200, 100, "RESTART");
  buttonRusume = new button(300, 340, 200, 100, "RESUME");
  Up = new button(10, 10, 100, 100, "в†‘");
  Left = new button(10, 110, 100, 100, "в†ђ");
  Right = new button(10, 210, 100, 100, "в†’");
  Down = new button(10, 310, 100, 100, "в†“");
}


void draw()
{
  background(255);
//return;
  noStroke();
  gameLogic();
  drawMap();
  drawPlayer();
  drawMonster();
  drawgameWinCar();
  if (faze > 0)
  {
    faze--;
  }
  if (mFaze > 0)
  {
    mFaze--;
  }

  if (keyCode != 0)
  {
    lastKeyCode = keyCode;
  }

  if (gameStopped == true)
  {
    if (gameStart == false)
    {
      buttonStart.draw();
    }
    if (gameStart == true)
    {
      if (gameOver == true)
      {
        buttonRestart.draw();
      }
      if (gameOver == false)
      {
        buttonRestart.draw();
        buttonRusume.draw();
      }
    }
  }
  if (debugMode == true)
  {
    Up.draw();
    Left.draw();
    Right.draw();
    Down.draw();
  }
}


void keyPressed()
{
    if (keyCode==87)
  {
    pressedW = true;
  }
  if (keyCode==65)
  {
    pressedA = true;
  }
  if (keyCode==83)
  {
    pressedS = true;
  }
  if (keyCode==68)
  {
    pressedD = true;
  }
  if (faze != 0)
  {
    return;
  }
 
  if (gameWin != true && gameOver != true)
  {
    if (pressedW && py != 0 && gameStopped == false /*|| keyCode == 38 && py != 0 && gameStopped == false*/) // w = 87
    {
      copyPlayerCoords();
      py -= 1;
      if (map[py].charAt(px) != char('.') && map[py].charAt(px) != char('=') && map[py].charAt(px) != char('@'))
      {
        py += 1;
      }
      paz = 4;
    }
    if (pressedA && px != 0 && gameStopped == false /*|| keyCode == 37 && px != 0 && gameStopped == false*/) // a = 65
    {
      copyPlayerCoords();
      px -= 1;
      if (map[py].charAt(px) != char('.') && map[py].charAt(px) != char('=') && map[py].charAt(px) != char('@'))
      {
        px +=1;
      }
      paz = 3;
    }
    if (pressedS && py != DIM - 1 && gameStopped == false /*|| keyCode == 40 && py != DIM - 1 && gameStopped == false*/) // s = 83
    {
      copyPlayerCoords();
      py += 1;
      if (map[py].charAt(px) != char('.') && map[py].charAt(px) != char('=') && map[py].charAt(px) != char('@'))
      {
        py -= 1;
      }
      paz = 2;
    }
    if (pressedD && px != DIM - 1 && gameStopped == false /*|| keyCode == 39 && px != DIM - 1 && gameStopped == false*/) // d = 68
    {
      copyPlayerCoords();
      px += 1;
      if (map[py].charAt(px) != char('.') && map[py].charAt(px) != char('=') && map[py].charAt(px) != char('@'))
      {
        px -= 1;
      }
      paz = 1;
    }
  }

  if (keyCode == 32 && bombPlanted == false && gameStopped == false) // SPACE = 32
  {
    bombPlanted = true;
    Gy = py;
    Gx = px;
  }

  if (keyCode == 47 && debugMode == true && gameStopped == false)
  {
    scoreLoot++;
    GoD = true;
  }

  if (key == ESC || keyCode == 80) // p = 80
  {
    if (gameStopped == false)
    {
      gameStopped = true;
    } else
    {
      gameStopped = false;
    }
    key = 0;
  }
}


int CS = 30;


void swamp(int x, int y)
{
  image(imgSwamp, x*CS, y*CS, CS, CS);
}


void grass(int x, int y)
{
  image(imgGrass, x*CS, y*CS, CS, CS);
}

void river(int x, int y)
{
  image(imgRiver, x*CS, y*CS, CS, CS);
}


void road(int x, int y)
{

  image(imgRoad, x*CS, y*CS, CS, CS);
}


void loot(int x, int y)
{
  image(imgLoot, x*CS, y*CS, CS, CS);
}


void drawgameWinCar()
{
  if (scoreLoot >= need)
  {
    image(imgCar, cx*CS, cy*CS, CS, CS);
  }
}


//void drawStartCar()
//{
  //sx = cx;
  //sy = cy;
  //image(imgCar, sx*CS, sy*CS, CS, CS);
//}


void drawMap()
{
  for (y = 0; y < map.length; y++)
  {
    for (x = 0; x < map[y].length(); x++)
    {
      if (map[y].charAt(x) == char('%'))
      {
        swamp(x, y);
      }
      if (map[y].charAt(x) == char('.'))
      {
        grass(x, y);
      }
      if (map[y].charAt(x) == char('~'))
      {
        river(x, y);
      }
      if (map[y].charAt(x) == char('='))
      {
        road(x, y);
      }
      if (map[y].charAt(x) == char('@'))
      {
        grass(x, y);
        loot(x, y);
      }
    }
  }
  if (bombPlanted)
  {
    if (cooldown == frameRate)
    {
      readyBomb++;
    }
    if (readyBomb == cooldownBomb)
    {
      bombPlanted = false;
    }
    drawGranade();
  }
  cooldown--;
}


void drawPlayer()
{
  //fill(255);
  //ellipse(px*CS + CS/2, py*CS + CS/2, CS, CS);
  //image(imgPlayer1, px*CS, py*CS, CS, CS);
  PImage pen = imgPlayer1;
  if (paz == 1)
  {
    pen = imgPlayer1;
  }
  if (paz == 2)
  {
    pen = imgPlayer2;
  }
  if (paz == 3)
  {
    pen = imgPlayer3;
  }
  if (paz == 4)
  {
    pen = imgPlayer4;
  }
  //image(pen, px*CS, py*CS, CS, CS);
  float fpx = px - 1.0 * faze / FAZE_MAX * (px - lpx);
  float fpy = py - 1.0 * faze / FAZE_MAX * (py - lpy);


  image(pen, fpx*CS, fpy*CS, CS, CS);
}

void drawMonster()
{
  //fill(255, 0, 0);
  //ellipse(mx*CS + CS/2, my*CS + CS/2, CS, CS);
  //image(imgEnemy, mx*CS, my*CS, CS, CS);
  PImage en = imgEnemy1;
  if (az == 1)
  {
    en = imgEnemy1;
  }
  if (az == 2)
  {
    en = imgEnemy2;
  }
  if (az == 3)
  {
    en = imgEnemy3;
  }
  if (az == 4)
  {
    en = imgEnemy4;
  }

  float fmx = mx - 1.0 * mFaze / FAZE_MAX * (mx - lmx);
  float fmy = my - 1.0 * mFaze / FAZE_MAX * (my - lmy);

  if (scoreLoot >= 1) image(en, fmx*CS, fmy*CS, CS, CS);
}

void gameLogic()
{
  if (!gameStopped)
  {
    monsterCooldown--;
  }

  if (monsterCooldown <= 0 && gameOver != true && gameWin != true && scoreLoot > 0)
  {
    monsterCooldown = MCD;
    az = monsterStep();
    if (az == 1)
    {
      copyMonsterCoords();
      mx++;
    }
    if (az == 2)
    {
      copyMonsterCoords();
      my++;
    }
    if (az == 3)
    {
      copyMonsterCoords();
      mx--;
    }
    if (az == 4)
    {
      copyMonsterCoords();
      my--;
    }
  }

  if (px == mx && py == my && scoreLoot >= 1 && GoD == false)
  {
    gameOver = true;
    //println("game over");
  gameStopped = true;
  }
  if (map[py].charAt(px) == char('@'))
  {
    map[py] = replace(map[py], px, '.');
    scoreLoot++;
    score++;
  }
  if (px == cx && py == cy && gameWin != true && scoreLoot >= 5)
  {
    //gameWin = true;
    //println("gameWin");
    mapGenerator();
    scoreLoot = 0;
    level++;
  }
  fill(0);
  text("SCORE: " + score, 10, 620);
  text("LEVEL: " + level, 80, 620);
  if (debugMode != false)
  {
    text("GOT_LOOT: " + scoreLoot, 150, 620);
    text("FPS: " + int(frameRate), 250, 620);
    text("DEBUG: " + debugMode, 310, 620);
    text("KEY_CODE: " + lastKeyCode, 400, 620);
    print("keyCode = ");
    println(keyCode);
  }
}



void drawGranade()
{
  image(imgGranade, Gx*CS, Gy*CS, CS, CS);
}

String replace(String s, int p, char ch)
{
  String newS = s.substring(0, p) + char(ch) + s.substring(p+1);
  return newS;
}


int monsterStep()
{
  int mdu;
  int mdr;
  int mdd;
  int mdl;

  int DIM = 20;
  //String[] imput;

  int n1 = 1000; // right
  int n2 = 1000; // down
  int n3 = 1000; // left
  int n4 = 1000; // up

  int VERY_MUCH = 1000;


  int a = min( min(n1, n2), min(n3, n4));

  float d0 = dist(mx, my, px, py);

  float dr = dist(mx+1, my, px, py);
  float dd = dist(mx, my+1, px, py);
  float dl = dist(mx-1, my, px, py);
  float du = dist(mx, my-1, px, py);

  char sc;


  //println("d0", d0);

  sc = map[my].charAt(constrain(mx+1, 0, DIM-1));
  //println("dr", "\""+sc+"\"", dr);

  sc = map[constrain(my+1, 0, DIM-1)].charAt(mx);
  //println("dd", "\""+sc+"\"", dd);

  sc = map[my].charAt(constrain(mx-1, 0, DIM-1));
  //println("dl", "\""+sc+"\"", dl);

  sc = map[constrain(my-1, 0, DIM-1)].charAt(mx);
  //println("du", "\""+sc+"\"", du);

  char ch;

  if (mx+1 < DIM)
  {
    ch = map[my].charAt(mx+1);
    if (ch == char('~') || ch == char('%'))
    {
      dr = VERY_MUCH;
    }
  }

  if (my+1 < DIM)
  {
    ch = map[my+1].charAt(mx);
    if (ch == char('~') || ch == char('%'))
    {
      dd = VERY_MUCH;
    }
  }

  if (mx-1 >= 0)
  {
    ch = map[my].charAt(mx-1);
    if (ch == char('~') || ch == char('%'))
    {
      dl = VERY_MUCH;
    }
  }

  if (my-1 >= 0)
  {
    ch = map[my-1].charAt(mx);
    if (ch == char('~') || ch == char('%'))
    {
      du = VERY_MUCH;
    }
  }

  //int i = int(min(min(dr, dd), min(dl, du)));

  float rm = d0;
  int azimut = -1;
  if (dr < rm)
  {
    rm = dr;
    azimut = 1;
  }

  if (dd < rm)
  {
    rm = dd;
    azimut = 2;
  }

  if (dl < rm)
  {
    rm = dl;
    azimut = 3;
  }

  if (du < rm)
  {
    rm = du;
    azimut = 4;
  }
  //println(azimut);

  mdu = int(dist(px, py, px, my));  //up 234
  mdr = int(dist(px, py, mx, py));  //right 134
  mdd = int(dist(px, my, px, py));  //down  12
  mdl = int(dist(mx, py, px, py));  //left


  return azimut;
}

void copyPlayerCoords()
{
  lpx = px;
  lpy = py;
  faze = FAZE_MAX;
}

void copyMonsterCoords()
{
  lmx = mx;
  lmy = my;
  mFaze = FAZE_MAX;
}

void addRandomSwamp()
{
  int sx = int(random(DIM-1));
  int sy = int(random(DIM-1));
  map[sy] = replace(map[sy], sx, '%');
  map[sy] = replace(map[sy], sx+1, '%');
  map[sy+1] = replace(map[sy+1], sx, '%');
  map[sy+1] = replace(map[sy+1], sx+1, '%');
}

void addRandomRiver()
{
  di = int(random(0, 2));
  //println("dimantion", di);
  if (di == 0)
  {
    addRandomHRiver();
  } else
  {
    addRandomVRiver();
  }
}

void addRandomHRiver()
{
  int ry = int(random(5, DIM-1-5));
  for (int x = 0; x < DIM; x++)
  {
    int dy = 0;//int(random(2));
    map[ry+dy] = replace(map[ry+dy], x, '~');
  }
}

void addRandomVRiver()
{
  int rx = int(random(5, DIM-1-5));
  for (int y = 0; y < DIM; y++)
  {
    map[y] = replace(map[y], rx, '~');
  }
}

void addRandomWay()
{
  if (di == 1)
  {
    addRandomHWay();
  } else
  {
    addRandomVWay();
  }
}

void addRandomHWay()
{
  int ry = int(random(5, DIM-1-5));
  for (int x = 0; x < DIM; x++)
  {
    int dy = 0;//int(random(2));
    map[ry+dy] = replace(map[ry+dy], x, '=');
  }
}

void addRandomVWay()
{
  int rx = int(random(5, DIM-1-5));
  for (int y = 0; y < DIM; y++)
  {
    map[y] = replace(map[y], rx, '=');
  }
}

void addRandomLoot()
{
  int sx = int(random(DIM-1));
  int sy = int(random(DIM-1));

  int coLoot = 7;
  for (int f = 0; f<coLoot; f++)
  {
    while (map[sy].charAt(sx) != char('.'))
    {
      sx = int(random(DIM-1));
      sy = int(random(DIM-1));
    }
    map[sy] = replace(map[sy], sx, '@');
  }
}


void make(int h, char symbvol)
{
  String[] object = new String[h];
  for (int k = 0; k < h; k++)
  {
    object[k] = "";
    object[k] = object[k] + char(symbvol);
  }
  //println(object);
}

void mapGenerator()
{
  //map = loadStrings("map.txt");


  //println(mx, my, px, py);
  lenY = DIM; //map.length;
  lenX = DIM; //map[0].length();
  map = new String[lenY];

  for (int h = 0; h < lenY; h++)
  {
    map[h] = "";
    for (int d = 0; d < lenY; d++)
    {
      map[h] = map[h] + ".";
    }
  }


  int coSwamp = 5;
  for (int d = 0; d<coSwamp; d++)
  {
    addRandomSwamp();
  }


  addRandomRiver();


  addRandomWay();


  addRandomLoot();


  while (map[cy].charAt(cx) != char('='))
  {
    cx = int(random(20-1));
    cy = int(random(20-1));
  }

  while (map[py].charAt(px) != char('=') && map[cy].charAt(cx) != map[py].charAt(px))
  {
    px = int(random(20-1));
    py = int(random(20-1));
  }

  while (map[my].charAt(mx) != char('=') && map[my].charAt(mx) != map[py].charAt(px) && map[my].charAt(mx) != map[cy].charAt(cx))
  {
    if (di == 1)
    {
      for (int h = 0; DIM == h; h++)
      {
      }
    }
    mx = int(random(20-1));
    my = int(random(20-1));
  }
}

void mouseMoved()
{
  if (gameStopped == true)
  {
    buttonStart.mouseMoved(mouseX, mouseY);
    buttonRusume.mouseMoved(mouseX, mouseY);
    buttonRestart.mouseMoved(mouseX, mouseY);
  }
  Up.mouseMoved(mouseX, mouseY);
  Right.mouseMoved(mouseX, mouseY);
  Left.mouseMoved(mouseX, mouseY);
  Down.mouseMoved(mouseX, mouseY);
}

void mousePressed()
{
  if (gameStopped == true)
  {
    if (buttonStart.mousePressed(mouseX, mouseY) == true)
    {
      mapGenerator();
      gameStopped = false;
      gameStart = true;
    }
    if (buttonRusume.mousePressed(mouseX, mouseY) == true)
    {
      gameStopped = false;
    }

    if (buttonRestart.mousePressed(mouseX, mouseY) == true)
    {
      gameStopped = false;
      scoreLoot = 0;
      score = 0;
      level = 1;
      gameOver = false;
    }
  }
  if (Up.mousePressed(mouseX, mouseY) == true)
  {
    pUp = true;
  } else if (Right.mousePressed(mouseX, mouseY) == true)
  {
    pRight = true;
  } else if (Left.mousePressed(mouseX, mouseY) == true)
  {
    pLeft = true;
  } else if (Down.mousePressed(mouseX, mouseY) == true)
  {
    pDown = true;
  } else
  {
    pUp = false;
    pRight = false;
    pLeft = false;
    pDown = false;
  }
}

void playerGo()
{

}

class button
{
  int _bx;
  int _by;
  int _bw;
  int _bh;
  boolean _bo = false;
  String _bString = "LAL";

  PGraphics _bg;

  button(int bx, int by, int bw, int bh, String bString)
  {
    _bx = bx;
    _by = by;
    _bw = bw;
    _bh = bh;
    _bString = bString;

    _bg = createGraphics(_bw, _bh);
    drawPrepare();
  }

  void draw()
  {
    _bg.beginDraw();
    if (_bo == true)
    {
      _bg.fill(255, 150, 150);
    } else
    {
      _bg.fill(255);
    }
    _bg.rect(0, 0, _bw, _bh);
    _bg.fill(0, 255, 0);
    _bg.text(_bString, _bw/2, _bh/2);
    _bg.endDraw();

    image(_bg, _bx, _by);
  }

  void drawPrepare()
  {
    _bg.beginDraw();
    _bg.background(0);

    //PFont pf = createFont("sans.ttf", 72);
    //_bg.textFont(pf);
    _bg.textAlign(CENTER, CENTER);
    _bg.textSize(40);

    _bg.endDraw();
  }

  void mouseMoved(int mx, int my)
  {
    if (mx >= _bx && mx <= _bx + _bw && my >= _by && my <= _by + _bh)
    {
      _bo = true;
    } else
    {
      _bo = false;
    }
  }

  boolean mousePressed(int mx, int my)
  {
    boolean bp = (mx >= _bx && mx <= _bx + _bw && my >= _by && my <= _by + _bh);
    //println(bp);
    return bp;
  }
}

void keyReleased()
{
    if (keyCode==87)
  {
    pressedW = false;
  }
  if (keyCode==65)
  {
    pressedA = false;
  }
  if (keyCode==83)
  {
    pressedS = false;
  }
  if (keyCode==68)
  {
    pressedD = false;
  }
}
