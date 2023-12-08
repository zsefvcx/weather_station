#include <Adafruit_BMP280.h>
#include <Adafruit_AHTX0.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <WiFiUdp.h>

#define BMP_SCK  (13)
#define BMP_MISO (12)
#define BMP_MOSI (11)
#define BMP_CS   (10)
#define DHTPIN    D4
#define DHTTYPE   DHT22 
#define SEALEVELPRESSURE_HPA (1013.25)

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


void setup() {
  Serial.begin(115200);
  Serial.println(F("-START-SETUP------------------------"));
  Serial.println(F("BMP280 Forced Mode && Adafruit AHT10/AHT20 && DHT22 Sensors"));
  Serial.println(F("-bmp--------------------------------"));
  if (!bmp.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring or "
                      "try a different address!"));
    while (1) delay(10);
  }
  Serial.println(F("-aht--------------------------------"));
  bmp.setSampling(Adafruit_BMP280::MODE_FORCED,     /* Operating Mode. */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                  Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */
  if (! aht.begin()) {
    Serial.println("Could not find AHT? Check wiring");
    while (1) delay(10);
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
  delayMS = sensor.min_delay / 1000;
  Serial.print(F("delayMS")); Serial.println(delayMS);
  Serial.println(F("-START-LOOP-------------------------"));
}

float tBmpInt=-255, tAthInt=-255, tDhtExt=-255; 
float pBmpInt = -255;
float aBmpInt = -255;
float toMmHg = 0.00750063755419211;
float hAthInt=-255, hDhtEct=-255;

void getBmpData(){
  if (bmp.takeForcedMeasurement()) {
      // can now print out the new measurements
      tBmpInt = bmp.readTemperature();
      pBmpInt = (bmp.readPressure())*toMmHg;
      aBmpInt =  bmp.readAltitude(SEALEVELPRESSURE_HPA);
      Serial.print(F("Temperature = ")); Serial.print(tBmpInt); Serial.println(" *C");
      Serial.print(F("Pressure = ")); Serial.print(pBmpInt); Serial.println(" mmHh");
    } else {
      Serial.println("Forced measurement failed!");
      tBmpInt=-255;
      pBmpInt=-255;
      aBmpInt=-255;
    }
}

void getAhtData(){
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
  statusFW.t       = (tBmpInt+tAthInt)/2; 
  statusFW.h       = hAthInt;
  statusFW.p       = pBmpInt;
  statusFW.Altitude= aBmpInt;
  statusFW.t2      = tDhtExt;
  statusFW.h2      = hDhtEct;
  statusFW.src = getHash((byte*)&statusFW, sizeof(statusFW));
}


void loop() {
  static int i  = 0; i++;  
  Serial.println(F("------------------------------------"));
  Serial.print("Packet:"); Serial.println(i);
  Serial.println(F("-getBmpData-------------------------"));
  getBmpData();
  Serial.println(F("-getAhtData-------------------------"));
  getAhtData();
  Serial.println(F("-getDhtData-------------------------"));
  getDhtData();
  Serial.println(F("-setStatusFW------------------------"));
  setStatusFW();

  Serial.println(F("------------------------------------"));
  delay(2000);delay(delayMS);
  


  if (i >= 5){
    Serial.println(F("-Sleep-600e6--------------------------"));
    ESP.deepSleep(600e6); // сон  (10 минут = 600e6) или 0 - чтобы не просыпаться самостоятельно
    i =  0;
  }
}
