:Class microbit

    :Field Public device←'/dev/ttyACM0'
    :Field Public tie←0

    ∇ make dev;cols;i;m;names;nums;s
        :Implements Constructor
        :Access Public

        dev,←(0=⍴dev)/device ⍝ default device  
        (names nums)←⎕NNAMES ⎕NNUMS
        :If (⍴dev)≤cols←2⊃s←⍴names
        :AndIf (1⊃s)≥i←(↓names)⍳⊂cols↑dev
            tie←i⊃⎕NNUMS
            device←dev
        :Else
            :Trap 0
                tie←dev ⎕NTIE 0
                device←dev
            :Else
                (⊃⎕DMX.EN)⎕SIGNAL 11
            :EndTrap
        :EndIf
    ∇

    ∇Unmake
        :Implements Destructor
        :Trap 0
            device ⎕NUNTIE tie
        :EndTrap
    ∇

    ∇r←PyREPL cmd
        :Access Public

        r←⎕UCS ⍬ (tie tie)⎕ARBIN (⎕UCS cmd),13
        :Repeat
            r,←⎕UCS ⍬ (tie tie)⎕ARBIN ⍬
        :Until '>>> '≡¯4↑r
        r←(r⍳⎕UCS 10)↓¯6↓r
    ∇

:EndClass
