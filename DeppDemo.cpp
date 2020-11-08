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

char			szDvc[cchSzLen];
char            R0[cchSzLen];
char            R1[cchSzLen];
char            R2[cchSzLen];
char            R3[cchSzLen];
char            R4[cchSzLen];
char            R5[cchSzLen];


HIF				hif = hifInvalid;

FILE* fhin = NULL;
FILE* fhout = NULL;

void ErrorExit();
void DoGetReg(SOCKET s);
void StrcpyS(char* szDst, size_t cchDst, const char* szSrc);
void disableDepp(HIF hif);
using namespace std;

boolean isPause = false;
BYTE prev_volume = (BYTE)0;

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


    BYTE	idData0;
    BYTE	idData1;
    BYTE	idData2;
    BYTE	idData3;
    BYTE    idData4;
    BYTE    idData5;


    BYTE    array[8];
    char* szStop;

    idReg0 = (BYTE)strtol(R0, &szStop, 10);
    idReg1 = (BYTE)strtol(R1, &szStop, 10);
    idReg2 = (BYTE)strtol(R2, &szStop, 10);
    idReg3 = (BYTE)strtol(R3, &szStop, 10);
    idReg4 = (BYTE)strtol(R4, &szStop, 10);
    idReg5 = (BYTE)strtol(R5, &szStop, 10);

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

    printf("%d\n", idData0);
    printf("%d\n", idData1);
    printf("%d\n", idData2);
    printf("%d\n", idData3);
    printf("%d\n", idData4);
    printf("%d\n", idData5);


    // message send to python server
    const char* r0;
    const char* r1;
    const char* r2;
    const char* r3;
    const char* r4;
    const char* r5;


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

    if (idData4 > prev_volume) {
        r4 = "volumeup";
        puts(r4);
        send(s, r4, strlen(r4), 0);
        prev_volume = idData4;

    } else if (idData4 < prev_volume) {
        r4 = "volumedown";
        puts(r4);
        send(s, r4, strlen(r4), 0);
        prev_volume = idData4;

    } else {
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


    /*
    if (idData4 != prev_volume) {
        if (idData4 == (BYTE)2) {
            r4 = "volume 0";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)5) {
            prev_volume = idData4;
            r4 = "volume 5";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)10) {
            r4 = "volume 10";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)15) {
            r4 = "volume 15";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)20) {
            r4 = "volume 20";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)25) {
            r4 = "volume 25";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)30) {
            r4 = "volume 30";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)35) {
            r4 = "volume 35";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)40) {
            r4 = "volume 40";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)45) {
            r4 = "volume 45";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)50) {
            r4 = "volume 50";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)55) {
            r4 = "volume 55";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)60) {
            r4 = "volume 60";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)65) {
            r4 = "volume 65";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)70) {
            r4 = "volume 70";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)75) {
            r4 = "volume 75";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)80) {
            r4 = "volume 80";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)85) {
            r4 = "volume 85";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)90) {
            r4 = "volume 90";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)95) {
            r4 = "volume 95";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }

        else if (idData4 == (BYTE)100) {
            r4 = "volume 100";
            puts(r4);
            send(s, r4, strlen(r4), 0);
        }
        prev_volume = idData4;
    }
    */
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
