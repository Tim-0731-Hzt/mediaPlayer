#define	_CRT_SECURE_NO_WARNINGS

/* ------------------------------------------------------------ */
/*					Include File Definitions					*/
/* ------------------------------------------------------------ */

#if defined(WIN32)

    /* Include Windows specific headers here.
    */
#include <windows.h>

#else

    /* Include Unix specific headers here.
    */

#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

BYTE	idReg0;
BYTE	idReg1;
BYTE	idReg2;
BYTE	idReg3;

void ErrorExit();
void DoGetReg();
void StrcpyS(char* szDst, size_t cchDst, const char* szSrc);

int main(int cszArg, char* rgszArg[]) {
    StrcpyS(szDvc, cchSzLen, deviceName);
    StrcpyS(R0, cchSzLen, r0);
    StrcpyS(R1, cchSzLen, r1);
    StrcpyS(R2, cchSzLen, r2);
    StrcpyS(R3, cchSzLen, r3);

    if (!DmgrOpen(&hif, szDvc)) {
        printf("DmgrOpen failed (check the device name you provided)\n");
        return 0;
    }

    // DEPP API call: DeppEnable
    if (!DeppEnable(hif)) {
        printf("DeppEnable failed\n");
        return 0;
    }



    BYTE	idData0;
    BYTE	idData1;
    BYTE	idData2;
    BYTE	idData3;

    char* szStop;

    idReg0 = (BYTE)strtol(R0, &szStop, 10);
    idReg1 = (BYTE)strtol(R1, &szStop, 10);
    idReg2 = (BYTE)strtol(R2, &szStop, 10);
    idReg3 = (BYTE)strtol(R3, &szStop, 10);

    while (1) {
        if (!DeppGetReg(hif, idReg0, &idData0, fFalse)) {
            printf("DeppGetReg failed\n");
            ErrorExit();
        }
        Sleep(200);
        if (!DeppGetReg(hif, idReg1, &idData1, fFalse)) {
            printf("DeppGetReg failed\n");
            ErrorExit();
        }
        Sleep(200);
        if (!DeppGetReg(hif, idReg2, &idData2, fFalse)) {
            printf("DeppGetReg failed\n");
            ErrorExit();
        }
        Sleep(200);
        if (!DeppGetReg(hif, idReg3, &idData3, fFalse)) {
            printf("DeppGetReg failed\n");
            ErrorExit();
        }
        Sleep(200);
        if (idData0 != 0) {
            printf("%d\n", idData0);
        }
        if (idData1 != 0) {
            printf("%d\n", idData1);
        }
        if (idData2 != 0) {
            printf("%d\n", idData2);
        }
        if (idData3 != 0) {
            printf("%d\n", idData3);
        }
    }
    return 0;
}


void DoGetReg() {

    BYTE	idReg0;
    BYTE	idReg1;
    BYTE	idReg2;
    BYTE	idReg3;

    BYTE	idData0;
    BYTE	idData1;
    BYTE	idData2;
    BYTE	idData3;

    char* szStop;

    idReg0 = (BYTE)strtol(R0, &szStop, 10);
    idReg1 = (BYTE)strtol(R1, &szStop, 10);
    idReg2 = (BYTE)strtol(R2, &szStop, 10);
    idReg3 = (BYTE)strtol(R3, &szStop, 10);
    // DEPP API Call: DeppGetReg
    /*
    if(!DeppGetReg(hif, idReg, &idData, fFalse)) {
        printf("DeppGetReg failed\n");
        ErrorExit();
    }
    */
    DeppGetReg(hif, idReg0, &idData0, fFalse);
    DeppGetReg(hif, idReg1, &idData1, fFalse);
    DeppGetReg(hif, idReg2, &idData2, fFalse);
    DeppGetReg(hif, idReg3, &idData3, fFalse);
    /*
    if (idData0 != 0) {
        printf("next\n");
    }
    if (idData1 != 0) {
        printf("pause\n");
    }
    if (idData2 != 0) {
        printf("play\n");
    }
    if (idData3 != 0) {
        printf("prev\n");
    }
    */
    printf("%d\n", idData0);
    printf("%d\n", idData1);
    printf("%d\n", idData2);
    printf("%d\n", idData3);
    
    /*
    idData0 = 0;
    idData1 = 0;
    idData2 = 0;
    idData3 = 0;
    */
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