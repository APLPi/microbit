:Namespace Morse
   ⍝ Display Morse code using the LEDs on a BBC micro:bit
   ⍝ Assumes the micro:bit is exposing the MicroPython REPL
   ⍝∇:require =microbit 

    rate←200÷1000 ⍝ length of "dit" = 200ms ("dah" will be 3x this)
    on←'09990:99999:99999:99999:09990'
    off←29⍴'00000:'

    ∇ Init filename;t
      ⍝ Read MorseCode.txt file (actual name passed as argument)
        t←↑⊃⎕NGET filename 1  ⍝ Read file into matrix
        Chars←t[;1],' '       ⍝ Chars are in column 1 (and add space)
        Codes←(↓0 1↓t)~¨' '   ⍝ Codes are everything from column 1
        Codes,←⊂'  '          ⍝ Space is as a double long pause    
        InitMB
    ∇

    ∇ InitMB
      ⍝ Ensure existence of instance of micro:bit class
        :If 0=⎕NC '#.mb'
            #.mb←⎕NEW #.microbit ''
        :EndIf    
    ∇

    ∇ Lights onoff;image;z
    ⍝ Use micro:bit Python API to manipulate LEDs
    ⍝ http://microbit-micropython.readthedocs.io/en/latest/microbit_micropython_api.html
        image←(1+onoff)⊃off on
        z←#.mb.PyREPL 'display.show(Image(''',image,'''))'
    ∇

    ∇ Display message;didah;duration;index;m;output
     ⍝ Output Morse code using LED connected to GPIO pin

        index←Chars⍳message    ⍝ Look message up in Chars

        :If ∨/m←index>⍴Chars   ⍝ Any chars not found?
            ('UNSUPPORTED CHARS: ',m/message)⎕SIGNAL 11
        :Else ⋄ output←∊Codes[index],¨','      ⍝ one long string, w/"," between symbols
        :EndIf

        InitMB

        :For didah :In output
            duration←(1 3 3 7)['.-, '⍳didah]            
            Lights didah∊'.-'                  ⍝ Turn light on if dit or dah
            ⎕DL duration×rate                  ⍝ Wait
            Lights 0                           ⍝ Turn off
            ⎕DL rate                           ⍝ Inter-didah pause
        :EndFor
    ∇

:EndNamespace
