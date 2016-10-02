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

Global $window1,$window2,$window3,$sc

HotKeySet("^1", "launchBrowsers");
HotKeySet("^2", "closeAll");
; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : launchBrowsers = ' & launchBrowsers & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


Func launchBrowsers()

    ;ClipPut("");
	;Send("!1");

	$windows=3;
	$windowWidth=$screenWidth/$windows;
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
	   Dim $window1 = _IECreate($url1);
	   _IEPropertySet($window1, "width", $windowWidth);
	   _IEPropertySet($window1, "left", 0);
	   _IEPropertySet($window1, "top", "0");
	   _IEPropertySet($window1, "height", $screenHeight - 40 - $sellerCentralHeight);

	   Dim $window2 = _IECreate($url2,1);
	   _IEPropertySet($window2, "width", $windowWidth);
	   _IEPropertySet($window2, "left", ($windowWidth*1));
	   _IEPropertySet($window2, "top", "0");
	   _IEPropertySet($window2, "height", $screenHeight - 40 - $sellerCentralHeight);

	   Dim $window3 = _IECreate($url3,1);
	   _IEPropertySet($window3, "width", $windowWidth);
	   _IEPropertySet($window3, "left", ($windowWidth*2));
	   _IEPropertySet($window3, "top", "0");
	   _IEPropertySet($window3, "height", $screenHeight - 40 - $sellerCentralHeight);

	  Dim $sc = _IECreate($url4);
	  _IEPropertySet($sc, "width", $screenWidth);
	   _IEPropertySet($sc, "left", 0);
	   _IEPropertySet($sc, "top", $screenHeight - 40 - $sellerCentralHeight);
	   _IEPropertySet($sc, "height", $sellerCentralHeight);

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

Func closeAll()
   ; Close the 3 IE windows that were previously opened
   _IEQuit($sc)
   _IEQuit($window1)
   _IEQuit($window2)
   _IEQuit($window3)



   ; Open
EndFunc



While 1
    Sleep(100)
WEnd