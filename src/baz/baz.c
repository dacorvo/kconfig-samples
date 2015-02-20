#include <stdlib.h>
#include <stdio.h>

#include "autoconf.h"

#include "bar/bar.h"
#ifdef CONFIG_BAZ_QUX
#include "baz/qux/qux.h"
#endif

void baz() {
    printf("Baz called\n");
    bar();
#ifdef CONFIG_BAZ_QUX
    qux();
#endif
}
