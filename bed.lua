-- ██████  ███████ ██████   ██████  ██████ 
-- ██   ██ ██      ██   ██ ██      ██      
-- ██████  █████   ██   ██ ██      ██      
-- ██   ██ ██      ██   ██ ██      ██      
-- ██████  ███████ ██████   ██████  ██████ 

-- #####  #   #     ####  # #    #   ##   #####  #    # #####  ###### 
-- #    #  # #     #      # ##  ##  #  #  #    # #    # #    # #      
-- #####    #       ####  # # ## # #    # #    # #    # #    # #####  
-- #    #   #           # # #    # ###### #    # #    # #    # #      
-- #    #   #      #    # # #    # #    # #    # #    # #    # #      
-- #####    #       ####  # #    # #    # #####   ####  #####  ######

local args = {...}

-- check for any flags
if args[1] == "-v" or args[1] == "--version" then
    print("Binary EDitor version unbitwisea by SimaDude")
    return nil
elseif args[1] == "-h" or args[1] == "--help" then
    print([[bed [options] filepath
    
    options:
            -v, --version - get the version of the program
            -h, --help - get this message
            -ob, --output-binary - prints all binary data without opening the main program
            -obd, --output-binary-detail - prints integer, symbol equivalents and line number.]])
    return nil
end

local filepath
if string.sub(args[1],1,1) ~= "-" then
    filepath = shell.dir().."/"..args[1]
else
    filepath = shell.dir().."/"..args[2]
end

if not fs.exists(filepath) then
    error("file \""..filepath.."\" does not exist")
end

local fh = fs.open(filepath, "rb")
if not fh then
    error("couldn't open file \""..filepath.."\"")
end

local content = fh.read()
local dectable = {}

while content do
    table.insert(dectable, content)
    content = fh.read()
end

fh.close()
fh = nil

local bintable = {}

