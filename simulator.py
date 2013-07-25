# SET UP ALL VARIABLES

from math import atan2, cos, sin, degrees, radians, sqrt
from random import uniform

# MAIN CONSTANTS
gravity = 0.1
airresist = 0.005
width = 982
height = 477

# A PARAMS
overheightA = 220
overcloseA = 10
overproxA = 75
underheightA = 325
undercloseA = 25
freqA = 10
speedA = 5
estoneadjustA = 0
esttwoadjustA = 0

#B PARAMS
overheightB = 227
overcloseB = 10
overproxB = 75
underheightB = 325
undercloseB = 10
freqB = 10
speedB = 5
estoneadjustB = -3
esttwoadjustB = 0

# GLOBALS
Apos = 282.0
Arot = -50.0
Aforehand = False
Abackhand = False
Bpos = 700.0
Brot = 50.0
Bforehand = False
Bbackhand = False
shuttX = 200.0
shuttDX = 0.0
shuttY = 50.0
shuttDY = 0.0
shuttAngle = 0.0
shuttDir = 0.0
shuttVel = 0.0
counterA = 0
counterB = 0
estimateoneA = 282.0
estimatetwoA = 282.0
estimateoneB = 700.0
estimatetwoB = 700.0
smashadjustA = 0
smashadjustB = 0
go = 0
serve = True

