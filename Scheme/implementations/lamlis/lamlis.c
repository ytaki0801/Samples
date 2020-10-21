// femtoLisp tiny reduced version, fltr, by TAKIZAWA Yozo
// Derived from https://github.com/JeffBezanson/femtolisp/blob/master/tiny/lisp.c

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <setjmp.h>
#include <stdarg.h>
#include <ctype.h>

typedef unsigned long value_t;

typedef struct {
    value_t car;
    value_t cdr;
} cons_t;

typedef struct _symbol_t {
    value_t binding;
    value_t constant;
    struct _symbol_t *left;
    struct _symbol_t *right;
    char name[1];
} symbol_t;

#define TAG_BUILTIN  0x1
#define TAG_SYM      0x2
#define TAG_CONS     0x3
#define UNBOUND      ((value_t)TAG_SYM)
#define tag(x) ((x)&0x3)
#define ptr(x) ((void*)((x)&(~(value_t)0x3)))
#define tagptr(p,t) (((value_t)(p)) | (t))
#define intval(x)  (((int)(x))>>2)
#define builtin(n) tagptr((((int)n)<<2), TAG_BUILTIN)
#define iscons(x)    (tag(x) == TAG_CONS)
#define issymbol(x)  (tag(x) == TAG_SYM)
#define isbuiltin(x) (tag(x) == TAG_BUILTIN)
#define car(v)  (tocons((v),"car")->car)
#define cdr(v)  (tocons((v),"cdr")->cdr)
#define set(s, v)  (((symbol_t*)ptr(s))->binding = (v))
#define setc(s, v) (((symbol_t*)ptr(s))->constant = (v))

enum {
    // special forms
    F_IF=0, F_QUOTE, F_LAMBDA,
    // functions
    F_EQ, F_ATOMP, F_SET, F_CONS, F_CAR, F_CDR,
    N_BUILTINS
};
#define isspecial(v) (intval(v) <= (int)F_LAMBDA)

static char *builtin_names[] = {
    // special forms
    "if", "quote", "lambda",
    // functions
    "eq", "atom", "set", "cons", "car", "cdr"
};

static char *stack_bottom;
#define PROCESS_STACK_SIZE (2*1024*1024)
#define N_STACK 49152
static value_t Stack[N_STACK];
static u_int32_t SP = 0;
#define PUSH(v) (Stack[SP++] = (v))
#define POP()   (Stack[--SP])
#define POPN(n) (SP-=(n))

value_t FALSE, TRUE, LAMBDA, QUOTE;

value_t read_sexpr(FILE *f);
void display(FILE *f, value_t v);
value_t eval_sexpr(value_t e, value_t *penv);

jmp_buf toplevel;

void lerror(char *format, ...)
{
    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    longjmp(toplevel, 1);
}

void type_error(char *fname, char *expected, value_t got)
{
    fprintf(stderr, "%s: error: expected %s, got ", fname, expected);
    display(stderr, got); lerror("\n");
}

