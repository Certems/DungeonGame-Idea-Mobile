void animate(ArrayList<PImage> images, int t, int cFrame, PVector pos, PVector size){
    /*
    Animate a list of PImages, with t frames per image, where the frame to be shown now is the cFrame^th frame,
    all shown at the screen position pos, with image dimensions of size
    */
    int cImgInd = floor(cFrame / t);
    image(images.get(cImgInd), pos.x, pos.y, size.x, size.y);
}