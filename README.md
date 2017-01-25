# APLPi/microbit
This repository contains tools for using the micro:bit with Dyalog APL
on the Raspberry Pi, with focus on MicroPython. Morten Kromberg is blogging about his experiences with this technology at: [http://www.dyalog.com/blog/2017/01/raspberry-apl-pi-and-python-on-the-microbit-2/](http://www.dyalog.com/blog/2017/01/raspberry-apl-pi-and-python-on-the-microbit-2/)

##The microbit class
The microbit class provides an interface from Dyalog APL to the MicroPython
REPL, using serial communications. For example, if you cloned the
repository to `/home/pi/microbit` and have started Dyalog APL:

        ]load /home/pi/microbit/microbit    
        mb←⎕NEW microbit ''
        mb.PyREPL '2+2'
    4

You can display morse code using the LEDs on the micro:bit using:

        ]load /home/pi/microbit/Morse
        Morse.Init '/home/pi/microbit/MorseCode.txt'
        Morse.Display 'SOS'

Video of the expected results at: [https://www.youtube.com/watch?v=yfGsSLEifAs](https://www.youtube.com/watch?v=yfGsSLEifAs)

More examples to come!
