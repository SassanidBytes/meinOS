#include <stdio.h>
#include <windows.h>
#include <string.h>

// Farben für die Konsole
#define ROT   FOREGROUND_RED
#define GRUEN (FOREGROUND_GREEN)
#define GELB  (FOREGROUND_RED | FOREGROUND_GREEN)
#define WEISS (FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE)

void setFarbe(int farbe) {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), farbe);
}

void druckeHeader() {
    setFarbe(GELB);
    printf("╔══════════════════════════════════╗\n");
    printf("║     SassanidOS AntiVirus v1.0    ║\n");
    printf("║         von SassanidBytes        ║\n");
    printf("╚══════════════════════════════════╝\n\n");
    setFarbe(WEISS);
}

void scanneOrdner(const char* pfad) {
    WIN32_FIND_DATA datei;
    HANDLE suche;
    char suchPfad[MAX_PATH];
    int anzahl = 0;

    // Suchpfad zusammenbauen z.B. "C:\Test\*"
    snprintf(suchPfad, MAX_PATH, "%s\\*", pfad);

    suche = FindFirstFile(suchPfad, &datei);

    if (suche == INVALID_HANDLE_VALUE) {
        setFarbe(ROT);
        printf("[FEHLER] Ordner nicht gefunden: %s\n", pfad);
        setFarbe(WEISS);
        return;
    }

    printf("[*] Scanne: %s\n\n", pfad);

    do {
        // Versteckte Systemordner überspringen
        if (strcmp(datei.cFileName, ".") == 0 ||
            strcmp(datei.cFileName, "..") == 0) {
            continue;
        }

        // Dateigröße berechnen
        LARGE_INTEGER groesse;
        groesse.LowPart  = datei.nFileSizeLow;
        groesse.HighPart = datei.nFileSizeHigh;

        if (datei.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
            // Unterordner
            setFarbe(GELB);
            printf("  [ORDNER] %s\n", datei.cFileName);
        } else {
            // Normale Datei
            setFarbe(GRUEN);
            printf("  [OK] %-30s  %lld Bytes\n",
                   datei.cFileName, groesse.QuadPart);
        }

        setFarbe(WEISS);
        anzahl++;

    } while (FindNextFile(suche, &datei));

    FindClose(suche);

    printf("\n");
    setFarbe(GELB);
    printf("[✓] Scan abgeschlossen. %d Dateien gefunden.\n", anzahl);
    setFarbe(WEISS);
}

int main(int argc, char* argv[]) {
    druckeHeader();

    if (argc < 2) {
        // Kein Pfad angegeben → aktuellen Ordner scannen
        printf("[INFO] Kein Pfad angegeben. Scanne aktuellen Ordner...\n\n");
        scanneOrdner(".");
    } else {
        scanneOrdner(argv[1]);
    }

    printf("\nDrücke ENTER zum Beenden...\n");
    getchar();
    return 0;
}
