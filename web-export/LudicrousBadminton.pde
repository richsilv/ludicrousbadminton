//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies

Maxim maxim;
AudioPlayer swinga, swingb, swingc, swingd, hita, hitb, nethit, floor, cheer, boo;

float Apos = 100.0;
float Arot = -50;
boolean Aforehand = false;
boolean Abackhand = false;
float Bpos = 700.0;
float Brot = 50.0;
boolean Bforehand = false;
boolean Bbackhand = false;
float shuttX = 200;
float shuttDX = 0;
float shuttY = 50;
float shuttDY = 0;
float shuttAngle = 0;
float shuttDir = 0;
float shuttVel = 0;
float gravity = 0.1;
float airresist = 0.005;
int shuttSize = 40;
int framerate = 60;
boolean hit = false;
int counter = 0;
float estimateone = 0;
float estimatetwo = 0;
float speed = 5;
int go = 0;
int gamemode = 0;
long mil = 0;

PImage court, net, shuttle, racone, ractwo, frontpage, instructions;

int you = 0;
int them = 0;

void setup() {
  size(982, 477);
  frameRate(framerate);
  textSize(26);

  maxim = new Maxim(this);
  swinga = maxim.loadFile("swing1.wav");
  swinga.setLooping(false);
  swinga.volume(0.2);
  swingb = maxim.loadFile("swing3.wav");
  swingb.setLooping(false);
  swingb.volume(0.2);
  swingc = maxim.loadFile("swing1.wav");
  swingc.setLooping(false);
  swingc.volume(0.2);
  swingd = maxim.loadFile("swing3.wav");
  swingd.setLooping(false);
  swingd.volume(0.2);
  hita = maxim.loadFile("hit1.wav");
  hita.setLooping(false);
  hita.volume(1.0);
  hitb = maxim.loadFile("hit2.wav");
  hitb.setLooping(false);
  hitb.volume(0.8);
  nethit = maxim.loadFile("net1.wav");
  nethit.setLooping(false);
  nethit.volume(0.5);
  floor = maxim.loadFile("floor1.wav");
  floor.setLooping(false);
  floor.volume(1.0);
  cheer = maxim.loadFile("cheer.wav");
  cheer.setLooping(false);
  cheer.volume(1.0);
  boo = maxim.loadFile("boo.wav");
  boo.setLooping(false);
  boo.volume(1.0);

  court = loadImage("background.png");
  net = loadImage("net.png");
  shuttle = loadImage("shuttlecock1.png");
  racone = loadImage("racket2.png");
  ractwo = loadImage("racket3.png");
  frontpage = loadImage("frontpage.png"); 
  instructions = loadImage("instructions.png");

  imageMode(CENTER);
}

