dungeon cDungeon;

class dungeon{
    boolean camUp  = false;
    boolean camDwn = false;
    boolean camLft = false;
    boolean camRht = false;

    boolean homeScreen = true;
    boolean inGame = false;

    ArrayList<dungeonFloor> floors = new ArrayList<dungeonFloor>();

    PVector camPos = new PVector(0,0);  //In relative coords

    dungeon(int floorNumber, PVector floorDim){
        buildDungeon(floorNumber, floorDim);
    }

    void update(){
        floors.get(cSlime.fPos).update();
    }
    void buildDungeon(int n, PVector d){
        /*
        Creates the dungeon with n floors, each of size d
        */
        for(int p=0; p<n; p++){
            dungeonFloor newFloor = new dungeonFloor(p, d);
            floors.add(newFloor);
        }
    }
    PVector relToScreen(PVector v){
        /*
        Converts a relative position to a screen position
        */
        PVector screenVec = new PVector( v.x-(camPos.x - (width/2.0)), v.y-(camPos.y - (height/2.0)) );
        return screenVec;
    }
}

dungeon createDungeon(int nFloor, PVector dFloor){
    dungeon newDungeon  = new dungeon(nFloor, dFloor);
    return newDungeon;
}
void calcDungeon(){
    moveDungeonCam();
}