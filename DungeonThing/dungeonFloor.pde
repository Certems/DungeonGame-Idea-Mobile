class dungeonFloor{
    ArrayList<ArrayList<tile>> tiles = new ArrayList<ArrayList<tile>>();
    ArrayList<entity> entities = new ArrayList<entity>();

    ArrayList<ArrayList<item>> rundownLoot = new ArrayList<ArrayList<item>>();  //1st -> for misc loot, 2nd -> for noteable loot

    ArrayList<entity> combatEntities = new ArrayList<entity>();

    boolean exploration     = true;
    boolean lootEncounter   = false;
    boolean combatEncounter = false;

    boolean treasureRundown = false;

    float cTimer = 0;
    float mTimer = 4.0*60.0;

    int lootPileInd = 0;

    float tileWidth = 40.0;

    int floorNumber;

    dungeonFloor(int dungeonFloorNumber, PVector floorDim){
        floorNumber = dungeonFloorNumber;
        rundownLoot.add( new ArrayList<item>() );
        rundownLoot.add( new ArrayList<item>() );
        buildTiles(floorDim);
        if(dungeonFloorNumber == 0){
            spawnSlime();
        }
    }

    void display(){
        if(treasureRundown){
            displayTreasureRundown();}
        else if(combatEncounter){
            displayCombatEncounter();}
        else if(lootEncounter){
            displayLootEncounter();}
        else if(exploration){
            displayExploration();}
        displayHoveredSlimeSlots();
    }
    void calculate(){
        if(treasureRundown){
        }
        else if(combatEncounter){
            calcCombatEncounter();}
        else if(lootEncounter){
            calcLootEncounter();}
        else if(exploration){
            calcExploration();}
    }
    void update(){
        display();
        calculate();
    }
    void displayHoveredSlimeSlots(){
        ArrayList<PVector> hPoints = new ArrayList<PVector>();
        for(int j=-floor(cSlime.gridSize/2.0); j<ceil(cSlime.gridSize/2.0); j++){
            for(int i=-floor(cSlime.gridSize/2.0); i<ceil(cSlime.gridSize/2.0); i++){
                PVector hGridPoint = cSlime.findHoveredSlimeSlot( new PVector(mouseX +i*cSlime.sqrSize, mouseY +j*cSlime.sqrSize) );
                if(hGridPoint.x != -1){
                    hPoints.add(hGridPoint);}
            }
        }
        for(int i=0; i<hPoints.size(); i++){
            PVector pixelPos = new PVector( cSlime.origin.x - (cSlime.invDim.x/2.0) + hPoints.get(i).x*cSlime.sqrSize, cSlime.origin.y - (cSlime.invDim.y) + hPoints.get(i).y*cSlime.sqrSize );
            displayHoverIcon(pixelPos, 0.8*cSlime.sqrSize );
        }
    }
    void displayHoverIcon(PVector pos, float size){
        pushStyle();

        rectMode(CENTER);
        fill(255,255,255,125);
        rect(pos.x, pos.y, size, size);

        popStyle();
    }
    void calcExploration(){
        //pass
    }
    void displayExploration(){
        //println("Exploration");
        pushMatrix();
        translate(-(width/2.0) +((width)-(tiles.size()*tileWidth))/2.0, -(height/2.0) +((height/2.0)-(tiles.get(0).size()*tileWidth))/2.0); //Adjusts for level grid starting point

        displayTiles();
        displayEntities();
        displaySlime();

        popMatrix();
    }
    void calcLootEncounter(){
        //pass
    }
    void displayLootEncounter(){
        //println("Looting");
        pushMatrix();

        ArrayList<ArrayList<item>> treasureSet = ( (treasure)tiles.get( int(cSlime.pos.y) ).get( int(cSlime.pos.x) ) ).items;
        if(treasureSet.size() != 0){
            displayLootPiles(treasureSet);
        }
        else{
            displayExploration();
            lootEncounter = false;
            exploration   = true;
        }

        popMatrix();
    }
    void calcCombatEncounter(){
        progressCombat();   //Check for end of timer run + perform if so
        //...
    }
    void displayCombatEncounter(){
        //println("Fighting");
        pushMatrix();

        displayCombatFrame();
        displayCombatEntities();
        displayCombatHighlights();
        displayCombatTimer();
        displayActionButtons();
        displayCombatDamageNumbers();
        displayCombatText();

        popMatrix();
    }
    void displayCombatFrame(){
        pushStyle();

        rectMode(CENTER);
        noFill();
        stroke(255,0,0);
        strokeWeight(4);
        rect(width/2.0, height/4.0, 0.8*width, 0.8*height/2.0);
        
        popStyle();
    }
    void displayCombatTimer(){
        pushStyle();

        PVector timerDim = new PVector(width/3.0, height/20.0);
        PVector timerPos = new PVector(width/2.0, height/10.0);

        rectMode(CENTER);
        fill(120,120,120);
        stroke(0);
        strokeWeight(2);
        rect(timerPos.x, timerPos.y, timerDim.x, timerDim.y);

        rectMode(CORNERS);
        fill(255);
        rect(timerPos.x -timerDim.x/2.0, timerPos.y -timerDim.y/2.0, timerPos.x -(timerDim.x/2.0) +(cTimer/mTimer)*timerDim.x, timerPos.y +timerDim.y/2.0);

        popStyle();
    }
    void progressCombat(){
        cTimer++;
        if(cTimer >= mTimer){   //When time is up
            cTimer = 0; //reset timer
            cSlime.bubbleInvUp();
            entitiesAttack();
            println("---");
        }
        checkEntitiesAlive();
    }
    void checkEntitiesAlive(){
        /*
        Checks if entities are still alive in the encounter
        */
        boolean enemiesRemain = false;
        for(int i=0; i<combatEntities.size(); i++){
            if(combatEntities.get(i).hp > 0){
                enemiesRemain = true;
            }
        }
        if(!enemiesRemain){
            endCombatEncounter();
        }
    }
    void entitiesAttack(){
        //Force default/chosen player action + enemy selected action
        cSlime.calcAttack();
        for(int i=0; i<combatEntities.size(); i++){
            combatEntities.get(i).randomiseAction();
            combatEntities.get(i).calcAttack();
        }
    }
    void initCombatEncounter(){
        combatEntities.clear();
        for(int i=0; i<entities.size(); i++){
            boolean onTile = (entities.get(i).pos.x == cSlime.pos.x) && (entities.get(i).pos.y == cSlime.pos.y);
            if(onTile){
                combatEntities.add( entities.get(i) );
            }
        }
    }
    void endCombatEncounter(){
        combatEntities.clear();
        //Find entities just fought
        ArrayList<Integer> entitiesOnTile = new ArrayList<Integer>();
        for(int i=0; i<entities.size(); i++){
            boolean onTile = (entities.get(i).pos.x == cSlime.pos.x) && (entities.get(i).pos.y == cSlime.pos.y);
            if(onTile){
                entitiesOnTile.add(i);
            }
        }
        //Add loot to treasure rundown
        for(int j=0; j<entitiesOnTile.size(); j++){
            //Add to sub loot
            for(int i=0; i<entities.get( int(entitiesOnTile.get(j)) ).heldItems.size(); i++){
                rundownLoot.get(0).add( entities.get( int(entitiesOnTile.get(j)) ).heldItems.get(i) );
            }
            //Add to noteable loot
            for(int i=0; i<entities.get( int(entitiesOnTile.get(j)) ).heldWeapons.size(); i++){
                rundownLoot.get(1).add( entities.get( int(entitiesOnTile.get(j)) ).heldWeapons.get(i) );
            }
        }
        //Remove entities just fought
        for(int i=entitiesOnTile.size()-1; i>=0; i--){
            println("BEFORE -> ",entities.size());
            entities.remove( int(entitiesOnTile.get(i)) );
            println("AFTER  -> ",entities.size());
        }
        combatEncounter = false;
        exploration = true;
        treasureRundown = true;
    }
    void displayActionButtons(){
        //#############################################################################
        //## WILL NEED TO TAKE ITS POSITION AND WIDTH FROM A BUTTON LIST THING LATER ##
        //#############################################################################
        pushStyle();

        float boxWidth  = width/12.0;
        float boxHeight = height/24.0;

        rectMode(CENTER);
        textAlign(CENTER);
        textSize(18);
        stroke(0);
        strokeWeight(2);
        //---
        fill(100,100,100);
        if(cSlime.action == 0){
            fill(100,200,100);}
        rect(1.0*width/8.0, height/2.0 + height/12.0, boxWidth, boxHeight);
        fill(100,100,100);
        if(cSlime.action == 1){
            fill(100,200,100);}
        rect(1.0*width/8.0, height - height/12.0, boxWidth, boxHeight);
        fill(100,100,100);
        if(cSlime.action == 2){
            fill(100,200,100);}
        rect(7.0*width/8.0, height/2.0 + height/12.0, boxWidth, boxHeight);
        fill(100,100,100);
        if(cSlime.action == 3){
            fill(100,200,100);}
        if(cSlime.launchItems.size() > 0){   //## MORE LIKE AN INDICATOR ON A HELICOPTER FOR WHETHER LAUNCH IS ENGAGED ## 
            stroke(255,60,60);
            strokeWeight(4);}
        rect(7.0*width/8.0, height - height/12.0, boxWidth, boxHeight);
        //---
        fill(255);
        text("Slime hit",1.0*width/8.0, height/2.0 + height/12.0);
        text("Take cover",1.0*width/8.0, height - height/12.0);
        text("Relocate items",7.0*width/8.0, height/2.0 + height/12.0);
        text("Launcher primed",7.0*width/8.0, height - height/12.0);

        popStyle();
    }
    void displayCombatEntities(){
        /*
        |-------------------|e.g 1
        |               E   |
        |                   |
        |  S                |
        |-------------------|
        |-------------------|e.g 2
        |           E . E   |
        |             E     |
        |  S                |
        |-------------------|
        */
        pushStyle();

        PVector entityPos = new PVector(6.0*width/8.0, 1.5*height/10.0);  //Origin point to center of set of entities
        PVector slimePos  = new PVector(2.0*width/8.0, 3.5*height/10.0);
        float entityDist = 50.0;
        float dTheta = 2.0*PI / combatEntities.size();
        float textOffset = 50.0;

        //Enemies
        for(int i=0; i<combatEntities.size(); i++){
            combatEntities.get(i).display( new PVector(entityPos.x +entityDist*cos(i*dTheta), entityPos.y +entityDist*sin(i*dTheta)) );
            //Health
            text("Hp; "+combatEntities.get(i).hp, entityPos.x +entityDist*cos(i*dTheta), entityPos.y +entityDist*sin(i*dTheta)+textOffset);
        }

        //Slime
        cSlime.display(slimePos);
        //Health
        text("Hp; "+cSlime.hp, slimePos.x, slimePos.y+textOffset);
        
        popStyle();
    }
    void displayCombatHighlights(){
        pushStyle();

        //Enemy highlight
        //################################################ ACTUALLY LINK BACK TO LAST FUNCTION
        PVector entityPos = new PVector(6.0*width/8.0, 1.5*height/10.0);  //Origin point to center of set of entities
        PVector slimePos  = new PVector(2.0*width/8.0, 3.5*height/10.0);
        float entityDist = 50.0;
        float dTheta = 2.0*PI / combatEntities.size();
        //################################################
        rectMode(CENTER);
        noFill();
        stroke(255,0,0);
        strokeWeight(2);
        rect(entityPos.x +entityDist*cos(cSlime.target*dTheta), entityPos.y +entityDist*sin(cSlime.target*dTheta), entityDist, entityDist);

        //Action highlight
        //pass -> look at buttons, pull their positions + dims to draw alpha'ed box

        popStyle();
    }
    void displayCombatDamageNumbers(){
        pushStyle();

        //Slime damage taken
        //pass

        //Entity damage taken
        //pass

        popStyle();
    }
    void displayCombatText(){
        pushStyle();

        fill(255);
        textSize(30);
        textAlign(CENTER);
        text("Skip fight by pressing '0'",width/2.0, height/4.0);

        textSize(20);
        text("Action  -> "+cSlime.action,width/2.0, height/4.0 +20);
        text("Target  -> "+cSlime.target,width/2.0, height/4.0 +40);
        text("Launcher-> "+cSlime.launchItems.size(),width/2.0, height/4.0 +60);

        popStyle();
    }
    void displayTreasureRundown(){
        pushStyle();

        imageMode(CENTER);

        float dispRad = 1.0*width/20.0;
        float itemsPerWheel = 16.0;
        float dTheta  = 2.0*PI/itemsPerWheel;
        float incMulti= 1.5;

        //Sub-loot
        for(int i=0; i<rundownLoot.get(0).size(); i++){
            if(i % itemsPerWheel == 0){
                dispRad *= incMulti;
            }
            rundownLoot.get(0).get(i).display( new PVector(1.0*width/4.0 +dispRad*cos((i % itemsPerWheel)*dTheta), height/4.0 +dispRad*sin((i % itemsPerWheel)*dTheta)), new PVector(cSlime.sqrSize, cSlime.sqrSize) );
        }
        //Background for sub
        fill(220, 180, 60, 50);
        noStroke();
        ellipse(1.0*width/4.0, height/4.0, 2.0*dispRad, 2.0*dispRad);

        dispRad /= pow(incMulti, floor(rundownLoot.get(0).size()/itemsPerWheel));

        //Noteable loot
        for(int i=0; i<rundownLoot.get(1).size(); i++){
            if(i % itemsPerWheel == 0){
                dispRad *= incMulti;
            }
            rundownLoot.get(1).get(i).display( new PVector(3.0*width/4.0 +dispRad*cos((i % itemsPerWheel)*dTheta), height/4.0 +dispRad*sin((i % itemsPerWheel)*dTheta)), new PVector(cSlime.sqrSize, cSlime.sqrSize) );
        }
        //Background for noteable
        fill(180, 60, 220, 50);
        noStroke();
        ellipse(3.0*width/4.0, height/4.0, 2.0*dispRad, 2.0*dispRad);

        popStyle();
    }
    void calcSituation(){
        /*
        Triggers when the slime moves
        0. Reset situation
        1. Find conditions
        2. Adjust according to conditions

        Conditions elsewhere will cause the slime to return to exploration mode so it can move again and allow this to be triggered again
        */
        //0
        exploration = false;
        lootEncounter = false;
        combatEncounter = false;
        //1
        boolean onTreasureTile = tiles.get( int(cSlime.pos.y) ).get( int(cSlime.pos.x) ).type == 2;
        boolean hasTreasure    = false;
        boolean onEnemyTile    = checkForEnemyOnTile();
        
        //2
        //Treasure Encounter
        if(onTreasureTile){
            hasTreasure = ((treasure)tiles.get( int(cSlime.pos.y) ).get( int(cSlime.pos.x) )).items.size() > 0;
            if(hasTreasure){
                lootEncounter = true;
            }
        }
        //Enemy Encounter
        if(onEnemyTile){
            initCombatEncounter();
            combatEncounter = true;
        }
        //...
        //If no other encounters, then continue as exploration
        if(!onEnemyTile && !hasTreasure){
            exploration = true;
        }
    }
    boolean checkForEnemyOnTile(){
        for(int i=0; i<entities.size(); i++){
            if( (entities.get(i).pos.x == cSlime.pos.x) && (entities.get(i).pos.y == cSlime.pos.y) ){
                return true;
            }
        }
        return false;
    }
    void displayTiles(){
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                tiles.get(j).get(i).display(tileWidth);
            }
        }
    }
    void displayEntities(){
        for(int i=0; i<entities.size(); i++){
            entities.get(i).displaySmall(tileWidth);
        }
    }
    void displaySlime(){
        cSlime.displaySmall(tileWidth);
    }
    void displayLootPiles(ArrayList<ArrayList<item>> lootSets){
        float border  = 100.0;
        float spacing = (width-2.0*border)/(lootSets.size()+1);
        float range   = spacing/20.0;
        //println(spacing);

        pushStyle();
        stroke(255);
        strokeWeight(1);
        for(int j=0; j<lootSets.size(); j++){
            PVector dispBase = new PVector((j+1)*spacing, height/10.0);
            for(int i=0; i<lootSets.get(j).size(); i++){
                //## DRAW THE TEXTUES FOR THE ITEMS HERE ##
                //## MAKE RANDOM IN THE FUTURE ##
                pushStyle();
                lootSets.get(j).get(i).display( new PVector(dispBase.x, dispBase.y + range*i), new PVector(cSlime.sqrSize, cSlime.sqrSize) );
                popStyle();
            }
        }
        //Highlight selected pile
        PVector dispBase = new PVector((lootPileInd+1)*spacing, height/10.0);
        rectMode(CENTER);
        noFill();
        stroke(255);
        strokeWeight(3);
        rect(dispBase.x, dispBase.y + range*(lootSets.get(lootPileInd).size())/2.0, spacing/4.0, range*(lootSets.get(lootPileInd).size() +1));
        popStyle();

    }
    void buildTiles(PVector d){
        /*
        Creates the tiles in this floor, in a grid of size d, according 
        to parameters from the ## floor number ##
        */
        //fillEmptyCollide(d);
        fillCorridors(d);
        generateEmptyCollide();
        populateCorridors();
        populateEntities();
    }
    void fillEmptyCollide(PVector d){
        for(int j=0; j<d.y; j++){
            tiles.add( new ArrayList<tile>() );
            for(int i=0; i<d.x; i++){
                empty newTile = new empty( new PVector(i, j), -1, true );
                tiles.get(j).add(newTile);
            }
        }
    }
    void fillCorridors(PVector d){
        for(int j=0; j<d.y; j++){
            tiles.add( new ArrayList<tile>() );
            for(int i=0; i<d.x; i++){
                empty newTile = new empty( new PVector(i, j), 0, false );
                tiles.get(j).add(newTile);
            }
        }
    }
    void generateEmptyCollide(){
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                float rVal = random(0,1.0);
                if(rVal < 0.2){
                    empty newTile = new empty(new PVector(i,j), -1, true);
                    tiles.get(j).remove(i);
                    tiles.get(j).add(i, newTile);
                    //## ++ ADDS MORE HERE ##
                }
                else if(rVal < 0.3){
                    empty newTile = new empty(new PVector(i,j), -1, true);
                    tiles.get(j).remove(i);
                    tiles.get(j).add(i, newTile);
                }
            }
        }
    }
    void populateCorridors(){
        //Situation 1 preset
        int x = floor(random(0, tiles.get(0).size()));
        for(int j=0; j<tiles.size(); j++)
        {

            float rVal = random(0, 1.0);
            if(rVal <= 0.2){
                treasure newTile = new treasure(new PVector(x, j), 0, false);
                tiles.get(j).remove(x);
                tiles.get(j).add(x, newTile);
            }
            else{
                empty newTile = new empty(new PVector(x, j), 0, false);
                tiles.get(j).remove(x);
                tiles.get(j).add(x, newTile);
            }

            if(j == tiles.size()-1){
                exit newTile = new exit(new PVector(x, j), 0, false);
                tiles.get(j).remove(x);
                tiles.get(j).add(x, newTile);
            }

            if(j == 0){
                tiles.get(j).get(x).spawnTile = true;
            }

        }
        //...

    }
    void populateEmptyCollide(int n){
        //Situation 1 present
        for(int i=0; i<n; i++)
        {
            int xCoord = floor(random(0, tiles.get(0).size()));
            int yCoord = floor(random(0, tiles.size()));

            float rVal = random(0, 1.0);
            if(rVal <= 0.2){
                treasure newTile = new treasure(new PVector(xCoord, yCoord), 0, false);
                tiles.get(yCoord).remove(xCoord);
                tiles.get(yCoord).add(xCoord, newTile);
            }
            else{
                empty newTile = new empty(new PVector(xCoord, yCoord), 0, false);
                tiles.get(yCoord).remove(xCoord);
                tiles.get(yCoord).add(xCoord, newTile);
            }

            if(i == n-1){
                exit newTile = new exit(new PVector(xCoord, yCoord), 0, false);
                tiles.get(yCoord).remove(xCoord);
                tiles.get(yCoord).add(xCoord, newTile);
            }

            if(i == 0){
                tiles.get(yCoord).get(xCoord).spawnTile = true;
            }

        }
        //...

    }
    void populateEntities(){
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                boolean notStart = !tiles.get(j).get(i).spawnTile;
                boolean onPath   = !tiles.get(j).get(i).collides;
                if(notStart && onPath){
                    float rVal = random(0, 1.0);
                    if(rVal < 0.4){
                        minotaur newEntity = spawnMinotaur(new PVector(i,j));
                        entities.add(newEntity);
                    }
                }
                if(tiles.get(j).get(i).type == 1){
                    minotaur newEntity = spawnMinotaur(new PVector(i,j));
                    entities.add(newEntity);
                }
            }
        }
    }
    void spawnSlime(){
        /*
        Moves slime to the spawn point for this floor
        */
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                if(tiles.get(j).get(i).spawnTile){
                    cSlime.fPos = floorNumber;
                    cSlime.pos  = new PVector(i,j);
                }
            }
        }
    }

}


