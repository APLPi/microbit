:Namespace ReactionTimer
   ⍝ Reaction timer using the LEDs & buttons on a BBC micro:bit
   ⍝ Assumes the micro:bit is exposing the MicroPython REPL
   ⍝∇:require =microbit 

    ∇ {mb}←InitMB
    ⍝ Ensure existence of and return ref to instance of micro:bit class
        :If 0=⎕NC '#.mb'
            #.mb←⎕NEW #.microbit ''
        :EndIf   
        mb←#.mb
    ∇

    ∇ Play;mb;start;z
        mb←InitMB
        mb.clear_buttons

        :Repeat
            mb.show 'CLOCK1'
            ⎕←⎕DL 1+0.1×?40 ⍝ Delay 1-5 seconds
            :If mb.was_pressed 'a'
                ⎕←'naughty!'            
            :EndIf

            mb.show 'HAPPY'
            start←⎕AI[3]

            :Repeat ⋄ ⎕DL 0.1            
            :Until ∨/mb.is_pressed¨'ab'
            ⎕←(⎕AI[3]-start)'ms'          
        :Until mb.was_pressed 'b'

        ⎕←'Bye...'
        mb.show 'SAD'
    ∇

:EndNamespace
