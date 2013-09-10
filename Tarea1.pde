import processing.serial.*;
import processing.net.*;
import cc.arduino.*;

Arduino arduino;

int tamArreglo = 10;  // tamanio de arreglo de valores sensados
float[] valores = new float[tamArreglo];    // arreglo para calcular promedio
int resistencias = 585;   // valor fijo de las resistencias
float voltaje = 5.0;  // valor fijo de voltaje
int maximo = 1023;    // maximo q llega el sensor
float sensor = 0.0; // lo que mide el sensor
float promedio = 0.0;   // promedio de los ultimos 10 valores
float valorR_t = 0.0;   // valor a plotear
int pos = 0;   // para no tener que mover
//PrintWriter pw ;

Server myServer;

void setup() {
  //Cambiar el numero del puerto segun lo que muestre la lista y el que se quiera usar
  println(Arduino.list());   arduino = new Arduino(this, Arduino.list()[2], 57600);
  myServer = new Server(this, 5204); 
  //pw = createWriter("lecturas.txt");
 
}

void draw() {
  sensor = arduino.analogRead(0);
  //print(sensor);
  //print(" --- --- --- --- ");
  // actualiz vector y muevo pos
  valores[pos] = voltaje * sensor / maximo;
  pos++;
  if (pos == tamArreglo){
    pos = 0;
  }

  // calcular promedio
  promedio = 0;
  for(int i = 0; i < tamArreglo; i++){
    promedio += valores[i];
  }
  promedio = promedio / tamArreglo;
    
   // calcular lo que hay que graficar, el valor de R_t
   if (promedio >= 0.01)
      valorR_t = resistencias * ((voltaje / promedio) - 1);      // calcular lo que hay que graficar, el valor de R_t
   else 
      valorR_t = 70000;
 
  if(valorR_t > 9999)
    valorR_t = 9999;  
    
  println(valorR_t);
  int val = (int) valorR_t;
  String str = "" + val+"-";
  myServer.write(str);
  //pw.println(val);
  //pw.flush();
  delay (50);

}
