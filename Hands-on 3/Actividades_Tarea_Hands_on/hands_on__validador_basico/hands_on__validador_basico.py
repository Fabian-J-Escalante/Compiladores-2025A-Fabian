import sys
import ply.lex as lex
import ply.yacc as yacc

tokens = ('NUMERO',)
literals = ['+', '-', '*', '/', '(', ')']
t_ignore = ' \t'


def t_NUMERO(t):
    r'\d+'
    t.value = int(t.value)
    return t


def t_error(t):
    t.lexer.skip(1)


precedence = (
    ('left', '+', '-'),
    ('left', '*', '/'),
    ('right', 'UMINUS'),
)


def p_expresion(p):
    '''expresion : expresion '+' termino
                 | expresion '-' termino
                 | termino'''
    pass


def p_termino(p):
    '''termino : termino '*' factor
               | termino '/' factor
               | factor'''
    pass


def p_factor(p):
    '''factor : '-' factor %prec UMINUS
              | '(' expresion ')'
              | NUMERO'''
    pass


def p_error(p):
    print('Expresión inválida')


analizador = yacc.yacc()
lexer = lex.lex()

print('Ingrese expresiones aritméticas:')
for linea in sys.stdin:
    linea = linea.strip()
    if not linea:
        continue
    try:
        analizador.parse(linea, lexer=lexer)
        print('Expresión válida')
    except Exception:
        print('Expresión inválida')
