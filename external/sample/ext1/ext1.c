#include <stdlib.h>
#include <stdio.h>

#include "foo/foo.h"
#include "ext1.h"

void ext1() {
    printf("Ext1 called\n");
    foo();
}
