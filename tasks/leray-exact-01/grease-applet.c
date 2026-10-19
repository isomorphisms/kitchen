/* Runtime name adapter only. The pinned Grease implementation uses its
 * inherited applet name internally. No orchestration or policy lives here. */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main(int argc, char **argv)
{
    const char *implementation=getenv("GREASE_IMPLEMENTATION");
    if (!implementation || implementation[0]!='/') {
        fputs("Missing absolute compiled Grease implementation.\n",stderr);
        return 2;
    }
    (void)argc;
    argv[0]="ysh";
    execv(implementation,argv);
    perror("Cannot execute compiled Grease implementation");
    return 2;
}
