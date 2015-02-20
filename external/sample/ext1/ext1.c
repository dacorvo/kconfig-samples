#include <stdlib.h>
#include <stdio.h>

#include "foo/foo.h"

void ext1() {
    printf("Ext1 called\n");
    foo();
}
