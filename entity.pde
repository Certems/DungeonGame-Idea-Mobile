slime cSlime;

class entity{
    PVector pos;

    ArrayList<item> heldWeapons = new ArrayList<item>();
    ArrayList<item> heldItems   = new ArrayList<item>();

    int hp;
    int action = 0;
    int target = 0;

    float dodge;

    entity(PVector tilePosition, int health){
        pos = tilePosition;
        hp  = health;
    }

    void display(PVector screenPos){
        //pass
    }
    void displaySmall(float tWidth){
        //pass
    }
    void randomiseAction(){
        //pass
    }
    void calcAttack(){
        //pass
    }
    void giveWeapons(){
        //pass
    }
    void giveItems(){
        //pass
    }
    boolean checkAttackHits(entity being){
        float rVal = random(0,1.0);
        if(rVal < being.dodge){ //Successful dodge
            return false;
        }
        return true;
    }
}
class slime extends entity{
    /*
    pos  = position in the floor
    fPos = the floor they are on
    */
    ArrayList<ArrayList<slimeSlot>> inv = new ArrayList<ArrayList<slimeSlot>>();
    ArrayList<item> launchItems = new ArrayList<item>();

    int fPos = 0;
    int hpConv = 2;     //x hp = 1 inv slot
    int gridSize = 3;   //Size of hover selection

    float sqrSize = width/100.0;
    PVector invDim = new PVector(0.65*width, 0.85*height/2.0);
    int invWidth  = ceil(invDim.x / sqrSize);
    int invHeight = ceil(invDim.y / sqrSize);
    float r = sqrt( ((hp/hpConv)*(pow(sqrSize,2))*(2.0)) / (PI) );
    PVector origin = new PVector(width/2.0, height - ( ((height/2.0)-invDim.y)/2.0 ));

    slime(PVector pos, int hp){
        super(pos, hp);
        dodge = 0.2;
        buildInitialInv();
    }

