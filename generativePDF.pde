// Title:        Introduction to Generative PDF Publications
// By:           Luke Demarest
// P5js version: https://editor.p5js.org/dema/sketches/gAQCFqRbU

import processing.pdf.*;
PGraphicsPDF pdf;
JSONArray customData;
PImage titleImage;
int totalPages;

void setup() {
  size(600, 600);
  
  // create the pdf
  pdf = (PGraphicsPDF)beginRecord(PDF, "LCC-DV.pdf");
  
  // load image
  titleImage = loadImage("ual-lcc.png");
  // pages are determined by our json data
  customData = loadJSONArray("example.json");
  totalPages = customData.size();
  print(customData);
  
  // 1 frame a second so that we can watch
  frameRate(1);
}


void draw() {
  
  // draw your custom generative background
  generativeBackground();

  // draw a poem from the json data
  drawBody( customData.getJSONObject( frameCount -1 ) );

  // draw a custom footer
  footer();
  
  // top right corner flipbook
  flipBook( totalPages );

  // if all pages have been drawn, save the pdf document and stop drawing.
  // else save the current page and open the next page for more drawing.
  if(frameCount == totalPages){
    endRecord();
    exit();
  }else{
    pdf.nextPage();
  }
}


//---------------------------------
// background
//---------------------------------
void generativeBackground(){
  background(255); 
  noFill();

  // -------------------------------------
  // add any random / unique elements here 
  // for a generative background
  // -------------------------------------
  
  // for example...
  // simple: random circles
  push();
  stroke(221);  
  for(int i=0; i<500; i++) ellipse(random(10,width-10),random(10,height-40), 3, 3);
  pop();
  
  // intermediate: triangles connecting random points
  PVector[] points = new PVector[9];
  for(int i=0; i<points.length; i++){
    points[i] = new PVector( random(100,width-100), random(height*0.45,height-100) );
  }
  push();
  beginShape(TRIANGLES);
  for(int i=0; i<points.length; i++){
    stroke(170);
    vertex( points[i].x, points[i].y);
    stroke(204);
    ellipse( points[i].x, points[i].y, 15, 15 );
    stroke(51);
    ellipse( points[i].x, points[i].y, 10, 10 );
  }
  endShape(CLOSE);
  pop();
  
}


//---------------------------------
// body of the page
//---------------------------------
void drawBody( JSONObject poem ){
  push();
  fill(51);
  // poem name
  stroke(51);
  strokeWeight(1);
  textSize(12);
  textAlign(LEFT);
  text( poem.getString("title"), 30, 50 );
  // poem text
  noStroke();
  textSize(14);
  textAlign(LEFT);
  text( poem.getString("text"), random(50, width-250), random(100,height*0.5) );
  // poem author
  noStroke();
  textSize(12);
  textAlign(RIGHT);
  text( poem.getString("author"), width-30, height-40 );
  pop();
}


//---------------------------------
// flipbook corner
//---------------------------------
void flipBook( Integer tp ){
  push();
  noFill();
  stroke(0,0,255,100);
  ellipse( width-20, 20, (frameCount % tp), (frameCount % tp) );
  pop();
}


//---------------------------------
// footer
//---------------------------------
void footer(){
  push();
  fill(235);
  noStroke();
  rect( 0, height-30, width, height);
  pop();
  
  titleArea("MA Data Visualisation 2021");
  progressBar( frameCount, totalPages );
  pageNumber( frameCount ); 
}

void titleArea( String title ){
  // create a new image size with the correct aspect ratio
  Float titleImageNewH = 200.0;
  Float titleImageNewW = titleImageNewH * ((float) titleImage.height/titleImage.width);
  push();
  // title image
  image( titleImage, 10, height - 40 - titleImageNewW, titleImageNewH, titleImageNewW );
  // title text
  noStroke();
  fill(85);
  textSize( 10 );
  textAlign( LEFT );
  text( title, 10, height-10 );
  pop();
}

void progressBar( Integer fc, Integer tp ){
  push(); 
  // bar for total pages
  noStroke();
  fill(221);
  rect( width-(30+(tp*10)), height-18, tp*10, 10 );
  // bar for current page
  noStroke();
  fill(153);
  rect( width-(30+(tp*10)), height-18, fc*10, 10 );
  pop();
}

void pageNumber( Integer fc ){
  push();
  noStroke();
  fill(85);
  textSize(10);
  textAlign(RIGHT);
  text(fc, width -10, height -10);
  pop();
}
