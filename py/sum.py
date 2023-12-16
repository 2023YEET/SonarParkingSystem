import RPi.GPIO as GPIO
import time
import pymysql

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

TRIG1 = 23
ECHO1 = 24

TRIG2 = 16
ECHO2 = 20

TRIG3 = 13
ECHO3 = 19

TRIG4 = 5
ECHO4 = 6

TRIG5 = 17
ECHO5 = 27



print("초음파 거리 측정기")



def selsql(cellnum):	#
    selsql = 'select occupied from pavailable  where cellnum = (%s)'
    cur.execute(selsql, (str(cellnum)))
    sqlres = cur.fetchone()
    return(sqlres[0])
    
    
def updsql(cellnum,occupied):
    updsql = 'update pavailable set occupied = (%s) where cellnum= (%s)'
    cur.execute(updsql, (str(occupied), str(cellnum)))
    db.commit()
    
def check(trig, echo):
    start=0
    stop=0
    check_time=0
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
    print("Distance : %d cm"% distance)
    return int(distance)
    time.sleep(0.8)
    
    
def logic(sqlres, dist, aldist, cellnum):
    if int(sqlres) == 0:
        if (aldist+1) < dist:
            updsql(cellnum, 1)
            return '0upd'
        elif aldist == dist:
            return '0same'
        else:
            return '0error'
    elif int(sqlres) ==1:
        if (aldist-1) > dist:
            updsql(cellnum, 0)
            return '1upd'
        elif aldist == dist:
            return '1same'
        else:
            return '1error'
    else:
        print(sqlres)
            
    

try:
    distance=0.0
    sqlres=0
    global dist1, dist2, dist3, dist4, dist5
    global aldist1, aldist2, aldist3, aldist4, aldist5
    
    dist1 = int(check(TRIG1, ECHO1))
    dist2 = int(check(TRIG2, ECHO2))
    dist3 = int(check(TRIG3, ECHO3))
    dist4 = int(check(TRIG4, ECHO4))
    dist5 = int(check(TRIG5, ECHO5))
    time.sleep(3)
    while True:
        db= pymysql.connect(
            host='localhost',
            user='yeetpi',
            passwd='a123123123',
            db='parking',
            charset='utf8'
            )
        cur = db.cursor()
        
        #for i in range(1,4):
            
        cellnum=1
        sqlres = selsql(cellnum)
        aldist1 = int(check(TRIG1, ECHO1))
        print(logic(sqlres, dist1, aldist1, cellnum))
        dist1=aldist1
        print(cellnum)
            

        cellnum=2
        sqlres = selsql(cellnum)
        aldist2 = int(check(TRIG2, ECHO2))
        print(logic(sqlres, dist2, aldist2, cellnum))
        dist2=aldist2
        print(cellnum)
        

        cellnum=3
        sqlres = selsql(cellnum)
        aldist3 = int(check(TRIG3, ECHO3))
        print(logic(sqlres, dist3, aldist3, cellnum))
        dist3=aldist3
        print(cellnum)
        

        cellnum=4
        sqlres = selsql(cellnum)
        aldist4 = int(check(TRIG4, ECHO4))
        print(logic(sqlres, dist4, aldist4, cellnum))
        dist4=aldist4
        print(cellnum)
        

        cellnum=5
        sqlres = selsql(cellnum)
        aldist5 = int(check(TRIG5, ECHO5))
        print(logic(sqlres, dist5, aldist5, cellnum))
        dist5=aldist5
        print(cellnum)
            
            
            
        time.sleep(1)
            
        db.close()
        time.sleep(5)

        
except KeyboardInterrupt:
    print("거리 측정 완료 ")
    GPIO.cleanup()      
        
        
        




