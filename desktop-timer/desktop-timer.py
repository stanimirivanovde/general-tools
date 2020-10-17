# pip3 install plyer 
# python3 -m pip install git+http://github.com/kivy/pyobjus/

import time 
import sys
from plyer import notification 

if __name__=="__main__": 
    timeout = (int)(sys.argv[1])
    print(f"Timer started with timeout of {timeout} seconds")
    notification.notify( 
            title = "Timer Started",
            message=f"Starting a timer of {timeout} seconds and counting down",
            app_name=sys.argv[0],

            # Lets display this for 10 seconds
            timeout=2,
            ticker="this is the ticker"
    ) 
    time.sleep(timeout)

    notification.notify( 
            title = "Timeout",
            message=f"{timeout} seconds has passed",
            app_name=sys.argv[0],

            # Lets display this for 10 minutes
            timeout=2,
            ticker="this is the ticker"
    ) 
    # waiting time 
    #time.sleep(600)

