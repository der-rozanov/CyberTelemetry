--===============================================================================--
altitude = 0 --altitude 
air_speed = 0 --airflow speed
gps_speed = 0 --GPS speed
heading = 0 --magnetic heading 0 - North
rssi = 0 --Connection quality
flight_mode = 0 --Flightmode
temperature = 0 -- not used
tx_voltage = 0 --Your transmitter voltage
fuel = 0 --Remaining charge as a percentage
vfas = 0 --Battery voltage 
current = 0 --Current in the power supply circuit
flaps_stick = "sa" --The stick assigned to the flap control
spoilers_stick = "sf" --The stick assigned to the spoilers control
--===============================================================================--
  
flaps_cond = 0 --Flaps condition
flaps_p_cond = 0

breaks_cond = 0 --spoilers condition
breaks_p_cond = 0


local function drawFrame()
  --Draw main frame on screen. LCD width 127, height 63
  lcd.drawLine(40,0,40,63,SOLID,FORCE)
  lcd.drawLine(0,40,127,40,SOLID,FORCE)
  lcd.drawLine(87,0,87,63,SOLID,FORCE)
  
end

local function drawBird(x_z,y_z) --Draw gyro horizon
  
  lcd.drawLine(x_z,y_z,x_z-3,y_z-6,SOLID,FORCE)
  lcd.drawLine(x_z-3,y_z-6,x_z-13,y_z-6,SOLID,FORCE)
  lcd.drawLine(x_z,y_z,x_z+3,y_z-6,SOLID,FORCE)
  lcd.drawLine(x_z+3,y_z-6,x_z+13,y_z-6,SOLID,FORCE)
  
  --Draw central point of Bird
  lcd.drawLine(40,22,43,22,SOLID,FORCE)
  lcd.drawLine(87,22,84,22,SOLID,FORCE)
end


local function drawWindMech(xz,yz)
  --[[  Flaps have two degrees of release. Low "L" and High "H". 
        Each time, the correspondence of the current state of the toggle switch flaps stick 
        and the past is checked. 
        If the status has changed, an audible signal is issued ]]--
  lcd.drawRectangle(xz+1,yz+10,38,12,FORCE)
  
  local Wing_text_x = xz+10
  local Wing_text_y = yz+2
  local Flap_text_x = xz+5
  local Flap_text_y = yz+13
  
  if getValue(flaps_stick) > -1024 then --check new state of flaps
    flaps_cond = 1;
  else
    flaps_cond = 0;
  end
  
  if getValue(spoilers_stick) > -1024 then
    breaks_cond = 1
  else
    breaks_cond = 0
  end
    
  if flaps_p_cond ~= flaps_cond then --if there is some changes, an audible signal is issued
    if flaps_cond == 1 then
      playFile("/SOUNDS/ru/flapdn.wav")
    else
      playFile("/SOUNDS/ru/flapup.wav")
    end
  end
  
  if breaks_p_cond ~= breaks_cond then --if there is some changes, an audible signal is issued
    if breaks_cond == 1 then
      playFile("/SOUNDS/ru/splrup.wav")
    else
      playFile("/SOUNDS/ru/splrdn.wav")
    end
  end
  
  if getValue(flaps_stick) ~= -1024 or getValue(spoilers_stick) == 1024 then
    lcd.drawText(Wing_text_x,Wing_text_y,"Wing",BLINK) --if flaps down "wing" text will blink
    
    if getValue(flaps_stick) == 0 then
      lcd.drawText(Flap_text_x,Flap_text_y,"Flaps L",SMLSIZE) --release degree
    end
    
    if getValue(flaps_stick) == 1024 then
      lcd.drawText(Flap_text_x,Flap_text_y,"Flaps H",SMLSIZE) --release degree
    end
    
    if getValue(spoilers_stick) > -1024 then
      lcd.drawText(Flap_text_x,Flap_text_y,"Breaks",SMLSIZE)
    end
    
  else
    lcd.drawText(Wing_text_x,Wing_text_y,"Wing") --if flaps up "wing" text will not blink
    lcd.drawText(Flap_text_x,Flap_text_y,"Flap Up",SMLSIZE) 
  end
  
  if getValue(flaps_stick) > -1024 then --remember current state of flaps
    flaps_p_cond = 1;
  else
    flaps_p_cond = 0;
  end
	
  if getValue(spoilers_stick) > -1024 then
    breaks_p_cond = 1
  else
    breaks_p_cond = 0
  end