    @Override
    void display(PVector screenPos){
        /*
        Displays the full size sprite for the entity during combat
        */
        pushStyle();

        imageMode(CENTER);
        //fill(60, 240, 100);
        //stroke(0);
        //strokeWeight(2);
        //ellipse(screenPos.x, screenPos.y, 40.0, 40.0);
        image(slimeSmallIcon ,screenPos.x, screenPos.y, 80.0, 80.0);

        popStyle();
    }
    @Override
    void displaySmall(float tWidth){
        /*
        Displays the icon on the map for the entity
        */
        pushStyle();

        float newWidth = 1.8*tWidth;
        PVector newPos = cDungeon.relToScreen( new PVector(pos.x*tWidth, pos.y*tWidth) );

        imageMode(CENTER);
        //fill(60, 240, 100);
        //stroke(255);
        //strokeWeight(1);
        //ellipse(newPos.x, newPos.y, 0.5*newWidth, 0.5*newWidth);
        image(slimeSmallIcon ,newPos.x, newPos.y, 0.5*newWidth, 0.5*newWidth);

        popStyle();
    }
    void displayInv(){
        pushStyle();

        //Framing
        rectMode(CENTER);
        noFill();
        stroke(30,230,80);
        strokeWeight(3);
        rect(width/2.0, 3.0*height/4.0, invDim.x, invDim.y);

        ellipse(origin.x, origin.y, 10,10);

        //Slots
        pushMatrix();
        imageMode(CENTER);
        translate((width-invDim.x)/2.0, (height/2.0) +(height-2.0*invDim.y)/4.0);
        for(int j=0; j<inv.size(); j++){
            for(int i=0; i<inv.get(j).size(); i++){
                inv.get(j).get(i).display(sqrSize);
            }
        }
        popMatrix();

        //...

        popStyle();
    }
    @Override
    void randomiseAction(){
        action = floor(random(0,4));
    }
    @Override
    void calcAttack(){
        if(action == 0){
            slimeHit();
        }
        if(action == 1){
            takeCover();
        }
        if(action == 2){
            relocateItems();
        }
        if(action == 3){
            launchItems();
        }
        //...
        action = 0;
    }
    void slimeHit(){
        //Basic hit
        println("!Slime hit!");
        int atkDamage = floor(random(5,21));
        if( checkAttackHits( cDungeon.floors.get(fPos).combatEntities.get(target) ) ){
            println("!HIT!");
            cDungeon.floors.get(fPos).combatEntities.get(target).hp -= atkDamage;
        }
        else{
            println("!MISSED!");
        }
    }
    void takeCover(){
        //Increase dodge chance
        println("!Taking cover!");
        //pass
    }
    void relocateItems(){
        //Moves selected items to bottom of slime
        println("!Relocating items!");
        //pass
    }
    void launchItems(){
        //Fires selected items at enemy
        println("!Launching items!");
        for(int i=0; i<launchItems.size(); i++){
            if(checkAttackHits(cDungeon.floors.get(fPos).combatEntities.get(target))){
                println("!HIT!");
                if(launchItems.get(i).type.x == 0){  //If a weapon
                    cDungeon.floors.get(fPos).combatEntities.get(target).hp -= ((weapon)launchItems.get(i)).dmg;
                }
                if(launchItems.get(i).type.x == 1){  //If a special item
                    //Do effect
                }
                //...
            }
            else{
                println("!MISSED!");
            }
        }
        launchItems.clear();
    }
    void buildInitialInv(){
        /*
        1. Create set of blank slots
        2. Activate valid slots
        */
        //1
        for(int j=0; j<=invHeight; j++){
            inv.add( new ArrayList<slimeSlot>() );
            for(int i=0; i<=invWidth; i++){
                blank newItem = new blank();
                slimeSlot newSlot = new slimeSlot(new PVector(i,j), newItem, false);
                inv.get(j).add(newSlot);
            }
        }
        //2
        activateValidSlots();
    }
    void updateSlimeSlots(){
        //Reset to default
        for(int j=0; j<=invHeight; j++){
            for(int i=0; i<=invWidth; i++){
                inv.get(j).get(i).isActive = false;
            }
        }
        //Find new active slots
        activateValidSlots();
    }
    void activateValidSlots(){
        for(int j=0; j<inv.size(); j++){
            for(int i=0; i<inv.get(j).size(); i++){
                PVector gridStart = new PVector( (width-invDim.x)/2.0, (height/2.0) + ((height/2.0 - invDim.y)/2.0) );
                PVector slotPos = new PVector(i*sqrSize +gridStart.x, j*sqrSize +gridStart.y);
                float dist = sqrt( pow(origin.x - slotPos.x,2) + pow(origin.y - slotPos.y,2) );
                if(dist <= r){
                    inv.get(j).get(i).isActive = true;
                }
            }
        }
    }
    void addItemToInv(item givenItem){
        //Random placement
        //-----------------
        boolean spaceFound = false;
        for(int i=0; i<pow(inv.size(),2); i++){
            PVector rVal = new PVector( floor(random(0,inv.get(0).size())), floor(random(0,inv.size())) );
            if( (inv.get( int(rVal.y) ).get( int(rVal.x) ).isActive) && (inv.get( int(rVal.y) ).get( int(rVal.x) ).cItem.type.x == -1) ){
                inv.get( int(rVal.y) ).get( int(rVal.x) ).cItem = givenItem;
                spaceFound = true;
                break;
            }
        }

        if(!spaceFound)
        {
            //From bottom up -> fail safe if cant randomly find space that is present *OR* just works on its own
            //---------------
            boolean slotFound = false;
            for(int j=inv.size()-1; j>=0; j--){
                if(slotFound){
                    break;
                }
                for(int i=0; i<inv.get(j).size(); i++){
                    boolean slotAvailable = inv.get(j).get(i).cItem.type.x == -1;
                    boolean slotSlimed = inv.get(j).get(i).isActive;
                    if(slotAvailable && slotSlimed){
                        inv.get(j).get(i).cItem = givenItem;
                        slotFound = true;
                        break;
                    }
                }
            }
        }
    }
    void addItemSetToInv(ArrayList<item> itemSet){
        for(int i=0; i<itemSet.size(); i++){
            addItemToInv( itemSet.get(i) );
        }
    }
    void bubbleInvUp(){
        int middle = floor(inv.get(0).size()/2.0);
        for(int j=1; j<inv.size(); j++){            //Go through all (except 0th row)
            for(int i=0; i<inv.get(j).size(); i++){
                boolean moved = false;
                if((inv.get(j).get(i).isActive) && (inv.get(j).get(i).cItem.type.x != -1)){     //If is a slime slot
                    //In preference order
                    if( ((inv.get(j-1).get(i).isActive) && (inv.get(j-1).get(i).cItem.type.x == -1)) && (!moved) ){               //If above is a slot AND clear
                        inv.get(j-1).get(i).cItem = inv.get(j).get(i).cItem;    //Move over
                        blank newItem = new blank();        //Remove old
                        inv.get(j).get(i).cItem = newItem;
                        moved = true;
                    }
                    if(i != 0){  //If left exists
                        if( ((inv.get(j-1).get(i-1).isActive) && (inv.get(j-1).get(i-1).cItem.type.x == -1)) && (!moved) ){          //OR If above and left is a slot AND clear
                            inv.get(j-1).get(i-1).cItem = inv.get(j).get(i).cItem;  //Move over
                            blank newItem = new blank();        //Remove old
                            inv.get(j).get(i).cItem = newItem;
                            moved = true;
                        }
                    }
                    if(i != inv.get(0).size()-1){  //If right exists
                        if( ((inv.get(j-1).get(i+1).isActive) && (inv.get(j-1).get(i+1).cItem.type.x == -1)) && (!moved) ){          //OR If above and right is a slot AND clear
                            inv.get(j-1).get(i+1).cItem = inv.get(j).get(i).cItem;  //Move over
                            blank newItem = new blank();        //Remove old
                            inv.get(j).get(i).cItem = newItem;
                        }
                    }
                    //If none of above, then cant move, so ignore
                }
            }
        }
    }
    void loadItemLauncher(){
        //Find all points covered by cursor
        ArrayList<PVector> hPoints = new ArrayList<PVector>();
        for(int j=-floor(gridSize/2.0); j<ceil(gridSize/2.0); j++){
            for(int i=-floor(gridSize/2.0); i<ceil(gridSize/2.0); i++){
                PVector hGridPoint = findHoveredSlimeSlot( new PVector(mouseX +i*sqrSize, mouseY +j*sqrSize) );
                if(hGridPoint.x != -1){
                    hPoints.add(hGridPoint);}
            }
        }
        //Add all those items to the launcher
        for(int i=0; i<hPoints.size(); i++){
            if(inv.get(int(hPoints.get(i).y)).get(int(hPoints.get(i).x)).cItem.type.x != -1){
                launchItems.add( inv.get(int(hPoints.get(i).y)).get(int(hPoints.get(i).x)).cItem );
            }
        }
        //Remove items from inv
        for(int i=0; i<hPoints.size(); i++){
            inv.get(int(hPoints.get(i).y)).get(int(hPoints.get(i).x)).cItem = new blank();
        }
    }
    PVector findHoveredSlimeSlot(PVector point){
        PVector slotPos;
        boolean withinX = ( (width-invDim.x)/2.0                    < point.x ) && ( point.x < (width-invDim.x)/2.0 + invWidth*sqrSize );
        boolean withinY = ( (height/2.0) +(height-2.0*invDim.y)/4.0 < point.y ) && ( point.y < (height/2.0) +(height-2.0*invDim.y)/4.0 + invHeight*sqrSize );
        if(withinX && withinY){     //If hovering over inv zone
            slotPos = new PVector( floor((point.x-(width-invDim.x)/2.0 +0.5*sqrSize)/sqrSize), floor((point.y-((height/2.0) +(height-2.0*invDim.y)/4.0) +0.5*sqrSize)/sqrSize) );
        }
        else{                       //If not hovering over inv zone
            slotPos = new PVector(-1,-1);
        }
        return slotPos;
    }
    void moveUp(){
        boolean onBoard = (pos.y-1 >= 0);
        if(onBoard){
            boolean notBlocked = !cDungeon.floors.get(fPos).tiles.get(int(pos.y) -1).get(int(pos.x)).collides;
            if(notBlocked){
                cSlime.pos.y--;
                cDungeon.floors.get(fPos).calcSituation();
                bubbleInvUp();
            }
        }
    }
    void moveDwn(){
        boolean onBoard = (pos.y+1 < cDungeon.floors.get(fPos).tiles.size());
        if(onBoard){
            boolean notBlocked = !cDungeon.floors.get(fPos).tiles.get(int(pos.y) +1).get(int(pos.x)).collides;
            if(notBlocked){
                cSlime.pos.y++;
                cDungeon.floors.get(fPos).calcSituation();
                bubbleInvUp();
            }
        }
    }
    void moveLft(){
        boolean onBoard = (pos.x-1 >= 0);
        if(onBoard){
            boolean notBlocked = !cDungeon.floors.get(fPos).tiles.get(int(pos.y)).get(int(pos.x) -1).collides;
            if(notBlocked){
                cSlime.pos.x--;
                cDungeon.floors.get(fPos).calcSituation();
                bubbleInvUp();
            }
        }
    }
    void moveRht(){
        boolean onBoard = (pos.x+1 < cDungeon.floors.get(fPos).tiles.get(int(pos.y)).size());
        if(onBoard){
            boolean notBlocked = !cDungeon.floors.get(fPos).tiles.get(int(pos.y)).get(int(pos.x) +1).collides;
            if(notBlocked){
                cSlime.pos.x++;
                cDungeon.floors.get(fPos).calcSituation();
                bubbleInvUp();
            }
        }
    }
}
class minotaur extends entity{
    //pass

