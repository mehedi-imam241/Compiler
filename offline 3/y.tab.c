/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<vector>
#include "symbolTablePackage/globals.h"
#include "symbolTablePackage/symbolTable.cpp"
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
FILE* error_out;

symbolTable table;

int errCounter = 0;
string lastDeclaredType;

void yyerror(char *s)
{	
	fprintf(error_out, "line no. %d: Error no. %d found\n%s\n", line_count, errCounter, s);
    errCounter++;
}



#line 100 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PRINTLN = 258,
    IF = 259,
    ELSE = 260,
    FOR = 261,
    DO = 262,
    INT = 263,
    FLOAT = 264,
    VOID = 265,
    DEFAULT = 266,
    SWITCH = 267,
    WHILE = 268,
    BREAK = 269,
    CHAR = 270,
    DOUBLE = 271,
    RETURN = 272,
    CASE = 273,
    CONTINUE = 274,
    INCOP = 275,
    DECOP = 276,
    ASSIGNOP = 277,
    NOT = 278,
    LPAREN = 279,
    RPAREN = 280,
    LCURL = 281,
    RCURL = 282,
    LTHIRD = 283,
    RTHIRD = 284,
    COMMA = 285,
    SEMICOLON = 286,
    COMMENT = 287,
    ADDOP = 288,
    MULOP = 289,
    RELOP = 290,
    LOGICOP = 291,
    BITOP = 292,
    CONST_CHAR = 293,
    CONST_INT = 294,
    CONST_FLOAT = 295,
    ID = 296,
    STRING = 297,
    LOWER_THAN_ELSE = 298
  };
#endif
/* Tokens.  */
#define PRINTLN 258
#define IF 259
#define ELSE 260
#define FOR 261
#define DO 262
#define INT 263
#define FLOAT 264
#define VOID 265
#define DEFAULT 266
#define SWITCH 267
#define WHILE 268
#define BREAK 269
#define CHAR 270
#define DOUBLE 271
#define RETURN 272
#define CASE 273
#define CONTINUE 274
#define INCOP 275
#define DECOP 276
#define ASSIGNOP 277
#define NOT 278
#define LPAREN 279
#define RPAREN 280
#define LCURL 281
#define RCURL 282
#define LTHIRD 283
#define RTHIRD 284
#define COMMA 285
#define SEMICOLON 286
#define COMMENT 287
#define ADDOP 288
#define MULOP 289
#define RELOP 290
#define LOGICOP 291
#define BITOP 292
#define CONST_CHAR 293
#define CONST_INT 294
#define CONST_FLOAT 295
#define ID 296
#define STRING 297
#define LOWER_THAN_ELSE 298

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 32 "parser.y"

	symbolINfo *smbl;

#line 242 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  11
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   159

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  44
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  26
/* YYNRULES -- Number of rules.  */
#define YYNRULES  66
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  118

#define YYUNDEFTOK  2
#define YYMAXUTOK   298


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    57,    57,    68,    77,    88,    97,   106,   117,   141,
     166,   166,   202,   202,   228,   244,   255,   267,   280,   289,
     300,   311,   323,   336,   351,   382,   415,   448,   486,   495,
     505,   514,   523,   532,   543,   554,   565,   576,   580,   591,
     600,   611,   626,   646,   657,   698,   709,   722,   733,   746,
     757,   778,   789,   810,   821,   832,   845,   856,   868,   879,
     890,   901,   912,   925,   934,   937,   946
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "PRINTLN", "IF", "ELSE", "FOR", "DO",
  "INT", "FLOAT", "VOID", "DEFAULT", "SWITCH", "WHILE", "BREAK", "CHAR",
  "DOUBLE", "RETURN", "CASE", "CONTINUE", "INCOP", "DECOP", "ASSIGNOP",
  "NOT", "LPAREN", "RPAREN", "LCURL", "RCURL", "LTHIRD", "RTHIRD", "COMMA",
  "SEMICOLON", "COMMENT", "ADDOP", "MULOP", "RELOP", "LOGICOP", "BITOP",
  "CONST_CHAR", "CONST_INT", "CONST_FLOAT", "ID", "STRING",
  "LOWER_THAN_ELSE", "$accept", "start", "program", "unit",
  "func_declaration", "func_definition", "$@1", "$@2", "parameter_list",
  "compound_statement", "var_declaration", "type_specifier",
  "declaration_list", "statements", "statement", "expression_statement",
  "variable", "expression", "logic_expression", "rel_expression",
  "simple_expression", "term", "unary_expression", "factor",
  "argument_list", "arguments", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298
};
# endif

