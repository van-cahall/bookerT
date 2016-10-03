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
Global $isbn;

; Coordinates of each browser window that will popup: [ top, height, left, width ]
Global $window1Coords[4]  = [0, $screenHeight-40, 0, ($screenWidth * .4)];
Global $window2Coords[4]  = [0, $screenHeight-40, ($screenWidth * .4), ($screenWidth * .3)];
Global $window3Coords[4]  = [0, $screenHeight-40, ($screenWidth*.68), ($screenWidth * .32)];
Global $zenArbWin1[4]     = [0, $screenHeight-40, 0, 1325];
Global $zenArbWin2[4]     = [0, $screenHeight-40, 1280, 650 ];
Global $zenArbWin3[4]     = [0, $screenHeight-40, 1280 + 650, 650];

Global $url1 = "https://www.amazon.com/dp/[]";
Global $url2 = "https://www.amazon.com/gp/offer-listing/[]/ref=olp_f_used?ie=UTF8&f_used=true&ref=olp_f_primeEligible&f_primeEligible=true";
Global $url3 = "https://keepa.com/#!product/1-[]";
Global $url4 = "https://sellercentral.amazon.com/hz/inventory/ref=ag_invmgr_dnav_xx_?tbla_myitable=sort:%7B%22sortOrder%22%3A%22ASCENDING%22%2C%22sortedColumnId%22%3A%22name%22%7D;search:" & $isbn & "%20;pagination:1;"
Global $urlAmazonUsedPrime = "https://www.amazon.com/gp/offer-listing/[]/ref=olp_f_used?ie=UTF8&f_primeEligible=true"  ; Amazon, Used, Prime
Global $urlZenArbitrageMyListings = "http://marketplace.zenarbitrage.com/listings"
Global $urlAmazonUsedNonPrime = "https://www.amazon.com/gp/offer-listing/[]/ref=tmm_hrd_used_olp_sr?ie=UTF8&condition=used&qid=&sr="  ; Amazon, Used, Non-Prime


Global $window1,$window2,$window3,$sc

; Keyboard Shortcuts
HotKeySet("^1", "launchBrowsers");  Open 3 Amazon browser windows to specific location/size
HotKeySet("^2", "closeAll"); Close 3 Amazon browser windows
HotKeySet("^3", "openZenArbitrage"); Close 3 Amazon browser windows

Func launchBrowsers()
	$windows=3;
    getIsbn($isbn);
   if (StringLen($isbn) = 10) Then
	   ; Open browser windows
	  showBrowser($window1, $url1, $window1Coords);
	  showBrowser($window2, $url2, $window2Coords);
	  showBrowser($window3, $url3, $window3Coords);

   EndIf
EndFunc

Func showBrowser(ByRef $browserObject, $url, $coords, $waitForLoad=0)
   Local $site = StringReplace($url,"[]",$isbn)
   $browserObject = _IECreate("about:blank",0,1,0,1);
    _IEPropertySet($browserObject, "width", $coords[3]);
	_IEPropertySet($browserObject, "left", $coords[2]);
	_IEPropertySet($browserObject, "top", $coords[0]);
	_IEPropertySet($browserObject, "height", $coords[1]);
	_IENavigate($browserObject, $site,$waitForLoad)
EndFunc

;  Open the set of browser windows for Zen Arbitrage
Func openZenArbitrage()
   getIsbn($isbn);
   $delayTime=500
   if (StringLen($isbn) = 10) Then
	   ; Open browser windows
	  showBrowser($window2, $urlAmazonUsedNonPrime, $zenArbWin2); Amazon, Non-Prime, Used
	  showBrowser($window3, $urlAmazonUsedPrime, $zenArbWin3);  Amazon, Prime
	  ; Load this page last because we need to navigate within the page
	  showBrowser($window1, $urlZenArbitrageMyListings, $zenArbWin1,1);  Zen Arbitrage, My Listings page
	  Sleep(1500)
;~ 	  MsgBox(0,"","Sending CTRL+F")
	  Send("^f")
	  Sleep($delayTime)
	  Send("^v")
	  Sleep($delayTime)
	  Send("{ESC}")
	  Sleep($delayTime)
	  Send("{TAB}")

	  Sleep($delayTime)
	  Send("{ENTER}")

	  ; Beep to notify user that pages are loaded
	  Beep(600,125);
	  Beep(600,125);
	  Beep(600,125);

   EndIf
EndFunc

Func closeAll()
   ; Close the 3 IE windows that were previously opened
   _IEQuit($window2)
   _IEQuit($window3)
   _IEQuit($window1);
EndFunc

Func getIsbn(ByRef $isbn)
   $isbn_length=0
	$isbn_clip = ClipGet();
	$isbn = StringStripWS($isbn_clip,$STR_STRIPLEADING + $STR_STRIPTRAILING)
	$isbn_length = StringLen($isbn)

	; If ISBN is < 10 characters, prefix with zeroes
    if $isbn_length > 0 And $isbn_length < 10  Then
	   For $numZeroes = 1 To (10 - $isbn_length)
		 $isbn = "0" & $isbn
	  Next
   ElseIf $isbn_length > 10 Then
	  MsgBox(0,"Aborting","ISBN is " & $isbn_length & " characters long.")
   EndIf
EndFunc

While 1
    Sleep(100)
WEnd