#include <stdio.h>
#include <windows.h>
#include <string.h>

// Farben
#define ROT   FOREGROUND_RED | FOREGROUND_INTENSITY
#define GRUEN FOREGROUND_GREEN
#define GELB  (FOREGROUND_RED | FOREGROUND_GREEN)
#define WEISS (FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE)

void setFarbe(int farbe) {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), farbe);
}

// Verdächtige Muster die wir suchen
const char* muster[] = {
    "EICAR",
    "virus",
    "malware",
    "ransomware",
    "keylogger",
    "trojan",
    "DeleteFile",
    "FORMAT C:",
    NULL  // Ende der Liste
};

// Verdächtige Dateiendungen
const char* gefahrEndungen[] = {
    ".bat", ".vbs", ".ps1", ".cmd", NULL
};

void druckeHeader() {
    setFarbe(GELB);
    printf("=====================================\n");
    printf("    SassanidOS AntiVirus v2.0\n");
    printf("       von SassanidBytes\n");
    printf("=====================================\n\n");
    setFarbe(WEISS);
}

// Prüft ob Dateiname verdächtige Endung hat
int istGefahrEndung(const char* dateiname) {
    for (int i = 0; gefahrEndungen[i] != NULL; i++) {
        int nLen = strlen(dateiname);
        int eLen = strlen(gefahrEndungen[i]);
        if (nLen > eLen) {
            // Vergleiche das Ende des Dateinamens
            if (_stricmp(dateiname + nLen - eLen, gefahrEndungen[i]) == 0) {
                return 1;
            }
        }
    }
    return 0;
}

// Schaut in die Datei rein und sucht Muster
int scanneDateiInhalt(const char* pfad) {
    FILE* f = fopen(pfad, "rb");
    if (!f) return 0;

    char puffer[1024];
    int gefunden = 0;

    while (fread(puffer, 1, sizeof(puffer), f) > 0) {
        for (int i = 0; muster[i] != NULL; i++) {
            if (strstr(puffer, muster[i]) != NULL) {
                setFarbe(ROT);
                printf("    !! Verdaechtiges Muster gefunden: \"%s\"\n", muster[i]);
                setFarbe(WEISS);
                gefunden = 1;
            }
        }
    }

    fclose(f);
    return gefunden;
}

int gesamtDateien = 0;
int gesamtVerdaechtig = 0;

void scanneOrdner(const char* pfad) {
    WIN32_FIND_DATA datei;
    HANDLE suche;
    char suchPfad[MAX_PATH];
    char vollPfad[MAX_PATH];

    snprintf(suchPfad, MAX_PATH, "%s\\*", pfad);
    suche = FindFirstFile(suchPfad, &datei);

    if (suche == INVALID_HANDLE_VALUE) {
        setFarbe(ROT);
        printf("[FEHLER] Ordner nicht gefunden: %s\n", pfad);
        setFarbe(WEISS);
        return;
    }

    do {
        if (strcmp(datei.cFileName, ".") == 0 ||
            strcmp(datei.cFileName, "..") == 0) continue;

        snprintf(vollPfad, MAX_PATH, "%s\\%s", pfad, datei.cFileName);

        if (datei.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
            setFarbe(GELB);
            printf("[ORDNER] %s\n", vollPfad);
            setFarbe(WEISS);
            // Unterordner auch scannen!
            scanneOrdner(vollPfad);
        } else {
            gesamtDateien++;
            int verdaechtig = 0;

            // Endung prüfen
            if (istGefahrEndung(datei.cFileName)) {
                setFarbe(ROT);
                printf("[WARNUNG] Verdaechtige Endung: %s\n", vollPfad);
                setFarbe(WEISS);
                verdaechtig = 1;
            }

            // Inhalt prüfen
            if (scanneDateiInhalt(vollPfad)) {
                if (!verdaechtig) {
                    setFarbe(ROT);
                    printf("[WARNUNG] %s\n", vollPfad);
                }
                verdaechtig = 1;
            }

            if (!verdaechtig) {
                setFarbe(GRUEN);
                printf("[OK]      %s\n", datei.cFileName);
                setFarbe(WEISS);
            } else {
                gesamtVerdaechtig++;
            }
        }

    } while (FindNextFile(suche, &datei));

    FindClose(suche);
}

int main(int argc, char* argv[]) {
    druckeHeader();

    const char* pfad = (argc >= 2) ? argv[1] : ".";
    printf("[*] Scanne: %s\n\n", pfad);

    scanneOrdner(pfad);

    printf("\n=====================================\n");
    printf("  Dateien gescannt : %d\n", gesamtDateien);

    if (gesamtVerdaechtig > 0) {
        setFarbe(ROT);
        printf("  Bedrohungen      : %d  << ACHTUNG!\n", gesamtVerdaechtig);
    } else {
        setFarbe(GRUEN);
        printf("  Bedrohungen      : 0  Alles sauber!\n");
    }

    setFarbe(WEISS);
    printf("=====================================\n");
    printf("\nDruecke ENTER zum Beenden...\n");
    getchar();
    return 0;
}