#define SAFECAST_OP(type,ctype,cnvt)                                          \
ctype to##type(value_t v, char *fname)                                        \
{                                                                             \
    if (is##type(v))                                                          \
        return (ctype)cnvt(v);                                                \
    type_error(fname, #type, v);                                              \
    return (ctype)0;                                                          \
}
SAFECAST_OP(cons,  cons_t*,  ptr)
SAFECAST_OP(symbol,symbol_t*,ptr)

static symbol_t *symtab = NULL;

static symbol_t *mk_symbol(char *str)
{
    symbol_t *sym;

    sym = (symbol_t*)malloc(sizeof(symbol_t) + strlen(str));
    sym->left = sym->right = NULL;
    sym->constant = sym->binding = UNBOUND;
    strcpy(&sym->name[0], str);
    return sym;
}

static symbol_t **symtab_lookup(symbol_t **ptree, char *str)
{
    int x;

    while(*ptree != NULL) {
        x = strcmp(str, (*ptree)->name);
        if (x == 0)
            return ptree;
        if (x < 0)
            ptree = &(*ptree)->left;
        else
            ptree = &(*ptree)->right;
    }
    return ptree;
}

value_t symbol(char *str)
{
    symbol_t **pnode;

    pnode = symtab_lookup(&symtab, str);
    if (*pnode == NULL)
        *pnode = mk_symbol(str);
    return tagptr(*pnode, TAG_SYM);
}

static unsigned char *fromspace;
static unsigned char *tospace;
static unsigned char *curheap;
static unsigned char *lim;
static u_int32_t heapsize = 64*1024;

void lisp_init(void)
{
    int i;

    fromspace = malloc(heapsize);
    tospace   = malloc(heapsize);
    curheap = fromspace;
    lim = curheap+heapsize-sizeof(cons_t);

    FALSE  = symbol("#f"); setc(FALSE, FALSE);
    TRUE   = symbol("#t"); setc(TRUE,  TRUE);
    LAMBDA = symbol("lambda");
    QUOTE  = symbol("quote");
    for (i=0; i < (int)N_BUILTINS; i++)
        setc(symbol(builtin_names[i]), builtin(i));
}

void gc(void);

static value_t mk_cons(void)
{
    cons_t *c;

    if (curheap > lim)
        gc();
    c = (cons_t*)curheap;
    curheap += sizeof(cons_t);
    return tagptr(c, TAG_CONS);
}

static value_t cons_(value_t *pcar, value_t *pcdr)
{
    value_t c = mk_cons();
    car(c) = *pcar; cdr(c) = *pcdr;
    return c;
}

value_t *cons(value_t *pcar, value_t *pcdr)
{
    value_t c = mk_cons();
    car(c) = *pcar; cdr(c) = *pcdr;
    PUSH(c);
    return &Stack[SP-1];
}

static value_t relocate(value_t v)
{
    value_t a, d, nc;

    if (!iscons(v))
        return v;
    if (car(v) == UNBOUND)
        return cdr(v);
    nc = mk_cons();
    a = car(v);   d = cdr(v);
    car(v) = UNBOUND; cdr(v) = nc;
    car(nc) = relocate(a);
    cdr(nc) = relocate(d);
    return nc;
}

static void trace_globals(symbol_t *root)
{
    while (root != NULL) {
        root->binding = relocate(root->binding);
        trace_globals(root->left);
        root = root->right;
    }
}

void gc(void)
{
    static int grew = 0;
    unsigned char *temp;
    u_int32_t i;

    curheap = tospace;
    lim = curheap+heapsize-sizeof(cons_t);

    for (i=0; i < SP; i++)
        Stack[i] = relocate(Stack[i]);
    trace_globals(symtab);
    temp = tospace;
    tospace = fromspace;
    fromspace = temp;

    if (grew || ((lim-curheap) < (int)(heapsize/5))) {
        temp = realloc(tospace, grew ? heapsize : heapsize*2);
        if (temp == NULL)
            lerror("out of memory\n");
        tospace = temp;
        if (!grew)
            heapsize*=2;
        grew = !grew;
    }
    if (curheap > lim) gc();
}

enum {
    TOK_NONE, TOK_LP, TOK_RP, TOK_DOT, TOK_QUOTE, TOK_SYM
};

static int symchar(char c)
{
    static char *special = "()';\\|";
    return (!isspace(c) && !strchr(special, c));
}

static u_int32_t toktype = TOK_NONE;
static value_t tokval;
static char buf[256];

static char nextchar(FILE *f)
{
    char c;
    int ch;

    do {
        ch = fgetc(f);
        if (ch == EOF)
            return 0;
        c = (char)ch;
        if (c == ';') {
            do {
                ch = fgetc(f);
                if (ch == EOF)
                    return 0;
            } while ((char)ch != '\n');
            c = (char)ch;
        }
    } while (isspace(c));
    return c;
}

static void take(void)
{
    toktype = TOK_NONE;
}

static void accumchar(char c, int *pi)
{
    buf[(*pi)++] = c;
    if (*pi >= (int)(sizeof(buf)-1))
        lerror("read: error: token too long\n");
}

static int read_token(FILE *f, char c)
{
    int i=0, ch, escaped=0, dot=(c=='.'), totread=0;

    ungetc(c, f);
    while (1) {
        ch = fgetc(f); totread++;
        if (ch == EOF)
            goto terminate;
        c = (char)ch;
        if (c == '|') {
            escaped = !escaped;
        }
        else if (c == '\\') {
            ch = fgetc(f);
            if (ch == EOF)
                goto terminate;
            accumchar((char)ch, &i);
        }
        else if (!escaped && !symchar(c)) {
            break;
        }
        else {
            accumchar(c, &i);
        }
    }
    ungetc(c, f);
 terminate:
    buf[i++] = '\0';
    return (dot && (totread==2));
}

static u_int32_t peek(FILE *f)
{
    char c;

    if (toktype != TOK_NONE)
        return toktype;
    c = nextchar(f);
    if (feof(f)) return TOK_NONE;
    if (c == '(') {
        toktype = TOK_LP;
    }
    else if (c == ')') {
        toktype = TOK_RP;
    }
    else if (c == '\'') {
        toktype = TOK_QUOTE;
    }
    else {
        if (read_token(f, c)) {
            toktype = TOK_DOT;
        }
        else {
            toktype = TOK_SYM;
            tokval = symbol(buf);
        }
    }
    return toktype;
}

static void read_list(FILE *f, value_t *pval)
{
    value_t c, *pc;
    u_int32_t t;

    PUSH(FALSE);
    pc = &Stack[SP-1];
    t = peek(f);
    while (t != TOK_RP) {
        if (feof(f))
            lerror("read: error: unexpected end of input\n");
        c = mk_cons(); car(c) = cdr(c) = FALSE;
        if (iscons(*pc))
            cdr(*pc) = c;
        else
            *pval = c;
        *pc = c;
        c = read_sexpr(f);
        car(*pc) = c;

        t = peek(f);
        if (t == TOK_DOT) {
            take();
            c = read_sexpr(f);
            cdr(*pc) = c;
            t = peek(f);
            if (feof(f))
                lerror("read: error: unexpected end of input\n");
            if (t != TOK_RP)
                lerror("read: error: expected ')'\n");
        }
    }
    take();
    (void)POP();
}

value_t read_sexpr(FILE *f)
{
    value_t v;

    switch (peek(f)) {
    case TOK_RP:
        take();
        lerror("read: error: unexpected ')'\n");
    case TOK_DOT:
        take();
        lerror("read: error: unexpected '.'\n");
    case TOK_SYM:
        take();
        return tokval;
    case TOK_QUOTE:
        take();
        v = read_sexpr(f);
        PUSH(v);
        v = cons_(&QUOTE, cons(&Stack[SP-1], &FALSE));
        POPN(2);
        return v;
    case TOK_LP:
        take();
        PUSH(FALSE);
        read_list(f, &Stack[SP-1]);
        return POP();
    }
    return FALSE;
}

void display(FILE *f, value_t v)
{
    value_t cd;

    switch (tag(v)) {
    case TAG_SYM: fprintf(f, "%s", ((symbol_t*)ptr(v))->name); break;
    case TAG_BUILTIN: fprintf(f, "#<builtin %s>",
                              builtin_names[intval(v)]); break;
    case TAG_CONS:
        fprintf(f, "(");
        while (1) {
            display(f, car(v));
            cd = cdr(v);
            if (!iscons(cd)) {
                if (cd != FALSE) {
                    fprintf(f, " . ");
                    display(f, cd);
                }
                fprintf(f, ")");
                break;
            }
            fprintf(f, " ");
            v = cd;
        }
        break;
    }
}

static inline void argcount(char *fname, int nargs, int c)
{
    if (nargs != c)
        lerror("%s: error: too %s arguments\n", fname, nargs<c ? "few":"many");
}

#define eval(e, env) ((tag(e)<0x2) ? (e) : eval_sexpr((e),env))
#define tail_eval(xpr, env) do { SP = saveSP;  \
    if (tag(xpr)<0x2) { return (xpr); } \
    else { e=(xpr); *penv=(env); goto eval_top; } } while (0)

value_t eval_sexpr(value_t e, value_t *penv)
{
    value_t f, v, bind, headsym, asym, labl=0, *argsyms, *body, *lenv;
    value_t *rest;
    symbol_t *sym;
    u_int32_t saveSP;
    int nargs, noeval=0;

 eval_top:
    if (issymbol(e)) {
        sym = (symbol_t*)ptr(e);
        if (sym->constant != UNBOUND) return sym->constant;
        v = *penv;
        while (iscons(v)) {
            bind = car(v);
            if (iscons(bind) && car(bind) == e)
                return cdr(bind);
            v = cdr(v);
        }
        if ((v = sym->binding) == UNBOUND)
            lerror("eval: error: variable %s has no value\n", sym->name);
        return v;
    }
    if ((unsigned long)(char*)&nargs < (unsigned long)stack_bottom || SP>=(N_STACK-100))
        lerror("eval: error: stack overflow\n");
    saveSP = SP;
    PUSH(e);
    PUSH(*penv);
    f = eval(car(e), penv);
    *penv = Stack[saveSP+1];
    if (isbuiltin(f)) {
        if (!isspecial(f)) {
            v = Stack[saveSP] = cdr(Stack[saveSP]);
            while (iscons(v)) {
                v = eval(car(v), penv);
                *penv = Stack[saveSP+1];
                PUSH(v);
                v = Stack[saveSP] = cdr(Stack[saveSP]);
            }
        }
        nargs = SP - saveSP - 2;
        switch (intval(f)) {
        case F_QUOTE:
            v = cdr(Stack[saveSP]);
            if (!iscons(v))
                lerror("quote: error: expected argument\n");
            v = car(v);
            break;
        case F_LAMBDA:
            v = Stack[saveSP];
            if (*penv != FALSE) {
                v = cdr(v);
                PUSH(car(v));
                argsyms = &Stack[SP-1];
                PUSH(car(cdr(v)));
                body = &Stack[SP-1];
                v = cons_(&LAMBDA, cons(argsyms, cons(body, penv)));
            }
            break;
        case F_IF:
            v = car(cdr(Stack[saveSP]));
            if (eval(v, penv) != FALSE)
                v = car(cdr(cdr(Stack[saveSP])));
            else
                v = car(cdr(cdr(cdr(Stack[saveSP]))));
            tail_eval(v, Stack[saveSP+1]);
            break;
        case F_SET:
            argcount("set", nargs, 2);
            e = Stack[SP-2];
            v = *penv;
            tosymbol(e, "set")->binding = (v=Stack[SP-1]);
	    v = TRUE;
            break;
        case F_EQ:
            argcount("eq", nargs, 2);
            v = ((Stack[SP-2] == Stack[SP-1]) ? TRUE : FALSE);
            break;
        case F_CONS:
            argcount("cons", nargs, 2);
            v = mk_cons();
            car(v) = Stack[SP-2];
            cdr(v) = Stack[SP-1];
            break;
        case F_CAR:
            argcount("car", nargs, 1);
            v = car(Stack[SP-1]);
            break;
        case F_CDR:
            argcount("cdr", nargs, 1);
            v = cdr(Stack[SP-1]);
            break;
        case F_ATOMP:
            argcount("atom", nargs, 1);
            v = ((!iscons(Stack[SP-1])) ? TRUE : FALSE);
            break;
        }
        SP = saveSP;
        return v;
    }
    else {
        v = Stack[saveSP] = cdr(Stack[saveSP]);
    }
    if (iscons(f)) {
        headsym = car(f);
        PUSH(cdr(cdr(cdr(f))));
        lenv = &Stack[SP-1];
        PUSH(car(cdr(f)));
        argsyms = &Stack[SP-1];
        PUSH(car(cdr(cdr(f))));
        body = &Stack[SP-1];
        if (labl) {
            PUSH(labl);
            PUSH(car(cdr(labl)));
            *lenv = cons_(cons(&Stack[SP-1], &Stack[SP-2]), lenv);
            POPN(3);
            v = Stack[saveSP];
        }
        if (headsym != LAMBDA)
            lerror("apply: error: head must be lambda\n");
        while (iscons(v)) {
            if (!iscons(*argsyms)) {
                if (*argsyms == FALSE)
                    lerror("apply: error: too many arguments\n");
                break;
            }
            asym = car(*argsyms);
            if (!issymbol(asym))
                lerror("apply: error: formal argument not a symbol\n");
            v = car(v);
            if (!noeval) {
                v = eval(v, penv);
                *penv = Stack[saveSP+1];
            }
            PUSH(v);
            *lenv = cons_(cons(&asym, &Stack[SP-1]), lenv);
            POPN(2);
            *argsyms = cdr(*argsyms);
            v = Stack[saveSP] = cdr(Stack[saveSP]);
        }
        if (*argsyms != FALSE) {
            if (issymbol(*argsyms)) {
                if (noeval) {
                    *lenv = cons_(cons(argsyms, &Stack[saveSP]), lenv);
                }
                else {
                    PUSH(FALSE);
                    PUSH(FALSE);
                    rest = &Stack[SP-1];
                    while (iscons(v)) {
                        v = eval(car(v), penv);
                        *penv = Stack[saveSP+1];
                        PUSH(v);
                        v = cons_(&Stack[SP-1], &FALSE);
                        (void)POP();
                        if (iscons(*rest))
                            cdr(*rest) = v;
                        else
                            Stack[SP-2] = v;
                        *rest = v;
                        v = Stack[saveSP] = cdr(Stack[saveSP]);
                    }
                    *lenv = cons_(cons(argsyms, &Stack[SP-2]), lenv);
                }
            }
            else if (iscons(*argsyms)) {
                lerror("apply: error: too few arguments\n");
            }
        }
        noeval = 0;
        tail_eval(*body, *lenv);
    }
    type_error("apply", "function", f);
    return FALSE;
}

value_t toplevel_eval(value_t expr)
{
    value_t v;
    u_int32_t saveSP = SP;
    PUSH(FALSE);
    v = eval(expr, &Stack[SP-1]);
    SP = saveSP;
    return v;
}

int main(int argc, char* argv[])
{
    value_t v;

    stack_bottom = ((char*)&v) - PROCESS_STACK_SIZE;
    lisp_init();
    if (setjmp(toplevel)) {
        SP = 0;
        fprintf(stderr, "\n");
        goto repl;
    }
 repl:
    while (1) {
        printf("lamlis> ");
        v = read_sexpr(stdin);
        if (feof(stdin)) break;
        v = toplevel_eval(v);
        display(stdout, v);
        set(symbol("that"), v);
        printf("\n");
    }
    return 0;
}