void keyPressedManager(){
    generalKeysPressed();
    if(cDungeon.homeScreen){
        homeScreenKeysPressed();
    }
    else{
        if(cDungeon.floors.get(cSlime.fPos).treasureRundown){
            rundownKeysPressed();
        }
        else{
            if( cDungeon.floors.get(cSlime.fPos).exploration ){
                explorationKeysPressed();}
            if( cDungeon.floors.get(cSlime.fPos).lootEncounter ){
                lootingKeysPressed();}
            if( cDungeon.floors.get(cSlime.fPos).combatEncounter ){
                combatKeysPressed();}
        }
    }
}
void keyReleasedManager(){
    generalKeysReleased();
    if(cDungeon.homeScreen){
        homeScreenKeysReleased();
    }
    else{
        if(cDungeon.floors.get(cSlime.fPos).treasureRundown){
            rundownKeysReleased();
        }
        else{
            if( cDungeon.floors.get(cSlime.fPos).exploration ){
                explorationKeysReleased();}
            if( cDungeon.floors.get(cSlime.fPos).lootEncounter ){
                lootingKeysReleased();}
            if( cDungeon.floors.get(cSlime.fPos).combatEncounter ){
                combatKeysReleased();}
        }
    }
}
void generalKeysPressed(){
    if(key == 'y'){
        showHotkeys = !showHotkeys;}
    if(key == 'e'){
        cSlime.gridSize += 2;}
    if(key == 'q'){
        if(cSlime.gridSize > 1){
            cSlime.gridSize -= 2;}}
}
void generalKeysReleased(){
    //pass
}
void explorationKeysPressed(){
    //Camera
    if(key == 'w'){
        cDungeon.camUp  = true;}
    if(key == 's'){
        cDungeon.camDwn = true;}
    if(key == 'a'){
        cDungeon.camLft = true;}
    if(key == 'd'){
        cDungeon.camRht = true;}

    //Slime
    if(key == 't'){
        cSlime.moveUp();}
    if(key == 'g'){
        cSlime.moveDwn();}
    if(key == 'f'){
        cSlime.moveLft();}
    if(key == 'h'){
        cSlime.moveRht();}
    if(key == '2'){
        cSlime.r += 10.0;}
    if(key == '1'){
        cSlime.r -= 10.0;}
    if(key == 'r'){
        cSlime.bubbleInvUp();}
}
void explorationKeysReleased(){
    //Camera
    if(key == 'w'){
        cDungeon.camUp  = false;}
    if(key == 's'){
        cDungeon.camDwn = false;}
    if(key == 'a'){
        cDungeon.camLft = false;}
    if(key == 'd'){
        cDungeon.camRht = false;}
}
void lootingKeysPressed(){
    //## Make work with mouse / finger ##
    if(key == '1'){
        cDungeon.floors.get(cSlime.fPos).lootPileInd++;
        boolean indTooHigh = cDungeon.floors.get(cSlime.fPos).lootPileInd >= ((treasure)cDungeon.floors.get(cSlime.fPos).tiles.get( int(cSlime.pos.y) ).get( int(cSlime.pos.x) )).items.size();
        if(indTooHigh){
            cDungeon.floors.get(cSlime.fPos).lootPileInd = 0;
        }
    }
    if(key == '2'){
        cSlime.addItemSetToInv( ((treasure)cDungeon.floors.get(cSlime.fPos).tiles.get( int(cSlime.pos.y) ).get( int(cSlime.pos.x) )).items.get( cDungeon.floors.get(cSlime.fPos).lootPileInd ) );
        ((treasure)cDungeon.floors.get(cSlime.fPos).tiles.get( int(cSlime.pos.y) ).get( int(cSlime.pos.x) )).items.clear();
        cDungeon.floors.get(cSlime.fPos).lootPileInd = 0;
        cDungeon.floors.get(cSlime.fPos).lootEncounter = false;
        cDungeon.floors.get(cSlime.fPos).exploration   = true;
    }
}
void lootingKeysReleased(){
    //pass
}
void combatKeysPressed(){
    if(key == '0'){
        cDungeon.floors.get(cSlime.fPos).combatEncounter = false;
        cDungeon.floors.get(cSlime.fPos).exploration = true;
    }
    if(key == '1'){
        cSlime.action++;
        if(cSlime.action >= 4){   //If more than possible actions available
            //## NEED TO UPDATE IF MORE ACTIONS ARE ADDED ##
            cSlime.action = 0;
        }
    }
    if(key == '2'){
        cSlime.target++;
        if(cSlime.target >= cDungeon.floors.get(cSlime.fPos).combatEntities.size()){
            cSlime.target = 0;
        }
    }
    if(key == '3'){
        cSlime.loadItemLauncher();
        cSlime.action = 3;
    }
}
void combatKeysReleased(){
    //pass
}
void rundownKeysPressed(){
    if(key == '1'){
        //Accept loot
        cSlime.addItemSetToInv( cDungeon.floors.get(cSlime.fPos).rundownLoot.get(0) );
        cSlime.addItemSetToInv( cDungeon.floors.get(cSlime.fPos).rundownLoot.get(1) );
        cDungeon.floors.get(cSlime.fPos).rundownLoot.get(0).clear();
        cDungeon.floors.get(cSlime.fPos).rundownLoot.get(1).clear();
        cDungeon.floors.get(cSlime.fPos).treasureRundown = false;}
}
void rundownKeysReleased(){
    //pass
}
void homeScreenKeysPressed(){
    //Press any key
    cDungeon.homeScreen = !cDungeon.homeScreen;
    cDungeon.inGame = !cDungeon.inGame;
}
void homeScreenKeysReleased(){
    //pass
}