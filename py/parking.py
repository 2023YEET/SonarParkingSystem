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

class sensor():
    
    originDistance = 0
    lastDiastance = 0
    
    def __init__(self,trigger,echo):
        self.trigger = trigger
        self.echo = echo
        print("Initialize Distance")
    
    def getDistance(self): #sonar
        start=0
        stop=0
        check_time=0
        GPIO.setup(self.trigger, GPIO.OUT)
        GPIO.setup(self.echo, GPIO.IN)
        GPIO.output(self.trigger,False)
        time.sleep(0.5)
        GPIO.output(self.trigger,True)
        time.sleep(0.00001)			#
        GPIO.output(self.trigger, False)   

        while GPIO.input(self.echo)==0:
            start = time.time()     

        while GPIO.input(self.echo)==1:
            stop = time.time()      
                
        check_time = stop - start
        distance = check_time * 34300 / 2 #get distance
        print("Distance : %d cm"% distance)
        time.sleep(0.8)
        return int(distance)
    

def getParkingCellOccupied(cellnum):	#searchPavailableOccupied
    sql = 'select occupied from pavailable  where cellnum = (%s)'
    cur.execute(sql, (str(cellnum)))
    isOccupied = cur.fetchone()
    return(isOccupied[0])
    
    
def updateOccupied(cellnum,occupied): #updatePavailableOccupied
    sql = 'update pavailable set occupied = (%s) where cellnum= (%s)'
    cur.execute(sql, (str(occupied), str(cellnum)))
    db.commit()
    
    
def writeOutTime(carnum): #updateOuttime
    sql = "update time set outtime = now() where carnum= '(%s)' and inoutnum = (select max(inoutnum) from time where carnum = '(%s)');"
    cur.execute(sql, (str(carnum), str(carnum)))
    db.commit()
    

def getNotOverDeadlineReservation(): #search reservation time <= 20min AND occupied=1 / not over 20min occupied
    sql = 'select r.cellnum, r.carnum from reservation r, pavailable p where r.cellnum = p.cellnum AND (regdate> (DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 20 minute)));'
    cur.execute(sql)
    chksqlres = cur.fetchall()
    return(chksqlres)

def deleteReservation(carnum): #deleteReservation
    sql = "delete from reservation where carnum = (%s);"
    cur.execute(sql, (str(carnum)))
    db.commit()
    
def getAllReservation():	#searchReservation
    sql = 'select * from reservation;'
    cur.execute(sql)
    sqlres = cur.fetchone()
    if sqlres == None:
        return("exitgogo")
    
def getCellReservation(cellnum):
    sql = "select * from reservation where cellnum = (%s);"
    cur.execute(sql, (str(cellnum)))
    sqlres = cur.fetchone()
    return (sqlres)

def getCarRecord(carnum):
    sql = "select * from time where carnum = (%s) and intime is not null and outtime is null;"
    cur.execute(sql, (str(carnum)))
    sqlres = cur.fetchone()
    return (sqlres) 
    
def getOverDeadlineReservation(cellnum):	#search ReservationTime > 20min
    sql = 'select carnum from reservation where cellnum = (%s) and regdate < (DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 20 minute))'
    cur.execute(sql, (str(cellnum)))
    sqlres = cur.fetchone()
    return (sqlres)
    
    if sqlres == None: #if null, return
        return
    else: #if not null, get result tuple length, and delete reservation
        m20count = len(sqlres)
        for a in range(0,m20count):
            carcar=sqlres[a][0]
            deleteReservation(carcar)
            

def getOuttimeNullRecordCarnum(): #check time record that the outtime is null;
    sql = 'select carnum from time where outtime is null;'
    cur.execute(sql)
    tmchksqlres = cur.fetchall()
    return(tmchksqlres)

def setOuttime(inoutnum):
    sql = 'update time set outtime = now() where inoutnum= (%s)'
    cur.execute(sql, str(inoutnum))
    db.commit()
    
def setCellCarnum(cellnum, carnum):
    sql = 'update pavailable set carnum = (%s) where cellnum= (%s)'
    cur.execute(sql, (str(carnum), str(cellnum)))
    db.commit()
    
def addCarRecord(carnum):
    sql = 'insert into time (intime, carnum) values (now(),(%s))'
    cur.execute(sql, str(carnum))
    db.commit()

p = []

p.append(sensor(23,24))
p.append(sensor(16,20))
p.append(sensor(13,19))
p.append(sensor(5,6))
p.append(sensor(17,27))


while True:
    
    db= pymysql.connect(
    host='localhost',
    user='yeetpi',
    passwd='a123123123',
    db='parking',
    charset='utf8'
    )
    cur = db.cursor()

    for i in p:
        time.sleep(3)
        index = p.index(i)+1
        print('No.'+str(index)+' sensor')
        i.originDistance = i.getDistance()
        if (i.originDistance < 22 and i.originDistance > 18):
            isOccupied = getParkingCellOccupied(index)
            print('Its Empty')
            if(isOccupied == 1):
                print('Its Occupied')
                cellReserveData = getCellReservation(index)
                if(cellReserveData!=None):
                    print('It has a reservation data')
                    hasRecordData = getCarRecord(cellReserveData[2])
                    if(hasRecordData!=None):
                        print('It has a I/O record')
                        target = hasRecordData[0]
                        setOuttime(target)
                        deleteReservation(cellReserveData[2])
                        setCellCarnum(index, "")
                        updateOccupied(index, 0)
                    else:
                        
                        later = getOverDeadlineReservation(index)
                        if(later==cellReserveData[2]):
                            print('you are later!')
                            updateOccupied(index, 0)
                else:
                    print('It doesnt have reservation, turn into unoccupied')
                    updateOccupied(index, 0)
                    
        elif (i.originDistance < 18):
            isOccupied = getParkingCellOccupied(index)
            if(isOccupied == 1):
                print('Its Occupied')
                cellReservationData = getCellReservation(index)
                if(cellReservationData!=None and getCarRecord(cellReservationData[2])==None):
                    print('It has a reservation data and I/O Record')
                    addCarRecord(cellReservationData[2])
                    setCellCarnum(index, cellReservationData[2])

                
                
                                                       
        


