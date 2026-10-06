/* Prebuilt runtime launcher: no shell, environment-selected interpreter,
 * source checkout, compiler, or inherited current-directory dependency. */
#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#ifndef KITCHEN_PYTHON
#define KITCHEN_PYTHON "/data/data/com.termux/files/usr/bin/python"
#endif
int main(int argc, char **argv) {
    char root[PATH_MAX], frontend[PATH_MAX], task[PATH_MAX];
    ssize_t n=readlink("/proc/self/exe", root, sizeof(root)-1);
    if (n<0 || (size_t)n>=sizeof(root)-1) {
        perror("Cannot resolve delivered executable"); return 126;
    }
    root[n]=0;
    char *slash=strrchr(root,'/');
    if (!slash) return 126;
    *slash=0; slash=strrchr(root,'/');
    if (!slash) return 126;
    *slash=0;
    if (snprintf(frontend,sizeof(frontend),"%s/lib/ithon/ithon_host.py",root)>=(int)sizeof(frontend) ||
        snprintf(task,sizeof(task),"%s/tasks/android-diagnostic.pi",root)>=(int)sizeof(task)) return 126;
    if (access(KITCHEN_PYTHON,X_OK) || access(frontend,R_OK) || access(task,R_OK)) {
        perror("Missing delivered runtime input; no compilation fallback"); return 127;
    }
    char **command=calloc((size_t)argc+4,sizeof(char *));
    if (!command) return 125;
    command[0]=KITCHEN_PYTHON; command[1]="-I"; command[2]=frontend; command[3]=task;
    for(int i=1;i<argc;i++) command[i+3]=argv[i];
    /* Preserve explicitly requested receipts, never module/interpreter shadowing. */
    unsetenv("PYTHONPATH"); unsetenv("PYTHONHOME");
    unsetenv("ITHON_PYTHON");
    execv(KITCHEN_PYTHON,command);
    perror("Cannot start delivered checked Ithon runtime"); return 126;
}
