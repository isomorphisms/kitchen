#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "frame-fixture.h"

/* Host-only fixture. Independent command observations, never device evidence.
 * Scenario lives beside this copied executable, not in inherited environment. */
int main(int argc, char **argv) {
    char path[4096], mode[128] = "valid";
    ssize_t n = readlink("/proc/self/exe", path, sizeof(path)-1);
    if (n <= 0) return 90;
    path[n] = 0;
    char *slash = strrchr(path, '/');
    if (!slash) return 90;
    strcpy(slash+1, "scenario.txt");
    FILE *f = fopen(path, "r");
    if (f) { if (!fgets(mode, sizeof(mode), f)) return 90; fclose(f); }
    mode[strcspn(mode, "\r\n")] = 0;
    const char *command = NULL;
    if (argc == 3 && !strcmp(argv[1], "-c")) command = argv[2];
    else if (argc == 5 && !strcmp(argv[1], "-s") && !strcmp(argv[3], "exec-out")) command = argv[4];
    else return 91;
    if (!strcmp(mode, "adb-server")) { fputs("cannot connect to daemon\n", stderr); return 1; }
    if (!strcmp(mode, "adb-connection")) { fputs("device offline\n", stderr); return 1; }
    if (!strcmp(mode, "service")) { fputs("Server is not running\n", stderr); return 1; }
    if (!strcmp(mode, "unauthorized")) { fputs("not authorized\n", stderr); return 1; }
    if (!strcmp(command, "/system/bin/id -u")) {
        puts(!strcmp(mode, "termux") ? "10234" : "2000"); return 0;
    }
    if (!strncmp(command, "/system/bin/cmd package", 23)) {
        puts("package:org.isomorphisms.crystal.inspect.halite");
        if (strcmp(mode, "wrong-package")) puts("package:org.isomorphisms.crystal.halite");
        return 0;
    }
    if (!strcmp(command, "/system/bin/getprop ro.product.model")) { puts("MIRO A1"); return 0; }
    if (!strcmp(command, "/system/bin/getprop ro.build.fingerprint")) { puts("fixture/firmware/one"); return 0; }
    if (!strncmp(command, "/system/bin/pm path", 19)) {
        puts("package:/data/app/fixture/base.apk"); return 0;
    }
    if (!strncmp(command, "/system/bin/toybox sha256sum", 26)) {
        if (!strcmp(mode, "swapped-apk")) puts("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb  /data/app/fixture/base.apk");
        else puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  /data/app/fixture/base.apk");
        return 0;
    }
    if (!strncmp(command, "/system/bin/dumpsys package", 26)) { puts("versionCode=2 minSdk=21"); return 0; }
    if (!strncmp(command, "/system/bin/pidof", 17)) {
        if (!strcmp(mode, "no-pid")) return 1;
        if (!strcmp(mode, "multiple-pid")) { puts("42 43"); return 0; }
        /* Count calls in private scratch: proves disappearance/change after capture. */
        strcpy(slash+1, "pid-count.txt");
        f = fopen(path, "r"); int count = 0;
        if (f) { if (fscanf(f, "%d", &count) != 1) return 92; fclose(f); }
        if (!strcmp(mode, "disappeared-pid") && count) return 1;
        f = fopen(path, "w"); if (!f) return 92;
        fprintf(f, "%d\n", count+1); fclose(f);
        puts(!strcmp(mode, "changed-pid") && count ? "43" : "42"); return 0;
    }
    if (!strncmp(command, "/system/bin/cat /proc/", 21)) {
        strcpy(slash+1, "start-count.txt");
        f = fopen(path, "r"); int count = 0;
        if (f) { if (fscanf(f, "%d", &count) != 1) return 92; fclose(f); }
        f = fopen(path, "w"); if (!f) return 92;
        fprintf(f, "%d\n", count+1); fclose(f);
        printf("42 (fixture ) with space) S");
        for (int i=0; i<18; i++) printf(" 0");
        puts(!strcmp(mode, "reused-pid") && count ? " 9877 0" : " 9876 0"); return 0;
    }
    if (strstr(command, "logcat") || strstr(command, "screencap")) {
        if (!strcmp(mode, "permission")) { fputs("Permission denied\n", stderr); return 13; }
        if (!strcmp(mode, "failed-producer")) { puts("plausible output followed by successful formatting"); return 7; }
        if (!strcmp(mode, "timeout")) { sleep(8); return 0; }
        if (!strcmp(mode, "output-limit")) {
            char block[16384]; memset(block, 'X', sizeof(block));
            for (int i=0; i<128; i++) fwrite(block, 1, sizeof(block), stdout);
            return 0;
        }
        if (!strcmp(mode, "interrupted")) { return 130; }
        if (!strcmp(mode, "empty-log")) return 0;
        if (!strcmp(mode, "zoom-missing")) { puts("unrelated log, no application state"); return 0; }
        if (!strcmp(mode, "zoom-valid") || !strcmp(mode, "zoom-stale")) {
            printf("{\"schema\":\"crystal-state-v1\",\"source_commit\":\"1111111111111111111111111111111111111111\",\"package\":\"org.isomorphisms.crystal.halite\",\"session\":\"%s\",\"replay_id\":\"frame-42\",\"gl_vendor\":\"fixture-vendor\",\"gl_renderer\":\"fixture-renderer\",\"gl_version\":\"fixture-version\",\"render_path\":\"gles2-explicit-lines\",\"geometry_result\":\"PASS\",\"camera_distance\":\"7.65\",\"camera_min\":\"2.6\",\"camera_max\":\"18\",\"clip_near\":\"0.05\",\"clip_far\":\"4000\",\"touch_count\":\"2\",\"pointer_ids\":\"7,9\",\"pinch_span\":\"100\",\"applied_zoom\":\"1\"}\n", !strcmp(mode, "zoom-stale")?"42-0":"42-9876");
            return 0;
        }
        if (strstr(command, "screencap")) {
            if (!strcmp(mode, "frame-header-only")) {
                const unsigned char corrupt[] = {137,80,78,71,13,10,26,10,0,0,0,0};
                fwrite(corrupt, 1, sizeof(corrupt), stdout);
            } else fwrite(frame_png, 1, sizeof(frame_png), stdout);
        } else puts("CrystalProducer: bounded fixture observation");
        return 0;
    }
    fprintf(stderr, "unexpected fixture command: %s\n", command); return 93;
}
