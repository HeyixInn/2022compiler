%code top{
    #include <iostream>
    #include <assert.h>
    #include <map>
    #include <vector>
    #include "parser.h"
    using namespace std;
    extern Ast ast;
    int yylex();
    int yyerror( char const * );

    map<std::string, ExprNode*> idlist;
    std::vector<Type*> paramdefs;
    std::vector<std::string> paramsymbols;
    std::vector<IdentifierSymbolEntry*> paramcalls;
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
    int itype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    Type* type;
}

%start Program
%token <strtype> ID 
%token <itype> INTEGER
%token IF ELSE WHILE FOR
%token INT VOID
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA
%token NOT AADD SSUB
%token MUL DIV MOD ADD SUB OR AND LESS MORE EQUAL MORE_E LESS_E NOT_EQUAL ASSIGN
%token RETURN CONST


%nterm <stmttype> Stmts Stmt AssignStmt BlockStmt IfStmt WhileStmt ForStmt AssignExpr ReturnStmt DeclStmt ExprStmt FuncDef
%nterm <exprtype> Exp MulExp AddExp Cond LOrExp PrimaryExp LVal RelExp LAndExp NotExp preSinExp sufSinExp FuncCall
%nterm <type> Type
%nterm IDList

%precedence THEN
%precedence ELSE
%%
Program
    : Stmts {
        ast.setRoot($1);
        ast.output();
    }
    ;
Stmts
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);
    }
    ;
Stmt
    : AssignStmt {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
    | WhileStmt {$$=$1;}
    | ForStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | FuncDef {$$=$1;}
    | ExprStmt{$$ = $1;}
    | SEMICOLON {$$ = new EmptyStmt();}
    ;

LVal
    : ID {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new Id(se);
        delete []$1;
    }
    ;
ExprStmt
    :
    Exp SEMICOLON{
        $$ = new ExprStmt($1);
    }
    ;
AssignStmt
    :
    AssignExpr SEMICOLON {
        $$ = $1;
    }
    ;
AssignExpr
    :
    LVal ASSIGN Exp {
        $$ = new AssignStmt($1, $3);
    }
    ;
BlockStmt
    :   LBRACE 
        {identifiers = new SymbolTable(identifiers);} 
        Stmts RBRACE 
        {
            $$ = new CompoundStmt($3);
            SymbolTable *top = identifiers;
            identifiers = identifiers->getPrev();
            delete top;
        }
    ;
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;
WhileStmt
    : WHILE LPAREN Cond RPAREN Stmt{
        $$ = new WhileStmt($3, $5);
    }   
    ;
ForStmt
    : FOR LPAREN AssignExpr SEMICOLON Cond SEMICOLON AssignExpr RPAREN Stmt{
        $$ = new ForStmt($3, $5, $7, $9);
    }   
    ;
ReturnStmt
    :
    RETURN SEMICOLON{
        $$ = new ReturnStmt();
    }
    |
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    ;
Exp
    :
    LOrExp {$$ = $1;}
    ;
Cond
    :
    LOrExp {$$ = $1;}
    ;
NotExp
    :
    NOT LVal
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::NOT, $2);
    }
    |
    NOT NotExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::NOT, $2);
    }
    |
    NOT LPAREN Exp RPAREN
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::NOT, $3);
    }
    ;
PrimaryExp
    :
    LVal {
        $$ = $1;
    }
    | 
    INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    }
    |
    LPAREN LOrExp RPAREN {
        $$ = $2;
    }
    |
    FuncCall {
        $$ = $1;
    }
    |
    NotExp {
        $$ = $1;
    } 
    ;

preSinExp
    :
    PrimaryExp {
        $$ = $1;
    }
    |
    AADD preSinExp {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::AADD, $2);
    }
    | 
    SSUB preSinExp{
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::SSUB, $2);
    }
    |
    ADD preSinExp {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::ADD, $2);
    }
    |
    SUB preSinExp{
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new preSingleExpr(se, preSingleExpr::SUB, $2);
    }
    ;

sufSinExp
    :
    preSinExp{
        $$ = $1;
    }
    |
    sufSinExp AADD {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new sufSingleExpr(se, $1, sufSingleExpr::AADD);
    }
    | 
    sufSinExp SSUB {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new sufSingleExpr(se, $1, sufSingleExpr::SSUB);
    }  
    ;
    
MulExp
    :
    sufSinExp {$$ = $1;}
    |
    MulExp MUL preSinExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
    }
    |
    MulExp DIV preSinExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
    }
    |
    MulExp MOD preSinExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOD, $1, $3);
    }
    ;
AddExp
    :
    MulExp {$$ = $1;}
    |
    AddExp ADD MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
    }
    |
    AddExp SUB MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
    }
    ;