void draw() {
switch(gamemode) {
  case 0:
  // This is the welcome screen
    image(court, width/2, height/2, width, height);
    image(frontpage, width/2, height/2, 750, 380);
    
    if (mousePressed == true) {
       if (mouseX <= 467 && mouseX >= 279 && mouseY >= 319 && mouseY <= 405) {
         gamemode = 2;
       }
       if (mouseX <= 708 && mouseX >= 530 && mouseY >= 323 && mouseY <= 409) {
         gamemode = 1;
       }       
    }
    break;
  
  case 1:
  // This is the instructions screen
    image(court, width/2, height/2, width, height);
    image(instructions, width/2, height/2, 680, 380);
    
    if (mousePressed == true) {
       if (mouseX <= 529 && mouseX >= 351 && mouseY >= 323 && mouseY <= 411) {
         gamemode = 0;
       }
    }    
    break;
  
  case 2:
  // This is the actual game
  
  // CHECK IF GAME HAS BEEN WON
    if (you == 11) {
      cheer.stop();
      cheer.play();
      mil = millis();
      while (millis() - mil < 2000) {}
    }
    if (them == 11) {
      boo.stop();
      boo.play();
      mil = millis();
      while (millis() - mil < 2000) {}
    }
    
  // APPLY PHYSICS
    shuttX = shuttX + shuttDX;
    shuttY = shuttY + shuttDY;
    shuttDY += gravity;
    Apos = constrain(mouseX, 30, 450);
    
  // KEEP SHUTTLE POINTING THE RIGHT WAY (UNLESS IT'S ALMOST STOPPED)
    shuttDir = degrees(atan2(shuttDY, shuttDX))-90;
    shuttVel = sqrt(pow(shuttDX, 2) + pow(shuttDY, 2));
    if (shuttVel > 2) {
      shuttAngle = shuttDir;
    }
    
  // APPLY AIR RESISTANCE
    float resist = pow(shuttVel, 2) * airresist;
    shuttDX += resist * sin(radians(shuttDir));
    shuttDY -= resist * cos(radians(shuttDir));
  
  // RACKET ANIMATION
    if (Aforehand) {
      Arot += 5;
      if (Arot > 50) {
        Aforehand = false;
        Arot = -50;
      }
    }
    if (Abackhand) {
      Arot -= 5;
      if (Arot < 70) {
        Abackhand = false;
        Arot = -50;
      }
    }
    if (Bforehand) {
      Brot -= 5;
      if (Brot < -50) {
        Bforehand = false;
        Brot = 50;
      }
    }
    if (Bbackhand) {
      Brot += 5;
      if (Brot > -70) {
        Bbackhand = false;
        Brot = 50;
      }
    }
  
  // COLLISION DETECTION
    // floor
    if (shuttY > 450) {
      floor.stop();
      floor.play();
      shuttDY = -0.6 * shuttDY;
      if (shuttX > width/2 && shuttX < 970) {
        you += 1;
        resetGame(0);
      } else if (shuttX < width/2 && shuttX > 7) {
        them += 1;
        resetGame(1);
      } else if (shuttX <= 7) {
        you += 1;
        resetGame(0);
      } else if (shuttX >= 970) {
        them += 1;
        resetGame(1);
      }
    }
    
    // racket A
    float Adist = dist(Apos, 300, shuttX, shuttY);
    if (Adist > 40 && Adist < 90) {
      float tempang = degrees(atan2(shuttY-300, shuttX-Apos)) + 90;
      if (abs(tempang - Arot) < 5.0) {
        if (Aforehand) {
          shuttDX = 75 * cos(radians(Arot));
          shuttDY = 75 * sin(radians(Arot));
          go += 1;
          hita.stop();
          hita.play();
        }
        if (Abackhand) {
          shuttDX = 75 * -cos(radians(Arot));
          shuttDY = 75 * -sin(radians(Arot));
          go += 1;
          hitb.stop();
          hitb.play();
        }
      }
    }
    
    // racket B
    float Bdist = dist(Bpos, 300, shuttX, shuttY);
    if (Bdist > 40 && Bdist < 90) {
      float tempang = degrees(atan2(shuttY-300, shuttX-Bpos)) + 90;
      if (abs(tempang - Brot) % 360 < 5.0) {
        if (Bforehand) {
          shuttDX = 75 * -cos(radians(Brot));
          shuttDY = 75 * -sin(radians(Brot));
          go -= 1;
          hita.stop();
          hita.play();
        }
        if (Bbackhand) {
          shuttDX = 75 * cos(radians(Brot));
          shuttDY = 75 * sin(radians(Brot));
          go -= 1 ;
          hitb.stop();
          hitb.play();
        }
      }
    }
    
    // net
    if (shuttY > height - 200 && shuttX > width/2 - 15 && shuttX < width/2 + 15) {
      nethit.stop();
      nethit.play();
      if (shuttY < height - 193) {
        shuttDY = -0.6 * shuttDY;
      }
      else {
        shuttDX = -0.6 * shuttDX;
      }
    }
  
    // check for hit twice
    if (go > 1) {
      them += 1;
      resetGame(1);
    }
    if (go < 0) {
      you += 1;
      resetGame(0);
    }
  
  // COMPUTER AI
    counter += 1;
    if (counter > 10) {
      float theta = radians(90 - shuttAngle);
      float adjVel = pow(shuttVel, 0.7);
      float termone = sqrt(sq(adjVel * sin(theta)) + (2 * gravity * (200 - shuttY)));
      float termtwo = sqrt(sq(adjVel * sin(theta)) + (2 * gravity * (350 - shuttY)));
      estimateone = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + termone)) - 30 - (5 * shuttDX);
      estimateone -= ((estimateone - 488) / 20);
      if (go < 1) {
        estimateone = 650;
      }
      estimatetwo = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + termtwo)) + 5;
      counter = 0;
    }
    if (estimateone) {
      Bpos += constrain(estimateone - Bpos, -speed, speed);
    } else if (estimatetwo) {
      Bpos += constrain(estimatetwo - Bpos, -speed, speed);
    }
    Bpos = constrain(Bpos, 500, 965);
    if (estimateone && abs(estimateone - Bpos) < 10 && abs(shuttX - Bpos) < 75 && shuttY > 220 && !Bforehand) {
      Bforehand = true;
      swingd.stop();
      swingd.play();
    } else if (estimatetwo && abs(estimatetwo - Bpos) < 25 && shuttY > 325 && !Bbackhand) {
      Bbackhand = true;
      Brot = -190;
      swingc.stop();
      swingc.play();
    }
    
  // DRAW BACKDROP
    image(court, width/2, height/2, width, height);
    stroke(0);
    fill(0);
    text("Score: " + you + " - " + them, 20, 40);
  
  // DRAW OBJECTS
    pushMatrix();
    translate(Apos, 300);
    rotate(radians(Arot));
    translate(0, -40);
    image(racone, 0, 0, 30, 100);
    popMatrix();
    
    pushMatrix();
    translate(Bpos, 300);
    rotate(radians(Brot));
    translate(0, -40);
    image(ractwo, 0, 0, 30, 100);
    popMatrix();
    
    pushMatrix();
    translate(shuttX, shuttY);
    rotate(radians(shuttAngle));
    image(shuttle, 0, 0, shuttSize, shuttSize);
    popMatrix();
    
    image(net, width/2, height-100, 30, 200);
    break;
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    if (!Aforehand && !Abackhand) {
      Abackhand = true;
      swinga.stop();
      swinga.play();
      Arot = 170;      
    }
  }
  else {
    if (!Aforehand && !Abackhand) {
      Aforehand = true;
      swingb.stop();
      swingb.play();
    }
  }
}

void keyPressed() {
  if (int(key) == 114) {
    resetGame(0);
  }
}

void mouseReleased() {

}

void resetGame(int server) {
    Apos = 100.0;
    Arot = -50;
    Aforehand = false;
    Abackhand = false;
    Bpos = 700.0;
    Brot = 50.0;
    Bforehand = false;
    Bbackhand = false;
    if (server) {
      shuttX = 780;
      go = 1;
    } else {
      shuttX = 200;
      go = 0;
    }
    shuttDX = 0;
    shuttY = 50;
    shuttDY = 0;
    shuttAngle = 0;
    shuttDir = 0;
    shuttVel = 0;
    counter = 0;
    estimateone = 0;
    estimatetwo = 0;    
}

