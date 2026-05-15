void main() {
    char* video = (char*) 0xB8000;
    
    // Bildschirm leeren
    for(int i = 0; i < 80*25*2; i+=2) {
        video[i]   = ' ';
        video[i+1] = 0x1F;
    }

    // Text anzeigen
    char* msg = "KERNEL GELADEN! SassanidOS v0.1";
    int i = 0;
    while(msg[i] != 0) {
        video[i*2]   = msg[i];
        video[i*2+1] = 0x1F;
        i++;
    }

    while(1);
}
