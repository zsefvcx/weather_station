#include <Adafruit_BMP280.h>
#include <Adafruit_AHTX0.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <WiFiUdp.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266WiFi.h>
#include <ArduinoJson.h>
#include <SimplePortal.h>
#include <EEPROM.h>

#define BMP_SCK  (13)
#define BMP_MISO (12)
#define BMP_MOSI (11)
#define BMP_CS   (10)
#define DHTPIN    D4
#define DHTTYPE   DHT22 
#define SEALEVELPRESSURE_HPA (1013.25)
#define RESETWIFI D8


Adafruit_AHTX0 aht;
Adafruit_BMP280 bmp; // I2C

DHT_Unified dht(DHTPIN, DHTTYPE);

uint32_t delayMS;

#pragma pack(push, 1)
struct Status{
uint8_t key[3];
bool alarm;
float t;//-50 ... 100
float h;//0 ... 100
bool err; 
float t2;//-50 ... 100
float h2;//0 ... 100 
bool err2;
float p;//700 ... 800 
float Altitude;
int8_t src;
} statusFW;
#pragma pack(pop)

#pragma pack(push, 1)
struct APData{
  char key;
  char ssid[32];
  char pass[32];
} currentAPData;
#pragma pack(pop)

ESP8266WebServer server(80);

unsigned int localPort = 8088; 
WiFiUDP Udp;

void handleRoot() {
  server.send(200, "text/plain", "hello from esp8266!");
}

void handleNotFound(){
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET)?"GET":"POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i=0; i<server.args(); i++){
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
}

bool isAhtStart = true;
bool isBmpStart = true;

void setup() {
  Serial.begin(115200);
  Serial.println(F("-START-SETUP------------------------"));
  Serial.println(F("BMP280 Forced Mode && Adafruit AHT10/AHT20 && DHT22 Sensors"));
  Serial.println(F("-bmp--------------------------------"));
  if (!bmp.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring or "
                      "try a different address!"));
    isBmpStart = false;
  }
  Serial.println(F("-aht--------------------------------"));
  bmp.setSampling(Adafruit_BMP280::MODE_FORCED,     /* Operating Mode. */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                  Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */
  if (!aht.begin()) {
    Serial.println("Could not find AHT? Check wiring");
    isAhtStart = false;
  }
  Serial.println(F("-dht--------------------------------"));
  dht.begin();
  sensor_t sensor;
  dht.temperature().getSensor(&sensor);
  Serial.println(F("Temperature Sensor"));
  Serial.print  (F("Sensor Type: ")); Serial.println(sensor.name);
  Serial.print  (F("Driver Ver:  ")); Serial.println(sensor.version);
  Serial.print  (F("Unique ID:   ")); Serial.println(sensor.sensor_id);
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("°C"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("°C"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("°C"));
  dht.humidity().getSensor(&sensor);
  Serial.println(F("Humidity Sensor"));
  Serial.print  (F("Sensor Type: ")); Serial.println(sensor.name);
  Serial.print  (F("Driver Ver:  ")); Serial.println(sensor.version);
  Serial.print  (F("Unique ID:   ")); Serial.println(sensor.sensor_id);
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("%"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("%"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("%"));
  delayMS = 10000;//sensor.min_delay / 1000;
  Serial.print(F("delayMS:")); Serial.println(delayMS);
  Serial.println(F("-START-LOOP-------------------------"));
startNext0:
  int i = -1;
startNext:
  i++; if(i>=4)i=0;
  EEPROM.begin(512);
    char buffer[sizeof(currentAPData)];  
    memset(&buffer, 0x00, sizeof(currentAPData));
    for(unsigned int add=0; add < sizeof(currentAPData); add++){
      buffer[add] = EEPROM.read(add+sizeof(currentAPData)*i);
    }
    memcpy((char *)&currentAPData, buffer, sizeof(currentAPData));
  EEPROM.end();
Serial.print  (F("i: ")); Serial.println(i);
Serial.print  (F("currentAPData.key: ")); Serial.println(currentAPData.key);
Serial.print  (F("currentAPData.ssid: ")); Serial.println(currentAPData.ssid);
Serial.print  (F("currentAPData.pass: ")); Serial.println(currentAPData.pass);

  pinMode(RESETWIFI, INPUT_PULLUP);

  if(currentAPData.key == 0xAB && digitalRead(RESETWIFI) == LOW){
    WiFi.begin(currentAPData.ssid, currentAPData.pass);
    Serial.println("");
    int i = 0;
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
      i++;
      if(i >= 50) goto startNext;
    }
  } 
  else
  {
startNextPortalRun:
    portalRun(300000);  // запустить с таймаутом 60с
    //portalRun(30000); // запустить с кастомных таймаутом
    Serial.println(portalStatus());
    // статус: 0 error, 1 connect, 2 ap, 3 local, 4 exit, 5 timeout
    if (portalStatus() == SP_SUBMIT) {
      Serial.println(portalCfg.SSID);
      Serial.println(portalCfg.pass);
      EEPROM.begin(512);
      char buffer[sizeof(currentAPData)];  
      memset(&buffer, 0x00, sizeof(currentAPData));
      currentAPData.key = 0xAB; 
      memcpy(&(currentAPData.ssid), (char *)&(portalCfg.SSID), sizeof(portalCfg.SSID));
      memcpy(&(currentAPData.pass), (char *)&(portalCfg.pass), sizeof(portalCfg.pass));
      memcpy(&buffer, (char *)&currentAPData, sizeof(currentAPData));
      for(unsigned int add=0; add<sizeof(currentAPData); add++){
        EEPROM.write(add+sizeof(currentAPData)*i, buffer[add]);
        EEPROM.commit();
      }
      EEPROM.end();
      // забираем логин-пароль
      WiFi.begin(portalCfg.SSID, portalCfg.pass);
      Serial.println("");
      int j = 0;
      while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
        i++;
        if(i >= 50) goto startNextPortalRun;
      }
    } else {
      goto startNext0;
    }
  }

  Serial.println("");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (MDNS.begin("esp8266")) {
    Serial.println("MDNS responder started");
  }

  server.on("/", handleRoot);

  server.on("/inline", [](){
    server.send(200, "text/plain", "this works as well");
  });

  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");
  Udp.begin(localPort);
}

