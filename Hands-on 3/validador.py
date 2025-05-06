import sys
import ply.lex  as lex
import ply.yacc as yacc

tokens = ('NUMBER',)
literals = ['+', '-', '*', '/', '(', ')']

t_ignore = ' \t'

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_error(t):
    print(f"Caracter ilegal '{t.value[0]}'")
    t.lexer.skip(1)

precedence = (
    ('left', '+', '-'),
    ('left', '*', '/'),
    ('right', 'UMINUS'),
)

def p_input_valid(p):
    'input : expr'
    print("Expresión válida")

def p_input_error(p):
    'input : error'
    print("Expresión inválida")

def p_expr_binop(p):
    '''expr : expr '+' expr
            | expr '-' expr
            | expr '*' expr
            | expr '/' expr'''
    pass

def p_expr_uminus(p):
    'expr : \'-\' expr %prec UMINUS'
    pass

def p_expr_group(p):
    'expr : \'(\' expr \')\''
    pass

def p_expr_number(p):
    'expr : NUMBER'
    pass

def p_error(p):
    raise SyntaxError

lexer = lex.lex()
parser = yacc.yacc()

def iniciar():
    print("Añade la expresión que quieras:")
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            parser.parse(line, lexer=lexer)
        except Exception:
            print("Expresión inválida")


iniciar()
