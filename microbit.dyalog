:Class microbit

    :Field Public device←'/dev/ttyACM0'
    :Field Public tie←0

    ∇ make dev;cols;i;m;names;nums;r;s
        :Implements Constructor
        :Access Public

        dev,←(0=⍴dev)/device        ⍝ default device  
        (names nums)←⎕NNAMES ⎕NNUMS ⍝ open files
        :If (⍴dev)≤cols←2⊃s←⍴names  ⍝ device already open?
        :AndIf (1⊃s)≥i←(↓names)⍳⊂cols↑dev
            tie←i⊃⎕NNUMS            ⍝ set handle
            device←dev
        :Else                       ⍝ not open
            :Trap 0
                tie←dev ⎕NTIE 0     ⍝ open it
                device←dev
            :Else
                (⊃⎕DMX.DM)⎕SIGNAL 11
            :EndTrap
        :EndIf
        r←Clear
    ∇

    ∇Unmake
        :Implements Destructor
        :Trap 0
            device ⎕NUNTIE tie ⍝ close the device
            tie←0
        :EndTrap
    ∇

    ∇r←PyREPL cmd;m
        :Access Public

        r←Clear            ⍝ Empty buffer
        r←Send cmd,⎕UCS 13 ⍝ send command + CR
        r,←Read            ⍝ Read until >>>
    ∇

    ∇r←Send cmd
        :Access Public

        r←⎕UCS ⍬ (tie tie)⎕ARBIN ⎕UCS cmd 
    ∇

    ∇r←Read
        ⍝ Read up to next >>> prompt
        :Access Public

        r←''
        :Repeat
            r,←⎕UCS ⍬ (tie tie)⎕ARBIN ⍬
        :Until '>>> '≡¯4↑r
        r←(r⍳⎕UCS 10)↓¯6↓r
    ∇

    ∇r←Clear;t
        ⍝ Read everything in the serial input queue
        :Access Public

        r←''
        :Repeat
            r,←t←⎕UCS ⍬ (tie tie)⎕ARBIN ⍬
        :Until 0=⍴t
    ∇

    ∇r←Reset
        ⍝ Send CTRL+D for soft reboot
        :Access Public
        r←Send ⎕UCS 4 ⍝ CTRL+D = Soft Reboot
        r,←Read
    ∇    

:EndClass
