// TODO: X-accel condition ; velocity non-zero in forward direction //

#include "required.h"

// Define Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Variable to save USER UID
String uid;

// Database main path (to be updated in setup with the user UID)
String databasePath;
// Database child nodes
String X_accel = "/X_accel";
String Y_accel = "/Y_accel";
String Z_accel = "/Z_accel";
String timePath = "/timestamp";
String K_concl = "/Kalman_Conclusion";
String location = "/loc_latlong";

// Parent Node (to be updated in every loop)
String parentPath;

FirebaseJson json;

// Define NTP Client to get time
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

// Variable to save current epoch time
int timestamp;

// updates

Adafruit_ADXL345_Unified accel = Adafruit_ADXL345_Unified(); /* ADXL345 Object */
sensors_event_t event;

// flag 
bool flag = false;

// constants Kalman

double Z_kalman_gain,Z_Estimated_value=50,Z_Error_Estimate=50,Z_Error_meas=50;    // Kalman filter arguments / parameters
double th_delta_z = 4;
double X_Measured_value, Y_Measured_value, Z_Measured_value, Delta_Z;

// TODO : X-accel condition ;if x> threshold (motion happens) then display (and consider) Z value;
// Kalman prediction 
void kalman()
{
  
  Delta_Z=0;
  Z_Measured_value=0;
  flag = false;
  volatile int i;
  
  accel.getEvent(&event);
  // for(i=0;i<4;i++) 
  // {
  //   // changed by keyur
  //   Z_Measured_value+=event.acceleration.z;
  // }          
  // Z_Measured_value= (Z_Measured_value)/4;   // Averaging (average of 4 consecutive Samples)       
  // measurement error = 500 ; initial estimated value = 500 ; initial error is estimate = 500
  X_Measured_value=event.acceleration.x;
  Y_Measured_value=event.acceleration.y;
  Z_Measured_value=event.acceleration.z;
  Z_kalman_gain=Z_Error_Estimate/(Z_Error_Estimate+Z_Error_meas);                     // Finding Kalman Gain
  Z_Estimated_value=Z_Estimated_value + Z_kalman_gain*(Z_Measured_value-Z_Estimated_value); // Finding an Estimate to our Measured Value
  Z_Error_Estimate=(1-Z_kalman_gain)*Z_Error_Estimate;                                // Updating the Error Coefficient
    
  Delta_Z = Z_Measured_value - Z_Estimated_value;                                     // Finding Difference between Estimated and Measured Value
  if(Delta_Z < 0) 
  { 
    Delta_Z *= (-1);
  } // if negative value, make it positive
  Serial.printf("\nDelta Z = %lf \n",Delta_Z);
  if(Delta_Z > th_delta_z)  // Accelerometer Noise Margin < 30, Hence if the detected values exceeds it , It is definitely a Pothole
  { 
   flag = true; 
  }  
}

// Timer variables (send new readings every 10 sec)
unsigned long sendDataPrevMillis = 0;
unsigned long timerDelay = 1500; 

// Initialize ADXL345
void initADXL()
{
  while (!accel.begin())   
  /* If not found, repeat the loop; otherwise, print FOUND. */
  { 
    Serial.println("\nADXL345 not found\n"); 
    delay(500); 
  }
  Serial.println("\nADXL345 FOUND !!\n");  
  
}

// Initialize WiFi
void initWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.. connecting ..\n');
    delay(1000);
  }
  Serial.printf("\n- - - - - - - - - - Internet Connection established !! - - - - - - - - - -\n");
  Serial.println(WiFi.localIP());
  
}

// Function that gets current epoch time
unsigned long getTime() {
  timeClient.update();
  unsigned long now = timeClient.getEpochTime();
  return now;
}

void fetchGPS()
{
  WiFiClient client;
  HTTPClient http;

  String serverPath = serverName;// + "?temperature=24.37";
  
  // Your Domain name with URL path or IP address with path
  http.begin(client, serverPath.c_str());

  // If you need Node-RED/server authentication, insert user and password below
  //http.setAuthorization("REPLACE_WITH_SERVER_USERNAME", "REPLACE_WITH_SERVER_PASSWORD");
    
  // Send HTTP GET request
  int httpResponseCode = http.GET();
  
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    String Location = http.getString();
    Serial.println(Location);
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  // Free resources
  http.end();

}

void setup(){
  Serial.begin(115200);

  // Initialize ADXL sensor
  initADXL();
  initWiFi();
  timeClient.begin();

  // Assign the api key (required)
  config.api_key = API_KEY;

  // Assign the user sign in credentials
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  // Assign the RTDB URL (required)
  config.database_url = DATABASE_URL;

  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

  // Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  // Assign the maximum retry of token generation
  config.max_token_generation_retry = max_retry;

  // Initialize the library with the Firebase authen and config
  Firebase.begin(&config, &auth);

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID\n");
  while ((auth.token.uid) == "") {
    Serial.print('.. getting uid ..\n');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  // Update database path
  databasePath = "/UsersData/" + uid + "/readings";
}

void loop(){

  // Send new readings to database
  if (Firebase.ready() && (millis() - sendDataPrevMillis > timerDelay || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();

    //Get current timestamp
    timestamp = getTime();
    Serial.print ("time: ");
    Serial.println (timestamp);

    parentPath= databasePath + "/" + String(timestamp);
    //
    //accel.getEvent(&event);
    kalman();  
    //Serial.printf("\ndelta Z = %lf \n",Delta_Z);
    json.set(X_accel.c_str(), String(X_Measured_value));
    json.set(Y_accel.c_str(), String(Y_Measured_value));
    json.set(Z_accel.c_str(), String(Z_Measured_value));
    if(flag == true)       { json.set(K_concl.c_str(),"True"); }
    else if(flag == false) { json.set(K_concl.c_str(),"False"); }    
        
    json.set(timePath, String(timestamp));
    Serial.printf("Set json... %s\n", Firebase.RTDB.setJSON(&fbdo, parentPath.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
    fetchGPS();
    json.set(location.c_str(), String(Location));
           
  }
}