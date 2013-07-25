//The MIT License (MIT) - See Licence.txt for details

// SET UP ALL VARIABLES
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
int counterA = 0;
float estimateoneA = 0;
float estimatetwoA = 0;
int counterB = 0;
float estimateoneB = 0;
float estimatetwoB = 0;
float speed = 5;
int go = 0;
int gamemode = 0;
long mil = 0;

PImage court, net, shuttle, racone, ractwo, frontpage, instructions;

int you = 0;
int them = 0;

// SET UP CANVAS AND LOAD SOUNDS AND IMAGES
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

// MAIN LOOP
void draw() {

// JUMP TO SECTION DEPENDING ON GAME MODE (Welcome screen, Instructions, Game itself)
switch(gamemode) {
  case 0:
  // This is the welcome screen
    image(court, width/2, height/2, width, height);
    image(frontpage, width/2, height/2, 750, 380);
    
    if (mousePressed == true) {
       if (mouseX <= 440 && mouseX >= 279 && mouseY >= 319 && mouseY <= 405) {
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
    image(instructions, width/2, height/2, 680, 400);
    
    if (mousePressed == true) {
       if (mouseX <= 529 && mouseX >= 351 && mouseY >= 333 && mouseY <= 421) {
         gamemode = 0;
       }
    }    
    break;
  
  case 2:
  // This is the actual game
  
  // CHECK IF GAME HAS BEEN WON
    if (you > 10 && (you - them) > 1) {
      cheer.stop();
      cheer.play();
      mil = millis();
      while (millis() - mil < 2000) {}
      you = 0;
      them = 0;
      gamemode = 0;
      break;
    }
    if (them > 10 && (them - you) > 1) {
      boo.stop();
      boo.play();
      mil = millis();
      while (millis() - mil < 2000) {}
      you = 0;
      them = 0;
      gamemode = 0;
      break;
    }
    
  // APPLY PHYSICS
    shuttX = shuttX + shuttDX;
    shuttY = shuttY + shuttDY;
    shuttDY += gravity;
    
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
          nethit.stop();
        }
        if (Abackhand) {
          shuttDX = 75 * -cos(radians(Arot));
          shuttDY = 75 * -sin(radians(Arot));
          go += 1;
          hitb.stop();
          hitb.play();
          nethit.stop();
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
          nethit.stop();
        }
        if (Bbackhand) {
          shuttDX = 75 * cos(radians(Brot));
          shuttDY = 75 * sin(radians(Brot));
          go -= 1 ;
          hitb.stop();
          hitb.play();
          nethit.stop();
        }
      }
    }
    
    // net
    if (shuttY > height - 200 && shuttX > width/2 - 15 && shuttX < width/2 + 15) {
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
    counterA += 1;
    // only update AI calculations once every 10 frames (lower overhead, less jerky AI)
    if (counterA > 10) {
      // estimateoneB and estimatetwoB essentially use standard differential-equation solutions for a projectile (with
      // no air resistance), and then crudely adjust them to account for the physics of a shuttlecock
      // estimateoneB is where the racket needs to be to hit overhead
      // estimatetwoB is where the racket needs to be to hit underarm
      float theta = radians(90 - shuttAngle);
      float adjVel = pow(shuttVel, 0.7);
      float termone = sqrt(sq(adjVel * sin(theta)) + (2 * gravity * (200 - shuttY)));
      float termtwo = sqrt(sq(adjVel * sin(theta)) + (2 * gravity * (350 - shuttY)));
      estimateoneA = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + termone)) + 25 - (5 * shuttDX);
      estimateoneA -= ((estimateoneA - 491) / 20);
      // if it's not AI's turn, aim for the middle of the court
      if (go > 0) {
        estimateoneA = 332;
      }
      estimatetwoA = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + termtwo)) + 10;
      counterA = 0;
    }
    if (estimateoneA > 382) {
      float smashadjustA = 60;
    } else {
      float smashadjustA = 0;
    }
    // if estimateoneB exists, it means the AI thinks it can get in position to hit overhead, so move in that
    // direction at maximum speed given by speed variable
    // otherwise, move towards the position for an underarm shot
    if (estimateoneA) {
      Apos += constrain(estimateoneA - Apos - smashadjustA, -speed, speed);
    } else if (estimatetwoA) {
      Apos += constrain(estimatetwoA - Apos, -speed, speed);
    }
    // make sure AI racquet stays within its court
    Apos = constrain(Apos, 17, 482);
    // if the AI thinks it's in a good position for a overhead shot, swing overhead
    // otherwise, if it thinks it might be in a good position for an underarm, do that (less exact)
    if (estimateoneA && abs(estimateoneA - Apos - smashadjustA) < 10 && abs(shuttX - Apos) < 75 && shuttY > (227 - smashadjustA) && !Aforehand) {
      Aforehand = true;
      swingd.stop();
      swingd.play();
    } else if (estimatetwoA && abs(estimatetwoA - Apos) < 25 && shuttY > 325 && !Abackhand) {
      Abackhand = true;
      Arot = 170;
      swingc.stop();
      swingc.play();
    }

    counterB += 1;
    // only update AI calculations once every 10 frames (lower overhead, less jerky AI)
    if (counterB > 10) {
      // estimateoneB and estimatetwoB essentially use standard differential-equation solutions for a projectile (with
      // no air resistance), and then crudely adjust them to account for the physics of a shuttlecock
      // estimateoneB is where the racket needs to be to hit overhead
      // estimatetwoB is where the racket needs to be to hit underarm
      float theta = radians(90 - shuttAngle);
      float adjVel = pow(shuttVel, 0.7);
      float termone = sqrt(sq(adjVel * sin(theta)) + (2 * gravity * (200 - shuttY)));
      float termtwo = sqrt(sq(adjVel * sin(theta)) + (2 * gravity * (350 - shuttY)));
      estimateoneB = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + termone)) - 30 - (5 * shuttDX);
      estimateoneB -= ((estimateoneB - 491) / 20);
      // if it's not AI's turn, aim for the middle of the court
      if (go < 1) {
        estimateoneB = 650;
      }
      estimatetwoB = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + termtwo)) - 10;
      counterB = 0;
    }
    if (estimateoneB < 600) {
      float smashadjustB = 60;
    } else {
      float smashadjustB = 0;
    }
    // if estimateoneB exists, it means the AI thinks it can get in position to hit overhead, so move in that
    // direction at maximum speed given by speed variable
    // otherwise, move towards the position for an underarm shot
    if (estimateoneB) {
      Bpos += constrain(estimateoneB - Bpos + smashadjustB, -speed, speed);
    } else if (estimatetwoB) {
      Bpos += constrain(estimatetwoB - Bpos, -speed, speed);
    }
    // make sure AI racquet stays within its court
    Bpos = constrain(Bpos, 500, 965);
    // if the AI thinks it's in a good position for a overhead shot, swing overhead
    // otherwise, if it thinks it might be in a good position for an underarm, do that (less exact)
    if (estimateoneB && abs(estimateoneB - Bpos + smashadjustB) < 10 && abs(shuttX - Bpos) < 75 && shuttY > (220 - smashadjustB) && !Bforehand) {
      Bforehand = true;
      swingd.stop();
      swingd.play();
    } else if (estimatetwoB && abs(estimatetwoB - Bpos) < 25 && shuttY > 325 && !Bbackhand) {
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

// Testing utility
void keyPressed() {
  if (int(key) == 114) {
    resetGame(0);
  }
}

// RESET GAME WHEN A POINT ENDS GIVEN NEW SERVER
void resetGame(int server) {
    Apos = constrain(mouseX, 30, 450);
    Arot = -50;
    Aforehand = false;
    Abackhand = false;
    Bpos = 700.0;
    Brot = 50.0;
    Bforehand = false;
    Bbackhand = false;
    if (server) {
      shuttX = 780 + random(-50, 50);
      go = 1;
    } else {
      shuttX = 200 + random(-50, 50);
      go = 0;
    }
    shuttDX = 0;
    shuttY = 50;
    shuttDY = 0;
    shuttAngle = 0;
    shuttDir = 0;
    shuttVel = 0;
    counterB = 0;
    estimateoneB = 0;
    estimatetwoB = 0;
}