float tBmpInt=-255, tAthInt=-255, tDhtExt=-255; 
float pBmpInt = -255;
float aBmpInt = -255;
float toMmHg = 0.00750063755419211;
float hAthInt=-255, hDhtEct=-255;

void getBmpData(){
  if(isBmpStart == false){
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring or "
                      "try a different address!"));
    tBmpInt=-255;
    pBmpInt=-255;
    aBmpInt=-255;
    return;
  }

  if (bmp.takeForcedMeasurement()) {
      // can now print out the new measurements
      tBmpInt = bmp.readTemperature();
      pBmpInt = (bmp.readPressure())*toMmHg;
      aBmpInt =  bmp.readAltitude(SEALEVELPRESSURE_HPA);
      Serial.print(F("Temperature = ")); Serial.print(tBmpInt); Serial.println(" *C");
      Serial.print(F("Pressure = ")); Serial.print(pBmpInt); Serial.println(" mmHh");
      Serial.print(F("Approx altitude = ")); Serial.print(aBmpInt); Serial.println(" m");
    } else {
      Serial.println("Forced measurement failed!");
      tBmpInt=-255;
      pBmpInt=-255;
      aBmpInt=-255;
    }
}

void getAhtData(){
  if(isAhtStart == false){
    Serial.println("Could not find AHT? Check wiring");
    tAthInt = -255;
    hAthInt = -255;
    return;
  }

  sensors_event_t humidity, temp;
  aht.getEvent(&humidity, &temp);// populate temp and humidity objects with fresh data
  tAthInt = temp.temperature;
  hAthInt = humidity.relative_humidity;
  Serial.print("Temperature: "); Serial.print(tAthInt); Serial.println(" degrees C");
  Serial.print("Humidity: "); Serial.print(hAthInt); Serial.println("% rH");
}

void getDhtData(){
  sensors_event_t event;
  dht.temperature().getEvent(&event);
  if (isnan(event.temperature)) {
    Serial.println(F("Error reading temperature!"));
    tDhtExt = -255;
  }
  else {
    tDhtExt = event.temperature;
    Serial.print(F("Temperature: ")); Serial.print(tDhtExt); Serial.println(F("°C"));
  }
  // Get humidity event and print its value.
  dht.humidity().getEvent(&event);
  if (isnan(event.relative_humidity)) {
    Serial.println(F("Error reading humidity!"));
    hDhtEct = -255;
  }
  else {
    hDhtEct = event.relative_humidity;
    Serial.print(F("Humidity: ")); Serial.print(hDhtEct); Serial.println(F("%"));
  }

}

byte getHash(byte* data, int length) {
  byte hash = 0;
  int i = 0;
  while (length--) {
    hash += *(data + i);
    i++;
  }
  return hash;
}

