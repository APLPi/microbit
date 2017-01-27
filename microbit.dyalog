:Class microbit

    :Field Public device←'/dev/ttyACM0'
    :Field Public tie←0       
    
    (CR LF)←⎕UCS 13 10

    ∇ Make dev
      :Implements Constructor
      :Access Public
      
      device←dev,(0=⍴dev)/device ⍝ Default if not provided
      tie←getFileHandle device   ⍝ What it says 
      r←Clear                    ⍝ Clear the serial buffer
    ∇

    ∇ Unmake
      :Implements Destructor
      :Trap 0
          device ⎕NUNTIE tie     ⍝ Close the device
          tie←0
      :EndTrap
    ∇

    ∇ r←PyREPL cmd
      ⍝ Send command to Python REPL and return response
      :Access Public
     
      r←Clear            ⍝ Empty buffer
      r←Send cmd,CR      ⍝ send command + CR
      r,←ReadTo '>>>'    ⍝ Read until >>>
    ∇

    ∇ r←Send cmd
      :Access Public
     
      r←⎕UCS ⍬(tie tie)⎕ARBIN ⎕UCS cmd
    ∇

    ∇ r←ReadUntil prompt;n    
      ⍝ Read up to next prompt
      :Access Public
     
      r←''
      :Repeat
          r,←⎕UCS ⍬(tie tie)⎕ARBIN ⍬
      :Until prompt≡(-n←≢prompt)↑r
      r←(r⍳LF)↓(n-2)↓r ⍝ Drop Echo, Drop prompt and preceding CRLF
    ∇

    ∇ r←Clear;t
      ⍝ Read everything in the serial input queue
      :Access Public
     
      r←''
      :Repeat
          r,←t←⎕UCS ⍬(tie tie)⎕ARBIN ⍬ ⍝ Read next line (⍬ means up to LF)
      :Until 0=⍴t                      ⍝ Repeat until no response
    ∇

    ∇ r←Reset
      ⍝ Send CTRL+D for soft reboot
      :Access Public
      r←Send ⎕UCS 4 ⍝ CTRL+D = Soft Reboot
      r←Read '>>> ' ⍝ Read until input promopt
    ∇


    ∇ tie←getFileHandle name;names;nums;cols;s;i
    ⍝ Return handle of file, opening it if necessary
     
      (names nums)←⎕NNAMES ⎕NNUMS ⍝ names & handles of open files
      :If (⍴name)≤cols←2⊃s←⍴names ⍝ name not too long to be in ⎕NNAMES?
      :AndIf (1⊃s)≥i←(↓names)⍳⊂cols↑name ⍝ name actually in the list
          tie←i⊃nums              ⍝ Already open: select handle
      :Else                       ⍝ Not open
          :Trap 0 ⋄ tie←name ⎕NTIE 0    ⍝ open it
          :Else ⋄ (⊃⎕DMX.DM)⎕SIGNAL 11  ⍝ re-throw error
          :EndTrap
      :EndIf
    ∇  

:EndClass
