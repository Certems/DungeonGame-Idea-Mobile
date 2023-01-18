void displayInterface(){
    if(cDungeon.homeScreen){
        displayHomeScreen();
    }
    if(cDungeon.inGame){
        displayBackground();
        
        displayDungeon();
        displaySlimeInv();

        displayHotkeys();
    }
}
void displayDungeon(){
    cDungeon.update();
}
void displaySlimeInv(){
    cSlime.displayInv();
}


void displayBackground(){
    background(60,60,60);
}


void moveDungeonCam(){
    float camStep = 3.0;
    if(cDungeon.camUp){
        cDungeon.camPos.y -= camStep;}
    if(cDungeon.camDwn){
        cDungeon.camPos.y += camStep;}
    if(cDungeon.camLft){
        cDungeon.camPos.x -= camStep;}
    if(cDungeon.camRht){
        cDungeon.camPos.x += camStep;}
}

boolean showHotkeys = true;
void displayHotkeys(){
    if(showHotkeys)
    {
        float tSpace = 20.0;
        float xPos   = width-150.0;
        pushStyle();
        fill(255);
        textSize(20);
        textAlign(LEFT);
        //General
        text(frameRate, 30,30);
        text("y -> hotkeys", xPos,1.0*tSpace);
        text("e -> cursorUp ", xPos-200,1.0*tSpace);
        text("q -> cursorDwn", xPos-200,2.0*tSpace);
        text("---"        , xPos, 2.0*tSpace);
        if(cDungeon.floors.get(cSlime.fPos).exploration){
            text("w -> camUp ", xPos, 3.0*tSpace);
            text("s -> camDwn", xPos, 4.0*tSpace);
            text("a -> camLft", xPos, 5.0*tSpace);
            text("d -> camRht", xPos, 6.0*tSpace);
            text("---"        , xPos, 7.0*tSpace);
            text("t -> mveUp ", xPos, 8.0*tSpace);
            text("g -> mveDwn", xPos, 9.0*tSpace);
            text("f -> mveLft", xPos,10.0*tSpace);
            text("h -> mveRht", xPos,11.0*tSpace);
            text("---"        , xPos,12.0*tSpace);
            text("2 -> grow  ", xPos,13.0*tSpace);
            text("1 -> shrink", xPos,14.0*tSpace);
            text("r -> bubble", xPos,15.0*tSpace);
        }
        if(cDungeon.floors.get(cSlime.fPos).lootEncounter){
            text("1 -> cycle ", xPos,3.0*tSpace);
            text("2 -> select", xPos,4.0*tSpace);
        }
        if(cDungeon.floors.get(cSlime.fPos).combatEncounter){
            text("0 -> skip  ", xPos,3.0*tSpace);
        }
        popStyle();
    }
}