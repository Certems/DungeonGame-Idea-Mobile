/*
Loads given textures and sounds
*/

//Textures
//-Entities
//--Slime
PImage slimeSmallIcon;
//--Minotaur
PImage mintotaurIcon;
//-Tiles
PImage corridorTileIcon;
PImage treasureTileIcon;
PImage exitTileIcon;
//-Screens
PImage homeScreen;
//-Items
//--Weapons
PImage axeIcon;
PImage hammerIcon;
PImage spearIcon;
PImage swordIcon;
//--SpecialItems
PImage dustIcon;
PImage scrapIcon;


//Sounds


void loadAll(){
    texturesLoadAll();
    soundsLoadAll();
}

void texturesLoadAll(){
    textureLoadEntities();
    textureLoadTiles();
    textureLoadScreens();
    textureLoadItems();
}
void soundsLoadAll(){
    soundsLoadMusic();
    soundsLoadEntityAttacks();
}

void textureLoadEntities(){
    //Slime
    slimeSmallIcon = loadImage("slimeSmallIcon.png");
    //Minotaur
    //pass
    //...
}
void textureLoadTiles(){
    corridorTileIcon = loadImage("corridorTileIcon.png");
    treasureTileIcon = loadImage("treasureTileIcon.png");
    exitTileIcon     = loadImage("exitTileIcon.png");
}
void textureLoadScreens(){
    //HomeScreen
    homeScreen = loadImage("homeScreen.png");
}
void textureLoadItems(){
    textureLoadWeapons();
    textureLoadSpecialItems();
}
void textureLoadWeapons(){
    axeIcon    = loadImage("axeIcon.png");
    hammerIcon = loadImage("hammerIcon.png");
    spearIcon  = loadImage("spearIcon.png");
    swordIcon  = loadImage("swordIcon.png");
}
void textureLoadSpecialItems(){
    dustIcon  = loadImage("dustIcon.png");
    scrapIcon = loadImage("scrapIcon.png");
}

void soundsLoadMusic(){
    //pass
}
void soundsLoadEntityAttacks(){
    //pass
}