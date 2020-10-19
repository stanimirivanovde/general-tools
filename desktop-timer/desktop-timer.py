# pip3 install plyer 
# python3 -m pip install git+http://github.com/kivy/pyobjus/

import time 
import sys
from plyer import notification 

if __name__=="__main__": 
    app_name=sys.argv[0]
    usage_string = f"Usage: {app_name} <timer name> <timeout in seconds>"
    try:
        if len(sys.argv) < 3:
            print("Missing arguments.")
            print(usage_string)
            sys.exit(1)
        name = sys.argv[1]
        timeout = (int)(sys.argv[2])
        if name is None or timeout is None:
            print(f"Usage: {app_name} <timer name> <timeout in seconds>")
            sys.exit(1)
        print(f"Timer {name} started with timeout: {timeout} seconds")
        notification.notify(
                title = f"Timer {name}",
                message=f"Counting {timeout} secs",
                app_name=app_name,

                # Lets display this for 10 seconds
                timeout=2,
                ticker="this is the ticker"
        )
        time.sleep(timeout)

        notification.notify(
                title = f"Timeout {name}",
                message=f"{timeout} seconds have passed",
                app_name=sys.argv[0],

                # Lets display this for 10 minutes
                timeout=2,
                ticker="this is the ticker"
        )
    except Exception as e:
        print(e)
        print(f"Usage: {app_name} <timer name> <timeout in seconds>")
        sys.exit(1)