    minotaur(PVector pos, int hp){
        super(pos, hp);
        dodge = 0.2;
        giveWeapons();
        giveItems();
    }

    @Override
    void display(PVector screenPos){
        /*
        Displays the full size sprite for the entity during combat
        */
        pushStyle();

        fill(245, 140, 70);
        stroke(0);
        strokeWeight(2);
        ellipse(screenPos.x, screenPos.y, 40.0, 40.0);

        popStyle();
    }
    @Override
    void displaySmall(float tWidth){
        /*
        Displays the icon on the map for the entity
        */
        pushStyle();

        float newWidth = 0.8*tWidth;
        PVector newPos = cDungeon.relToScreen( new PVector(pos.x*tWidth, pos.y*tWidth) );

        fill(245, 140, 70);
        stroke(255);
        strokeWeight(1);
        ellipse(newPos.x, newPos.y, 0.5*newWidth, 0.5*newWidth);

        popStyle();
    }
    @Override
    void giveWeapons(){
        //Fill with loot
        int weaponNum = 2;
        for(int i=0; i<weaponNum; i++){
            int rItem = floor(random(0,4));
            if(rItem == 0){
                sword newItem = new sword();
                heldWeapons.add(newItem);}
            if(rItem == 1){
                axe newItem = new axe();
                heldWeapons.add(newItem);}
            if(rItem == 2){
                hammer newItem = new hammer();
                heldWeapons.add(newItem);}
            if(rItem == 3){
                spear newItem = new spear();
                heldWeapons.add(newItem);}
        }
    }
    @Override
    void giveItems(){
        //Fill with loot
        int treasureNum = 30;
        int rVal = ceil(random(treasureNum*0.6, treasureNum));
        for(int i=0; i<rVal; i++){
            float iVal = random(0, 1.0);
            if(iVal < 0.5){
                int rItem = floor(random(0,4));
                if(rItem == 0){
                    sword newItem = new sword();
                    heldItems.add(newItem);}
                if(rItem == 1){
                    axe newItem = new axe();
                    heldItems.add(newItem);}
                if(rItem == 2){
                    hammer newItem = new hammer();
                    heldItems.add(newItem);}
                if(rItem == 3){
                    spear newItem = new spear();
                    heldItems.add(newItem);}
            }
            if(iVal >= 0.5){
                int rItem = floor(random(0,2));
                if(rItem == 0){
                    dust newItem = new dust();
                    heldItems.add(newItem);}
                if(rItem == 1){
                    scrap newItem = new scrap();
                    heldItems.add(newItem);}
            }
        }
    }
    @Override
    void randomiseAction(){
        //## MUST BE UPDATED FOR EACH NEW ACTION ADDED ##
        action = floor( random(0,3) );
        target = -1; //Enemies can only attack the slime
    }
    @Override
    void calcAttack(){
        if(action == 0){
            lftWeaponHit();
        }
        if(action == 1){
            rhtWeaponHit();
        }
        if(action == 2){
            bothWeaponHit();
        }
        //...
        action = 0;
    }
    void lftWeaponHit(){
        println("!Left hit!");
        if(checkAttackHits(cSlime)){
            println("!HIT!");
            cSlime.hp -= ((weapon)heldWeapons.get(0)).dmg;
        }
        else{
            println("!MISSED!");
        }
    }
    void rhtWeaponHit(){
        println("!Right hit!");
        if(checkAttackHits(cSlime)){
            println("!HIT!");
            cSlime.hp -= ((weapon)heldWeapons.get(1)).dmg;
        }
        else{
            println("!MISSED!");
        }
    }
    void bothWeaponHit(){
        println("!Both hit!");
        if(checkAttackHits(cSlime)){
            println("!HIT!");
            cSlime.hp -= ((weapon)heldWeapons.get(0)).dmg + ((weapon)heldWeapons.get(1)).dmg;
        }
        else{
            println("!MISSED!");
        }
    }
}
//...


class slimeSlot{
    /*
    Slime inventory slot, stores its position in the inv and the item it is holding
    */
    boolean isActive;

    PVector pos;

    item cItem;

    slimeSlot(PVector position, item heldItem, boolean isUseable){
        pos   = position;
        cItem = heldItem;
        isActive = isUseable;
    }

    void display(float tSize){
        pushStyle();

        rectMode(CENTER);
        stroke(0);
        strokeWeight(1);

        //Tile backing
        if(isActive){
            fill(105, 245, 70, 255);}
        else{
            fill(110, 125, 110, 60);}
        rect(pos.x*tSize, pos.y*tSize, 0.8*tSize, 0.8*tSize);

        //Item
        cItem.display( new PVector(pos.x*tSize, pos.y*tSize), new PVector(tSize, tSize) );

        popStyle();
    }
}


minotaur spawnMinotaur(PVector pos){
    int health = ceil(random(10, 20));
    minotaur newEntity = new minotaur(new PVector(pos.x, pos.y), health);
    return newEntity;
}
