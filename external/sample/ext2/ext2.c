#include <stdlib.h>
#include <stdio.h>

#include "foo/foo.h"
#include "ext1.h"
#include "ext2.h"

void ext2() {
    printf("Ext2 called\n");
    foo();
    ext1();
}
