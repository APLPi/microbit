:Class microbit

    :Field Public device←'/dev/ttyACM0'
    :Field Public tie←0       

    (CR LF)←⎕UCS 13 10

    ∇ Make dev;r
        :Implements Constructor
        :Access Public

        device←dev,(0=⍴dev)/device ⍝ Default if not provided
        tie←device ⎕NTIE 0         ⍝ Get a file handle 
        :If 0≠≢r←SetTTY device     ⍝ Initalise serial tty comms 
            r ⎕SIGNAL 11           
        :EndIf
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
        ⎕DL 0.5     ⍝ Give it half a sec
        :Trap 999
            r←5 ReadUntil '>>> ' ⍝ Allow 5 seconds to get input prompt
        :Else
            'TIMEOUT: micro:bit Python REPL not issuing >>>' ⎕SIGNAL 11
        :EndTrap
    ∇

    ∇r←SetTTY device
    ⍝ Initialise TTY device 
        r←''
        :If ~⎕NEXISTS device
            r←'Unable to connect to micro:bit via ',device,': device does not exist or is inaccessable'
            →0
        :EndIf
        :Trap 0
            {}⎕SH'stty 115200 -parenb -parodd -cmspar cs8 hupcl -cstopb cread clocal -crtscts -ignbrk -brkint ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8 -opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0 -isig -icanon -iexten -echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke <',device
            {}⎕SH'stty min 0 <',device
        :Else
            r←'Problems initialising connection to micro:bit via ',device
        :EndTrap
    ∇

    ∇{z}←clear_buttons
        :Access Public
        z←was_pressed¨'ab'
    ∇

    ∇ show image;z
        :Access Public
        z←PyREPL 'display.show(Image.',image,')'
    ∇

    ∇ r←is_pressed button
        :Access Public

        r←is_true 'button_',button,'.is_pressed()'    
    ∇

    ∇ r←was_pressed button
        :Access Public
        r←is_true 'button_',button,'.was_pressed()'    
    ∇    

    ∇r←is_true expr;t;z
        :Access Public
        r←1⊃t←'True' 'False'∊⊂z←PyREPL expr
        :If ~∨/t ⋄ ⎕←'True/False expected, got: ',z ⋄ ∘∘∘ ⋄ :EndIf
    ∇

:EndClass
