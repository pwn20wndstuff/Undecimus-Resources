#include <sys/wait.h>
#include <spawn.h>
#include <mach/error.h>

void finish(const char *action) {
    if (action == NULL)
        return;

    const char *cydia = getenv("CYDIA");

    if (cydia == NULL)
        return;

    int fd = [[[[NSString stringWithUTF8String:cydia] componentsSeparatedByString:@" "] objectAtIndex:0] intValue];

    FILE *fout = fdopen(fd, "w");
    fprintf(fout, "finish:%s\n", action);
    fclose(fout);
}


int main(int argc, char **argv, char **envp) {
    int rv;

    NSArray<NSString*> *resources = [NSArray arrayWithContentsOfFile:@"/usr/share/jailbreak/injectme.plist"];
    if (resources.count > 0) {
        char *args[resources.count + 2];
        int i=1;
        args[0] = "/usr/bin/inject";
        for (NSString *resource in resources) {
            char *path = (char *)resource.UTF8String;
            if (access(path, F_OK) == ERR_SUCCESS) {
                args[i++] = path;
            } else {
                fprintf(stderr, "Resource to inject: \"%s\" does not exist\n", path);
            }
        }
        args[i] = NULL;
        pid_t child;
        if (posix_spawn(&child, "/usr/bin/inject", NULL, NULL, args, envp) != 0) {
            fprintf(stderr, "unable to spawn /usr/bin/inject: reboot\n");
            finish("reboot");
            return 0;
        }
        int stat;
        waitpid(child, &stat, 0);
    }
    rv = system("/usr/libexec/substrate");
    if (WEXITSTATUS(rv) != 0) {
        fprintf(stderr, "unable to restart substrate: reboot\n");
        finish("reboot");
    }
    return 0;
}

// vim:ft=objc
