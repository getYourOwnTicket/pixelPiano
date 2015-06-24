//minim library
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil[] colFrequences;

PImage pixelBild;

Oscil tonBerechnen(int spalte) {
  int n = spalte+1; //Nummer der Klaviertaste ist gleichzeitig Faktor zur Berechnung, muss mit 1 beginnen
  float frequence = 440 * pow(2f, (n-49f)/12f);  //Berechnet genaue Frequenzen der Tonleiter                           
  println("Taste: "+n+" Tonfrequenz: "+frequence);
  return new Oscil( frequence, 0.1f, Waves.SINE );
}

void setup() {
  //Minim       minim;
  //AudioOutput out;
  //Oscil[] colFrequences;

  //PImage pixelBild;

  pixelBild = loadImage("quadrat88x24.jpg");
  size( pixelBild.width, pixelBild.height);
  pixelBild.loadPixels();   

  int numCols = pixelBild.width;
  int numRows = pixelBild.height;

  minim = new Minim(this); //constructor minim aufrufen
  out = minim.getLineOut(Minim.STEREO, 2048, 44020); //start transfer to soundcard methode(STEREO/MONO, Buffer, sampleRate)   

  float r;

  // Declare 2D array Auswertung, ob Töne gespielt werden
  boolean [][] myArray = new boolean[numCols][numRows];
  println("cols: "+numCols);
  println("rows: "+numRows); 

  colFrequences = new Oscil[numCols];

  for (int x=0; x< numCols; x++) {
    colFrequences[x] = tonBerechnen(x);
  }

  for (int row=0; row < numRows; row++) {   
    for (int col=0; col < numCols; col++) {        

      int pxNumber = col+row*numCols; 
      println("pxNumber: "+pxNumber);
      r = red(pixelBild.pixels[pxNumber]); //Entnimmt Farbwerte aus den einzelnen Pixeln 
      println("r : "+r);    

      //spielt nur einen Ton, wenn der rote Farbwert (RGB) größer als 250 ist 
      if (r > 250 && myArray[col][row]==false) {
        myArray[col][row]=true;
        colFrequences[col].patch(out);
      } else if (r <= 250 && myArray[col][row]==true) {
        myArray[col][row]=false;
        colFrequences[col].unpatch(out);
      }
    }
    delay(1000);
    for (int col=0; col<numCols; col++) {
      colFrequences[col].unpatch(out);
    }
  }

  minim.stop(); //stop playing midi
  out.close(); //stop output soundcard
}



void draw() {
}
