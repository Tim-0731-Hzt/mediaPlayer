#define	_CRT_SECURE_NO_WARNINGS

/* ------------------------------------------------------------ */
/*					Include File Definitions					*/
/* ------------------------------------------------------------ */

#if defined(WIN32)

    /* Include Windows specific headers here.
    */
    //
#include <WS2tcpip.h> 
#include <windows.h>

#else

    /* Include Unix specific headers here.
    */
#endif



#pragma comment (lib,"ws2_32.lib")


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ioStream>

#include "dpcdecl.h" 
#include "depp.h"
#include "dmgr.h"

const int cchSzLen = 1024;

const char* deviceName = "DOnbUsb";
const char* r0 = "0";
const char* r1 = "1";
const char* r2 = "2";
const char* r3 = "3";
const char* r4 = "4";
const char* r5 = "5";
const char* r6 = "6";
const char* r7 = "7";
const char* r8 = "8";


char			szDvc[cchSzLen];
char            R0[cchSzLen];
char            R1[cchSzLen];
char            R2[cchSzLen];
char            R3[cchSzLen];
char            R4[cchSzLen];
char            R5[cchSzLen];
char            R6[cchSzLen];
char            R7[cchSzLen];
char            R8[cchSzLen];


HIF				hif = hifInvalid;

FILE* fhin = NULL;
FILE* fhout = NULL;

void ErrorExit();
void DoGetReg(SOCKET s);
void StrcpyS(char* szDst, size_t cchDst, const char* szSrc);
void disableDepp(HIF hif);
using namespace std;

boolean isPause = false;
int prev_toggle = 0;
BYTE prev_volume = (BYTE)0;
boolean isOpen = false;

int main(int cszArg, char* rgszArg[]) {

    // set up the client socket
    sockaddr_in serv_addr;
    WSADATA wsa;
    SOCKET s;

    printf("\nInitialising Winsock...");
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
    {
        printf("Failed. Error Code : %d", WSAGetLastError());
        return 0;
    }

    printf("Initialised.\n");


    if ((s = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET)
    {
        printf("Could not create socket : %d", WSAGetLastError());
    }

    printf("Socket created.\n");


    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(12000);

    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0)
    {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }

    if (connect(s, (sockaddr*)&serv_addr, sizeof(serv_addr)) < 0)
    {
        puts("connect error");
        return 0;
    }

    puts("Connected");

    // setup depp connection
    StrcpyS(szDvc, cchSzLen, deviceName);
    StrcpyS(R0, cchSzLen, r0);
    StrcpyS(R1, cchSzLen, r1);
    StrcpyS(R2, cchSzLen, r2);
    StrcpyS(R3, cchSzLen, r3);
    StrcpyS(R4, cchSzLen, r4);
    StrcpyS(R5, cchSzLen, r5);
    StrcpyS(R6, cchSzLen, r6);
    StrcpyS(R7, cchSzLen, r7);
    StrcpyS(R8, cchSzLen, r8);

    if (!DmgrOpen(&hif, szDvc)) {
        printf("DmgrOpen failed (check the device name you provided)\n");
        return 0;
    }
    puts("DmgrOpen");
    // DEPP API call: DeppEnable
    if (!DeppEnable(hif)) {
        printf("DeppEnable failed\n");
        return 0;
    }
    puts("DeppEnable");

    // handle continous input from button, tracking the value of registers every 500ms, and send to python server
    while (1) {
        DoGetReg(s);
        printf("\n");

        if (GetKeyState('Q') & 0x8000) {
            break;
        }
    }
    // close socket and depp
    closesocket(s);
    disableDepp(hif);
    return 0;
}


