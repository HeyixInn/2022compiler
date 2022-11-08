#include <iostream>
#include "Ast.h"
#include "SymbolTable.h"
#include <string>
#include "Type.h"

using namespace std;

extern FILE *yyout;
int Node::counter = 0;

Node::Node()
{
    seq = counter++;
}

void Ast::output()
{
    fprintf(yyout, "program\n");
    if(root != nullptr)
        root->output(4);
}

void BinaryExpr::output(int level)
{
    std::string op_str;
    switch(op)
    {
        case ADD:
            op_str = "add";
            break;
        case SUB:
            op_str = "sub";
            break;
        case MUL:
            op_str = "mul";
            break;
        case DIV:
            op_str = "div";
            break;
        case MOD:
            op_str = "mod";
            break;
        case AND:
            op_str = "and";
            break;
        case OR:
            op_str = "or";
            break;
        case LESS:
            op_str = "less";
            break;
        case MORE:
            op_str = "more";
            break;
        case EQUAL:
            op_str = "equal";
            break;
        case MORE_E:
            op_str = "more_than_or_equal";
            break;
        case LESS_E:
            op_str = "less_than_or_equal";
            break;
        case NOT_EQUAL:
            op_str = "not_equal";
            break;
    }
    fprintf(yyout, "%*cBinaryExpr\top: %s\n", level, ' ', op_str.c_str());
    expr1->output(level + 4);
    expr2->output(level + 4);
}

void preSingleExpr::output(int level)
{
    std::string op_str;
    switch(op)
    {
        case NOT:
            op_str = "not";
            break;
        case AADD:
            op_str = "prefix_self_add";
            break;
        case SSUB:
            op_str = "prefix_self_sub";
            break;
        case ADD:
            op_str = "add";
            break;
        case SUB:
            op_str = "sub";
            break;
    }
    fprintf(yyout, "%*cprefix_SingleExpr\top: %s\n", level, ' ', op_str.c_str());
    expr->output(level + 4);
}

void sufSingleExpr::output(int level)
{
    std::string op_str;
    switch(op)
    {
        case AADD:
            op_str = "suffix_self_add";
            break;
        case SSUB:
            op_str = "suffix_self_sub";
            break;
    }
    fprintf(yyout, "%*csuffix_SingleExpr\top: %s\n", level, ' ', op_str.c_str());
    expr->output(level + 4);
}

void Constant::output(int level)
{
    std::string type, value;
    type = symbolEntry->getType()->toStr();
    value = symbolEntry->toStr();
    fprintf(yyout, "%*cIntegerLiteral\tvalue: %s\ttype: %s\n", level, ' ',
            value.c_str(), type.c_str());
}

void Id::output(int level)
{
    std::string name, type;
    int scope;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    bool isconst = symbolEntry->getType()->is_const();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();
    fprintf(yyout, "%*cId\tname: %s\tscope: %d\ttype: %s\tis_const:%d\n", level, ' ',
            name.c_str(), scope, type.c_str(), isconst);
}

void CompoundStmt::output(int level)
{
    fprintf(yyout, "%*cCompoundStmt\n", level, ' ');
    stmt->output(level + 4);
}

void SeqNode::output(int level)
{
    fprintf(yyout, "%*cSequence\n", level, ' ');
    stmt1->output(level + 4);
    stmt2->output(level + 4);
}

void DeclStmt::output(int level)
{
    fprintf(yyout, "%*cDeclStmt\n", level, ' ');
    std::map<Id*, ExprNode*>::iterator it=idlist.begin();
    while(it!=idlist.end()){
        it->first->output(level + 4);
        if(it->second!=nullptr){
            // cout<<"hi"<<endl;
            it->second->output(level+4);
        }
        it++;
    }
}

void IfStmt::output(int level)
{
    fprintf(yyout, "%*cIfStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
}

void IfElseStmt::output(int level)
{
    fprintf(yyout, "%*cIfElseStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
    elseStmt->output(level + 4);
}

void WhileStmt::output(int level)
{
    fprintf(yyout, "%*cWhileStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
}

void ForStmt::output(int level)
{
    fprintf(yyout, "%*cForStmt\n", level, ' ');
    init->output(level + 4);
    judge->output(level + 4);
    ctrl->output(level + 4);
}

void ReturnStmt::output(int level)
{
    fprintf(yyout, "%*cReturnStmt\n", level, ' ');
    if(!retValue){
        retValue->output(level + 4);
    }
}

void ExprStmt::output(int level)
{
    fprintf(yyout, "%*cExprStmt\n", level, ' ');
    if(!exp){
        exp->output(level + 4);
    }
}

void AssignStmt::output(int level)
{
    fprintf(yyout, "%*cAssignStmt\n", level, ' ');
    lval->output(level + 4);
    expr->output(level + 4);
}

void FunctionDef::output(int level)
{
    std::string name, type;
    name = se->toStr();
    type = se->getType()->toStr();
    fprintf(yyout, "%*cFunctionDefine function name: %s, type: %s\n", level, ' ', 
            name.c_str(), type.c_str());
    stmt->output(level + 4);
}

void FunctionCall::output(int level)
{
    std::string name, type;
    name = se->toStr();
    type = se->getType()->toStr();
    fprintf(yyout, "%*cFunctionCall function name: %s, type: %s, params_num: %d\n", level, ' ', 
            name.c_str(), type.c_str(), int(params.size()));
    //vector<SymbolEntry*>::iterator it=params.begin();
    if(params.empty()){
        // cout<<"hi"<<endl;
        return;
    }
    // cout<<int(params.size())<<endl;
    // for(int i=1;i<=int(params.size());i++){
        // name = params.at(i-1)->toStr();
        // type = params.at(i-1)->getType()->toStr();
        // cout<<name<<endl;
        // fprintf(yyout, "%*cparam%d: name: %s, type: %s, \n", level, ' ', i, 
        //     name.c_str(), type.c_str());
        // cout<< typeid(se).name()<<endl;
    // }
}

void FunctionCallStmt::output(int level)
{
    func->output(level+4);
}

void EmptyStmt::output(int level)
{
    fprintf(yyout, "%*cEmptyStmt\n", level, ' ');
}