RelExp
    :
    AddExp {$$ = $1;}
    |
    RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    |
    RelExp MORE AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MORE, $1, $3);
    }
    |
    RelExp EQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    |
    RelExp LESS_E AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS_E, $1, $3);
    }
    |
    RelExp MORE_E AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MORE_E, $1, $3);
    }
    |
    RelExp NOT_EQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOT_EQUAL, $1, $3);
    }
    ;
LAndExp
    :
    RelExp {$$ = $1;}
    |
    LAndExp AND RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;
Type
    : INT {
        $$ = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
    | CONST Type {
        // cout<<"ha"<<endl;
        $$ = new IntType(4, 1);
    }
    ;
IDList
    :
    ID COMMA{
        idlist[$1]=nullptr;
    }
    |
    ID ASSIGN Exp COMMA{
        idlist[$1]=$3;
    }
    |
    IDList ID COMMA{
        idlist[$2]=nullptr;
    }
    |
    IDList ID ASSIGN Exp COMMA{
        idlist[$2]=$4;
    }
    |
    IDList ID{
        //结束
        idlist[$2]=nullptr;
    }
    |
    IDList ID ASSIGN Exp{
        //结束
        idlist[$2]=$4;
    }
    ;
DeclStmt
    :
    Type ID SEMICOLON {
        // cout<<"hhh"<<endl;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        DeclStmt* tmp = new DeclStmt();
        tmp->insert(new Id(se));
        $$ = tmp; 
        delete []$2;
    }
    |Type ID ASSIGN Exp SEMICOLON{
        //应该加一个value值 在entry里也要加
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        DeclStmt* tmp = new DeclStmt();
        tmp->insert(new Id(se),$4);
        $$ = tmp;       
        delete []$2;
    }
    |
    Type IDList SEMICOLON {
        std::map <std::string, ExprNode*>::iterator it=idlist.begin();
        DeclStmt* tmp = new DeclStmt();
        SymbolEntry *se;
        while(it!=idlist.end()){
            // cout<<it->first<<endl;
            se = new IdentifierSymbolEntry($1, it->first, identifiers->getLevel());
            identifiers->install(it->first, se);
            tmp->insert(new Id(se), it->second);
            it++;
        }
        $$ = tmp;
        idlist.clear();//存完以后清空
        //delete []$2;
    }
    ;
ParamDefs:
    Type ID{
        paramdefs.push_back($1);
        paramsymbols.push_back($2);
    }
    |
    ParamDefs COMMA Type ID{
        paramdefs.push_back($3);
        paramsymbols.push_back($4);
    }
    ;
FuncDef
    :
    Type ID 
    LPAREN ParamDefs RPAREN
    {
        Type *funcType;
        //std::vector<Type*> params;
        //params.swap(paramdefs);
        funcType = new FunctionType($1,paramdefs);
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);

        for(int i=0;i<int(paramsymbols.size());i++){
            // cout<<paramsymbols[i]<<endl;
            SymbolEntry *sesym = new IdentifierSymbolEntry(paramdefs[i], paramsymbols[i], identifiers->getLevel());
            identifiers->install(paramsymbols[i], sesym);
        }
    }
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $7);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();

        std::vector<Type*> params;
        params.swap(paramdefs);
        std::vector<std::string> params1;
        params1.swap(paramsymbols);

        delete top;
        delete []$2;
    }
    |
    Type ID 
    LPAREN RPAREN
    {
        Type *funcType;
        std::vector<Type*> params;
        funcType = new FunctionType($1,params);
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);

        for(int i=0;i<int(paramsymbols.size());i++){
            // cout<<paramsymbols[i]<<endl;
            SymbolEntry *sesym = new IdentifierSymbolEntry(paramdefs[i], paramsymbols[i], identifiers->getLevel());
            identifiers->install(paramsymbols[i], sesym);
        }
    }
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $6);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;
Params:
    ID{
        SymbolEntry *se;
        se = identifiers->lookup($1);
        assert(se != nullptr);
        paramcalls.push_back((IdentifierSymbolEntry*)$1);
    }
    |
    Params COMMA ID{
        SymbolEntry *se;
        se = identifiers->lookup($3);
        assert(se != nullptr);
        paramcalls.push_back((IdentifierSymbolEntry*)$3);
    }
    ;
FuncCall
    :
    ID LPAREN Params RPAREN
    {
        std::vector<IdentifierSymbolEntry*> params;
        params.swap(paramcalls);
        
        SymbolEntry *se;
        se = identifiers->lookup($1);
        //assert(se != nullptr);
        $$ = new FunctionCall(se, params);
    }
    |
    ID LPAREN RPAREN
    {
        std::vector<IdentifierSymbolEntry*> params;
        //params.swap(paramcalls);

        SymbolEntry *se;
        se = identifiers->lookup($1);
        //assert(se != nullptr);
        $$ = new FunctionCall(se, params);
    }
    ;

%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
