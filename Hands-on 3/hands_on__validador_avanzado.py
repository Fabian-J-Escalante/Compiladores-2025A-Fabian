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
    ('left', 'AND', 'OR'),
    ('left', '+', '-'),
    ('left', '*', '/'),
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
              | logico'''
    pass


def p_logico(p):
    '''logico : logico AND termino
              | logico OR termino
              | NOT factor
              | BOOLEANO'''
    pass


def p_error(p):
    print('Expresión inválida')


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
    except Exception:
        print('Expresión inválida')
