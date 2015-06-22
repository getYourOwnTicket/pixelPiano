//minim library
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;

PImage pixelBild;



void setup(){

  pixelBild = loadImage("quadrat88x4.jpg");
  size( pixelBild.width, pixelBild.height);
  pixelBild.loadPixels();   
  
  int cols = pixelBild.width;
  int rows = pixelBild.height;
  
  int j; //Zähler für Spalten
  int i; //Zähler für Zeilen
  
  float r;
  
  // Declare 2D array Auswertung ob Töne gespielt werden
  float [][] myArray = new float [cols][rows];
  println("cols: "+cols);
  println("rows: "+rows); 
     
    
   for (j=0; j < rows; j++) {   
     for (i=0; i < cols; i++) {        
                  
         int pxNumber = i+j*cols; 
         println("pxNumber: "+pxNumber);
         r = red(pixelBild.pixels[pxNumber]); //Entnimmt Farbwerte aus den einzelnen Pixeln 
         println("r : "+r);
         myArray[i][j] = r;        
                  
         //spielt nur einen Ton, wenn der rote Farbwert (RGB) größer als 250 ist 
         if (myArray[i][j] > 250){           
              
             
           
           
             //##############Sound abspielen##############################
              minim = new Minim(this); //constructor minim aufrufen
              out = minim.getLineOut(); //start transfer to soundcard         
                                                                                                 
              if(i < 88){    //Klaviatur mit 88 Tasten 
              
                int n = i+1; //Nummer der Klaviertaste ist gleichzeitig Faktor zur Berechnung, muss mit 1 beginnen
                float frequence = 440 * pow(2f,(n-49f)/12f);  //Berechnet genaue Frequenzen der Tonleiter                           
                println("Taste: "+n+" Tonfrequenz: "+frequence);
                wave = new Oscil( frequence, 0.1f, Waves.SINE );                
              }
                           
              // patch the Oscil to the output                          
              wave.patch(out);
              delay(100); //verzögert das ausschalten des Tons              
              
              minim.stop(); //stop playing midi
              out.close(); //stop output soundcard           
              delay(50); //Spieldauer des Tons
               //##############Sound abspielen##############################          
           
         }else if (myArray[i][j] < 251) {
             
              wave.unpatch( out );
              delay(100); //Nicht gespielte Töne, gleiche Dauer wie gespielte
         }
          
     }
   }
   
  
   
}



void draw(){
  
}
