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

char			szDvc[cchSzLen];
char            R0[cchSzLen];
char            R1[cchSzLen];
char            R2[cchSzLen];
char            R3[cchSzLen];

HIF				hif = hifInvalid;

FILE* fhin = NULL;
FILE* fhout = NULL;

void ErrorExit();
void DoGetReg(SOCKET s);
void StrcpyS(char* szDst, size_t cchDst, const char* szSrc);
void disableDepp(HIF hif);
using namespace std;


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
        Sleep(500);
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

    BYTE	idData0;
    BYTE	idData1;
    BYTE	idData2;
    BYTE	idData3;

    BYTE    array[8];
    char* szStop;

    idReg0 = (BYTE)strtol(R0, &szStop, 10);
    idReg1 = (BYTE)strtol(R1, &szStop, 10);
    idReg2 = (BYTE)strtol(R2, &szStop, 10);
    idReg3 = (BYTE)strtol(R3, &szStop, 10);

    // DEPP API Call: DeppGetReg
    // get the single byte value from 4 registers which is mapped to 4 buttons
    DeppGetReg(hif, idReg0, &idData0, fFalse);
    DeppGetReg(hif, idReg1, &idData1, fFalse);
    DeppGetReg(hif, idReg2, &idData2, fFalse);
    DeppGetReg(hif, idReg3, &idData3, fFalse);

    printf("%d\n", idData0);
    printf("%d\n", idData1);
    printf("%d\n", idData2);
    printf("%d\n", idData3);

    // message send to python server
    const char* r0;
    const char* r1;
    const char* r2;
    const char* r3;

    if (idData0 == (BYTE)0) {
        r0 = "b0 not press";
    }
    else {
        r0 = "next";
    }

    if (idData1 == (BYTE)0) {
        r1 = "b1 not press";
    }
    else {
        r1 = "play";
    }

    if (idData2 == (BYTE)0) {
        r2 = "b2 not press";
    }
    else {
        r2 = "stop";
    }

    if (idData3 == (BYTE)0) {
        r3 = "b3 not press";
    }
    else {
        r3 = "back";
    }

    if (send(s, r0, strlen(r0), 0) < 0)
    {
        puts("r0 Send failed");
        disableDepp(hif);
        return;
    }
    puts("r0 Send\n");

    if (send(s, r1, strlen(r1), 0) < 0)
    {
        puts("r1 Send failed");
        disableDepp(hif);
        return;
    }
    puts("r1 Send\n");

    if (send(s, r2, strlen(r2), 0) < 0)
    {
        puts("r2 Send failed");
        disableDepp(hif);
        return;
    }
    puts("r2 Send\n");

    if (send(s, r3, strlen(r3), 0) < 0)
    {
        puts("r3 Send failed");
        disableDepp(hif);
        return;
    }
    puts("r3 Send\n");
    return;
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
