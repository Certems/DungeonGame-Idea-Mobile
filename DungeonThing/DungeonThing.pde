/*
Dungeon Game
-------------
TLDR; You play as a slime travelling through a dungeon, fighting monster and 
gaining loot. Loot is absorbed and thrown to damage enemies and grow in size 
and strength. Combat revolves around the order in which loot is gained and 
consumed and must be tacticaly managed in order to deal more damage at key 
moments and gain more gold when the dungeon is finished.

Ideal flows;
.   Slime moves path tile
    Continues to look at map
    Makes a choice to move again ...

.   Slime moves onto treasure tile
    Switches to treasure screen
    Scoops up treasure, makes a choice of which pile to select + Extras, text is shown throughout to explain the situation
    Treasure is added to inventory and map shows again
    Makes a choice to move again...

.   Slime moves onto a tile with an enemy
    Switches to fighting screen
    Makes choices of what action to do, within the time limit, unitl monster is killed
    Treasure is given (everything monster has + some Extras)
    Map is shown again
    Makes a choice to move again

.   Slime moves onto exit door
    Must face enemy automatically placed on door (combat encounter as usual)
    Special treasure item is given (trophy to rey hold onto until end of dungeon / MAYBE gives buff if eaten to grow)
    Moves onto next level of the dungeon, show by an angled map of the layer you are on + some text

TODO;
Have chat log on right to show what attacks occurred in combat / what treasure picked up / who died
Animation
Textures
System for reducing inventory when damage is taken

Make floor list
Fix treasure chest fading
*/
void setup(){
    size(1400,630,P2D);//fullScreen(P2D);

    loadAll();

    cSlime = new slime( new PVector(0,0), 90 );

    cDungeon = createDungeon(3, new PVector(20,20));
}
void draw(){
    displayInterface();
    cSlime.updateSlimeSlots();

    calcDungeon();
}
void keyPressed(){
    keyPressedManager();    
}
void keyReleased(){
    keyReleasedManager();
}
void mousePressed(){
    if(cDungeon.homeScreen){
        cDungeon.homeScreen = !cDungeon.homeScreen;
        cDungeon.inGame = !cDungeon.inGame;
    }
}
void mouseReleased(){
    //pass
}
