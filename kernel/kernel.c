void main() {
    char* video = (char*) 0xB8000;
    char* msg = "SassanidOS Kernel geladen!";
    int i = 0;
    
    while(msg[i] != 0) {
        video[i*2]   = msg[i];
        video[i*2+1] = 0x1F;
        i++;
    }
    
    while(1);
}
