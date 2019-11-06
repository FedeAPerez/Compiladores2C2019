typedef struct Terceto {
    int tercetoID;
    // Helpers for Assembler
    // Operator
    int isOperator;
    char operator; // + / - *
    int left;
    int right;
    // Operand
    int isOperand;
    char type; // S, F, I
    // Operand -> Store for values
    char *stringValue;
    int intValue;
    float floatValue;
    int isConst;
} Terceto;

typedef struct ArrayTercetos 
{
    size_t tamanioUsado;
    size_t tamanioTotal;
    struct Terceto *punteroTercetos;
} ArrayTercetos;


void crearTercetos(ArrayTercetos *, size_t);
void insertarTercetos(ArrayTercetos *, Terceto);

void generarAssembler(ArrayTercetos *);
void generarCode(FILE *);
void generarData(FILE *);
