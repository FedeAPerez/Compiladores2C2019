typedef struct Terceto {
    int tercetoID;
    char type; // S, F, I
    // Store for values
    char *stringValue;
    int intValue;
    float floatValue;
    // Helpers for Assembler
    int isOperator;
    char operator; // + / - *
    int left;
    int right;
    int isOperand;
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