void DoGetReg(SOCKET s) {

    BYTE	idReg0;
    BYTE	idReg1;
    BYTE	idReg2;
    BYTE	idReg3;
    BYTE    idReg4;
    BYTE    idReg5;
    BYTE    idReg6;
    BYTE    idReg7;
    BYTE    idReg8;

    BYTE	idData0;
    BYTE	idData1;
    BYTE	idData2;
    BYTE	idData3;
    BYTE    idData4;
    BYTE    idData5;
    BYTE    idData6;
    BYTE    idData7;
    BYTE    idData8;

    BYTE    array[8];
    char* szStop;

    idReg0 = (BYTE)strtol(R0, &szStop, 10);
    idReg1 = (BYTE)strtol(R1, &szStop, 10);
    idReg2 = (BYTE)strtol(R2, &szStop, 10);
    idReg3 = (BYTE)strtol(R3, &szStop, 10);
    idReg4 = (BYTE)strtol(R4, &szStop, 10);
    idReg5 = (BYTE)strtol(R5, &szStop, 10);
    idReg6 = (BYTE)strtol(R6, &szStop, 10);
    idReg7 = (BYTE)strtol(R7, &szStop, 10);
    idReg8 = (BYTE)strtol(R8, &szStop, 10);

    // DEPP API Call: DeppGetReg
    // get the single byte value from 4 registers which is mapped to 4 buttons
    Sleep(30);
    DeppGetReg(hif, idReg0, &idData0, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg1, &idData1, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg2, &idData2, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg3, &idData3, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg4, &idData4, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg5, &idData5, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg6, &idData6, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg7, &idData7, fFalse);
    Sleep(30);
    DeppGetReg(hif, idReg8, &idData8, fFalse);

    printf("Register 0: %d\n", idData0);
    printf("Register 1: %d\n", idData1);
    printf("Register 2: %d\n", idData2);
    printf("Register 3: %d\n", idData3);
    printf("Register 4: %d\n", idData4);
    printf("Register 5: %d\n", idData5);
    printf("Register 6: %d\n", idData6);
    printf("Register 7: %d\n", idData7);
    printf("Register 8: %d\n", idData8);

    // message send to python server
    const char* r0;
    const char* r1;
    const char* r2;
    const char* r3;
    const char* r4;
    const char* r5;
    const char* r6;
    const char* r8;

    if (idData0 == (BYTE)1) {
        r0 = "next";
        puts(r0);
        send(s, r0, strlen(r0), 0);
    }

    if (idData1 == (BYTE)2) {
        r1 = "play";
        puts(r1);
        send(s, r1, strlen(r1), 0);
    }

    if (idData2 == (BYTE)1 and isPause == false) {
        r2 = "pause";
        puts(r2);
        send(s, r2, strlen(r2), 0);
        isPause = true;
    }

    else if (idData2 == (BYTE)1 and isPause == true) {
        r2 = "stop";
        puts(r2);
        send(s, r2, strlen(r2), 0);
        isPause = false;
    }

    if (idData3 == (BYTE)1) {
        r3 = "back";
        puts(r3);
        send(s, r3, strlen(r3), 0);
    }

    if (idData4 > prev_volume && idData4 != 4) {
        r4 = "volumeup";
        puts(r4);
        send(s, r4, strlen(r4), 0);
        prev_volume = idData4;

    }
    else if (idData4 < prev_volume && idData4 != 4) {
        r4 = "volumedown";
        puts(r4);
        send(s, r4, strlen(r4), 0);
        prev_volume = idData4;

    }
    else {
        r4 = "0";
        puts(r4);

        send(s, r4, strlen(r4), 0);
    }

    if (idData5 == (BYTE)1) {
        r5 = "volumeup";
        puts(r5);
        send(s, r5, strlen(r5), 0);
    }
    else if (idData5 == (BYTE)2) {
        r5 = "volumedown";
        puts(r5);
        send(s, r5, strlen(r5), 0);
    }
    else if (idData5 == (BYTE)4) {
        r5 = "mute";
        puts(r5);
        send(s, r5, strlen(r5), 0);
    }

    if (idData6 == (BYTE)1) {
        r6 = "ffwd";
        puts(r6);
        send(s, r6, strlen(r6), 0);
    }
    else if (idData6 == (BYTE)2) {
        r6 = "rwd";
        puts(r6);
        send(s, r6, strlen(r6), 0);
    }

    if (idData7 == (BYTE)1) {
        system(R"(C:\Windows\Sysnative\psshutdown -d -t 0)");
    }
    else if (idData7 == (BYTE)2 and isOpen == false) {
        isOpen = true;
        /// C:/Users/seanw/AppData/Local/Programs/Python/Python39/python.exe "c:/Users/seanw/Local Documents/UNSW/COMP3601/COMP3601/frontendMediaPlayer.py"
        // STARTUPINFO si = { sizeof(STARTUPINFO) };
        // PROCESS_INFORMATION pi;
        // LPWSTR cmdLine[] = L"C:/Users/seanw/AppData/Local/Programs/Python/Python39/python.exe \"c: / Users / seanw / Local Documents / UNSW / COMP3601 / COMP3601 / frontendMediaPlayer.py\""
        // if (!CreateProcess(L"C:\\Windows\\System32\\cmd.exe",
        //     cmdLine,
        //     NULL, NULL, 0, 0, NULL, NULL, &si, &pi)
        // {
        //     printf("CreateProcess failed (%d).\n", GetLastError());
        // }

        ShellExecute(0, 0, L"https://www.mp3juices.cc/", 0, 0, SW_HIDE);
    }
    else if (idData7 == (BYTE)2 and isOpen == true) {
        isOpen = false;
        system("TASKKILL /F /IM chrome.exe 1>NULL");
    }

    if (idData8 != prev_toggle && idData8 != 8) {
        prev_toggle = idData8;
        r8 = "toggle";
        puts(r8);
        send(s, r8, strlen(r8), 0);
    }
}

/* ------------------------------------------------------------ */
/***	StrcpyS
**
**	Parameters:
**		szDst - pointer to the destination string
**		cchDst - size of destination string
**		szSrc - pointer to zero terminated source string
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Cross platform version of Windows function strcpy_s.
*/
void StrcpyS(char* szDst, size_t cchDst, const char* szSrc) {

#if defined (WIN32)

    strcpy_s(szDst, cchDst, szSrc);

#else

    if (0 < cchDst) {

        strncpy(szDst, szSrc, cchDst - 1);
        szDst[cchDst - 1] = '\0';
    }

#endif
}

// disable depp connection
void disableDepp(HIF hif) {
    if (hif != hifInvalid) {
        // DEPP API Call: DeppDisable
        DeppDisable(hif);
        // DMGR API Call: DmgrClose
        DmgrClose(hif);
    }
}


void ErrorExit() {
    if (hif != hifInvalid) {
        // DEPP API Call: DeppDisable
        DeppDisable(hif);

        // DMGR API Call: DmgrClose
        DmgrClose(hif);
    }

    if (fhin != NULL) {
        fclose(fhin);
    }

    if (fhout != NULL) {
        fclose(fhout);
    }

    exit(1);
}
