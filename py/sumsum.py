import RPi.GPIO as GPIO
import time
import pymysql

GPIO.setmode(GPIO.BCM) #input/output control sensor
GPIO.setwarnings(False) #just exist

#port numbers
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



def getParkingCellOccupied(cellnum):	#searchPavailableOccupied
    selsql = 'select occupied from pavailable  where cellnum = (%s)'
    cur.execute(selsql, (str(cellnum)))
    sqlres = cur.fetchone()
    return(sqlres[0])
    
    
def updateOccupied(cellnum,occupied): #updatePavailableOccupied
    updsql = 'update pavailable set occupied = (%s) where cellnum= (%s)'
    cur.execute(updsql, (str(occupied), str(cellnum)))
    db.commit()
    
    
def writeOutTime(carnum): #updateOuttime
    OUTupdsql = "update time set outtime = now() where carnum= '(%s)' and inoutnum = (select max(inoutnum) from time where carnum = '(%s)');"
    cur.execute(OUTupdsql, (str(carnum), str(carnum)))
    db.commit()
    

def getNotOverDeadlineReservation(): #search reservation time <= 20min AND occupied=1 / not over 20min occupied
    chksql = 'select r.cellnum, r.carnum from reservation r, pavailable p where r.cellnum = p.cellnum AND (regdate> (DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 20 minute)));'
    cur.execute(chksql)
    chksqlres = cur.fetchall()
    return(chksqlres)

def deleteReservation(carnum): #deleteReservation
    resvDelsql = "delete from reservation where carnum = '(%s)';"
    cur.execute(resvDelsql, (str(carnum)))
    db.commit()
    
def getAllReservation():	#searchReservation
    resvSelsql = 'select * from reservation;'
    cur.execute(resvSelsql)
    sqlres = cur.fetchone()
    if sqlres == None:
        return("exitgogo")
    
def getOverDeadlineReservation():	#search ReservationTime > 20min
    resv20Msql = 'select carnum from reservation where regdate < (DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 20 minute))'
    cur.execute(resv20Msql)
    sqlres = cur.fetchone()
    
    if sqlres == None: #if null, return
        return
    else: #if not null, get result tuple length, and delete reservation
        m20count = len(sqlres)
        for a in range(0,m20count):
            carcar=sqlres[a][0]
            deleteReservation(carcar)
            

def getOuttimeNullRecordCarnum(): #check time record that the outtime is null;
    tmchksql = 'select carnum from time where outtime is null;'
    cur.execute(tmchksql)
    tmchksqlres = cur.fetchall()
    return(tmchksqlres)
    
def check(trig, echo): #sonar
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
    distance = check_time * 34300 / 2 #get distance
    print("Distance : %d cm"% distance)
    return int(distance)
    time.sleep(0.8)
    
    
def logic(parkingCellOccupied, originDistance, secondDistance, cellnum, carnum): #input : (searchPavailableOccupied, origin distance, second distance, cellnum, carnum)
    if int(parkingCellOccupied) == 0:
        if (secondDistance+1) < originDistance:        
            updateOccupied(cellnum, 1)
            return str(cellnum)+"occupied changed"
        elif aldist == dist:
            return 'Unoccupied do nothing'
        else:
            return 'distance is shorter then defore'
    elif int(parkingCellOccupied) ==1:
        if (secondDistance-1) > originDistance:
            updateOccupied(cellnum, 0)
            writeOutTime(carnum) #write outtime
            deleteReservation(carnum) #delete reservation
            return str(carnum)+' has gone'
        elif secondDistance == originDistance:
            return 'Occupied do nothing'
        else:
            return 'distance is longer then defore'
    else:
        print('error')
            
    