void setStatusFW(){
  statusFW.key[0]  = 0xAA;
  statusFW.key[1]  = 0xAA;
  statusFW.key[2]  = 0xAB;
  statusFW.alarm   = tBmpInt==-255||tAthInt==-255||tDhtExt==-255||pBmpInt==-255 ||hAthInt==-255||hDhtEct==-255||aBmpInt==-255; 
  statusFW.err     = tBmpInt==-255||tAthInt==-255||               pBmpInt==-255|| hAthInt==-255               ||aBmpInt==-255;
  statusFW.err2    =                               tDhtExt==-255||                               hDhtEct==-255;
  if(tAthInt == -255){
    statusFW.t     =  tBmpInt;
  } else if(tBmpInt == -255){
    statusFW.t     =  tAthInt;
  } else if(tAthInt == -255 && tBmpInt == -255){
    statusFW.t     =  -255;
  } else {
    statusFW.t     =  (tBmpInt+tAthInt)/2; 
  }
  
  statusFW.h       = hAthInt;
  statusFW.p       = pBmpInt;
  statusFW.Altitude= aBmpInt;
  statusFW.t2      = tDhtExt;
  statusFW.h2      = hDhtEct;
  statusFW.src     = getHash((byte*)&statusFW, sizeof(statusFW));
}

char packetBuffer[UDP_TX_PACKET_MAX_SIZE + 1];
StaticJsonDocument<400> jsonDocument;

void statusToJson(int sending){
    jsonDocument["key"] = "AAAAAB_KEY:16032023";
    jsonDocument["sending"] = sending+1;
    jsonDocument["alarm"] = statusFW.alarm;
    jsonDocument["temperature"] = ((long)(statusFW.t*100));
    jsonDocument["humidity"] = ((long)(statusFW.h*100));
    jsonDocument["error"] = statusFW.err;
    jsonDocument["temperature2"] = ((long)(statusFW.t2*100));
    jsonDocument["humidity2"] = ((long)(statusFW.h2*100));
    jsonDocument["pressure"] = ((long)(statusFW.p*100));
    jsonDocument["altitude"] = ((long)(statusFW.Altitude*100));
    jsonDocument["error2"] = statusFW.err2;
}


void loop() {

  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println(F("-getBmpData-------------------------"));
  getBmpData();
  Serial.println(F("-getAhtData-------------------------"));
  getAhtData();
  Serial.println(F("-getDhtData-------------------------"));
  getDhtData();
  Serial.println(F("-setStatusFW------------------------"));
  setStatusFW();
  Serial.println(F("-statusToJson--To-Serial------------"));
  statusToJson(-1);
  Serial.println(F("-serializeJson----------------------"));
  serializeJson(jsonDocument, Serial);Serial.println();
  Serial.println(F("-SendReceiveData-----------------------"));
  int i = 0;
  do{
    Serial.println(F("------------------------------------"));
    Serial.print("Packet:"); Serial.println(i+1);
    statusToJson(i);
    Serial.println(F("-serializeJson-To-Serial------------"));
    serializeJson(jsonDocument, Serial);Serial.println();
    int packetSize = Udp.parsePacket();
    if (packetSize) {
      static String IP_Ban[20];
      static int i = 0;
      memset(&packetBuffer, 0x00, UDP_TX_PACKET_MAX_SIZE);
      int n = Udp.read(packetBuffer, UDP_TX_PACKET_MAX_SIZE);
      packetBuffer[n] = 0;
      String stringpacketBuffer =  String(packetBuffer);
      Serial.println("Contents:");
      Serial.println(packetBuffer);
      Serial.println(Udp.remoteIP().toString());
      for(int j = 0; j < i; j++){
        Serial.println(IP_Ban[j]);
        if(IP_Ban[j] == Udp.remoteIP().toString()){
          Serial.println("IP_Ban:");
          Serial.println(IP_Ban[j]);
          return;
        }
      }
      if(stringpacketBuffer != "AAAAAB_KEY:16032023"){
        Serial.println(F("-serializeJson-To-UDP-ErrorPacket---"));
        IP_Ban[i] = Udp.remoteIP().toString();
        Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
        Udp.write("ErrorPacket");
        Udp.println();
        Udp.endPacket();
        i++;
        if(i > 20) i = 0;
        } else {
          Serial.println(F("-serializeJson-To-UDP-CLIENT------"));
          Serial.println(Udp.remoteIP());
          Serial.println(Udp.remotePort());
          Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
          serializeJson(jsonDocument, Udp);
          Udp.println();
          Udp.endPacket();
        }
      } else {
          Serial.println(F("-serializeJson-To-UDP-MULTICAST------"));
          server.handleClient();
          IPAddress broadcastIp(255,255,255,255);//239, 255, 255, 250);
          Udp.beginPacket(broadcastIp,localPort);
          serializeJson(jsonDocument, Udp);
          Udp.println();
          Udp.endPacket();
      }
   delay(delayMS);
   i++;
  } while(i < 30);//5 минут бодрствования
  Serial.println(F("-deepSleep-600e6-------------------"));
  //Замкнуть пины D0 на RST
  ESP.deepSleep(600e6); // сон  (10 минут = 600e6) или 0 - чтобы не просыпаться самостоятельно
}
