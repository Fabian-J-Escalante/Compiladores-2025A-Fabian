import sys
import ply.lex as lex
import ply.yacc as yacc

tokens = ('NUMERO', 'BOOLEANO', 'AND', 'OR', 'NOT')
literals = ['+', '-', '*', '/', '(', ')']
t_AND = r'AND'
t_OR = r'OR'
t_NOT = r'NOT'
t_ignore = ' \t'

def t_NUMERO(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_BOOLEANO(t):
    r'[01]'
    t.value = int(t.value)
    return t

def t_error(t):
    t.lexer.skip(1)

precedence = (
    ('right', 'NOT', 'UMINUS'),
    ('left', 'AND'),
    ('left', 'OR'),
    ('left', '+', '-'),
    ('left', '*', '/'),
)

def p_expr(p):
    '''expr : expr OR expr
            | expr AND expr
            | arit'''
    pass

def p_arit(p):
    '''arit : arit '+' arit
            | arit '-' arit
            | arit '*' arit
            | arit '/' arit
            | '-' arit %prec UMINUS
            | '(' expr ')'
            | NUMERO'''
    pass

def p_error(p):
    raise SyntaxError

analizador = yacc.yacc()
lexer = lex.lex()

print('Ingrese expresiones complejas:')
for linea in sys.stdin:
    linea = linea.strip()
    if not linea:
        continue
    try:
        analizador.parse(linea, lexer=lexer)
        print('Expresión válida')
    except SyntaxError:
        print('Expresión inválida')
