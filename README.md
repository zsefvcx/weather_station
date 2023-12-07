# weather_station

Weather Station.

## Getting Started


Модуль датчика температуры, давления, влажности AHT20 + BMP280:
    Датчик температуры и влажности: AHT20;
    Датчик давления: BMP280;
    Интерфейс: I2C;
    Рабочее напряжение: 2.8 - 5 В;
    Размеры платы: 16 мм * 16 мм.

https://arduinolab.pw/index.php/2021/07/06/datchik-temperatury-i-vlazhnosti-aht20-i-aht21/
https://github.com/enjoyneering/AHT10
https://3d-diy.ru/wiki/arduino-datchiki/sensor-bmp280/
https://github.com/adafruit/Adafruit_BMP280_Library
 
Контроллер ESP8266 4Mb D1 Mini
Распиновка:
Назначение 	          | №   | 	               | №  | Назначение        |
Перезагрузка          | RST |         | JPIO-1 | TX | UART (TX)         | 
TOUT, ADC 	          | A0  |	      | JPIO-3 | RX | UART (RX)         |
WAKE 	              | D0  | JPIO-16 | JPIO-5 | D1 | I2C (SCL), IR (RX)|
IR (TX), SPI (CLK) 	  | D5  | JPIO-14 | JPIO-4 | D2 | I2C (SDA)         |
SPI (MISO)            | D6  | JPIO-12 | JPIO-0 | D3 |	                |
UART (CTS), SPI (MOSI)| D7 	| JPIO-13 | JPIO-2 | D4 | LED, UART1 (TX)   |
UART (RTS), SPI (CS)  |	D8 	| JPIO-15 |        | GND| Общий             |
Вход питания 	      | 3V3 |	      |        | 5V | Вход питания      |

https://alexgyver.ru/lessons/esp8266/
https://arduino.esp8266.com/stable/package_esp8266com_index.json.