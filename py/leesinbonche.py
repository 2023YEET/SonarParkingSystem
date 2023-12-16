import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)





TRIG1 = 23
ECHO1 = 24

TRIG2 = 16
ECHO2 = 20

TRIG3 = 13
ECHO3 = 19


    

print("초음파 거리 측정기")

def check(trig, echo):
    global start, stop, check_time, distance
    
    GPIO.setup(trig, GPIO.OUT)
    GPIO.setup(echo, GPIO.IN)
    GPIO.output(trig,False)
    print("초음파 출력 초기화")
    time.sleep(0.5)
    GPIO.output(trig,True)
    time.sleep(0.00001)			# 10uS의 펄스 발생을 위한 딜레이
    GPIO.output(trig, False)   

    while GPIO.input(echo)==0:
        start = time.time()     # Echo핀 상승 시간값 저장


    while GPIO.input(echo)==1:
        stop = time.time()      # Echo핀 하강 시간값 저장
            
    check_time = stop - start
    distance = check_time * 34300 / 2
    print("Distance : %.1f cm"% distance)
    time.sleep(0.8)
try:
    while True:
        for i in range(3):
            print("1st")
            check(TRIG1, ECHO1)
            print("2nd")
            check(TRIG2, ECHO2)
            print("3rd")
            check(TRIG3, ECHO3)
            time.sleep(1)
##            time.sleep(60)

        
except KeyboardInterrupt:
    print("거리 측정 완료 ")
    GPIO.cleanup()      
        
        
        



