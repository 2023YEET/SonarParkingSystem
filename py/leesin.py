import RPi.GPIO as GPIO
import time
import pymysql

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
conn = None
cur = None

sql=""

conn =""
cur=""

canNum=0
carNum=""#null
avail=""

conn = pymysql.connect(host='localhost:3306', user='yeetpi', db='parking', charset='utf8')


TRIG1 = 23
ECHO1 = 24

TRIG2 = 16
ECHO2 = 20

TRIG3 = 13
ECHO3 = 19
print("초음파 거리 측정기")

GPIO.setup(TRIG1, GPIO.OUT)
GPIO.setup(ECHO1, GPIO.IN)
GPIO.setup(TRIG2, GPIO.OUT)
GPIO.setup(ECHO2, GPIO.IN)
GPIO.setup(TRIG3, GPIO.OUT)
GPIO.setup(ECHO3, GPIO.IN)

GPIO.output(TRIG1, False)
GPIO.output(TRIG2, False)
GPIO.output(TRIG3, False)
print("초음파 출력 초기화")
time.sleep(2)

try:
    while True:
        GPIO.output(TRIG1,True)
        GPIO.output(TRIG2,True)
        GPIO.output(TRIG3,True)
        time.sleep(0.00001)        # 10uS의 펄스 발생을 위한 딜레이
        GPIO.output(TRIG1, False)
        GPIO.output(TRIG2, False)
        GPIO.output(TRIG3, False)
        start1 =0.0
        start2 =0.0
        start3=0.0
        
        stop1=0.0
        stop2=0.0
        stop3=0.0
        check_time1=0.0
        check_time2=0.0
        check_time3=0.0
        distance1=0
        distance2=0
        distance3=0
        
        
        while GPIO.input(ECHO1)==0:
            start1 = time.time()     # Echo핀 상승 시간값 저장
            
        while GPIO.input(ECHO2)==0:
            start2 = time.time()     # Echo핀 상승 시간값 저장
            
        while GPIO.input(ECHO3)==0:
            start3 = time.time()     # Echo핀 상승 시간값 저장    


        while GPIO.input(ECHO1)==1:
            stop1 = time.time()      # Echo핀 하강 시간값 저장
            
        while GPIO.input(ECHO2)==1:
            stop2 = time.time()      # Echo핀 하강 시간값 저장
            
        while GPIO.input(ECHO3)==1:
            stop3 = time.time()      # Echo핀 하강 시간값 저장
            
        check_time1 = stop1 - start1
        check_time2 = stop2 - start2
        check_time3 = stop3 - start3
        distance1 = check_time1 * 34300 / 2
        distance2 = check_time2 * 34300 / 2
        distance3 = check_time3 * 34300 / 2
        print("Distance1 : %.1f cm" % distance1)
        print("Distance2 : %.1f cm" % distance2)
        print("Distance3 : %.1f cm" % distance3)
        time.sleep(1)
        
except KeyboardInterrupt:
    print("거리 측정 완료 ")
    GPIO.cleanup()      
        