try:
    distance=0.0
    sqlres=0
    global dist1, dist2, dist3, dist4, dist5
    global aldist1, aldist2, aldist3, aldist4, aldist5
    #initialize sensors
    dist1 = int(check(TRIG1, ECHO1))
    dist2 = int(check(TRIG2, ECHO2))
    dist3 = int(check(TRIG3, ECHO3))
    dist4 = int(check(TRIG4, ECHO4))
    dist5 = int(check(TRIG5, ECHO5))
    time.sleep(3)
    
    db= pymysql.connect(
    host='localhost',
    user='yeetpi',
    passwd='a123123123',
    db='parking',
    charset='utf8'
    )
    cur = db.cursor()
    
    while True:

        cRes = getNotOverDeadlineReservation(); #check not arrived reservation.
        #print("sex");
        cResCount = len(cRes)
        #print(cResNum)
        occupied1="false"
        occupied2="false"
        occupied3="false"
        occupied4="false"
        occupied5="false"
        cell1Carnum="1"
        cell2Carnum="1"
        cell3Carnum="1"
        cell4Carnum="1"
        cell5Carnum="1"
        
        """
        rSql=resvSelsql()
        if rSql =="exitgogo" and ckN1=="false" and ckN2=="false" and ckN3=="false" and ckN4=="false" and ckN5=="false":
            break
        resv20Msql()
        """
        for i in range(0,cResCount):
            parkingCellNum = cRes[i][0]
            carnum = cRes[i][1]
            if parkingCellNum==1:
                occupied1 = 'true'
                cell1Carnum=carnum
            elif parkingCellNum==2:
                occupied2 = 'true'
                cell2Carnum=carnum
            elif parkingCellNum==3:
                occupied3 = 'true'
                cell3Carnum=carnum
            elif parkingCellNum==4:
                occupied4 = 'true'
                cell4Carnum=carnum
            elif parkingCellNum==5:
                occupied5 = 'true'
                cell5Carnum=carnum
            else:
                print('carnum_error')
                
        print("it works in here");
        outtimeNullCarNum = getOuttimeNullRecordCarnum()
        outtimeNullCount = len(outtimeNullCarNum)
        
        outtimeNullCar = []
        
        for i in range(0,outtimeNullCount):
            outtimeNullCar.append(tRes[i][0])
            
        parkingCell=[]#parking lot list
        
        
        for j in range(0, len(outtimeNullCar)):
            if cell1Carnum in outtimeNullCar:
                parkingCell.append('1')
            elif cell2Carnum in outtimeNullCar:
                parkingCell.append('2')
                print(cPlaNo2)
            elif cell3Carnum in outtimeNullCar:
                parkingCell.append('3')
            elif cell4Carnum in outtimeNullCar:
                parkingCell.append('4')
            elif cell5Carnum in outtimeNullCar:
                parkingCell.append('5')
            else:
                print('list_error')
            
        parkingCellCount = len(parkingCell)

        for k in range(0,parkingCellCount):
            
            if '1' in parkingCell:
                cellnum=1
                isOccupied = getParkingCellOccupied(cellnum)
                aldist1 = int(check(TRIG1, ECHO1))
                print(logic(isOccupied, dist1, aldist1, cellnum, cell1Carnum))
                dist1=aldist1
                print(cellnum)
            elif '2' in parkingCell:
                cellnum=2
                isOccupied = getParkingCellOccupied(cellnum)
                aldist2 = int(check(TRIG2, ECHO2))
                print(logic(isOccupied, dist2, aldist2, cellnum, cell2Carnum))
                dist2=aldist2
                print(cellnum)
            elif '3' in parkingCell:
                cellnum=3
                isOccupied = getParkingCellOccupied(cellnum)
                aldist3 = int(check(TRIG3, ECHO3))
                print(logic(isOccupied, dist3, aldist3, cellnum, cell3Carnum))
                dist3=aldist3
                print(cellnum)
            elif '4' in parkingCell:
                cellnum=4
                isOccupied = getParkingCellOccupied(cellnum)
                aldist4 = int(check(TRIG4, ECHO4))
                print(logic(isOccupied, dist4, aldist4, cellnum, cell4Carnum))
                dist4=aldist4
                print(cellnum)
            elif '5' in parkingCell:
                cellnum=5
                isOccupied = getParkingCellOccupied(cellnum)
                aldist5 = int(check(TRIG5, ECHO5))
                print(logic(isOccupied, dist5, aldist5, cellnum, cell5Carnum))
                dist5=aldist5
                print(cellnum)
            else:
                print('logical_error')
                
        del parkingCell[:]
        del outtimeNullCar[:]
            
        time.sleep(1)
        time.sleep(15)

        
except KeyboardInterrupt:
    print("거리 측정 완료 ")
    db.close()
    GPIO.cleanup()      
        
        
        




