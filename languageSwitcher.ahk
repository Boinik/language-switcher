#noenv
#singleinstance, ignore
setbatchlines, -1
setworkingdir, %a_scriptdir%

gosub,osd_create
return

osd_create:
 {
   gui, -caption +toolwindow +alwaysontop +lastfound
   gui, color, 8b0fc6
   gui, font, s10 w600, Arial Bold
   gui, margin, 0, 0
   winset, transcolor, 8b0fc6

   gui, add, listview, x63 y0 w40 h16 -hdr -e0x200 -multi background5481E6 vMyBox glv altsubmit
   gui, add, text, x63 y0 w40 h16 0x201 cwhite backgroundtrans vMyText, ... ; overlay the word CAPS on top of the ListView control
   gui, show, xCenter y0 NA, OSD	

 }
return

LaguageBox(text,color){
	guicontrol, +background%color%, MyBox
	guicontrol, Text, MyText, %text%
	return
}

GetCurrentKeyboardLayout() {
SetFormat, Integer, H
WinGet, WinID,, A ;get the active Window
ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")

if (InputLocaleID == 0x4220422)
	LaguageBox("UA","1E90FF")
else if (InputLocaleID == 0x4190419)
    LaguageBox("RU","808000")
else if (InputLocaleID == 0x4090409 )
    LaguageBox("ENG","228B22")

;MsgBox, The language of the active window is %languageName%. (code: %InputLocaleID%)
return
}


SetDefaultKeyboard(LocaleID){
	Static SPI_SETDEFAULTINPUTLANG := 0x005A, SPIF_SENDWININICHANGE := 2
	
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(binaryLocaleID, 4, 0)
	NumPut(LocaleID, binaryLocaleID)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &binaryLocaleID, "UInt", SPIF_SENDWININICHANGE)
	
	WinGet, windows, List
	Loop % windows {
		PostMessage 0x50, 0, % Lan, , % "ahk_id " windows%A_Index%
	}
	return

}

F20::
if GetKeyState("F20", "P") {
    Send, {LAlt down}{Shift down}
    Send, {LAlt up}{Shift up}
	GetCurrentKeyboardLayout()
}
return

^a::
SetDefaultKeyboard(0x0409)
GetCurrentKeyboardLayout()
return

^r::
SetDefaultKeyboard(0x419)
GetCurrentKeyboardLayout()
return

^u::
SetDefaultKeyboard(0x422)
GetCurrentKeyboardLayout()
return

lv:
{
    Send, {LAlt down}{Shift down}
    Send, {LAlt up}{Shift up}
	GetCurrentKeyboardLayout()
}
	return