# SET UP CANVAS AND LOAD SOUNDS AND IMAGES
# MAIN LOOP
def main_loop(target):
    global Apos, Arot, Aforehand, Abackhand, Bpos, Brot, Bforehand, Bbackhand
    global shuttX, shuttDX, shuttY, shuttDY, shuttAngle, shuttDir, shuttVel, counterA, counterB
    global estimateoneA, estimatetwoA, estimateoneB, estimatetwoB, go, serve
    Apos = 282.0
    Arot = -50.0
    Aforehand = False
    Abackhand = False
    Bpos = 700.0
    Brot = 50.0
    Bforehand = False
    Bbackhand = False
    shuttX = 200.0
    shuttDX = 0.0
    shuttY = 50.0
    shuttDY = 0.0
    shuttAngle = 0.0
    shuttDir = 0.0
    shuttVel = 0.0
    counterA = 0
    counterB = 0
    estimateoneA = 282.0
    estimatetwoA = 282.0
    estimateoneB = 700.0
    estimatetwoB = 700.0
    smashadjustA = 0
    smashadjustB = 0
    go = 0
    you = 0
    them = 0
    counterA = 0
    counterB = 0

    shotcount = 0
    hitfloor = 0
    out = 0
    hittwice = 0

    # RESET GAME WHEN A POINT ENDS GIVEN NEW SERVER
    def resetGame(server):
        global Apos, Arot, Aforehand, Abackhand, Bpos, Brot, Bforehand, Bbackhand
        global shuttX, shuttDX, shuttY, shuttDY, shuttAngle, shuttDir, shuttVel, counterA, counterB
        global estimateoneA, estimatetwoA, estimateoneB, estimatetwoB, go, serve
        Apos = 282.0
        Arot = -50
        Aforehand = False
        Abackhand = False
        Bpos = 700.0
        Brot = 50.0
        Bforehand = False
        Bbackhand = False
        if serve:
          shuttX = 782 + uniform(-50, 50)
          go = 1
        else:
          shuttX = 200 + uniform(-50, 50)
          go = 0
        shuttDX = 0
        shuttY = 50
        shuttDY = 0
        shuttAngle = 0
        shuttDir = 0
        shuttVel = 0
        counterA = 0
        counterB = 0
        estimateoneA = 282.0
        estimatetwoA = 282.0
        estimateoneB = 700.0
        estimatetwoB = 700.0
        smashadjustA = 0
        smashadjustB = 0
        serve = not serve

    # MAIN LOOP
    while True:
        # CHECK IF GAME HAS BEEN WON
        if (you > target and (you - them) > 1):
            return (you, them, shotcount/(you+them), hitfloor, out, hittwice)
        if (them > target and (them - you) > 1):
            return (you, them, shotcount/(you+them), hitfloor, out, hittwice)
        
      # APPLY PHYSICS
        shuttX = shuttX + shuttDX
        shuttY = shuttY + shuttDY
        shuttDY += gravity
        
      # KEEP SHUTTLE POINTING THE RIGHT WAY (UNLESS IT'S ALMOST STOPPED)
        shuttDir = degrees(atan2(shuttDY, shuttDX))-90
        shuttVel = pow(pow(shuttDX, 2) + pow(shuttDY, 2), 0.5)
        if (shuttVel > 2):
          shuttAngle = shuttDir
        
      # APPLY AIR RESISTANCE
        resist = pow(shuttVel, 2) * airresist
        shuttDX += resist * sin(radians(shuttDir))
        shuttDY -= resist * cos(radians(shuttDir))
      
      # RACKET ANIMATION
        if (Aforehand):
            Arot += 5
            if (Arot > 50.1):
                Aforehand = False
                Arot = -50
        if (Abackhand):
            Arot -= 5
            if (Arot < 70.1):
                Abackhand = False
                Arot = -50
        if (Bforehand):
            Brot -= 5
            if (Brot < -50.1):
                Bforehand = False
                Brot = 50
        if (Bbackhand):
            Brot += 5
            if (Brot > -70.1):
                Bbackhand = False
                Brot = 50
      
      # COLLISION DETECTION
        # floor
        if (shuttY > 450):
            shuttDY = -0.6 * shuttDY
            if (shuttX > width/2 and shuttX < 970):
                you += 1
                resetGame(0)
                hitfloor += 1
            elif (shuttX < width/2 and shuttX > 7):
                them += 1
                resetGame(1)
                hitfloor += 1
            elif (shuttX <= 7):
                you += 1
                resetGame(0)
                out += 1
            elif (shuttX >= 970):
                them += 1
                resetGame(1)
                out += 1
        
        # racket A
        Adist = dist(Apos, 300, shuttX, shuttY)
        if (Adist > 40 and Adist < 90):
            tempang = degrees(atan2(shuttY-300, shuttX-Apos)) + 90
            if (abs(tempang - Arot) <= 5.0):
                if (Aforehand):
                    shuttDX = 75 * cos(radians(Arot))
                    shuttDY = 75 * sin(radians(Arot))
                    go += 1
                    shotcount += 1
                if (Abackhand):
                    shuttDX = 75 * -cos(radians(Arot))
                    shuttDY = 75 * -sin(radians(Arot))
                    go += 1
                    shotcount += 1
        
        # racket B
        Bdist = dist(Bpos, 300, shuttX, shuttY)
        if (Bdist > 40 and Bdist < 90):
            tempang = degrees(atan2(shuttY-300, shuttX-Bpos)) + 90
            if (abs(tempang - Brot) % 360.0 <= 5.0):
                if (Bforehand):
                    shuttDX = 75 * -cos(radians(Brot))
                    shuttDY = 75 * -sin(radians(Brot))
                    go -= 1
                    shotcount += 1
                if (Bbackhand):
                    shuttDX = 75 * cos(radians(Brot))
                    shuttDY = 75 * sin(radians(Brot))
                    go -= 1 
                    shotcount += 1
        
        # net
        if (shuttY > height - 200 and shuttX > width/2 - 15 and shuttX < width/2 + 15):
            if (shuttY < height - 193):
                shuttDY = -0.6 * shuttDY
            else:
                shuttDX = -0.6 * shuttDX
      
        # check for hit twice
        if (go > 1):
            them += 1
            resetGame(1)
            hittwice += 1
        if (go < 0):
            you += 1
            resetGame(0)
            hittwice += 1

        # COMPUTER AI - PLAYER A
        counterA += 1
        # only update AI calculations once every 10 frames (lower overhead, less jerky AI)
        if (counterA > freqA):
            if (go > 0):
                estimateoneA = 332
                estimatetwoA = 332
                smashadjustA = 0
            else:
                estimateoneA, estimatetwoA, smashadjustA = aione(shuttX, shuttY, shuttVel, shuttAngle, shuttDX, -1)
                if estimateoneA:
                    estimateoneA += estoneadjustA
                if estimatetwoA:
                    estimatetwoA += esttwoadjustA
            counterA = 0
        # if estimateone exists, it means the AI thinks it can get in position to hit overhead, so move in that
        # direction at maximum speed given by speed variable
        # otherwise, move towards the position for an underarm shot
        if (estimateoneA):
            Apos += constrain(estimateoneA - Apos + smashadjustA, -speedA, speedA)
        elif (estimatetwoA):
            Apos += constrain(estimatetwoA - Apos, -speedA, speedA)
        # make sure AI racquet stays within its court
        Apos = constrain(Apos, 17, 482)
        # if the AI thinks it's in a good position for a overhead shot, swing overhead
        # otherwise, if it thinks it might be in a good position for an underarm, do that (less exact)
        if (estimateoneA and abs(estimateoneA - Apos + smashadjustA) < overcloseA and abs(shuttX - Apos) < overproxA and shuttY > (overheightA + smashadjustA) and not Aforehand):
            Aforehand = True
        elif (estimatetwoA and abs(estimatetwoA - Apos) < undercloseA and shuttY > underheightA and not Abackhand):
            Abackhand = True
            Arot = 170.0
      
        # COMPUTER AI - PLAYER B
        counterB += 1
        # only update AI calculations once every 10 frames (lower overhead, less jerky AI)
        if (counterB > freqB):
            if (go < 1):
                estimateoneB = 650
                estimatetwoB = 650
                smashadjustB = 0
            else:
                estimateoneB, estimatetwoB, smashadjustB = aione(shuttX, shuttY, shuttVel, shuttAngle, shuttDX, 1)
                if estimateoneB:
                    estimateoneB += estoneadjustB
                if estimatetwoB:
                    estimatetwoB += esttwoadjustB
            counterB = 0
        # if estimateone exists, it means the AI thinks it can get in position to hit overhead, so move in that
        # direction at maximum speed given by speed variable
        # otherwise, move towards the position for an underarm shot
        if (estimateoneB):
            Bpos += constrain(estimateoneB - Bpos + smashadjustB, -speedB, speedB)
        elif (estimatetwoB):
            Bpos += constrain(estimatetwoB - Bpos, -speedB, speedB)
        # make sure AI racquet stays within its court
        Bpos = constrain(Bpos, 500, 965)
        # if the AI thinks it's in a good position for a overhead shot, swing overhead
        # otherwise, if it thinks it might be in a good position for an underarm, do that (less exact)
        if (estimateoneB and abs(estimateoneB - Bpos + smashadjustB) < overcloseB and abs(shuttX - Bpos) < overproxB and shuttY > (overheightB - smashadjustB) and  not Bforehand):
            Bforehand = True
        elif (estimatetwoB and abs(estimatetwoB - Bpos) < undercloseB and shuttY > underheightB and not Bbackhand):
            Bbackhand = True
            Brot = -190.0

        # print "(" + str(shuttX) + ", " + str(shuttY) + ") " + str(shuttDir) + "  [" + str(Bpos) + ", " + str(counterB) + "]"

