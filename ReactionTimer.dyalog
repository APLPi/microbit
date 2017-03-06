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

    ∇ r←Play;mb;start;time;z
        mb←InitMB
        r←⍬

        :Repeat
            mb.clear_buttons
            mb.show 'CLOCK1'
            z←⎕DL 1+0.1×?40 ⍝ Delay 1-5 seconds
            :If mb.was_pressed 'a'
                ⎕←'naughty!'            
            :EndIf

            mb.show 'HAPPY'
            start←⎕AI[3]

            :Repeat ⋄ ⎕DL 0.01            
            :Until ∨/mb.is_pressed¨'ab'
            ⎕←(time←⎕AI[3]-start)'ms'
            r,←time
        :Until mb.was_pressed 'b'
        r←¯1↓r ⍝ drop time to press 'b'
        ⎕←'Bye...'
        mb.show 'SAD'
    ∇

    AsciiChart←{
        scale←25                     ⍝ size of each row
        tiks←4                       ⍝ tik spacing
        (max min)←(⌈/ , ⌊/) ⍵        ⍝ maximum and minimum
        base←⌊min÷scale              ⍝ round down to nearest scale unit
        rb←base+0,⍳⌈(max-min)÷scale  ⍝ row base values
        r←' *'[1+rb∘.=⌊⍵÷scale]      ⍝ our chart
        r←((≢rb)⍴'+',(tiks-1)⍴'|'),' ',r ⍝ add tiks
        r←(⍕⍪rb×scale),r                 ⍝ add base values
        ⊖r                           ⍝ low values last (humans!)
    }

:EndNamespace