#define YYPACT_NINF (-63)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  ((Yyn) == YYTABLE_NINF)

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     125,   -63,   -63,   -63,    10,   125,   -63,   -63,   -63,   -63,
     -16,   -63,   -63,     3,    46,    -2,     0,    11,   -63,    29,
      -1,    23,    41,    51,   -63,    67,    64,   125,   -63,   -63,
      58,     9,   -63,   -63,    67,    61,    70,    83,    85,    89,
      96,    91,    91,    91,   -63,   -63,    91,   -63,   -63,    31,
     -63,   -63,    84,    65,   -63,   -63,   116,    95,   -63,   103,
      28,   106,   -63,   -63,   -63,   -63,   -63,   100,    91,    88,
      91,   111,   102,   -63,   118,   -63,    91,    91,   117,   -63,
     -63,   -63,   -63,    91,   -63,    91,    91,    91,    91,   119,
     121,    88,   122,   -63,   -63,   -63,   123,   120,   124,   -63,
     -63,   106,   126,   -63,   127,    77,    91,    77,   -63,    91,
     -63,   -63,   144,   129,   -63,   -63,    77,   -63
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,    21,    22,    23,     0,     2,     4,     6,     7,     5,
       0,     1,     3,    26,     0,     0,     0,     0,    20,    12,
       0,    17,     0,    24,     9,     0,    10,     0,    16,    27,
       0,     0,    13,     8,     0,    15,     0,     0,     0,     0,
       0,     0,     0,     0,    19,    39,     0,    59,    60,    41,
      32,    30,     0,     0,    28,    31,    56,     0,    43,    45,
      47,    49,    51,    55,    11,    14,    25,     0,     0,     0,
       0,     0,    56,    54,     0,    53,    64,     0,    26,    18,
      29,    61,    62,     0,    40,     0,     0,     0,     0,     0,
       0,     0,     0,    38,    58,    66,     0,    63,     0,    44,
      46,    50,    48,    52,     0,     0,     0,     0,    57,     0,
      42,    37,    34,     0,    36,    65,     0,    33
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -63,   -63,   -63,   146,   -63,   -63,   -63,   -63,   -63,   -14,
      53,    57,   -63,   -63,   -51,   -53,   -42,   -40,   -62,    71,
      68,    66,   -37,   -63,   -63,   -63
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     4,     5,     6,     7,     8,    34,    25,    20,    50,
      51,    52,    14,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    96,    97
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      72,    71,    80,    74,    72,    73,     1,     2,     3,    75,
      11,    32,    37,    38,    95,    39,    91,     1,     2,     3,
      64,    99,    40,    19,    26,    13,    41,    15,    90,    27,
      92,    16,    42,    43,    72,    31,    44,    98,   106,    22,
      45,    72,    46,    72,    72,    72,    72,   115,    47,    48,
      49,   103,    23,     9,   112,    76,   114,    10,     9,    77,
      24,    86,    10,    87,    28,   117,   113,    72,    37,    38,
      29,    39,    21,     1,     2,     3,    17,    18,    40,    30,
      37,    38,    41,    39,    35,     1,     2,     3,    42,    43,
      40,    31,    79,    31,    41,    33,    45,    36,    46,    66,
      42,    43,    65,    31,    47,    48,    49,    67,    45,    68,
      46,    42,    43,    69,    42,    43,    47,    48,    49,    45,
      70,    46,    81,    82,    46,    78,    84,    47,    48,    49,
      47,    48,    49,     1,     2,     3,    81,    82,    83,    85,
      88,    89,    93,    94,   104,    16,   105,   107,   108,    -1,
     109,    12,   101,   110,   116,   102,   100,     0,   111,    86
};

