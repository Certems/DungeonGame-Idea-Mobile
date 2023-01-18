void displayHomeScreen(){
    pushStyle();

    imageMode(CENTER);
    fill(100,100,100);
    background(120,0,0);    //## TEMPORARY -> GET RID OF##
    image(homeScreen, width/2.0, height/2.0, width,height);

    popStyle();
}