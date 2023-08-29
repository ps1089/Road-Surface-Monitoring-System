#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include <Wire.h>

#include <Adafruit_Sensor.h>    // Adafruit  sensor library
#include <Adafruit_ADXL345_U.h> // ADXL345 library

#include <NTPClient.h>
#include <WiFiUdp.h>

// getting location data from app ; for http connection
#include <ESP8266HTTPClient.h> // 
#include <WiFiClient.h>        //
// #define timer_delay 5000       // fetch location data every 'timer_delay' ms.
//Your Domain name with URL path or IP address with path
String serverName = "http://192.168.243.1:8080";
String Location; // fetched data to be stored here

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastTime = 0;
// Timer set to 10 minutes (600000)
//unsigned long timerDelay = 600000;
// Set timer to 5 seconds (5000)
// unsigned long timerDelay = timer_delay;

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "Construct"
#define WIFI_PASSWORD "Keyur2444"

// Insert Firebase project API Key
#define API_KEY "AIzaSyC3w-8kiBswLxJvOYjySBQUl68nbwGsQpA"
#define max_retry 5

// Insert Authorized Email and Corresponding Password
#define USER_EMAIL "parasboy@rocks.com"
#define USER_PASSWORD "paras01"

// Insert RTDB URLefine the RTDB URL
#define DATABASE_URL "https://dbtrials-default-rtdb.asia-southeast1.firebasedatabase.app/"
