import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
FFT fft;

float spinAngle=radians(1);
int rings = 32;
float[] rads= new float[rings];
float[] angles=new float[rings];
color[] cores = {color(195,254,233),color(151,252,198),color(2,133,143),color(1,89,131),color(110,201,251)};

void setup(){
  size(1280,720);
  
  minim = new Minim(this);
  jingle = minim.loadFile("All.mp3", 2048);
  jingle.loop();
  
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  fft.linAverages(rings);
  
  noStroke();
  background(0);
  for(int k=0;k<rings;k++){ //number of rings
    rads[k]=100+k*((height*1.3-70)/rings); //change brackets for layout of rings
    angles[k]=k;
  }
}

void draw(){
  //noLoop();
  fill(0);
  rect(0,0,width,height);
  
  fft.forward(jingle.mix);
  
  //spinAngle+=0.0002; //rotate by fraction
  circles();
}

void circles(){
  translate(width/2,height);
  float noCirc = 10; 
  for(int j=0;j<rings;j++){ //number of rings (of circles)
    float dSpin = abs(log(fft.getAvg(j)));
    if(dSpin<1000){ //loop solves infinity problem
      if(dSpin>1.2){
        angles[j]=angles[j]+dSpin/1500; //change divisor to alter rotational speed
      }
    }
    rotate(angles[j]);
    float rad1=rads[j];
    for(int i=1;i<noCirc;i++){ //number of circles in ring
      pushMatrix();
      translate(rad1*cos(radians(360/(noCirc-1))*i),rad1*sin(radians(360/(noCirc-1))*i));
      if(j<10){
        fill(cores[j/2]);
      }
      else{
        fill(cores[0]); 
      }
      ellipse(0,0,60-(j*3.5),60-(j*3.5));
      popMatrix();  
    }
    noCirc+=3; //increase number of circles in next ring
  }
}
