# APLPi/microbit
This repository contains tools for using the micro:bit with Dyalog APL
on the Raspberry Pi, with focus on MicroPython. Morten Kromberg is blogging about his experiences with this technology on the [Dyalog Blog.](http://www.dyalog.com/blog/2017/01/raspberry-apl-pi-and-python-on-the-microbit-2/)

##The microbit class
The microbit class provides an interface from Dyalog APL to the MicroPython
REPL, using serial communications. The interface relies on the MicroPython REPL being up and running on the micro:bit. The easiest way to do this is to use the "mu" editor on the Pi to flash a trivial programme to the micro:bit. The file `repl_prompt.py` contains a suitable bit of code which will display a ">>" prompt on the micro:bit display when it is reset (because that looks a bit like the Python >>> prompt).

If you cloned the repository to `/home/pi/microbit` and have started Dyalog APL, you should be able to execute simple Python commands.

        ]load /home/pi/microbit/microbit    
        mb←⎕NEW microbit ''
        mb.PyREPL '2+2'
    4

You can display morse code using the LEDs on the micro:bit using the Morse example:

        ]load /home/pi/microbit/Morse
        Morse.Init '/home/pi/microbit/MorseCode.txt'
        Morse.Display 'SOS'

A video of this in action is availble [on YouTube](https://www.youtube.com/watch?v=yfGsSLEifAs).

More examples to come!