static const yytype_int8 yycheck[] =
{
      42,    41,    53,    43,    46,    42,     8,     9,    10,    46,
       0,    25,     3,     4,    76,     6,    69,     8,     9,    10,
      34,    83,    13,    25,    25,    41,    17,    24,    68,    30,
      70,    28,    23,    24,    76,    26,    27,    77,    91,    39,
      31,    83,    33,    85,    86,    87,    88,   109,    39,    40,
      41,    88,    41,     0,   105,    24,   107,     0,     5,    28,
      31,    33,     5,    35,    41,   116,   106,   109,     3,     4,
      29,     6,    15,     8,     9,    10,    30,    31,    13,    28,
       3,     4,    17,     6,    27,     8,     9,    10,    23,    24,
      13,    26,    27,    26,    17,    31,    31,    39,    33,    29,
      23,    24,    41,    26,    39,    40,    41,    24,    31,    24,
      33,    23,    24,    24,    23,    24,    39,    40,    41,    31,
      24,    33,    20,    21,    33,    41,    31,    39,    40,    41,
      39,    40,    41,     8,     9,    10,    20,    21,    22,    36,
      34,    41,    31,    25,    25,    28,    25,    25,    25,     5,
      30,     5,    86,    29,    25,    87,    85,    -1,    31,    33
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     8,     9,    10,    45,    46,    47,    48,    49,    54,
      55,     0,    47,    41,    56,    24,    28,    30,    31,    25,
      52,    55,    39,    41,    31,    51,    25,    30,    41,    29,
      28,    26,    53,    31,    50,    55,    39,     3,     4,     6,
      13,    17,    23,    24,    27,    31,    33,    39,    40,    41,
      53,    54,    55,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    53,    41,    29,    24,    24,    24,
      24,    61,    60,    66,    61,    66,    24,    28,    41,    27,
      58,    20,    21,    22,    31,    36,    33,    35,    34,    41,
      61,    59,    61,    31,    25,    62,    68,    69,    61,    62,
      63,    65,    64,    66,    25,    25,    59,    25,    25,    30,
      29,    31,    58,    61,    58,    62,    25,    58
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    44,    45,    46,    46,    47,    47,    47,    48,    48,
      50,    49,    51,    49,    52,    52,    52,    52,    53,    53,
      54,    55,    55,    55,    56,    56,    56,    56,    57,    57,
      58,    58,    58,    58,    58,    58,    58,    58,    58,    59,
      59,    60,    60,    61,    61,    62,    62,    63,    63,    64,
      64,    65,    65,    66,    66,    66,    67,    67,    67,    67,
      67,    67,    67,    68,    68,    69,    69
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     6,     5,
       0,     7,     0,     6,     4,     3,     2,     1,     3,     2,
       3,     1,     1,     1,     3,     6,     1,     4,     1,     2,
       1,     1,     1,     7,     5,     7,     5,     5,     3,     1,
       2,     1,     4,     1,     3,     1,     3,     1,     3,     1,
       3,     1,     3,     2,     2,     1,     1,     4,     3,     1,
       1,     2,     2,     1,     0,     3,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 58 "parser.y"
        {
		fprintf(logout,"line no. %d: start : program\n\n",line_count);

		symbolINfo *s = new symbolINfo((yyvsp[0].smbl)->getName(), "start");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());
	}
#line 1515 "y.tab.c"
    break;

  case 3:
#line 69 "parser.y"
        {
		fprintf(logout,"line no. %d: program : program unit\n\n",line_count);

		(yyvsp[-1].smbl)->setName((yyvsp[-1].smbl)->getName() + "\n" + (yyvsp[0].smbl)->getName());
		fprintf(logout, "%s\n\n", (yyvsp[-1].smbl)->getName().c_str());

		(yyval.smbl)=(yyvsp[-1].smbl);
	}
#line 1528 "y.tab.c"
    break;

  case 4:
#line 78 "parser.y"
        {
		fprintf(logout,"line no. %d: program : unit\n\n",line_count);

		symbolINfo *s = new symbolINfo((yyvsp[0].smbl)->getName(), "program");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());
	}
#line 1541 "y.tab.c"
    break;

  case 5:
