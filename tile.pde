/*
. Add collideable system
. Add floor system
*/

class tile{
    boolean collides;
    boolean spawnTile = false;  //Where the slime should appear when moving to the next floor

    PVector pos;

    int type;
    int fStyle;

    tile(PVector gridPos, int floorStyle, boolean collideable){
        pos     = gridPos;
        fStyle  = floorStyle;
        collides = collideable;
    }

    void display(float tWidth){
        //pass
    }
}
class empty extends tile{
    //pass

    empty(PVector pos, int fStyle, boolean collides){
        super(pos, fStyle, collides);
        type = 0;
    }

    @Override
    void display(float tWidth){
        pushStyle();

        float newWidth = 0.8*tWidth;
        PVector newPos = cDungeon.relToScreen( new PVector(pos.x*tWidth, pos.y*tWidth) );

        //Draw floor
        if(fStyle != -1){
            //Get texture from list
            imageMode(CENTER);
            //rectMode(CENTER);
            //fill(100,100,100);
            //noStroke();
            //rect(newPos.x, newPos.y, newWidth, newWidth);
            image(corridorTileIcon, newPos.x, newPos.y, newWidth, newWidth);
        }

        //Draw main tile
        //rectMode(CENTER);
        //noFill();
        //stroke(255);
        //strokeWeight(0.1);
        //rect(newPos.x, newPos.y, newWidth, newWidth);

        popStyle();
    }
}
class exit extends tile{
    //pass

    exit(PVector pos, int fStyle, boolean collides){
        super(pos, fStyle, collides);
        type = 1;
    }

    @Override
    void display(float tWidth){
        pushStyle();

        float newWidth = 0.8*tWidth;
        PVector newPos = cDungeon.relToScreen( new PVector(pos.x*tWidth, pos.y*tWidth) );

        //Draw floor
        if(fStyle != -1){
            imageMode(CENTER);
            //Get texture from list
            //rectMode(CENTER);
            //fill(100,100,100);
            //noStroke();
            //rect(newPos.x, newPos.y, newWidth, newWidth);
            image(corridorTileIcon, newPos.x, newPos.y, newWidth, newWidth);
        }

        //Draw main tile
        imageMode(CENTER);
        //fill(255,30,30);
        //noStroke();
        //rect(newPos.x, newPos.y, 0.8*newWidth, 0.8*newWidth);
        image(exitTileIcon, newPos.x, newPos.y, newWidth, newWidth);

        popStyle();
    }
}
class treasure extends tile{
    ArrayList<ArrayList<item>> items = new ArrayList<ArrayList<item>>();

    treasure(PVector pos, int fStyle, boolean collides){
        super(pos, fStyle, collides);
        type = 2;
        generateTreasure();
    }

    @Override
    void display(float tWidth){
        pushStyle();

        float newWidth = 0.8*tWidth;
        PVector newPos = cDungeon.relToScreen( new PVector(pos.x*tWidth, pos.y*tWidth) );

        //Draw floor
        if(fStyle != -1){
            imageMode(CENTER);
            //Get texture from list
            //rectMode(CENTER);
            //fill(100,100,100);
            //noStroke();
            //rect(newPos.x, newPos.y, newWidth, newWidth);
            image(corridorTileIcon, newPos.x, newPos.y, newWidth, newWidth);
        }

        //Draw main tile
        imageMode(CENTER);
        float alphaVal = 255;   //########################## DO SOMETHING LIKE THIS ####################################
        if(items.size() > 0){   //If full
            fill(220, 240, 70);
        }
        else{                   //if empty
            fill(150, 170, 0);
            alphaVal = 0;
        }
        //noStroke();
        //rect(newPos.x, newPos.y, 0.8*newWidth, 0.8*newWidth);
        image(treasureTileIcon, newPos.x, newPos.y, newWidth, newWidth);

        popStyle();
    }
    void generateTreasure(){
        //Create rVal number of loot piles
        int rVal = ceil(random(1,3));
        for(int i=0; i<rVal; i++){
            items.add( new ArrayList<item>() );
        }
        //Fill each loot pile
        int treasureNum = 10;
        for(int j=0; j<items.size(); j++){
            rVal = ceil(random(treasureNum*0.6, treasureNum));
            for(int i=0; i<rVal; i++){
                float iVal = random(0, 1.0);
                if(iVal < 0.5){
                    int rItem = floor(random(0,4));
                    if(rItem == 0){
                        sword newItem = new sword();
                        items.get(j).add(newItem);}
                    if(rItem == 1){
                        axe newItem = new axe();
                        items.get(j).add(newItem);}
                    if(rItem == 2){
                        hammer newItem = new hammer();
                        items.get(j).add(newItem);}
                    if(rItem == 3){
                        spear newItem = new spear();
                        items.get(j).add(newItem);}
                }
                if(iVal >= 0.5){
                    int rItem = floor(random(0,2));
                    if(rItem == 0){
                        dust newItem = new dust();
                        items.get(j).add(newItem);}
                    if(rItem == 1){
                        scrap newItem = new scrap();
                        items.get(j).add(newItem);}
                }
            }
        }
    }
}