end

local function drawSpeedHeadAtl(xz,yz)
  lcd.drawNumber(xz+17,yz+10,heading,SMLSIZE)  --top center position 
  lcd.drawText(lcd.getLastPos(),yz+9,"\64")
  
  lcd.drawNumber(xz+6,yz+27,air_speed,SMLSIZE) --bottom left 
  lcd.drawText(xz+2,yz+33,"m/s",SMLSIZE)
  
  lcd.drawNumber(xz+32,yz+27,altitude,SMLSIZE) --bottom right
  lcd.drawText(xz+37,yz+33,"m",SMLSIZE)
end

local function drawBatteryData(xz, yz)
  
  lcd.drawGauge(xz+1,yz+9,xz+37,yz+8,fuel,100)
  lcd.drawLine(xz+38,yz+12,xz+38,yz+13,SOLID,FORCE)
  
  lcd.drawNumber(xz+1,yz+18,10*vfas,PREC1+SMLSIZE)
  lcd.drawText(lcd.getLastPos(),yz+18,"V",SMLSIZE)
  
  lcd.drawNumber(xz+1,yz+25,100*current,PREC2+SMLSIZE)
  lcd.drawText(lcd.getLastPos(),yz+25,"A",SMLSIZE)
  
  lcd.drawText(xz+1,yz+32,"Tx",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+1,yz+32,100*getValue("tx-voltage"),SMLSIZE+PREC2)
  lcd.drawText(lcd.getLastPos(),yz+32,"V",SMLSIZE)
  
end  

local function drawOtherData(zx,zy)
  
  lcd.drawText(zx+2,zy+9,"SWR",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2,zy+9,rssi,SMLSIZE)
  lcd.drawText(lcd.getLastPos(),zy+9,"dB",SMLSIZE)
  
  lcd.drawText(zx+2, zy+16,"Tmp",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2, zy+16, temperature, SMLSIZE)
  lcd.drawText(lcd.getLastPos(), zy+16,"\64C",SMLSIZE)
  
end

local function drawTimer(zx, zy)

  local datenow = getDateTime()
  local tim = model.getTimer(0)
  lcd.drawText(zx+2,zy+2,"M:",SMLSIZE)
  lcd.drawTimer(lcd.getLastPos(),zy+2,tim.value,SMLSIZE)
  
  lcd.drawText(zx+4,zy+11,datenow.hour..":"..datenow.min..":"..datenow.sec)

end

local function getTelemeryValue()
  altitude = getValue("Alt")
  air_speed = getValue("VSpd")
  gps_speed = getValue("GSpd")
  heading = getValue("Hdg")
  rssi = getValue("RSSI")
  flight_mode = getValue("Tmp1")
  temperature = getValue("Tmp2")
  tx_voltage = getValue("tx-voltage")
  fuel = getValue("Fuel")
  vfas = getValue("VFAS")
  current = getValue("Curr")
end

local function run_func(event)

  lcd.clear() --clear lcd display
  
  drawFrame() --draw general frame
  
  getTelemeryValue() --get telemetry value from reciever
  
  lcd.drawScreenTitle("Cyber Telemetry V0.1",1,1) --put there current version
  
  drawBird(64,28) --gyro horizon
  
  drawWindMech(0,40) --Flaps and breaks
  
  drawSpeedHeadAtl(40,0) --central screen
  
  drawBatteryData(0,0) --battery data
  
  drawOtherData(87,0) --rssi tmp
  
  drawTimer(87,40) --timer and global time
  
  if event == EVT_EXIT_BREAK then   --if "Exit" button pressed, stop program
    return 1 
  else
    return 0
  end
  
end


return { run=run_func } --looping the program