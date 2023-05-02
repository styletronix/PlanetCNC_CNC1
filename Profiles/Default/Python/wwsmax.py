import json
import sys
import time
import datetime
import planetcnc 
import http.client
import urllib.parse
import requests
import math


print("|!WWS Max module BEGIN", str(datetime.datetime.now()))
planetcnc.setParam("_sx_module_stop", 0)


API_DOMAIN = "xxx" 
API_DISABLED = 1
ISSIM = planetcnc.getParam("_hw_sim")
if ISSIM > 0:
    print("|!WWS Max: Simulationsmodus")
    API_KEY = "xxxxxx"
else:
    API_KEY = "xxxxx"


LAST_STATUS = ""
LAST_PROGRESS = 0
LAST_PROGRESS_STRING = ""

def send_Status(STATUS):
    if API_DISABLED > 0:
        return
    
    try:
        conn = http.client.HTTPSConnection(API_DOMAIN)
        conn.request('GET', f"/WWSMaxMobile/HMISetMachineStatus(Key='{API_KEY}',Status='{STATUS}',OfflineTimer=5)")
        resp = conn.getresponse()
        content = resp.read()
        conn.close()
        if resp.status != 200:
            print(f"|!|bWWS Max Fehler bei HMISetMachineStatus ({STATUS}) HTTPCode {resp.status}")
        else:
            if ISDEBUG > 0:
                print(f"|!WWS Max: Status geändert: {STATUS} - HTTPCode {resp.status}")

    except BaseException as err:
        #print(f"|!|bUnexpected {err=}, {type(err)=}")   
        print(f"|!|bWWS Max Fehler bei HMISetMachineStatus: Unexpected {err=} {type(err)=}")


def send_Value(Parameter, Value):
    try:
        conn = http.client.HTTPSConnection(API_DOMAIN)
        parsed_parameter = urllib.parse.quote(Parameter)
        parsed_value = urllib.parse.quote(Value)
        conn.request('GET', f"/WWSMaxMobile/HMISetMachineValue(Key='{API_KEY}',Caption='{parsed_parameter}',Value='{parsed_value}')")
        resp = conn.getresponse()
        content = resp.read()
        conn.close()
        if resp.status != 200:
            print(f"|!|bWWS Max Fehler bei HMISetMachineValue HTTPCode {resp.status}")
        else:
            if ISDEBUG > 0:
                S = f"|!WWS Max: Wert geändert: {Parameter} = {Value} - HTTPCode {resp.status}"
                S = S.replace("[", "_").replace("]", "_")
                print(S)

    except BaseException as err:
        #print(f"|!|bUnexpected {err=}, {type(err)=}")
        print(f"|!|bWWS Max Fehler bei HMISetMachineValue: Unexpected {err=} {type(err)=}")

def send_Values(data):
    try:
        url = f"https://{API_DOMAIN}/wwsmaxmobile/HMISetMachineValues"
        jsondat = {"Key": API_KEY, "Values": data}

        x = requests.post(url, json = jsondat, timeout=5)

        if ISDEBUG > 0:
            #print(json.dumps(data))
            print(x.text)

    except BaseException as err:
        print(f"|!|bWWS Max Fehler bei send_Values: Unexpected {err=} {type(err)=}")

def secondsToHumanReadableString(t):
        #return f"{int(t)} Sek."
        return f"{int(t/60)}:{int(t%60)}"
        #return f"{int(t/3600)} H {int((t/60)%60) if t/3600>0 else int(t/60)} M {int(t%60)} S"

cnt = 0


while True:
    if planetcnc.getParam("_sx_module_stop"):
        send_Status("noStatus")
        break

    ISDEBUG = int(planetcnc.getParam("_sx_debug"))

    status_ready = int(planetcnc.getParam("_sx_hmi_status_ready"))
    status_running = int(planetcnc.getParam("_sx_hmi_status_running"))
    status_warning = int(planetcnc.getParam("_sx_hmi_status_warning"))
    status_exception = int(planetcnc.getParam("_sx_hmi_status_exception"))
    progress = int(planetcnc.getParam("_sx_hmi_progress"))
    timetoend = int(planetcnc.getParam("_sx_hmi_timetoend"))

    progress_string = ""

    status = "noStatus"

    if status_ready > 0:
        status = "Ready"

    if status_running > 0:
        status = "Running"

    if status_warning > 0:
        status = "Warning"
    
    if status_exception > 0:
        status = "Exception"

    if status_running > 0:
        if timetoend > 0:
            progress_string = secondsToHumanReadableString(timetoend)
        elif progress > 0:
            progress_string = str(progress) + "%"

    if progress != LAST_PROGRESS or progress_string != LAST_PROGRESS_STRING or LAST_STATUS != status:
        LAST_PROGRESS = progress
        LAST_PROGRESS_STRING = progress_string
        LAST_STATUS = status
        send_Values([
                {"Caption": "[reset]", "Value": "true"},
                {"Caption": "[progress]", "Value": str(progress)}, 
                {"Caption": "Statusinfo", "Value": progress_string},
                {"Caption": "[status]", "Value": status},
                {"Caption": "[offlinetimer]", "Value": "1"}
                ])

    # if status != LAST_STATUS:
    #     LAST_STATUS = status
    #     send_Status(status)
    
    # if progress != LAST_PROGRESS:
    #     LAST_PROGRESS = progress
    #     send_Value("[progress]", str(progress))

    # if progress_string != LAST_PROGRESS_STRING:
    #     LAST_PROGRESS_STRING = progress_string
    #     send_Value("Fortschritt", progress_string)
        
    time.sleep(2)
    
    cnt = cnt + 1
    if cnt > 60:
        cnt = 0
        LAST_STATUS = ""
        LAST_PROGRESS_STRING = "-"
        LAST_PROGRESS = -1