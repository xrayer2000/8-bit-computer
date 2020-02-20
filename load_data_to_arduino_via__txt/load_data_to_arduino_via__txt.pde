import processing.serial.*;
import java.io.*;
int mySwitch=0;
int counter=0;
String [] subtext;
Serial myPort;
int byteRead;


void setup() {
  //Create a switch that will control the frequency of text file reads.
  //When mySwitch=1, the program is setup to read the text file.
  //This is turned off when mySwitch = 0
  mySwitch=1;

  //Open the serial port for communication with the Arduino
  //Make sure the COM port is correct (look in your Arduino sketch, tools->port) 
  //and same baudrate as the Arduino sketch (57600)
  myPort = new Serial(this, "COM3", 57600);
  myPort.bufferUntil('\n');
  delay(1500);
}

void draw() {
  if (mySwitch>0) {
    /*The readData function can be found later in the code.
     This is the call to read a CSV file on the computer hard-drive. */
    readData("D:/Desktop Rent/Code.txt"); //C:/Users/It/Desktop/Code.txt

    /*The following switch prevents continuous reading of the text file, until
     we are ready to read the file again. */
    mySwitch=0;
  }
  /*Only send new data. This IF statement will allow new data to be sent to
   the arduino. */
  if (counter<subtext.length) {

    myPort.write(subtext[counter]); //send a byte to the Arduino via serial port

    delay(400);


    if (myPort.available() > 0)
    { 
      //print(char(myPort.read()) + ", ");
      //print(char(myPort.read()) + ", ");
      print(Integer.toHexString(myPort.read()) + ": ");

      delay(100);
    }

    //Increment the counter so that the next number is sent to the arduino.
    counter++;
  } 
} 


/* The following function will read from a CSV or TXT file */
void readData(String myFileName) {

  File file=new File(myFileName);
  BufferedReader br=null;

  try {
    br=new BufferedReader(new FileReader(file));
    String text=null;

    /* keep reading each line until you get to the end of the file */
    while ((text=br.readLine())!=null) {
      /* Spilt each line up into bits and pieces using a comma as a separator */
      subtext = splitTokens(text, ",");
    }
  }
  catch(FileNotFoundException e) {
    e.printStackTrace();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  finally {
    try {
      if (br != null) {
        br.close();
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}