# CONSTRAIN FUNCTION
def constrain(a, x, y):
    if x > y:
        x, y = y, x
    if a < x:
        return x
    elif a > y:
        return y
    else:
        return a

# DISTANCE FUNCTION
def dist(a, b, c, d):
    return pow(pow(a - c, 2) + pow(b - d, 2), 0.5)

def aione(shuttX, shuttY, shuttVel, shuttAngle, shuttDX, player):
    # estimateone and estimatetwo essentially use standard differential-equation solutions for a projectile (with
    # no air resistance), and then crudely adjust them to account for the physics of a shuttlecock
    # estimateone is where the racket needs to be to hit overhead
    # estimatetwo is where the racket needs to be to hit underarm
    theta = radians(90 - shuttAngle)
    adjVel = pow(shuttVel, 0.7)
    termone = pow(adjVel * sin(theta), 2) + (2 * gravity * (200 - shuttY))
    termtwo = pow(adjVel * sin(theta), 2) + (2 * gravity * (350 - shuttY))
    smashadjust = 0
    if termone > 0:
        estimateone = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + sqrt(termone))) - (5 * shuttDX) - (30 * player)
        estimateone -= ((estimateone - 491) / 20)
        if ((491 - estimateone) * player) > -109:
            smashadjust = 60 * player
    else:
        estimateone = None
    # if it's not AI's turn, aim for the middle of the court
    if termtwo > 0:
        estimatetwo = shuttX - ((adjVel * cos(theta) / gravity) * ((adjVel * sin(theta)) + sqrt(termtwo))) - (10 * player)
    else:
        estimatetwo = None
    return (estimateone, estimatetwo, smashadjust)
