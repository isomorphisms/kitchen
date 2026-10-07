/* HOST_FIXTURE only. Implements the provisional adapter protocol independently
 * of Kitchen's wrapper; it is not a Cat Food installer or validator. */
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

static const char *arg(int argc, char **argv, const char *key) {
    for (int i=2; i+1<argc; i+=2) if (!strcmp(argv[i],key)) return argv[i+1];
    return "";
}
static int contents(const char *path, char *data, size_t size) {
    FILE *f=fopen(path,"r"); if (!f) return 0;
    size_t n=fread(data,1,size-1,f); data[n]=0; fclose(f); return 1;
}
int main(int argc, char **argv) {
    if (argc<2) return 90;
    const char *stage=argv[1];
    char scenario[128], location[512];
    if (!contents(arg(argc,argv,"--profile"),scenario,sizeof(scenario))) return 91;
    scenario[strcspn(scenario,"\r\n")]=0;
    if (!contents(arg(argc,argv,"--location"),location,sizeof(location))) return 91;
    if (!strcmp(stage,"admission")) {
        if (!strcmp(scenario,"wrong-handset")) { fputs("WRONG_HANDSET\n",stderr); return 7; }
        if (!strcmp(scenario,"wrong-abi")) { fputs("WRONG_ABI\n",stderr); return 7; }
        if (!strcmp(scenario,"stale-profile")) { fputs("STALE_PROFILE\n",stderr); return 7; }
        if (!strcmp(scenario,"signer-refusal")) { fputs("SIGNER_REFUSAL\n",stderr); return 7; }
        if (!strcmp(scenario,"downgrade-refusal")) { fputs("DOWNGRADE_REFUSAL\n",stderr); return 7; }
        if (!strncmp(location,"path\tcontent://",15)) { fputs("URI_IS_NOT_PATH\n",stderr); return 7; }
        if (!strcmp(scenario,"mutant-admission-exit-zero")) return 0;
    }
    if (!strcmp(stage,"executor")) {
        if (!strcmp(scenario,"timeout")) { sleep(8); return 0; }
        char effects[4096];
        snprintf(effects,sizeof(effects),"%s.effects",arg(argc,argv,"--output"));
        FILE *effect=fopen(effects,"w"); if (!effect) return 92;
        fputs("fixture-owner-called; no actual Android effects\n",effect); fclose(effect);
        if (!strcmp(scenario,"executor-changes-input")) {
            const char *plan=arg(argc,argv,"--plan");
            if (chmod(plan,0600)) return 92;
            FILE *changed=fopen(plan,"a"); if (!changed) return 92;
            fputs("changed\n",changed); fclose(changed);
        }
        if (!strcmp(scenario,"install-failed")) { puts("plausible partial install output"); return 23; }
        if (!strcmp(scenario,"partial-receipt")) { FILE *f=fopen(arg(argc,argv,"--output"),"w"); if (!f) return 92; fputs("state\tINCOMPLETE\n",f); fclose(f); return 0; }
    }
    if (!strcmp(stage,"validator")) {
        if (!strcmp(scenario,"validator-failed")) return 29;
        if (!strcmp(scenario,"mutant-validator-exit-zero")) return 0;
        char owner[4096];
        if (!contents(arg(argc,argv,"--owner-receipt"),owner,sizeof(owner))) return 93;
        if (!strstr(owner,"state\tCOMPLETED\n")) return 93;
        if (!strcmp(scenario,"validator-rewrites-owner")) {
            const char *receipt=arg(argc,argv,"--owner-receipt");
            if (chmod(receipt,0600)) return 92;
            FILE *changed=fopen(receipt,"a"); if (!changed) return 92;
            fputs("changed\tbytes\n",changed); fclose(changed);
        }
    }
    FILE *f=fopen(arg(argc,argv,"--output"),"w"); if (!f) return 92;
    const char *state=!strcmp(stage,"admission")?"ADMITTED":!strcmp(stage,"executor")?"COMPLETED":"VALIDATED";
    fprintf(f,"schema\tkitchen-owner-%s-fixture-v1\nstate\t%s\noperation\t%s\n",stage,state,arg(argc,argv,"--operation"));
    const char *keys[]={"contract","plan","profile","requirements","runtime","location"};
    for (size_t i=0;i<sizeof(keys)/sizeof(keys[0]);i++) {
        char option[128]; snprintf(option,sizeof(option),"--%s-sha256",keys[i]);
        const char *value=arg(argc,argv,option);
        if (!strcmp(scenario,"wrong-receipt") && !strcmp(stage,"executor") && !strcmp(keys[i],"plan")) value="wrong";
        fprintf(f,"%s_sha256\t%s\n",keys[i],value);
    }
    fclose(f); return 0;
}
