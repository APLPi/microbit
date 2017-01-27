:Class microbit

    :Field Public device←'/dev/ttyACM0'
    :Field Public tie←0       

    (CR LF)←⎕UCS 13 10

    ∇ Make dev
        :Implements Constructor
        :Access Public

        device←dev,(0=⍴dev)/device ⍝ Default if not provided
        tie←device ⎕NTIE 0         ⍝ Get a file handle 
        :if 0≠≢r←SetTTY device 
            'Unable to create connection: ',r
            →0
        :endif
        r←Reset                    ⍝ Clear the serial buffer
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
        Send cmd,CR        ⍝ send command + CR
        r←ReadUntil '>>> ' ⍝ Read until >>>
    ∇

    ∇ Send cmd
        :Access Public

        tie ⎕ARBOUT ⎕UCS cmd
    ∇

    ∇ r←{timeout} ReadUntil prompt;n;start;stop;⎕RTL
      ⍝ Read up to next prompt
        :Access Public

        r←''
        start←⎕AI[3] ⍝ Start time
        :If 0=⎕NC 'timeout' ⋄ timeout←0 ⋄ :EndIf
        ⎕RTL←×timeout ⍝ Time out every second if we're checking
        :Repeat
            r,←⎕UCS ⍬(tie tie)⎕ARBIN ⍬            
            stop←(timeout≠0)∧timeout<0.001×⎕AI[3]-start
        :Until stop∨prompt≡(-n←≢prompt)↑r
        'TIMEOUT' ⎕SIGNAL stop/999
        r←(r⍳LF)↓(-n+2)↓r ⍝ Drop Echo, Drop prompt and preceding CRLF
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

        Send ⎕UCS 4 ⍝ CTRL+D = Soft Reboot
        ⎕DL 0.5       ⍝ Give it half a sec
        :Trap 999
            r←5 ReadUntil '>>> ' ⍝ Allow 5 seconds to get input prompt
        :Else
            'TIMEOUT: micro:bit Python REPL not issuing >>>' ⎕SIGNAL 11
        :EndTrap
    ∇

    ∇r←SetTTY device
        r←''
        :If ~⎕nexists device
            r←'Unable to connect to micro:bit via ',device,': device does not exist or is inaccessable'
            →0
        :EndIf
        :trap 0
            0 0⍴⎕sh'stty 115200 -parenb -parodd -cmspar cs8 hupcl -cstopb cread clocal -crtscts -ignbrk -brkint ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke <',device
            0 0⍴⎕sh'stty min 0 <',device
        :else
            r←'Problems setting speed etc of connection to micro:bit via ',device
        :endtrap
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
