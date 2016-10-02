; Open a browser with the basic example, check to see if the
; addressbar is visible, if it is not turn it on. Then change
; the text displayed in the statusbar

#include <IE.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

Opt("WinTitleMatchMode", 2)
$screenHeight = @DeskTopHeight
$screenWidth  = @DesktopWidth
$sellerCentralHeight = 360
Global $windows=3;
Global $windowWidth=$screenWidth/$windows;

; Coordinates of each browser window that will popup: [ top, height, left, width ]
Global $window1Coords[4] = [0, $screenHeight-40, 0, ($screenWidth * .4)];
Global $window2Coords[4] = [0, $screenHeight-40, ($screenWidth * .4), ($screenWidth * .3)];
Global $window3Coords[4] = [0, $screenHeight-40, ($screenWidth*.68), ($screenWidth * .32)];


Global $window1,$window2,$window3,$sc

HotKeySet("^1", "launchBrowsers");
HotKeySet("^2", "closeAll");
; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : launchBrowsers = ' & launchBrowsers & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


Func launchBrowsers()

    ;ClipPut("");
	;Send("!1");

	$windows=3;

    $isbn_length=0
	$isbn_clip = ClipGet();
	Global $isbn = StringStripWS($isbn_clip,$STR_STRIPLEADING + $STR_STRIPTRAILING)
	$isbn_length = StringLen($isbn)

	; If ISBN is < 10 characters, prefix with zeroes
    if $isbn_length > 0 And $isbn_length < 10  Then
	   For $numZeroes = 1 To (10 - $isbn_length)
		 $isbn = "0" & $isbn
	  Next
   ElseIf $isbn_length > 10 Then
	  MsgBox(0,"","ISBN is " & $isbn_length & " characters long.")
   EndIf

   if (StringLen($isbn) = 10) Then
	   ; URL 1
	   $url1 = "https://www.amazon.com/dp/" & $isbn;
	   $url2 = "https://www.amazon.com/gp/offer-listing/" & $isbn & "/ref=olp_f_used?ie=UTF8&f_used=true&ref=olp_f_primeEligible&f_primeEligible=true";
	   $url3 = "https://keepa.com/#!product/1-" & $isbn;
	   $url4 = "https://sellercentral.amazon.com/hz/inventory/ref=ag_invmgr_dnav_xx_?tbla_myitable=sort:%7B%22sortOrder%22%3A%22ASCENDING%22%2C%22sortedColumnId%22%3A%22name%22%7D;search:" & $isbn & "%20;pagination:1;"

	   ; Open browser windows
	  showBrowser($window1, $url1, $window1Coords);
	  showBrowser($window2, $url2, $window2Coords);
	  showBrowser($window3, $url3, $window3Coords);

   EndIf

;~ ShellExecute("iexplore.exe", $url1)
;~ WinWait("Blank Page - Internet Explorer")

;~ $oIE = _IEAttach($url1, "url")
;~ _IEPropertySet($oIE, "width", $windowWidth);
;~ _IEPropertySet($oIE, "left", 0);
;~ _IEPropertySet($oIE, "top", "0");
;~ _IEPropertySet($oIE, "height", $screenHeight - 40);

;~ _IELoadWait($oIE)
;_IENavigate($oIE, $url1)


EndFunc

Func showBrowser($browserObject, $url, $coords)
   Dim $browserObject = _IECreate($url);
    _IEPropertySet($browserObject, "width", $coords[3]);
	_IEPropertySet($browserObject, "left", $coords[2]);
	_IEPropertySet($browserObject, "top", $coords[0]);
	_IEPropertySet($browserObject, "height", $coords[1]);
EndFunc

Func closeAll()

   ; Close the 3 IE windows that were previously opened
   _IEQuit($window1)
   _IEQuit($window2)
   _IEQuit($window3)



   ; Open
EndFunc



While 1
    Sleep(100)
WEnd