#line 89 "parser.y"
        {
		fprintf(logout,"line no. %d: unit: var_declaration\n\n",line_count);

		symbolINfo *s = new symbolINfo('\n' + (yyvsp[0].smbl)->getName(), "unit");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());
	}
#line 1554 "y.tab.c"
    break;

  case 6:
#line 98 "parser.y"
    {
     	fprintf(logout,"line no. %d: unit: func_declaration\n\n",line_count);

     	symbolINfo *s = new symbolINfo('\n' + (yyvsp[0].smbl)->getName(), "unit");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());
    }
#line 1567 "y.tab.c"
    break;

  case 7:
#line 107 "parser.y"
    {
     	fprintf(logout,"line no. %d: unit: func_definition\n\n",line_count);

     	symbolINfo *s = new symbolINfo('\n' + (yyvsp[0].smbl)->getName(), "unit");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());
    }
#line 1580 "y.tab.c"
    break;

  case 8:
#line 118 "parser.y"
        {
		fprintf(logout,"line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
		
		string line = (yyvsp[-5].smbl)->getName() + (yyvsp[-4].smbl)->getName() + "(" + (yyvsp[-2].smbl)->getName() + ");";

		symbolINfo *s = new symbolINfo(line, "func_declaration");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());

		(yyvsp[-4].smbl)->setReturnType((yyvsp[-5].smbl)->getVariableType());
		//cout << $2->getName() << " " << $2->returnType << endl;

		string id = "ID";

		if (!table.insert((yyvsp[-4].smbl)->getName(), id))
		{
			errCounter++;
			fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		}

		//table.printCur(logout);
	}
#line 1608 "y.tab.c"
    break;

  case 9:
