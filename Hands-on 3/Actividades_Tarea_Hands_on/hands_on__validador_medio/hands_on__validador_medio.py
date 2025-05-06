import sys
import ply.lex as lex
import ply.yacc as yacc

tokens = ('BOOLEANO', 'AND', 'OR', 'NOT')
literals = ['(', ')']
t_AND = r'AND'
t_OR = r'OR'
t_NOT = r'NOT'
t_ignore = ' \t'


def t_BOOLEANO(t):
    r'[01]'
    t.value = int(t.value)
    return t


def t_error(t):
    t.lexer.skip(1)


precedence = (
    ('right', 'NOT'),
    ('left', 'AND', 'OR'),
)


def p_expresion(p):
    '''expresion : expresion AND termino
                 | expresion OR termino
                 | termino'''
    pass


def p_termino(p):
    '''termino : NOT factor
               | factor'''
    pass


def p_factor(p):
    '''factor : '(' expresion ')'
              | BOOLEANO'''
    pass


def p_error(p):
    print('Expresión inválida')


analizador = yacc.yacc()
lexer = lex.lex()

print('Ingrese expresiones lógicas:')
for linea in sys.stdin:
    linea = linea.strip()
    if not linea:
        continue
    try:
        analizador.parse(linea, lexer=lexer)
        print('Expresión válida')
    except Exception:
        print('Expresión inválida')