---converts from decimal to Binary and returns it in String
---@param x number
---@return string
local function toBin(x)
    x = math.floor(x)
    ---@type string
    local s = ""

    while x ~= 0 do
        s = s..tostring(x%2)
        x = math.floor(x / 2)
    end

    s = string.reverse(s)
    s = string.rep("0", 8-#s)..s

    return s
end

-- fill binary table
for _, v in ipairs(dectable) do
    table.insert(bintable, toBin(v))
end

if args[1] == "-ob" or args[1] == "--output-binary" then
    for _, v in ipairs(bintable) do
        print(v)
    end
    return nil
elseif args[1] == "-obd" or args[1] == "--output-binary-detailed" then
    for k, v in ipairs(bintable) do
        print(k, v, tonumber(v, 2), tonumber(string.sub(v, 1, 1))*-128 + tonumber(string.sub(v, 2, 8), 2), string.char(tonumber(v, 2)))
    end
    return nil
end

term.clear()



--  █████    ████    ███    ██   ███████  ██    ██████  
-- ██      ██    ██  ████   ██   ██       ██  ██       
-- ██      ██    ██  ██ ██  ██   █████    ██  ██   ███ 
-- ██      ██    ██  ██  ██ ██   ██       ██  ██    ██ 
--  █████    ████    ██   ████   ██       ██   ██████  
-- load config
local cfg = {startnumline= 0,
up          = keys.up,
up1         = keys.k,
down        = keys.down,
down1       = keys.j,
left        = keys.left,
left1       = keys.h,
right       = keys.right,
right1      = keys.l,
quit        = keys.q,
write       = keys.w,
flip        = keys.f,
inc         = keys.i,
dec         = keys.u,
delete      = keys.delete,
backdelete  = keys.backspace,
createabove = "c",
createunder = "C",
command     = ":",
cadd        = ":a",
csub        = ":s",
cdiv        = ":d",
cmul        = ":m",
cflip       = ":f",
cbitand     = ":ba",
cbitor      = ":bo",
cbitxor     = ":bx",
cbitrshift  = ":brs",
cbitlshift  = ":bls",
cquit       = ":q",
cwrite      = ":w",
cwritequit  = ":wq"}

local w, h = term.getSize()

local curbit = 0
local curEline = 0
local curDline = 0

---comment
---@param x string
---@return number|nil
local function toInt8(x)
    local mb = tonumber(string.sub(x, 1, 1), 2)
    local rb = tonumber(string.sub(x, 2, 8), 2)
    if mb == nil or rb == nil then
        return nil
    end

    return mb*-128 + rb
end

local nums = {"1","2","3","4","5","6","7","8","9","0"}
local function elementExists (t, e)
    for _, v in ipairs(t) do
        if v == e then
            return true
        end
    end
    return false
end
local rval = 1
local commandmode = false
local command = ""
local commandresult = ""

--[[

  #####     #          ### 
 #     #    #           #  
 #          #           #  
 #          #           #  
 #          #           #  
 #     #    #           #  
  #####     #######    ### 

  ]]

-- draw the program
local function redraw()
    term.clear()
    -- header of program
    term.setCursorPos(1, 1)
    term.write("Binary EDitor by SimaDude")

    -- header of bintable's contents
    term.setCursorPos(1, 2)
    term.write("byte|  binary| u8|  i8|str|")

    term.setCursorPos(30, 2)
    term.write(string.format("bytes: %i", #bintable))

    -- essential keybindings
    if commandmode == false then
        term.setCursorPos(29, 4)
        term.write(keys.getName(cfg.quit).." - quit")

        term.setCursorPos(29, 5)
        term.write(keys.getName(cfg.write).." - write")

        term.setCursorPos(29, 6)
        term.write(keys.getName(cfg.inc).." - increment")

        term.setCursorPos(29, 7)
        term.write(keys.getName(cfg.dec).." - decrement")

        term.setCursorPos(29, 8)
        term.write(keys.getName(cfg.flip).." - flip selected bit")

        
        term.setCursorPos(29, 9)
        term.write(cfg.createunder.." - create byte under")

        term.setCursorPos(29, 10)
        term.write(cfg.createabove.." - create byte upper")
        
        term.setCursorPos(29, 11)
        term.write(keys.getName(cfg.delete).." - delete this")
        term.setCursorPos(29, 12)
        term.write("byte")
        
        term.setCursorPos(29, 13)
        term.write(keys.getName(cfg.backdelete).." - delete")
        term.setCursorPos(29, 14)
        term.write("previous byte")

        term.setCursorPos(29, 15)
        term.write(cfg.command.." - command")

    -- essential commands
    else
        term.setCursorPos(29, 4)
        term.write(string.format("%s x - add x", cfg.cadd))

        term.setCursorPos(29, 5)
        term.write(string.format("%s x - subtract by x", cfg.csub))

        term.setCursorPos(29, 6)
        term.write(string.format("%s x - multiply by x", cfg.cmul))

        term.setCursorPos(29, 7)
        term.write(string.format("%s x - divide by x", cfg.cdiv))

        term.setCursorPos(29, 8)
        term.write(string.format("%s - quit", cfg.cquit))

        term.setCursorPos(29, 9)
        term.write(string.format("%s - write to file", cfg.cwrite))

        term.setCursorPos(29, 10)
        term.write(string.format("%s - write to file and quit", cfg.cwritequit))

        term.setCursorPos(31, 12)
        term.write(command)
    end

    term.setCursorPos(28, 18)
    term.write(commandresult)


    -- display bintable contents and representation of bytes
    for i = curDline+1, curDline+h do
        term.setCursorPos(1, i-curDline+2)
        if i <= #bintable then
            if i - 1 == curEline then
                term.setBackgroundColor(colors.gray)
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(string.rep(" ",
                        math.floor(3-#tostring(i-1+cfg.startnumline)))..string.sub(tostring(i-1+cfg.startnumline), #tostring(i-1+cfg.startnumline)-2, #tostring(i-1+cfg.startnumline))..":|"
                        ..bintable[i]

                        .."|"..string.rep(" ", math.floor(3-#tostring(tonumber(bintable[i], 2))))
                        ..tostring(tonumber(bintable[i], 2))

                        .."|"..string.rep(" ", math.floor(4-#tostring(toInt8(bintable[i]))))
                        ..tostring(toInt8(bintable[i]))

                        .."| "
                        ..string.char(tonumber(bintable[i], 2))
                        .." |")
        end
    end

    -- display currently selected bit
    term.setCursorPos(6+7-curbit, curEline-curDline+3)
    term.setBackgroundColor(colors.green)
    term.write(string.sub(bintable[curEline+1], 8-curbit, 8-curbit))
    term.setBackgroundColor(colors.black)

    term.setCursorPos(1, h)
end

local loop = true
local function quit(r)
    loop = false
    term.clear()
    term.setCursorPos(1, 1)
    sleep(0.1) -- without sleep the 'q' would appear at the start of string in shell
               -- if exited by hitting 'q' key
    return r
end

local function write()
    local fh = fs.open(filepath, "wb")
    if not fh then return string.format("couldn't write to file at: %s", filepath) end
    -- convert all binary back to decimal before writing
    for _, b in ipairs(bintable) do
        fh.write(tonumber(b, 2))
    end
    fh.flush()
    fh.close()
    return string.format("successful write to file at: %s", filepath)
end






local function execCommand(cmd)
    cmd = cmd.." "
    local cmds = {}
    local curc = ""
    for i = 1, #cmd do
        local s = string.sub(cmd, i, i)
        if s == " " then
            table.insert(cmds, curc)
            curc = ""
        else
            curc = curc..s
        end
    end

    -- commands that don't require first argument to be a number
    if cmds[1] == cfg.cquit then
        return quit(0)
    elseif cmds[1] == cfg.cwrite then
        return write()
    elseif cmds[1] == cfg.cwritequit then
        local c = write()
        if string.sub(c, 1, 1) == "c" then
            return c
        end
        return quit(0)
    end

    if string.sub(cmds[2], 1, 2) == "0x" then
        local c = tonumber(string.sub(cmds[2], 3, #cmds[2]), 16)
        if not c then return string.format("can't convert to a number: %s", cmds[2]) end
        cmds[2] = c
    elseif string.sub(cmds[2], 1, 2) == "0b" then
        local c = tonumber(string.sub(cmds[2], 3, #cmds[2]), 2)
        if not c then return string.format("can't convert to a number: %s", cmds[2]) end
        cmds[2] = c
    else
        if tostring(tonumber(cmds[2])) ~= cmds[2] then
            return string.format("can't convert to a number: %s", cmds[2])
        else
            cmds[2] = math.floor(tonumber(cmds[2]))
        end
    end

    if cmds[1] == cfg.cadd then
        local s = bintable[curEline+1]
        s = toBin((tonumber(s, 2) + cmds[2])%255)

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.csub then
        local s = bintable[curEline+1]
        s = toBin((tonumber(s, 2) - cmds[2])%255)

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cmul then
        local s = bintable[curEline+1]
        s = toBin((tonumber(s, 2) * cmds[2])%255)

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cdiv then
        local s = bintable[curEline+1]
        s = toBin((tonumber(s, 2) / cmds[2])%255)

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cbitand then
        local s = bintable[curEline+1]
        s = toBin(bit32.band(tonumber(s, 2), cmds[2]))

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cbitor then
        local s = bintable[curEline+1]
        s = toBin(bit32.bor(tonumber(s, 2), cmds[2]))

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cbitxor then
        local s = bintable[curEline+1]
        s = toBin(bit32.bxor(tonumber(s, 2), cmds[2]))

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cbitrshift then
        local s = bintable[curEline+1]
        s = toBin(bit32.rshift(tonumber(s, 2), cmds[2])%255)

        bintable[curEline+1] = s
    elseif cmds[1] == cfg.cbitlshift then
        local s = bintable[curEline+1]
        s = toBin(bit32.lshift(tonumber(s, 2), cmds[2])%255)

        bintable[curEline+1] = s
    else
        return string.format("unknown command %s", cmds[1])
    end
    return string.format("success - %s", cmd)
end







redraw()

--[[

#### ##    ## ########  ##     ## ######## 
 ##  ###   ## ##     ## ##     ##    ##    
 ##  ####  ## ##     ## ##     ##    ##    
 ##  ## ## ## ########  ##     ##    ##    
 ##  ##  #### ##        ##     ##    ##    
 ##  ##   ### ##        ##     ##    ##    
#### ##    ## ##         #######     ##    

]]

-- Input handler
while loop do
    local event = {os.pullEvent()}
    if not loop then break end
    if not commandmode then
        if event[1] == "key" then
            if event[2] == cfg.quit then
                quit()
                break
            -- go to Left
            elseif event[2] == cfg.left or event[2] == cfg.left1 then
                if rval > 0 then
                    curbit = math.min(curbit + rval, 7)
                    rval = 0
                else
                    curbit = math.min(curbit + 1, 7)
                end
                redraw()
            -- go to Right
            elseif event[2] == cfg.right or event[2] == cfg.right1 then
                if rval > 0 then
                    curbit = math.max(curbit - rval, 0)
                    rval = 0
                else
                    curbit = math.max(curbit - 1, 0)
                end
                redraw()
            -- go up
            elseif event[2] == cfg.up or event[2] == cfg.up1 then
                if rval > 0 then
                    curEline = (curEline - rval)%(#bintable)
                    rval = 0
                else
                    curEline = (curEline - 1)%(#bintable)
                end
                if curDline > curEline then
                    curDline = curEline
                end
                if curDline < curEline - h + 3 then
                    curDline = curEline - h + 3
                end
                rval = 0
                redraw()
            -- go to down
            elseif event[2] == cfg.down or event[2] == cfg.down1 then
                if rval > 0 then
                    curEline = (curEline + rval)%(#bintable)
                else
                    curEline = (curEline + 1)%(#bintable)
                end
                if curDline > curEline then
                    curDline = curEline
                end
                if curDline < curEline - h + 3 then
                    curDline = curEline - h + 3
                end
                rval = 0
                redraw()
            -- flip bit
            elseif event[2] == cfg.flip then
                local s = bintable[curEline+1]
                s = string.sub(s, 1, 7-curbit)..tostring(math.abs(tonumber(string.sub(s, 8-curbit, 8-curbit))-1))..string.sub(s, 9-curbit, 8)
                bintable[curEline+1] = s
                redraw()
            -- increment byte
            elseif event[2] == cfg.inc then
                local s = bintable[curEline+1]
                if rval > 0 then
                    s = toBin((tonumber(s, 2) + rval)%255)
                    rval = 0
                else
                    s = toBin((tonumber(s, 2) + 1)%255)
                end
                bintable[curEline+1] = s
                redraw()
            -- decrement byte
            elseif event[2] == cfg.dec then
                local s = bintable[curEline+1]
                if rval > 0 then
                    s = toBin((tonumber(s, 2) - rval)%255)
                    rval = 0
                else
                    s = toBin((tonumber(s, 2) - 1)%255)
                end
                bintable[curEline+1] = s
                redraw()
            elseif event[2] == cfg.write then
                commandresult = write()
                redraw()
            elseif event[2] == cfg.delete then
                if #bintable > 1 then
                    table.remove(bintable, curEline+1)
                    curEline = curEline % #bintable
                    redraw()
                end
            elseif event[2] == cfg.backdelete then
                if #bintable > 1 then
                    table.remove(bintable, curEline)
                    curEline = (curEline - 1) % #bintable
                    redraw()
                end
            end
        elseif event[1] == "char" then
            if event[2] == cfg.command then
                command = ":"
                commandmode = true
                redraw()
            elseif event[2] == cfg.createabove then
                table.insert(bintable, curEline+1, "00000000")
                redraw()
            elseif event[2] == cfg.createunder then
                table.insert(bintable, curEline+2, "00000000")
                redraw()
            elseif elementExists(nums, event[2]) then
                rval = rval*10+tonumber(event[2])
            end
        end
    else
        if event[1] == "char" then
            command = command..event[2]
            redraw()
        elseif event[1] == "key" then
            if event[2] == keys.enter then
                commandresult = execCommand(command)
                if commandresult == 0 then
                    return 0
                end
                commandmode = false
                redraw()
            elseif event[2] == keys.backspace then
                command = string.sub(command, 1, #command-1)
                redraw()
            end
        end
    end
end
