flaps_cond = 0
flaps_p_cond = 0

breaks_cond = 0
breaks_p_cond = 0

altitude = 150
air_speed = 70
gps_speed = 0
heading = 315.4
RSSI = 79
FMode = 0
Temperature = 0
Tx_votage = 0
Fuel = 39
VFAS = 0 --voltage 
Curr = 0 --current 

  
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


local function WingMech(xz,yz)
  --[[  Flaps have two degrees of release. Low "L" and High "H". 
        Each time, the correspondence of the current state of the toggle switch "sa" and the past is checked. 
        If the status has changed, an audible signal is issued ]]--
  lcd.drawRectangle(xz+1,yz+10,38,12,FORCE)
  
  local Wing_text_x = xz+10
  local Wing_text_y = yz+2
  local Flap_text_x = xz+5
  local Flap_text_y = yz+13
  
  if getValue("sa") > -1024 then --check new state of flaps
    flaps_cond = 1;
  else
    flaps_cond = 0;
  end
  
  if getValue("sf") > -1024 then
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
  
  if getValue("sa") ~= -1024 or getValue("sf") == 1024 then
    lcd.drawText(Wing_text_x,Wing_text_y,"Wing",BLINK) --if flaps down "wing" text will blink
    
    if getValue("sa") == 0 then
      lcd.drawText(Flap_text_x,Flap_text_y,"Flaps L",SMLSIZE) --release degree
    end
    
    if getValue("sa") == 1024 then
      lcd.drawText(Flap_text_x,Flap_text_y,"Flaps H",SMLSIZE) --release degree
    end
    
    if getValue("sf") > -1024 then
      lcd.drawText(Flap_text_x,Flap_text_y,"Breaks",SMLSIZE)
    end
    
  else
    lcd.drawText(Wing_text_x,Wing_text_y,"Wing") --if flaps up "wing" text will not blink
    lcd.drawText(Flap_text_x,Flap_text_y,"Flap Up",SMLSIZE) 
  end
  
  if getValue("sa") > -1024 then --remember current state of flaps
    flaps_p_cond = 1;
  else
    flaps_p_cond = 0;
  end
	
  if getValue("sf") > -1024 then
    breaks_p_cond = 1
  else
    breaks_p_cond = 0
  end

end

local function spd_head_alt()
  lcd.drawNumber(57,10,heading,SMLSIZE)  --top center position 
  lcd.drawText(lcd.getLastPos(),9,"\64")
  
  lcd.drawNumber(46,27,air_speed,SMLSIZE) --bottom left 
  lcd.drawText(42,33,"m/s",SMLSIZE)
  
  lcd.drawNumber(72,27,altitude,SMLSIZE) --bottom right
  lcd.drawText(77,33,"m",SMLSIZE)
end

local function bat_data()
  
  lcd.drawGauge(1,9,37,8,Fuel,100)
  lcd.drawLine(38,12,38,13,SOLID,FORCE)
  
  lcd.drawNumber(1,18,10*VFAS,PREC1+SMLSIZE)
  lcd.drawText(lcd.getLastPos(),18,"V",SMLSIZE)
  
  lcd.drawNumber(1,25,100*Curr,PREC2+SMLSIZE)
  lcd.drawText(lcd.getLastPos(),25,"A",SMLSIZE)
  
  lcd.drawText(1,32,"Tx",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+1,32,100*getValue("tx-voltage"),SMLSIZE+PREC2)
  lcd.drawText(lcd.getLastPos(),32,"V",SMLSIZE)
  
end  

local function other_data(zx,zy)
  
  lcd.drawText(zx+2,zy+1,"SWR",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2,zy+1,RSSI,SMLSIZE)
  lcd.drawText(lcd.getLastPos(),zy+1,"dB",SMLSIZE)
  
  lcd.drawText(zx+2, zy+8,"Tmp",SMLSIZE)
  lcd.drawNumber(lcd.getLastPos()+2, zy+8, Temperature, SMLSIZE)
  lcd.drawText(lcd.getLastPos(), zy+8,"\64C",SMLSIZE)
  
end

local function timer(zx, zy )

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
  RSSI = getValue("RSSI")
  FMode = getValue("Tmp1")
  Temperature = getValue("Tmp2")
  Tx_votage = getValue("tx-voltage")
  Fuel = getValue("Fuel")
  VFAS = getValue("VFAS")
  Curr = getValue("Curr")
end

local function run_func(event)

  lcd.clear() --clear lcd display
  
  drawFrame()
  
  getTelemeryValue()
  
  lcd.drawScreenTitle("Cyber Telemetry V0.1",1,1) --put there current version
  
  drawBird(64,28) --gyro horizon
  
  WingMech(0,40) --Flaps and breaks
  
  spd_head_alt() --central screen
  
  bat_data()
  
  other_data(87,8)
  
  timer(87,40)
  
  if event == EVT_EXIT_BREAK then   --if "Exit" button pressed, stop program
    return 1 
  else
    return 0
  end
  
end


return { run=run_func } --looping the program