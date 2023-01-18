class item{
    PVector type;   //(type, subType)

    item(){
        //pass
    }

    void display(PVector pos, PVector dim){
        //pass
    }
}
class blank extends item{
    //pass

    blank(){
        type = new PVector(-1,-1);
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //...

        popStyle();
    }
}
class weapon extends item{
    int dmg;

    weapon(){
        //pass
    }

    void display(PVector pos, PVector dim){
        //pass
    }
}
class sword extends weapon{
    //pass

    sword(){
        type = new PVector(0,0);
        dmg  = 6;
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //fill(220, 140, 80);
        //ellipse(pos.x, pos.y, 10.0, 10.0);
        image(swordIcon, pos.x, pos.y, dim.x, dim.y);

        popStyle();
    }
}
class axe extends weapon{
    //pass

    axe(){
        type = new PVector(0,1);
        dmg  = 8;
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //fill(240, 160, 100);
        //ellipse(pos.x, pos.y, 10.0, 10.0);
        image(axeIcon, pos.x, pos.y, dim.x, dim.y);

        popStyle();
    }
}
class hammer extends weapon{
    //pass

    hammer(){
        type = new PVector(0,2);
        dmg  = 10;
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //fill(255, 180, 120);
        //ellipse(pos.x, pos.y, 10.0, 10.0);
        image(hammerIcon, pos.x, pos.y, dim.x, dim.y);

        popStyle();
    }
}
class spear extends weapon{
    //pass

    spear(){
        type = new PVector(0,3);
        dmg  = 12;
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //fill(255, 220, 180);
        //ellipse(pos.x, pos.y, 10.0, 10.0);
        image(spearIcon, pos.x, pos.y, dim.x, dim.y);

        popStyle();
    }
}
//...
class splItem extends item{
    int effect;

    splItem(){
        effect = -1;
    }

    void display(PVector pos, PVector dim){
        //pass
    }
}
class dust extends splItem{
    //pass

    dust(){
        type = new PVector(1,0);
        effect = 0;
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //fill(20, 180, 200);
        //ellipse(pos.x, pos.y, 10.0, 10.0);
        image(dustIcon, pos.x, pos.y, dim.x, dim.y);

        popStyle();
    }
}
class scrap extends splItem{
    //passs

    scrap(){
        type = new PVector(1,1);
        effect = 1;
    }

    @Override
    void display(PVector pos, PVector dim){
        pushStyle();

        //fill(60, 220, 240);
        //ellipse(pos.x, pos.y, 10.0, 10.0);
        image(scrapIcon, pos.x, pos.y, dim.x, dim.y);

        popStyle();
    }
}
//...