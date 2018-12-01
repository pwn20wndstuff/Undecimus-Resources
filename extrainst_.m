#include <sys/wait.h>
#include <spawn.h>
#include <mach/error.h>

int main(int argc, char **argv, char **envp) {

    NSArray<NSString*> *resources = [NSArray arrayWithContentsOfFile:@"/usr/share/undecimus/injectme.plist"];
    if (resources.count < 1)
        return 0;

    char *args[resources.count + 2];
    int i=1;
    args[0] = "/usr/bin/inject";
    for (NSString *resource in resources) {
        char *path = (char *)resource.UTF8String;
        if (access(path, F_OK) == ERR_SUCCESS) {
            args[i++] = path;
        } else {
            fprintf(stderr, "Resource to inject: \"%s\" does not exist", path);
        }
    }
    args[i] = NULL;
    pid_t child;
    if (posix_spawn(&child, "/usr/bin/inject", NULL, NULL, args, envp) != 0) {
        fprintf(stderr, "unable to spawn /usr/bin/inject");
        return 1;
    }
    int stat;
    waitpid(child, &stat, 0);
    int rv = system("/bin/launchctl stop jailbreakd");
    return WEXITSTATUS(rv);
}

// vim:ft=objc