#line 142 "parser.y"
        {
			fprintf(logout, "Line no. %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count);
			
			string id = "ID";
			symbolINfo* Sym = new symbolINfo((yyvsp[-3].smbl)->getName(), id);
			
			// This Function Is Already Declared Once
			if(!table.insert((yyvsp[-3].smbl)->getName(),id)){
				fprintf(error_out, "Error at Line %d: Previous Declaration of Function \'%s\' Found\n\n", line_count, (yyvsp[-3].smbl)->getName().c_str());
				errCounter++;
			}
			
			string Line = "";
			Line += (yyvsp[-4].smbl)->getName() + " " + (yyvsp[-3].smbl)->getName() + "();";
			
			symbolINfo* sym = new symbolINfo(Line, "function_declaration");
			(yyval.smbl) = sym;
			
			fprintf(logout, "%s\n\n", Line.c_str());
			

	}
#line 1635 "y.tab.c"
    break;

  case 10:
#line 166 "parser.y"
                                                                 {table.enterScope();}
#line 1641 "y.tab.c"
    break;

  case 11:
#line 167 "parser.y"
        {
		// fprintf(logout,"line no. %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \n\n",line_count);

		// string line = $1->getName() + $2->getName() + "(" + $4->getName() + ")" + $7->getName();

		// symbolINfo *s = new symbolINfo(line, "func_definition");
		// $$ = s;

		// $2->returnType = $1->varType;
		// //cout << $2->getName() << " " << $2->returnType << endl;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());

		// for(int i = 0; i < paramList.size(); i++)
		// {
		// 	table.insertSymbol(paramList[i]->getName(), "ID", 0);
		// }

		// paramList.clear();

		// table.printCur(logout);
		// table.removeScope();

		// symbolINfo *sInfo = table.srch($2->getName());

		// if(sInfo == NULL)
		// {
		// 	table.insertSymbol($2->getName(), "ID", 0);
		// }

		// symbolINfo = table.srch($2->getName());
		// symbolINfo->returnType = $1->getName();

		// table.printAll(logout);
	}
#line 1681 "y.tab.c"
    break;

  case 12:
#line 202 "parser.y"
                                          {table.enterScope();}
#line 1687 "y.tab.c"
    break;

  case 13:
#line 203 "parser.y"
        {
		// fprintf(logout,"line no. %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
	
		// string line = $1->getName() + $2->getName() + "()" + $6->getName();

		// symbolINfo *s = new symbolINfo(line, "func_definition");
		// $$ = s;

		// $2->returnType = $1->varType;
		// //cout << $2->getName() << " " << $2->returnType << endl;		

		// table.insertSymbol($2->getName(), "ID", 0);

		// symbolINfo = table.srch($2->getName());
		// symbolINfo->returnType = $1->getName();

		// fprintf(logout, "%s\n\n", $$->getName().c_str());

		// table.printCur(logout);
		// table.removeScope();
		// table.printAll(logout);
	}
#line 1714 "y.tab.c"
    break;

  case 14:
#line 229 "parser.y"
        {
		// fprintf(logout,"line no. %d: parameter_list : parameter_list COMMA type_specifier ID\n\n",line_count);

		// string line = $1->getName() + ", " + $3->getName() + $4->getName();

		// symbolINfo *s = new symbolINfo(line, "parameter_list");
		// $$ = s;

		// $4->varType = variableType;
		// $4->returnType = $3->returnType;
		
		// paramList.push_back($4);

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1734 "y.tab.c"
    break;

  case 15:
#line 245 "parser.y"
        {
		// fprintf(logout,"line no. %d: parameter_list : parameter_list COMMA type_specifier\n\n",line_count);
	
		// string line = $1->getName() + ", " + $3->getName();

		// symbolINfo *s = new symbolINfo(line, "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1749 "y.tab.c"
    break;

  case 16:
#line 256 "parser.y"
        {
		// fprintf(logout,"line no. %d: parameter_list : type_specifier ID\n\n",line_count);

		// $$->setName($$->getName() + $2->getName());

		// $2->varType = $1->varType;
		
		// paramList.push_back($2);

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1765 "y.tab.c"
    break;

  case 17:
#line 268 "parser.y"
        {
		// fprintf(logout,"line no. %d: parameter_list : type_specifier\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "parameter_list");
		// $$ = s;

		// //$1->varType = variableType;
		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1779 "y.tab.c"
    break;

  case 18:
#line 281 "parser.y"
        {
		// fprintf(logout,"line no. %d: compound_statement : LCURL statements RCURL\n\n",line_count);

		// symbolINfo *s = new symbolINfo("{\n" + $2->getName() + "\n}", "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1792 "y.tab.c"
    break;

  case 19:
#line 290 "parser.y"
        {
		// fprintf(logout,"line no. %d: compound_statement : LCURL RCURL\n\n",line_count);

		// symbolINfo *s = new symbolINfo("{}", "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1805 "y.tab.c"
    break;

  case 20:
#line 301 "parser.y"
        {
		// fprintf(logout,"line no. %d: var_declaration : type_specifier declaration_list SEMICOLON\n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + ";", "parameter_list");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1818 "y.tab.c"
    break;

  case 21:
#line 312 "parser.y"
        {
		fprintf(logout,"line no. %d: type_specifier : INT\n\n",line_count);
		fprintf(logout,"int\n\n");

		symbolINfo *s = new symbolINfo("int","type_specifier");
		s->setVariableType("int");
		(yyval.smbl) = s;

		lastDeclaredType = "int";

	}
#line 1834 "y.tab.c"
    break;

  case 22:
#line 324 "parser.y"
        {
		// fprintf(logout,"line no. %d: type_specifier : FLOAT\n\n",line_count);

		// symbolINfo *s = new symbolINfo("float ", "type_specifier");
		// $$ = s;

		// variableType = "float";
		
		// $$->varType = "float";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1851 "y.tab.c"
    break;

  case 23:
#line 337 "parser.y"
        {
		// fprintf(logout,"line no. %d: type_specifier : VOID\n\n",line_count);

		// symbolINfo *s = new symbolINfo("void ", "type_specifier");
		// $$ = s;

		// variableType = "void";
		
		// $$->varType = "void";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 1868 "y.tab.c"
    break;

  case 24:
#line 352 "parser.y"
        {
		// fprintf(logout,"line no. %d: declaration_list : declaration_list COMMA ID\n\n",line_count);

		// $$->setName($$->getName() + ", " + $3->getName());

		// fprintf(logout,"%s\n\n", $$->getName().c_str());

		// check = table.insertSymbol($3->getName(), "ID", 0);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// symbolINfo *sInfo = table.srch($3->getName());
		
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }

		//table.printCur(logout);
	}
#line 1903 "y.tab.c"
    break;

  case 25:
#line 383 "parser.y"
        {
		// fprintf(logout,"line no. %d: declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);

		// $$->setName($$->getName() + ", " + $3->getName() + "[" + $5->getName() + "]" );

		// fprintf(logout, "%s\n\n", $$->getName().c_str());

		// int number = atoi($5->getName().c_str());

		// check = table.insertSymbol($3->getName(), "ID", number);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// //table.printCur(logout);

		// symbolINfo *sInfo = table.srch($3->getName());
	
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }
	}
#line 1940 "y.tab.c"
    break;

  case 26:
#line 416 "parser.y"
        {
		// fprintf(logout,"line no. %d: declaration_list : ID\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(),"declaration_list");
		// $$ = s;

		// fprintf(logout,"%s\n\n", $$->getName().c_str());

		// check = table.insertSymbol($1->getName(), "ID", 0);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// symbolINfo *sInfo = table.srch($1->getName());
	
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }
		

		//table.printCur(logout);
	}
#line 1977 "y.tab.c"
    break;

  case 27:
#line 449 "parser.y"
        {
		// fprintf(logout,"line no. %d: declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n",line_count);

		// string line = $1->getName() + "[" + $3->getName() + "]";

		// symbolINfo *s = new symbolINfo(line, "declaration_list");
		// $$ = s;

		// fprintf(logout,"%s\n\n", $$->getName().c_str());

		// int number=atoi($3->getName().c_str());
		
		// check = table.insertSymbol($1->getName(), "ID", number);

		// if (check == false)
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nAlready Exists\n\n", errCounter, line_count);
		// }

		// symbolINfo *sInfo = table.srch($1->getName());
		
		// if(variableType != "void")
		// {
		// 	sInfo->varType = variableType;
		// }

		// else 
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nVariable type can't be void\n\n", errCounter, line_count);
		// }

		// //table.printCur(logout);
	}
#line 2017 "y.tab.c"
    break;

  case 28:
#line 487 "parser.y"
        {
		// fprintf(logout,"line no. %d: statements : statement\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "statements");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2030 "y.tab.c"
    break;

  case 29:
#line 496 "parser.y"
        {
		// fprintf(logout,"line no. %d: statements : statements statement\n\n",line_count);

		// $$->setName($$->getName() + $2->getName());

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2042 "y.tab.c"
    break;

  case 30:
#line 506 "parser.y"
        {
		fprintf(logout,"line no. %d: statement : var_declaration\n\n",line_count);

		symbolINfo *s = new symbolINfo((yyvsp[0].smbl)->getName() + '\n', "statement");
		(yyval.smbl) = s;

		fprintf(logout, "%s\n\n", (yyval.smbl)->getName().c_str());
	}
#line 2055 "y.tab.c"
    break;

  case 31:
#line 515 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : expression_statement\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName()+ '\n', "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2068 "y.tab.c"
    break;

  case 32:
#line 524 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : compound_statement\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + '\n', "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2081 "y.tab.c"
    break;

  case 33:
#line 533 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);
	
		// string line = "for (" + $3->getName() + $4->getName() + $5->getName() + ") " + $7->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2096 "y.tab.c"
    break;

  case 34:
#line 544 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : IF LPAREN expression RPAREN statement\n\n",line_count);
	
		// string line = "if (" + $3->getName() + ") " + $5->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2111 "y.tab.c"
    break;

  case 35:
#line 555 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);
	
		// string line = "if (" + $3->getName() + ") " + $5->getName() + "else " + $7->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2126 "y.tab.c"
    break;

  case 36:
#line 566 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : WHILE LPAREN expression RPAREN statement\n\n",line_count);
	
		// string line = "while (" + $3->getName() + ") " + $5->getName();

		// symbolINfo *s = new symbolINfo(line, "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2141 "y.tab.c"
    break;

  case 37:
#line 577 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n",line_count);
	}
#line 2149 "y.tab.c"
    break;

  case 38:
#line 581 "parser.y"
        {
		// fprintf(logout,"line no. %d: statement : RETURN expression SEMICOLON\n\n",line_count);
	
		// symbolINfo *s = new symbolINfo("return " + $2->getName() + ";", "statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2162 "y.tab.c"
    break;

  case 39:
#line 592 "parser.y"
        {
		// fprintf(logout,"line no. %d: expression_statement : SEMICOLON\n\n",line_count);

		// symbolINfo *s = new symbolINfo(";", "expression_statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2175 "y.tab.c"
    break;

  case 40:
#line 601 "parser.y"
        {
		// fprintf(logout,"line no. %d: expression_statement : expression SEMICOLON\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + ";", "expression_statement");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2188 "y.tab.c"
    break;

  case 41:
#line 612 "parser.y"
        {
		// fprintf(logout,"line no. %d: variable: ID\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "variable");
		// $$ = s;

		// symbolINfo = table.srch($1->getName());

		// if(symbolINfo != NULL) $$->varType = symbolINfo->varType;
		
		// //cout<<$$->getName()<<"  hg  "<<$$->varType<<endl;
 
		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2207 "y.tab.c"
    break;

  case 42:
#line 627 "parser.y"
        {
		// fprintf(logout,"line no. %d: variable: ID LTHIRD expression RTHIRD\n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName() + "[" + $3->getName() + "]", "variable");
		// $$ = s;

		// $$->varType = $1->varType;
		
		// if($3->varType != "int")
		// {
		// 	errCounter++;
		// 	fprintf(error_out, "Error no. %d at line no. %d\nArray indexing error\n\n", errCounter, line_count);
		// 	//cout << $3->getName() << " \'" << $3->varType << "\' id:" << $1->getName() << endl ;
		// }

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2229 "y.tab.c"
    break;

  case 43:
#line 647 "parser.y"
        {
		// fprintf(logout,"line no. %d: expression : logic_expression \n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName(), "expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2244 "y.tab.c"
    break;

  case 44:
#line 658 "parser.y"
        {
		// fprintf(logout,"line no. %d: expression : variable ASSIGNOP logic_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + " = " + $3->getName(), "expression");
		// $$ = s;

		// string t = "";
		// for(int i = 0; i < $1->getName().length(); i++)
		// {
		// 	if($1->getName()[i] == '[') break;
			
		// 	else
		// 	{
		// 		t.push_back($1->getName()[i]);
		// 	}
		// }

		// symbolINfo *sInfo = table.srch(t);

		// if(sInfo == 0)
		// {
		// 	errCounter++;
		// 	fprintf(logout,"variable %s not declared\n",t.c_str());
		// }

		// else
		// {
		// 	if(sInfo->varType != $3->varType)
		// 	{
		// 		errCounter++;
		// 		fprintf(error_out, "Error no. %d at line no. %d\nAssignment error\n\n", errCounter, line_count);
		// 	}
		// }

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2287 "y.tab.c"
    break;

  case 45:
#line 699 "parser.y"
        {
		// fprintf(logout,"line no. %d: logic_expression : rel_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "logic_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2302 "y.tab.c"
    break;

  case 46:
#line 710 "parser.y"
        {
		// fprintf(logout,"line no. %d: logic_expression : rel_expression LOGICOP rel_expression \n\n",line_count);
		
		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "logic_expression");
		// $$ = s;

		// $$->varType = "int";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2317 "y.tab.c"
    break;

  case 47:
#line 723 "parser.y"
        {
		// fprintf(logout,"line no. %d: rel_expression : simple_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "rel_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2332 "y.tab.c"
    break;

  case 48:
#line 734 "parser.y"
        {
		// fprintf(logout,"line no. %d: rel_expression : simple_expression RELOP simple_expression \n\n",line_count);
	
		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "rel_expression");
		// $$ = s;
		
		// $$->varType = "int";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2347 "y.tab.c"
    break;

  case 49:
#line 747 "parser.y"
        {
		// fprintf(logout,"line no. %d: simple_expression : term \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "simple_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2362 "y.tab.c"
    break;

  case 50:
#line 758 "parser.y"
        {
		// fprintf(logout,"line no. %d: simple_expression : simple_expression ADDOP term \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "simple_expression");
		// $$ = s;

		// if($1->varType == "float" || $3->varType == "float")
		// {
		// 	$$->varType = "float";
		// }

		// else
		// {
		// 	$$->varType = "int";
		// }

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2385 "y.tab.c"
    break;

  case 51:
#line 779 "parser.y"
        {
		// fprintf(logout,"line no. %d: term : unary_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "term");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2400 "y.tab.c"
    break;

  case 52:
#line 790 "parser.y"
        {
		// fprintf(logout,"line no. %d: term : term MULOP unary_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName() + $3->getName(), "term");
		// $$ = s;

		// if($1->varType == "float" || $3->varType == "float")
		// {
		// 	$$->varType = "float";
		// }

		// else
		// {
		// 	$$->varType = "int";
		// }

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2423 "y.tab.c"
    break;

  case 53:
#line 811 "parser.y"
        {
		// fprintf(logout,"line no. %d: unary_expression : ADDOP unary_expression\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + $2->getName(), "unary_expression");
		// $$ = s;

		// $$->varType = $2->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2438 "y.tab.c"
    break;

  case 54:
#line 822 "parser.y"
        {
		// fprintf(logout,"line no. %d: unary_expression : NOT unary_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo("!" + $2->getName(), "unary_expression");
		// $$ = s;

		// $$->varType = $2->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2453 "y.tab.c"
    break;

  case 55:
#line 833 "parser.y"
        {
		// fprintf(logout,"line no. %d: unary_expression : factor \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "unary_expression");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2468 "y.tab.c"
    break;

  case 56:
#line 846 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : variable\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2483 "y.tab.c"
    break;

  case 57:
#line 857 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : ID LPAREN argument_list RPAREN\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// symbolINfo = table.srch($1->getName());
		// $$->varType = symbolINfo->returnType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2499 "y.tab.c"
    break;

  case 58:
#line 869 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : LPAREN expression RPAREN\n\n",line_count);

		// symbolINfo *s = new symbolINfo("(" + $2->getName() + ")", "factor");
		// $$ = s;

		// $$->varType = $2->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2514 "y.tab.c"
    break;

  case 59:
#line 880 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : CONST_INT\n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// $$->varType = "int";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2529 "y.tab.c"
    break;

  case 60:
#line 891 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : CONST_FLOAT \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "factor");
		// $$ = s;

		// $$->varType = "float";

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2544 "y.tab.c"
    break;

  case 61:
#line 902 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : variable INCOP \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + "++", "factor");
		// $$ = s;

		// $$->varType = $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2559 "y.tab.c"
    break;

  case 62:
#line 913 "parser.y"
        {
		// fprintf(logout,"line no. %d: factor : variable DECOP \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + "--", "factor");
		// $$ = s;

		// $$->varType == $1->varType;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2574 "y.tab.c"
    break;

  case 64:
#line 934 "parser.y"
          { }
#line 2580 "y.tab.c"
    break;

  case 65:
#line 938 "parser.y"
        {
		// fprintf(logout,"line no. %d: arguments : arguments COMMA logic_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName() + ", " + $3->getName(), "arguments");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2593 "y.tab.c"
    break;

  case 66:
#line 947 "parser.y"
        {
		// fprintf(logout,"line no. %d: arguments : logic_expression \n\n",line_count);

		// symbolINfo *s = new symbolINfo($1->getName(), "arguments");
		// $$ = s;

		// fprintf(logout, "%s\n\n", $$->getName().c_str());
	}
#line 2606 "y.tab.c"
    break;


#line 2610 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 958 "parser.y"


int main(int argc,char *argv[])
{

	if((yyin=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logout= fopen(argv[2],"w");
	fclose(logout);
	error_out= fopen(argv[3],"w");
	fclose(error_out);
	
	logout= fopen(argv[2],"a");
	error_out= fopen(argv[3],"a");
	
	yyparse();

	table.printAllScopeTable();
	fprintf(logout,"total lines: %d\n",line_count);
	fprintf(logout,"total errors encountered: %d\n",errCounter);
	
	fclose(logout);
	fclose(error_out);
	
	return 0;
}
 
